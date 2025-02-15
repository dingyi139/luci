-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2010-2012 Jo-Philipp Wich <jow@openwrt.org>
-- Copyright 2010 Manuel Munz <freifunk at somakoma dot de>
-- Licensed to the public under the Apache License 2.0.

local fs  = require "nixio.fs"
local sys = require "luci.sys"

local inits = { }
local handled = false

for _, name in ipairs(sys.init.names()) do
	local index   = sys.init.index(name)
	local enabled = sys.init.enabled(name)

	if index < 255 then
		inits["%02i.%s" % { index, name }] = {
			name    = name,
			index   = tostring(index),
			enabled = enabled
		}
	end
end


m = SimpleForm("initmgr", translate("Initscripts"))
m.reset = false
m.submit = false


s = m:section(Table, inits)

i = s:option(DummyValue, "index", translate("Start priority"))
n = s:option(DummyValue, "name", translate("Initscript"))


e = s:option(Button, "endisable", translate("Enable/Disable"))

e.render = function(self, section, scope)
	if inits[section].enabled then
		self.title = translate("Enabled")
		self.inputstyle = "save"
	else
		self.title = translate("Disabled")
		self.inputstyle = "reset"
	end

	Button.render(self, section, scope)
end

e.write = function(self, section)
	if inits[section].enabled then
		handled = true
		inits[section].enabled = false
		return sys.init.disable(inits[section].name)
	else
		handled = true
		inits[section].enabled = true
		return sys.init.enable(inits[section].name)
	end
end


start = s:option(Button, "start", translate("Start"))
start.inputstyle = "apply"
start.write = function(self, section)
	handled = true
	sys.call("/etc/init.d/%s %s >/dev/null" %{ inits[section].name, self.option })
end

restart = s:option(Button, "restart", translate("Restart"))
restart.inputstyle = "reload"
restart.write = start.write

stop = s:option(Button, "stop", translate("Stop"))
stop.inputstyle = "remove"
stop.write = start.write



f = SimpleForm("rc", translate("Local Startup"))

t = f:field(TextValue, "rcs")
t.forcewrite = true
t.rmempty = true
t.rows = 20

function t.cfgvalue()
	return fs.readfile("/etc/rc.local") or ""
end

function f.handle(self, state, data)
	if not handled and state == FORM_VALID then
		if data.rcs then
			fs.writefile("/etc/rc.local", data.rcs:gsub("\r\n", "\n"))
		else
			fs.writefile("/etc/rc.local", "")
		end
	end
	return true
end

return m, f
