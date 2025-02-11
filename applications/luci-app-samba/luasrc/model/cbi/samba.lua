-- Copyright 2018 DingYi <dingyi139@gmail.com>
-- Licensed to the public under the Apache License 2.0.

m = Map("samba", translate("Network Shares"))

s = m:section(TypedSection, "samba", "共享设置")
s.anonymous = true

s:tab("general",  translate("General Settings"))
s:tab("template", translate("Edit Template"))

s:taboption("general", Value, "name", translate("Hostname"))
s:taboption("general", Value, "description", translate("Description"))
s:taboption("general", Value, "workgroup", translate("Workgroup"))

tmpl = s:taboption("template", Value, "_tmpl")
tmpl.template = "cbi/tvalue"
tmpl.rows = 20

function tmpl.cfgvalue(self, section)
	return nixio.fs.readfile("/etc/samba/smb.conf.template")
end

function tmpl.write(self, section, value)
	value = value:gsub("\r\n?", "\n")
	nixio.fs.writefile("//etc/samba/smb.conf.template", value)
end


s = m:section(TypedSection, "sambashare")
s.anonymous = true
s.addremove = true
s.template = "cbi/tblsection"

s:option(Value, "name", translate("Share name"))
pth = s:option(Value, "path", translate("Path"))
if nixio.fs.access("/etc/config/fstab") then
        pth.titleref = luci.dispatcher.build_url("admin", "system", "fstab")
end

ro = s:option(Flag, "read_only", translate("Read-only"))
ro.rmempty = false
ro.enabled = "yes"
ro.disabled = "no"

br = s:option(Flag, "browseable", translate("Browseable"))
br.rmempty = false
br.default = "yes"
br.enabled = "yes"
br.disabled = "no"

go = s:option(Flag, "guest_ok", translate("Allow guests"))
go.rmempty = false
go.enabled = "yes"
go.disabled = "no"

cm = s:option(Value, "create_mask", translate("Create mask"))
cm.rmempty = true
cm.size = 3

dm = s:option(Value, "dir_mask", translate("Directory mask"))
dm.rmempty = true
dm.size = 3


return m
