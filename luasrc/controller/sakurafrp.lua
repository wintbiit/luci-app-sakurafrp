module("luci.controller.sakurafrp", package.seeall)

local natfrpapi = require "luci.model.cbi.sakurafrp.natfrpapi"
local api = require "luci.model.cbi.sakurafrp.api"
local prog = api.prog

get_log = api.get_log
clear_log = api.clear_log
refresh_tunnels = natfrpapi.refresh_tunnels

frpc_install = api.frpc_install
frpc_restart = api.frpc_restart
frpc_stop = api.frpc_stop
frpc_force_stop = api.frpc_force_stop
frpc_fetch_config = api.frpc_fetch_config
frpc_uninstall = api.frpc_uninstall
function frpc_status()
        api.output_screen(api.frpc_status())
end

function index()
        prog = require("luci.model.cbi.sakurafrp.api").prog
        entry({"admin", "services", prog},
                cbi(prog .. "/pages/index"), translate("SakuraFrp"), 1).dependent = true

        entry({"admin", "services", prog, "config"},
                cbi(prog .. "/pages/index"), translate("Config"), 1).leaf = true

        entry({"admin", "services", prog, "tunnel_list"},
                cbi(prog .. "/pages/tunnel/list"), translate("Tunnels"), 2).leaf = true

        entry({"admin", "services", prog, "tunnel_config"},
                cbi(prog .. "/pages/tunnel/config")).leaf = true

        entry({"admin", "services", prog, "log"},
                cbi(prog .. "/pages/log"), translate("Log"), 3).leaf = true

        entry({"admin", "services", prog, "manual_edit"},
                cbi(prog .. "/pages/manual_edit"), translate("Manual Edit"), 4).leaf = true

        entry({"admin", "services", prog, "get_log"},
                call("get_log")).leaf = true
        entry({"admin", "services", prog, "clear_log"},
                call("clear_log")).leaf = true
        entry({"admin", "services", prog, "refresh_tunnels"},
                call("refresh_tunnels")).leaf = true
        entry({"admin", "services", prog, "frpc_install"},
                call("frpc_install")).leaf = true
        entry({"admin", "services", prog, "frpc_restart"},
                call("frpc_restart")).leaf = true
        entry({"admin", "services", prog, "frpc_stop"},
                call("frpc_stop")).leaf = true
        entry({"admin", "services", prog, "frpc_force_stop"},
                call("frpc_force_stop")).leaf = true
        entry({"admin", "services", prog, "frpc_status"},
                call("frpc_status")).leaf = true
        entry({"admin", "services", prog, "frpc_uninstall"},
                call("frpc_uninstall")).leaf = true

        entry({"admin", "services", prog, "frpc_fetch_config"},
                call("frpc_fetch_config")).leaf = true
end