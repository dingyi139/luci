-- Copyright (C) 2018 DingYi <dingyi139@gmail.com>
-- Licensed to the public under the Apache License 2.0.

local netmod = luci.model.network

local _, p
for _, p in ipairs({"pppoe"}) do

	local proto = netmod:register_protocol(p)

	function proto.get_i18n(self)
		if p == "pppoe" then
			return luci.i18n.translate("PPPoE")
		end
	end

	function proto.ifname(self)
		return p .. "-" .. self.sid
	end

	function proto.opkg_package(self)
		if p == "pppoe" then
			return "ppp-mod-pppoe"
		end
	end

	function proto.is_installed(self)
		if p == "pppoe" then
			return (nixio.fs.glob("/usr/lib/pppd/*/rp-pppoe.so")() ~= nil)
		end
	end

	function proto.is_floating(self)
		return (p ~= "pppoe")
	end

	function proto.is_virtual(self)
		return true
	end

	function proto.get_interfaces(self)
		if self:is_floating() then
			return nil
		else
			return netmod.protocol.get_interfaces(self)
		end
	end

	function proto.contains_interface(self, ifc)
		if self:is_floating() then
			return (netmod:ifnameof(ifc) == self:ifname())
		else
			return netmod.protocol.contains_interface(self, ifc)
		end
	end

	netmod:register_pattern_virtual("^%s%%-%%w" % p)
end
