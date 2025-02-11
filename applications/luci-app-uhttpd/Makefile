#
# Copyright (C) 2018 DingYi <dingyi139@gmail.com>
#
# This is free software, licensed under the GNU General Public License v2.
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=uHTTPd Webserver Configuration
LUCI_DEPENDS:=+uhttpd
LUCI_PKGARCH:=all

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=Daniel Dickinson <openwrt@daniel.thecshore.com>

LUA_TARGET:=source

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
