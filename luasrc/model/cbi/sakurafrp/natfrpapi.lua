module("luci.model.cbi.sakurafrp.natfrpapi", package.seeall)

local api = require "luci.model.cbi.sakurafrp.api"
local prog = api.prog

nodeTable = {}

function curlRequest(url, method, ...)
    if ... ~= nil then
        local args = { ... }
        args = table.concat(args, "&")
        url = url .. "?" .. args
    end

    return api.exec("curl -X %s %s", method, url)
end

function fetch_nodes(token)
    local response = curlRequest("https://api.natfrp.com/launcher/get_nodes", "GET", "token=" .. token)
    return luci.jsonc.parse(response).data
end

function fetch_tunnels(token)
    local response = curlRequest("https://api.natfrp.com/launcher/get_tunnels", "GET", "token=" .. token)
    return luci.jsonc.parse(response).data
end

function verify_token(token)
    api.output_log("Verifying token=%s", tostring(token))
    local response = curlRequest("https://api.natfrp.com/launcher/get_tunnels", "GET", "token=" .. token)
    return luci.jsonc.parse(response).success == true
end

function apply_nodes(token)
    local data = fetch_nodes(token)
    for _, v in pairs(data) do
        nodeTable[v.id] = v.name
    end
end

function local_remote_wrapper(tunnel_data)
    local result = {
        _local = "",
        remote = ""
    }
    function map_port(port)
        if (port == "HTTP") then
            return "80"
        elseif (port == "HTTPS") then
            return "443"
        else
            return port
        end
    end

    local node = string.format("[%s]", nodeTable[tunnel_data.node])
    local type = tunnel_data.type
    local description = tunnel_data.description

    if (type == "wol") then
        result._local = ""
        result.remote = node
    elseif (type == "etcp" or type == "eudp") then
        result.remote = node
        result._local = description
    else
        description = string.gsub(description, " ", "")
        local position = string.find(description, "→")

        local remote_port = string.sub(description, 1, position-1)
        local remote_host = "NotProvided"
        local remote_ip = "NotProvided"
        remote_port = map_port(remote_port)

        result.remote = string.format("%s<br>%s:%s<br>%s:%s", node, remote_host, remote_port, remote_ip, remote_port)
        result._local = string.sub(description, position+3)
    end

    return result, description
end

function apply_tunnels(token)
    local data = fetch_tunnels(token)
    for _, v in pairs(data) do
        local id = tostring(v.id)
        local wrapped = local_remote_wrapper(v)

        api.output_log("Setting up tunnel{id=%s, name=%s}", id, v.name)

        api.uci_create_type_id(id, "tunnel")
        api.uci_set_type_id(id, "id", id)
        api.uci_set_type_id(id, "tunnel_name", v.name)
        api.uci_set_type_id(id, "note", v.note)
        api.uci_set_type_id(id, "type", v.type)
        api.uci_set_type_id(id, "local", wrapped._local)
        api.uci_set_type_id(id, "remote", wrapped.remote)
    end
end

function remove_tunnels()
    api.uci_remove_all_type("tunnel")
end

function refresh_tunnels()
    token = api.uci_get_type_id("config", "token", "")
    return refresh_tunnels_token(token)
end

function refresh_tunnels_token(token)
    remove_tunnels()
    if token == nil or token == "" or type(token) ~= "string" then return end

    api.output_log("Refreshing with token %s.", token)
    if verify_token(token) then
        apply_nodes(token)
        apply_tunnels(token)
    end
end