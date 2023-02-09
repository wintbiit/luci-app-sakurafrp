local api = require "luci.model.cbi.sakurafrp.api"
local natfrpapi = require "luci.model.cbi.sakurafrp.natfrpapi"
local prog = api.prog

if not arg[1] or not api.uci:get(prog, arg[1]) then
    luci.http.redirect(api.url("tunnel_list"))
end

m = Map(prog, translate("Tunnel Config"), translate("Not yet implemented."))
m.redirect = api.url()

tunnel = m:section(NamedSection, arg[1])


return m