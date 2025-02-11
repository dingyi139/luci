local s = require "luci.sys"
local net = require"luci.model.network".init()
local ifaces = s.net:devices()
local m, s, o
m = Map("pptpd", translate("PPTP VPN Server"))
m.template = "pptpd/index"

s = m:section(TypedSection, "service")
s.anonymous = true

o = s:option(DummyValue, "pptpd_status", translate("Current Condition"))
o.template = "pptpd/status"
o.value = translate("Collecting data...")

o = s:option(Flag, "enabled", translate("Enable VPN Server"))
o.rmempty = false

o = s:option(Value, "localip", translate("Server IP"))
o.datatype = "ipaddr"
o.placeholder = translate("192.168.8.1")
o.rmempty = true
o.default = "192.168.8.1"

o = s:option(Value, "remoteip", translate("Client IP"))
o.placeholder = translate("192.168.8.10-20")
o.rmempty = true
o.default = "192.168.8.10-20"

--[[
o = s:option(Value, "dns", translate("DNS IP address"))
o.placeholder = translate("192.168.8.1")
o.datatype = "ipaddr"
o.rmempty = true
o.default = "192.168.8.1"
]]--

o = s:option(Flag, "mppe", translate("Enable MPPE Encryption"))
o.rmempty = false
return m
