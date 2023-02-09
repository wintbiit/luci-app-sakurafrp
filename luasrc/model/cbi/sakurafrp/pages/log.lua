local api = require "luci.model.cbi.sakurafrp.api"
local prog = api.prog

f = Form(prog, translate("View Log"))
f.reset = false
f.submit = false
f.template = prog .. "/log"
return f
