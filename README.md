
# 玩客云openwrt自动编译

集合常用插件，不定期编译。

## 使用方法
文件名包含burn的为线刷固件，解压后使用[Amlogic_USB_Burning_Tool](https://androiddatahost.com/khfj4)烧录。\
红灯闪是在启动中，启动完成后蓝灯常亮。首次启动时间可能会长一些(五分钟左右)。

- 登录ip: 192.168.5.1
- 用户名: root
- 密码: password
## 固件特性
- 添加常用调度器 (除了performance和powersave,其他常用调度器在调度的时候会**软中断**很久，表象为疑似**路由器掉线**，需要等待中断恢复才能正常运行)
- 添加schedutil(该调度器没有以上问题，推荐使用，功耗和性能中最好的)
- 添加sqm、nft-qos限流机制(优化高负载下载时打游戏延迟)
- 添加v2raya
- 添加smartdns
- 添加ZeroTier
- 界面调整为自由风

## 界面风格
![首页](./index.png)
## 感谢
- 自动编译工作流改自 https://github.com/P3TERX/Actions-OpenWrt
- 玩客云u-boot https://github.com/hzyitc/u-boot-onecloud
- openwrt源码 https://github.com/coolsnowwolf/lede
- 线刷包打包工具 https://github.com/hzyitc/AmlImg
- 打包脚本改自 https://github.com/shiyu1314/openwrt-onecloud
- 父项目的作者 https://github.com/xydche/onecloud-openwrt
- 所有为openwrt做出贡献的人
