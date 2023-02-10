#Copyright (C) 2023-2025 xiaorouji

include $(TOPDIR)/rules.mk


PKG_NAME:=luci-app-sakurafrp
PKG_VERSION:=1.0.0
PKG_RELEASE:=1
PKG_MAINTAINER:=wintbit
PKG_LICENSE:=MIT
PKG_LICENSE_FILES:=LICENSE
PKG_BUILD_DIR=${BUILD_DIR}/${PKG_NAME}

LUCI_TITLE:=LuCI support for SakuraFrp
LUCI_PKGARCH:=all
LUCI_DEPENDS:=+wget	+curl

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-sakurafrp
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=SakuraFrp for Luci
	PKGARCH:=all
endef

define Package/luci-app-sakurafrp/description
	Added Luci support for SakuraFrp
endef

define Package/$(PKG_NAME)/conffiles
	/etc/config/sakurafrp
endef

define Build/Configure
endef

define Build/Compile
endef

include $(TOPDIR)/feeds/luci/luci.mk