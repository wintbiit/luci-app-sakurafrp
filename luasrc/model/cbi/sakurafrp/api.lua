module("luci.model.cbi.sakurafrp.api", package.seeall)

prog = "sakurafrp"
profile_dir = "/usr/share/sakurafrp"
frpc_file = profile_dir .. "/frpc"
log_file = "/tmp/log/sakurafrp.log"
conf_file = profile_dir .. "/frpc.ini"
install_file = profile_dir .. "/install.sh"
http = require "luci.http"
uci = require "luci.model.uci".cursor()
sys = require "luci.sys"
i18n = require "luci.i18n"
fs = require "nixio.fs"

function exec(cmd, ...)
    return sys.exec(string.format(cmd, ...))
end

function exec_log(cmd, ...)
    sys.exec(string.format(cmd, ...) .. " >> " .. log_file)
end

function exec_print(cmd, ...)
    local stdout = exec(cmd, ...)
    luci.http.prepare_content("text/plain;charset=utf-8")
    luci.http.write(stdout)
    return stdout
end

function output_screen(msg, ...)
    luci.http.prepare_content("text/plain;charset=utf-8")
    luci.http.write(string.format(msg, ...))
end

function output_log(msg, ...)
    return sys.exec("echo " ..
        string.format(msg, ...) ..
        " >> " .. log_file)
end

function url(...)
    return luci.dispatcher.build_url("admin", "services", "sakurafrp", ...)
end

function uci_get_type(type, config, default)
    local value = uci:get_first(prog, type, config, default) or exec("echo -n $(uci -q get " .. prog .. ".@" .. type .."[0]." .. config .. ")")
    if (value == nil or value == "") and (default and default ~= "") then
        value = default
    end
    return value
end

function uci_get_type_id(id, config, default)
    local value = uci:get(prog, id, config, default) or exec("echo -n $(uci -q get " .. prog .. "." .. id .. "." .. config .. ")")
    if (value == nil or value == "") and (default and default ~= "") then
        value = default
    end
    return value
end

function uci_set_type_id(id, option, value)
    uci:set(prog, id, option, value)
    uci:save(prog)
end

function uci_create_type_id(id, type)
    uci:set(prog, id, type)
    uci:save(prog)
end

function grantExecute(file)
    exec("chmod a+rx %s", file)
end

function gen_uuid()
    local uuid = exec("echo -n $(cat /proc/sys/kernel/random/uuid)")
    assert(uuid)
    uuid = string.gsub(uuid, "-", "")
    return uuid
end

function clear_log()
    exec("echo '' > %s", log_file)
end

function get_log()
    exec_print("[ -f '%s' ] && cat %s", log_file, log_file)
end

function frpc_install()
    grantExecute(install_file)
    exec_log(install_file)
    grantExecute(frpc_file)
end

function frpc_version()
    return exec("echo -n $(%s -V)", frpc_file)
end

function frpc_restart()
    output_log("Triggered restart")
    grantExecute("/etc/init.d/sakurafrp")
    frpc_install()
    sys.call("/etc/init.d/sakurafrp restart >> " .. log_file)
end

function frpc_stop()
    sys.call("/etc/init.d/sakurafrp stop > /dev/null 2>&1")
end

function frpc_force_stop()
    frpc_stop()
    sys.call(string.format("kill -9 $(pidof %s)", frpc_file))
end

function frpc_status()
    local installed = exec("if [ -f %s ]; then echo 1; else echo 0; fi", frpc_file)

    if (tonumber(installed) == 0) then
        return i18n.translate("Frpc Not Installed (Will be automatically installed when run.)")
    end

    local version = exec("echo -n $(%s -V)", frpc_file)
    local status = exec("if [ -f /var/lock/sakurafrp.lock ]; then echo Frpc Running; else echo Frpc Not Running; fi")
    status = i18n.translate(status)

    return string.format("%s [%s]", status, version)
end

function frpc_fetch_config()
    exec_print("[ -f '%s' ] && cat %s", conf_file, conf_file)
end

function frpc_uninstall()
    frpc_force_stop()
    exec("rm -rf %s %s %s", frpc_file, profile_dir .. "/lastrun", conf_file)
end