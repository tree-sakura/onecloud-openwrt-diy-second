#!/bin/bash
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#
# Copyright (c) 2019-2024 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.5.1/g' package/base-files/files/bin/config_generate

# Modify default theme (新版 luci 的默认主题配置移到了 luci-base 的 /etc/config/luci)
sed -i 's|/luci-static/bootstrap|/luci-static/argon|' feeds/luci/modules/luci-base/root/etc/config/luci

# Modify hostname (新版 lede 默认主机名从 OpenWrt 改成了 LEDE)
sed -i "s/hostname='LEDE'/hostname='OneCloud'/" package/base-files/files/bin/config_generate

# 替换终端为bash
sed -i 's/\/bin\/ash/\/bin\/bash/' package/base-files/files/etc/passwd

# xray-core 的 cronet 链接器只有 x86_64 版, 非 x86_64 宿主跑不动; arm 版 libcronet.a 是普通 ELF 目标文件(无 bitcode), 换回交叉工具链自带链接器即可
if [ "$(uname -m)" != "x86_64" ] && [ -f feeds/packages/net/xray-core/Makefile ]; then
  sed -i 's|-B\$(CRONET_CLANG_DIR)/bin -fuse-ld=lld||' feeds/packages/net/xray-core/Makefile
fi
