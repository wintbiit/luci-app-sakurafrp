local api = require "luci.model.cbi.sakurafrp.api"
local fs = api.fs
local prog = api.prog

m = Map(prog, translate("Manual Edit frpc.ini"))
s = m:section(NamedSection, "other")
o = s:option(TextValue, "frpc_config", "", "<font color='red'>" .. translate("Please note. frpc.ini will be overwritten once you changed tunnel config and then run frpc!") .. "</font>")
o.rows = 25
o.wrap = "off"
o.cfgvalue = function(self, section)
    return fs.readfile(api.conf_file) or ""
end
o.write = function(self, section, value)
    fs.writefile(api.conf_file, value:gsub("\r\n", "\n"))
end
o.remove = function(self, section, value)
    fs.writefile(api.conf_file, "")
end

return m