-- Copyright 2020 lwz322 <lwz322@qq.com>
-- Licensed to the public under the MIT License.

local m, s, o

m = Map("frps")
m.title = translate("Frps - Server Settings")

s = m:section(NamedSection, "main", "frps")
s.anonymous = true
s.addremove = false

o = s:option(Value, "bind_port", translate("Bind port"))
o.datatype = "port"
o.rmempty = false

o = s:option(Value, "token", translate("Token"))
o.password = true

o = s:option(Flag, "tcp_mux", translate("TCP mux"))
o.enabled = "true"
o.disabled = "false"
o.defalut = o.enabled
o.rmempty = false

o = s:option(Flag, "tls_only", translate("Enforce frps only accept TLS connection"))
o.enabled = "true"
o.disabled = "false"
o.default = o.disabled
o.rmempty = false

o = s:option(Value, "bind_udp_port", translate("UDP bind port"))
o.datatype = "port"

o = s:option(Value, "kcp_bind_port", translate("KCP bind port"))
o.datatype = "port"

o = s:option(Value, "vhost_http_port", translate("vhost http port")) 
o.datatype = "port"

o = s:option(Value, "vhost_https_port", translate("vhost https port"))
o.datatype = "port"

o = s:option(DynamicList, "extra_setting", translate("Extra Settings"))
o.placeholder = "option=value"

return m
