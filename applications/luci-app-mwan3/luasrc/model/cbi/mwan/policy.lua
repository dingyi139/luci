-- Copyright 2014 Aedan Renner <chipdankly@gmail.com>
-- Copyright 2018 Florian Eckert <fe@dev.tdt.de>
-- Licensed to the public under the GNU General Public License v2.

local dsp = require "luci.dispatcher"
local uci = require "uci"

local m, s, o

function policyCheck()
	local policy_error = {}

	uci.cursor():foreach("mwan3", "policy",
		function (section)
			policy_error[section[".name"]] = false
			if string.len(section[".name"]) > 15 then
				policy_error[section[".name"]] = true
			end
		end
	)

	return policy_error
end

function policyError(policy_error)
	local warnings = ""
	for i, k in pairs(policy_error) do
		if policy_error[i] == true then
			warnings = warnings .. string.format("<strong>%s</strong><br />",
				translatef("WARNING: Policy %s has exceeding the maximum name of 15 characters", i)
				)
		end
	end

	return warnings
end

m = Map("mwan3", translate("MWAN - Policies"),
	policyError(policyCheck()))

s = m:section(TypedSection, "policy", nil)
s.addremove = true
s.dynamic = false
s.sectionhead = translate("Policy")
s.sortable = true
s.template = "cbi/tblsection"
s.extedit = dsp.build_url("admin", "network", "mwan", "policy", "%s")
function s.create(self, section)
	if #section > 15 then
		self.invalid_cts = true
	else
		TypedSection.create(self, section)
		m.uci:save("mwan3")
		luci.http.redirect(dsp.build_url("admin", "network", "mwan", "policy", section))
	end
end

o = s:option(DummyValue, "use_member", translate("Members assigned"))
o.rawhtml = true
function o.cfgvalue(self, s)
	local memberConfig, memberList = self.map:get(s, "use_member"), ""
	if memberConfig then
		for k,v in pairs(memberConfig) do
			memberList = memberList .. v .. "<br />"
		end
		return memberList
	else
		return "&#8212;"
	end
end

o = s:option(DummyValue, "last_resort", translate("Last resort"))
o.rawhtml = true
function o.cfgvalue(self, s)
	local action = self.map:get(s, "last_resort")
	if action == "blackhole" then
		return translate("blackhole (drop)")
	elseif action == "default" then
		return translate("default (use main routing table)")
	else
		return translate("unreachable (reject)")
	end
end

return m
