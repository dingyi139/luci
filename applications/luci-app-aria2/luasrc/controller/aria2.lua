--[[
LuCI - Lua Configuration Interface - aria2 support

Copyright 2014-2015 nanpuyue <nanpuyue@gmail.com>
Modified by kuoruan <kuoruan@gmail.com>

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0
]]--

module("luci.controller.aria2", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/aria2") then
		return
	end

	local page = entry({"admin", "nas", "aria2"}, cbi("aria2"), _("Aria2 Download"), 35)
	page.dependent = true

	entry({"admin", "nas", "aria2", "status"}, call("status")).leaf = true

end

function status()
	local sys  = require "luci.sys"
	local ipkg = require "luci.model.ipkg"
	local http = require "luci.http"
	local uci  = require "luci.model.uci".cursor()

	local status = {
		running = (sys.call("pidof aria2c > /dev/null") == 0),
		yaaw = ipkg.installed("yaaw"),
		webui = ipkg.installed("webui-aria2")
	}

	http.prepare_content("application/json")
	http.write_json(status)
end
