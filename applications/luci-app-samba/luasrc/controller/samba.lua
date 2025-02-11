-- Copyright 2018 DingYi <dingyi139@gmail.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.samba", package.seeall)

function index()
	if not nixio.fs.access("/etc/config/samba") then
		return
	end

	local page

	page = entry({"admin", "services", "samba"}, cbi("samba"), _("Network Shares"), 25)
	page.dependent = true
end
