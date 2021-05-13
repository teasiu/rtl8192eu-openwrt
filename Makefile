#
# Copyright (C) 2013-2015 OpenWrt.org
#
# This is free software, licensed under the GNU General Public License v2.
# See /LICENSE for more information.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=rtl8192eu
PKG_VERSION:=2019-3-12
PKG_RELEASE:=1

include $(INCLUDE_DIR)/kernel.mk
include $(INCLUDE_DIR)/package.mk

USER_EXTRA_CFLAGS = -DBACKPORT

ifneq ($(LINUX_KARCH), x86)
USER_EXTRA_CFLAGS += -DCONFIG_MINIMAL_MEMORY_USAGE 
endif

#
# Debugging trace flags
#
#USER_EXTRA_CFLAGS += -DCONFIG_DEBUG
#USER_EXTRA_CFLAGS += -DCONFIG_DEBUG_RTL871X
#USER_EXTRA_CFLAGS += -DCONFIG_DEBUG_CFG80211
#USER_EXTRA_CFLAGS += -DCONFIG_RTW_DEBUG
USER_EXTRA_CFLAGS += -DCONFIG_RTW_IOCTL_SET_COUNTRY
USER_EXTRA_CFLAGS += -DCONFIG_CONCURRENT_MODE
USER_EXTRA_CFLAGS += -DDBG_MEM_ALLOC
USER_EXTRA_CFLAGS += -DCONFIG_IOCTL_CFG80211
USER_EXTRA_CFLAGS += -DRTW_USE_CFG80211_STA_EVENT
USER_EXTRA_CFLAGS += -DCONFIG_PLATFORM_ARM_RPI
USER_EXTRA_CFLAGS += -DCONFIG_MP_INCLUDED
USER_EXTRA_CFLAGS += -DCONFIG_WEXT_PRIV
USER_EXTRA_CFLAGS += -DCONFIG_WIRELESS_EXT

MAKE_FEATURES:= \
	CONFIG_POWER_SAVING="n"

NOSTDINC_FLAGS = \
	-I$(STAGING_DIR)/usr/include/mac80211 \
	-I$(STAGING_DIR)/usr/include/mac80211/uapi \
	-I$(STAGING_DIR)/usr/include/mac80211-backport \
	-include backport/backport.h 

MAKE_OPTS:= \
	ARCH="$(LINUX_KARCH)" \
	CROSS_COMPILE="$(KERNEL_CROSS)" \
	KSRC="$(LINUX_DIR)" \
	KVER="$(LINUX_VERSION)" \
	M="$(PKG_BUILD_DIR)" \
	MODULE_NAME="8192eu" \
	USER_EXTRA_CFLAGS="$(USER_EXTRA_CFLAGS)" \
	NOSTDINC_FLAGS="$(NOSTDINC_FLAGS)" 
	KBUILD_EXTRA_SYMBOLS="${STAGING_DIR}/usr/include/mac80211/Module.symvers" \
	$(MAKE_FEATURES)


define KernelPackage/$(PKG_NAME)
  SUBMENU:=Wireless Drivers
  TITLE:=Realtek RTL8192EU support
  DEPENDS:=@USB_SUPPORT +kmod-mac80211 +kmod-usb-core +@DRIVER_11N_SUPPORT
  FILES:=$(PKG_BUILD_DIR)/8192eu.ko
  AUTOLOAD:=$(call AutoProbe,8192eu)
endef

define KernelPackage/$(PKG_NAME)/description
 Kernel modules for the Realtek RTL-8192EU USB 802.11bgn
 wireless USB adapters
endef

define Build/Prepare
	mkdir -p $(PKG_BUILD_DIR)
	$(CP) ./rtl8192EU_WiFi_linux_20210111/* $(PKG_BUILD_DIR)
endef

define Build/Compile
	$(MAKE) -C $(PKG_BUILD_DIR) $(MAKE_OPTS)
endef

$(eval $(call KernelPackage,$(PKG_NAME)))
