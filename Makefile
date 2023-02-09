include $(TOPDIR)/rules.mk

LUCI_TITLE:=LuCI support for SakuraFrp
LUCI_PKGARCH:=all
PKG_NAME:=luci-app-sakurafrp
PKG_VERSION:=1.0.2
PKG_RELEASE:=1

PKG_MAINTAINER:=wintbit
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE

include $(TOPDIR)/feeds/luci/luci.mk