#
# Copyright 2018 DingYi <dingyi139@gmail.com>
# Licensed to the public under the MIT License.
#

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-frps
PKG_VERSION:=1.0
PKG_RELEASE:=68

PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

PKG_MAINTAINER:=DingYi <dingyi139@gmail.com>

LUCI_TITLE:=LuCI support for Frps
LUCI_DEPENDS:=+wget +frps
LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/conffiles
/etc/config/frps
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
