#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part1.sh
# Description: OpenWrt DIY script part 1 (Before Update feeds)
#

# Uncomment a feed source
#sed -i 's/^#\(.*helloworld\)/\1/' feeds.conf.default

# Add a feed source
# 注意: 新版 lede 的 feeds.conf.default 已默认启用 luci(openwrt-25.12 分支) 和 helloworld,
# 不要再取消注释 luci 或重复追加 helloworld, 否则 ./scripts/feeds update 会报
# "Duplicate feed name 'luci'" 并以 exit 25 退出
# passwall 仓库已从 xiaorouji 组织迁移到 Openwrt-Passwall 组织(旧地址已 404)
echo "src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git;main" >> "feeds.conf.default"
echo "src-git passwall https://github.com/Openwrt-Passwall/openwrt-passwall.git;main" >> "feeds.conf.default"

git clone -b lua https://github.com/sbwml/luci-app-alist package/alist
# git clone https://github.com/rufengsuixing/luci-app-onliner package/onliner
