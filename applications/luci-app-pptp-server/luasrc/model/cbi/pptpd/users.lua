m = Map("pptpd", translate("PPTP VPN Server"))
s = m:section(TypedSection, "users", translate("Users Manager"))
s.addremove = true
s.anonymous = true
s.template = "cbi/tblsection"
o = s:option(Flag, "enabled", translate("Tick ​​Select"))
o.rmempty = false
o = s:option(Value, "username", translate("User name"))
o.placeholder = translate("User name")
o.rmempty = true
o = s:option(Value, "password", translate("Password"))
o.rmempty = true
o = s:option(Value, "ipaddress", translate("IP address"))
o.placeholder = translate("Automatically")
o.datatype = "ipaddr"
o.rmempty = true
return m
