#
# Copyright (C) 2018 DingYi <dingyi139@gmail.com>
#
# This is free software, licensed under the Apache License, Version 2.0 .
#

include $(TOPDIR)/rules.mk

LUCI_TITLE:=WireGuard Status
LUCI_DEPENDS:=+wireguard +wireguard-tools +kmod-wireguard +luci-proto-wireguard +qrencode
PKG_VERSION:=1.0
PKG_RELEASE:=68
LUCI_PKGARCH:=all

include ../../luci.mk

# call BuildPackage - OpenWrt buildroot signature
