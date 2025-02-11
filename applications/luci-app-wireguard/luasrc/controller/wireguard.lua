-- Copyright 2018 DingYi <dingyi139@gmail.com>
-- Licensed to the public under the Apache License 2.0.

module("luci.controller.wireguard", package.seeall)

function index()
	entry({"admin", "status", "wireguard"}, template("wireguard"), _("WireGuard Status"), 94)
end
