#Copyright (C) 2023-2025 WinterOfBit

include $(TOPDIR)/rules.mk

PKG_NAME:=luci-app-sakurafrp
PKG_VERSION=1.0.0
PKG_RELEASE:=0

PKG_BUILD_DIR:=$(BUILD_DIR)/$(PKG_NAME)

include $(INCLUDE_DIR)/package.mk

define Package/luci-app-sakurafrp
	SECTION:=luci
	CATEGORY:=LuCI
	SUBMENU:=3. Applications
	TITLE:=Luci Support for SakuraFrp
	PKGARCH:=all
endef

define Package/luci-app-sakurafrp/description
	This package contains LuCI Support and administration for SakuraFrp
endef

define Package/luci-app-sakurafrp/conffiles
/etc/config/sakurafrp
endef

define Build/Prepare
	$(foreach po,$(wildcard ${CURDIR}/po/*.po), \
		po2lmo $(po) $(PKG_BUILD_DIR)/$(patsubst %.po,%.lmo,$(notdir $(po)));)
endef

define Build/Configure
endef

define Build/Compile
endef

define Package/luci-app-sakurafrp/install
	$(INSTALL_DIR) $(1)/etc/config
	$(INSTALL_DIR) $(1)/etc/init.d
	$(INSTALL_DIR) $(1)/etc/uci-defaults
	$(INSTALL_DIR) $(1)/usr/share/rpcd
	$(INSTALL_DIR) $(1)/usr/share/sakurafrp
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/sakurafrp
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/sakurafrp/pages
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/model/cbi/sakurafrp/pages/tunnel
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/controller
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/view/sakurafrp
	$(INSTALL_DIR) $(1)/usr/lib/lua/luci/i18n

	$(INSTALL_DATA) $(PKG_BUILD_DIR)/sakurafrp.*.lmo $(1)/usr/lib/lua/luci/i18n/
	$(INSTALL_CONF) ./root/etc/config/sakurafrp $(1)/etc/config/sakurafrp
	$(INSTALL_BIN) ./root/etc/init.d/sakurafrp $(1)/etc/init.d/sakurafrp

	$(INSTALL_DATA) ./luasrc/model/cbi/sakurafrp/api.lua $(1)/usr/lib/lua/luci/model/cbi/sakurafrp/api.lua
	$(INSTALL_DATA) ./luasrc/model/cbi/sakurafrp/natfrpapi.lua $(1)/usr/lib/lua/luci/model/cbi/mentohust/natfrpapi.lua

	$(INSTALL_DATA) ./luasrc/model/cbi/sakurafrp/pages/index.lua $(1)/usr/lib/lua/luci/model/cbi/sakurafrp/pages/index.lua
	$(INSTALL_DATA) ./luasrc/model/cbi/sakurafrp/pages/log.lua $(1)/usr/lib/lua/luci/model/cbi/mentohust/pages/log.lua
	$(INSTALL_DATA) ./luasrc/model/cbi/sakurafrp/pages/manual_edit.lua $(1)/usr/lib/lua/luci/model/cbi/sakurafrp/pages/manual_edit.lua

	$(INSTALL_DATA) ./luasrc/model/cbi/sakurafrp/pages/tunnel/config.lua $(1)/usr/lib/lua/luci/model/cbi/mentohust/pages/tunnel/config.lua
	$(INSTALL_DATA) ./luasrc/model/cbi/sakurafrp/pages/tunnel/list.lua $(1)/usr/lib/lua/luci/model/cbi/sakurafrp/pages/tunnel/list.lua

	$(INSTALL_DATA) ./luasrc/controller/sakurafrp.lua $(1)/usr/lib/lua/luci/controller/sakurafrp.lua

	$(INSTALL_DATA) ./luasrc/view/sakurafrp/frpc_banner.lua $(1)/usr/lib/lua/luci/view/sakurafrp/frpc_banner.lua
	$(INSTALL_DATA) ./luasrc/view/sakurafrp/index_banner.lua $(1)/usr/lib/lua/luci/view/sakurafrp/index_banner.lua
	$(INSTALL_DATA) ./luasrc/view/sakurafrp/list_banner.lua $(1)/usr/lib/lua/luci/view/sakurafrp/list_banner.lua
	$(INSTALL_DATA) ./luasrc/view/sakurafrp/log.lua $(1)/usr/lib/lua/luci/view/sakurafrp/log.lua
	$(INSTALL_DATA) ./luasrc/view/sakurafrp/refresh.lua $(1)/usr/lib/lua/luci/view/sakurafrp/refresh.lua
endef