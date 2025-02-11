m = Map("vlmcsd")
m.title = translate("KMS Server")

m:section(SimpleSection).template  = "vlmcsd/vlmcsd_status"

s = m:section(TypedSection, "vlmcsd")
s.addremove = false
s.anonymous = true

enable = s:option(Flag, "enabled", translate("Enable"))
enable.rmempty = false

autoactivate = s:option(Flag, "autoactivate", translate("Auto activate"))
autoactivate.rmempty = false

return m
