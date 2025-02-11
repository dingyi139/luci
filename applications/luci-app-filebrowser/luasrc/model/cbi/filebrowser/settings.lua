m = Map("filebrowser", translate("FileBrowser"))
m:append(Template("filebrowser/status"))

s = m:section(TypedSection, "global", translate("Global Settings"))
s.anonymous = true
s.addremove = false

o = s:option(Flag, "enable", translate("Enable"))
o.rmempty = false

o = s:option(Value, "port", translate("Listen port"))
o.datatype = "port"
o.default = 7002
o.rmempty = false

o = s:option(Value, "root_path", translate("Root path"))
o.default = "/"
o.rmempty = false

o = s:option(Value, "project_directory", translate("Project directory"))
o.default = "/tmp"
o.rmempty = false

o = s:option(Button, "_download", translate("Manually download"))
o.template = "filebrowser/download"
o.inputstyle = "apply"
o.btnclick = "downloadClick(this);"
o.id = "download_btn"

m:append(Template("filebrowser/log"))

return m
