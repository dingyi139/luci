# Copyright (C) 2018 DingYi <dingyi139@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for PPTP VPN Server
LUCI_DEPENDS:=+pptpd +kmod-mppe +ppp
LUCI_PKGARCH:=all
PKG_VERSION:=1.0
PKG_RELEASE:=68

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
