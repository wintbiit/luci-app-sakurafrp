local api = require "luci.model.cbi.sakurafrp.api"
local natfrpapi = require "luci.model.cbi.sakurafrp.natfrpapi"
local prog = api.prog

local m = Map(prog, translate("Tunnel List"))

banner = m:section(NamedSection, "other")
banner.template = prog .. "/list_banner"

tunnels = m:section(TypedSection, "tunnel")

tunnels.template = "cbi/tblsection"
tunnels.anonymous = true
tunnels.sortable = true

enable = tunnels:option(Flag, "enable", translate("Enable"))
id = tunnels:option(DummyValue, "id", "ID")
tunnel_name = tunnels:option(DummyValue, "tunnel_name", translate("Tunnel Name"))
type = tunnels:option(DummyValue, "type", translate("Tunnel Type"))
_local = tunnels:option(DummyValue, "local", translate("Local"))
remote = tunnels:option(DummyValue, "remote", translate("Remote"))
remote.rawhtml = true
note = tunnels:option(DummyValue, "note", translate("Note"))
advanced_config = tunnels:option(Button, "advanced_config", translate("Advanced Config"))
advanced_config.inputstyle	= "apply"
function advanced_config.write(e, t)
    luci.http.redirect(api.url("tunnel_config", t))
end

return m