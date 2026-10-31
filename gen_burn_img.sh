#!/bin/bash
set -e

rm -rf burn
./AmlImg unpack ./uboot.img burn/
gzip -dkf openwrt/bin/targets/*/*/*.gz

diskimg_path="openwrt/bin/targets/*/*/*.img"
prefix=$(ls $diskimg_path | sed 's/\.img$//')
burnimg_name="${prefix}.burn.img"
diskimg=$(ls -1 $diskimg_path | head -n 1)

# 取分区起始扇区和扇区数(不需要 loop 设备)
part() {
  sfdisk -d "$diskimg" | sed -n "s/^.*[^0-9]$1 *: *start= *\([0-9]*\), *size= *\([0-9]*\),.*/\1 \2/p"
}
read b_start b_size < <(part 1)
read r_start r_size < <(part 2)
[ -n "$b_start" ] && [ -n "$r_start" ] || { echo "Error: 读取分区表失败"; exit 1; }

# 切出 boot 和 rootfs 两个分区
dd if="$diskimg" of=boot.img   bs=512 skip=$b_start count=$b_size status=none
dd if="$diskimg" of=rootfs.img bs=512 skip=$r_start count=$r_size status=none

# rootfs 扩到 600MiB(代替原来的 mkfs + mount + cp)
truncate -s 600M rootfs.img
e2fsck -fy rootfs.img || [ $? -le 1 ]
resize2fs rootfs.img

img2simg boot.img   burn/boot.simg
img2simg rootfs.img burn/rootfs.simg
rm -f boot.img rootfs.img

printf "PARTITION:boot:sparse:boot.simg\nPARTITION:rootfs:sparse:rootfs.simg\n" >> burn/commands.txt

./AmlImg pack "${burnimg_name}" burn/
sha256sum "${burnimg_name}" > "${burnimg_name}.sha"
xz -9 --threads=0 --compress "${burnimg_name}"
rm -rf burn
rm ${diskimg_path}
echo "Script execution completed."
