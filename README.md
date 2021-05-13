# rtl8192eu_for_openwrt
rtl8192eu ap mode driver
support openwrt 19.07 and snapshot

Steps:
1. put rtl8192eu folder in /openwrt/package/kernel/
2. make menuconfig, choose kernel modules -> wireless drivers -> kmod-rtl8192eu
3. compile
