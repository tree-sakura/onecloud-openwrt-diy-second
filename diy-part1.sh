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

# 2025-11 基线。lede 主仓由 workflow 的 REPO_COMMIT 钉住(amlogic 内核还是 6.1, 两份 config-6.1
# 片段才会被引用), 但 packages/luci 这些 feed 是 update 时现拉的, 不一起钉就会拿到 2026 年的
# 版本 —— frpc 0.70.1 的 web 端要 Node >= 20.19, runner 只有 18.15, 直接编不过。
# src-git 的 <url>^<commit> 形式 scripts/feeds 支持(update_feed_via 的 init_commit 分支)。
cat > feeds.conf.default <<'EOF'
src-git packages https://github.com/coolsnowwolf/packages^e7ac58e2f2a93ff93392fec24041cda10739804d
src-git luci https://github.com/coolsnowwolf/luci.git;master
src-git routing https://github.com/coolsnowwolf/routing^d6138757432b18203f4a983c2392e948fc8b8941
src-git telephony https://github.com/coolsnowwolf/telephony.git^a04b7acfd30a6f8f4d78e62955376c4febcb0976
src-git helloworld https://github.com/fw876/helloworld^5d98b7442e89c5e9e5683c2310bfe9eb516d1e39
src-git passwall_packages https://github.com/Openwrt-Passwall/openwrt-passwall-packages.git^27effca2f4835709d22766b8648d512ac7feb67a
src-git passwall https://github.com/Openwrt-Passwall/openwrt-passwall.git^88f1746d0933ccdca361dfa81a9a8fd8928ecd03
EOF

# luci 不能写成 ^<commit>: 那个写法走 scripts/feeds 的 init_commit 分支, clone 的是仓库默认分支,
# 而 coolsnowwolf/luci 的默认分支已经是 openwrt-25.12, 与 2025-11 的 master 提交没有共同祖先,
# checkout 会直接失败。所以这里只声明 ;master, 真正的钉版放在 update 之后那一步。
git clone -b lua https://github.com/sbwml/luci-app-alist package/alist
git -C package/alist checkout 6a6d4fb541b3b9685f3304ff2b2cb3143c88c551
