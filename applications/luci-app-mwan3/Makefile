#
# Copyright (C) 2018 DingYi <dingyi139@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for the MWAN3 multiwan hotplug script
LUCI_DEPENDS:=+luci-compat \
	+mwan3 \
	+libuci-lua \
	+luci-mod-admin-full \
	+luci-lib-nixio
LUCI_PKGARCH:=all
PKG_LICENSE:=GPLv2

PKG_MAINTAINER:=DingYi <dingyi139@gmail.com>

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
