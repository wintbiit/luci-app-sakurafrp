local api = require "luci.model.cbi.sakurafrp.api"
local natfrpapi = require "luci.model.cbi.sakurafrp.natfrpapi"
local prog = api.prog

m = Map(prog, "Luci Support for SakuraFrp")

banner = m:section(NamedSection, "other")
banner.template = prog .. "/index_banner"

frpc = m:section(NamedSection, "other", "", api.frpc_status())
frpc:append(Template(prog .. "/frpc_banner"))

user = m:section(NamedSection, "config", "", translate("User Config"))
user.addremove = false
user.anonymous = true
enable = user:option(Flag, "enable", translate("Run SakuraFrp"))
token = user:option(Value, "token", translate("Access Token"))
token.validate = function(self, value, t)
    if natfrpapi.verify_token(value) then
        return value
    else
        return nil, translate("Invalid Token!")
    end
end

local apply = luci.http.formvalue("cbi.apply")
if apply then
    api.frpc_restart()
    --luci.dispatcher.build_url("admin", "services", "sakurafrp", "frpc_restart")
end
return m