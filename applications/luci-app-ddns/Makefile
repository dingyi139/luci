#
# Copyright (C) 2018 DingYi <dingyi139@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0

include $(TOPDIR)/rules.mk

# PKG_NAME:=luci-app-ddns

# Version == major.minor.patch
# increase on new functionality (minor) or patches (patch)
PKG_VERSION:=1.0

# Release == build
# increase on changes of translation files
PKG_RELEASE:=68

PKG_LICENSE:=Apache-2.0
PKG_MAINTAINER:=DingYi <dingyi139@gmail.com>

# LuCI specific settings
LUCI_TITLE:=LuCI Support for Dynamic DNS Client (ddns-scripts)
LUCI_DEPENDS:=+luci-mod-admin-full +ddns-scripts +drill
# LUCI_PKGARCH:=all

define Package/$(PKG_NAME)/config
# shown in make menuconfig <Help>
help
	$(LUCI_TITLE)
	Version: $(PKG_VERSION)-$(PKG_RELEASE)
endef

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
