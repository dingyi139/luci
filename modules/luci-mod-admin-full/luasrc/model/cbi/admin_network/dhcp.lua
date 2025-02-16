-- Copyright 2008 DingYi <dingyi139@gmail.com>
-- Licensed to the public under the Apache License 2.0.

local ipc = require "luci.ip"
local sys = require "luci.sys"
local o
require "luci.util"

m = Map("dhcp", translate("DHCP and DNS"))

s = m:section(TypedSection, "dnsmasq", translate("Server Settings"))
s.anonymous = true
s.addremove = false

s:tab("general", translate("General Settings"))
s:tab("files", translate("Resolv and Hosts Files"))
s:tab("tftp", translate("TFTP Settings"))
s:tab("advanced", translate("Advanced Settings"))

s:taboption("general", Flag, "authoritative",
	translate("Authoritative"))

s:taboption("files", Flag, "readethers",
	translate("Use <code>/etc/ethers</code>"))

s:taboption("files", Value, "leasefile",
	translate("Leasefile"))

s:taboption("files", Flag, "noresolv",
	translate("Ignore resolve file")).optional = true

rf = s:taboption("files", Value, "resolvfile",
	translate("Resolve file"))
rf:depends("noresolv", "")
rf.optional = true

s:taboption("files", Flag, "nohosts",
	translate("Ignore <code>/etc/hosts</code>")).optional = true

s:taboption("files", DynamicList, "addnhosts",
	translate("Additional Hosts files")).optional = true

qu = s:taboption("advanced", Flag, "quietdhcp",
	translate("Suppress logging"))
qu.optional = true

bp = s:taboption("advanced", Flag, "boguspriv",
	translate("Filter private"))
bp.default = bp.enabled

s:taboption("advanced", Flag, "localise_queries",
	translate("Localise queries"))

s:taboption("general", Value, "local",
	translate("Local server"))

s:taboption("general", Value, "domain",
	translate("Local domain"))

s:taboption("advanced", Flag, "strictorder",
	translate("Strict order")).optional = true

s:taboption("advanced", Flag, "allservers",
	translate("All Servers")).optional = true

df = s:taboption("general", DynamicList, "server", translate("DNS forwardings"))
df.optional = true

rp = s:taboption("general", Flag, "rebind_protection",
	translate("Rebind protection"))
rp.rmempty = false

rl = s:taboption("general", Flag, "rebind_localhost",
	translate("Allow localhost"))
rl:depends("rebind_protection", "1")

rd = s:taboption("general", DynamicList, "rebind_domain",
	translate("Domain whitelist"))
rd.optional = true
rd:depends("rebind_protection", "1")
rd.datatype = "host(1)"
rd.placeholder = "ihost.netflix.com"

pt = s:taboption("advanced", Value, "port",
	translate("<abbr title=\"Domain Name System\">DNS</abbr> server port"))
pt.optional = true
pt.datatype = "port"
pt.placeholder = 53

qp = s:taboption("advanced", Value, "queryport",
	translate("<abbr title=\"Domain Name System\">DNS</abbr> query port"))
qp.optional = true
qp.datatype = "port"
qp.placeholder = translate("any")

em = s:taboption("advanced", Value, "ednspacket_max",
	translate("<abbr title=\"maximal\">Max.</abbr> <abbr title=\"Extension Mechanisms for " ..
		"Domain Name System\">EDNS0</abbr> packet size"))
em.optional = true
em.datatype = "uinteger"
em.placeholder = 1232

cq = s:taboption("advanced", Value, "dnsforwardmax",
	translate("<abbr title=\"maximal\">Max.</abbr> concurrent queries"))
cq.optional = true
cq.datatype = "uinteger"
cq.placeholder = 150

cs = s:taboption("advanced", Value, "cachesize",
	translate("Size of DNS query cache"))
cs.optional = true
cs.datatype = "range(0,10000)"
cs.placeholder = 1000

s:taboption("tftp", Flag, "enable_tftp",
	translate("Enable TFTP server")).optional = true

tr = s:taboption("tftp", Value, "tftp_root",
	translate("TFTP server root"))
tr.optional = true
tr:depends("enable_tftp", "1")
tr.placeholder = "/"

db = s:taboption("tftp", Value, "dhcp_boot",
	translate("Network boot image"))
db.optional = true
db:depends("enable_tftp", "1")
db.placeholder = "pxelinux.0"

o = s:taboption("general", Flag, "localservice",
	translate("Local Service Only"))
o.optional = false
o.rmempty = false

o = s:taboption("general", Flag, "nonwildcard",
	translate("Non-wildcard"))
o.optional = false
o.rmempty = false

o = s:taboption("general", DynamicList, "interface",
	translate("Listen Interfaces"))
o.optional = true
o:depends("nonwildcard", true)

o = s:taboption("general", DynamicList, "notinterface",
	translate("Exclude interfaces"))
o.optional = true
o:depends("nonwildcard", true)

m:section(SimpleSection).template = "admin_network/lease_status"

s = m:section(TypedSection, "host", translate("Static Leases"))
s.addremove = true
s.anonymous = true
s.template = "cbi/tblsection"

name = s:option(Value, "name", translate("Hostname"))
name.datatype = "hostname('strict')"
name.rmempty  = true
name.width="14%"

function name.write(self, section, value)
	Value.write(self, section, value)
	m:set(section, "dns", "1")
end

function name.remove(self, section)
	Value.remove(self, section)
	m:del(section, "dns")
end

mac = s:option(Value, "mac", translate("<abbr title=\"Media Access Control\">MAC</abbr>-Address"))
mac.datatype = "list(macaddr)"
mac.rmempty  = true
mac.width="17%"

function mac.cfgvalue(self, section)
	local val = Value.cfgvalue(self, section)
	return ipc.checkmac(val) or val
end

ip = s:option(Value, "ip", translate("<abbr title=\"Internet Protocol Version 4\">IPv4</abbr>-Address"))
ip.datatype = "or(ip4addr,'ignore')"
ip.width="14%"

time = s:option(Value, "leasetime", translate("Lease times"))
time.rmempty = true
time.width="13%"

duid = s:option(Value, "duid", translate("<abbr title=\"The DHCP Unique Identifier\">DUID</abbr>"))
duid.datatype = "and(rangelength(20,36),hexstring)"
fp = io.open("/var/hosts/odhcpd")
if fp then
	for line in fp:lines() do
		local net_val, duid_val = string.match(line, "# (%S+)%s+(%S+)")
		if duid_val then
			duid:value(duid_val, duid_val)
		end
	end
	fp:close()
end

hostid = s:option(Value, "hostid", translate("<abbr title=\"Internet Protocol Version 6\">IPv6</abbr>-Suffix (hex)"))

sys.net.host_hints(function(m, v4, v6, name)
	if m and v4 then
		ip:value(v4)
		mac:value(m, "%s (%s)" %{ m, name or v4 })
	end
end)

function ip.validate(self, value, section)
	local m = mac:formvalue(section) or ""
	local n = name:formvalue(section) or ""
	if value and #n == 0 and #m == 0 then
		return nil, translate("One of hostname or mac address must be specified!")
	end
	return Value.validate(self, value, section)
end

d = m:section(TypedSection, "domain", translate("Custom domain"))

d.addremove = true
d.anonymous = true
d.template = "cbi/tblsection"

dns_name = d:option(Value, "name", translate("Domain name"))
dns_name.datatype = "hostname"
dns_name.rmempty  = true

dns_ip = d:option(Value, "ip", translate("<abbr title=\"Internet Protocol Version 4\">IPv4</abbr>-Address"))
dns_ip.datatype = "or(ip4addr,'ignore')"

dns_comments = d:option(Value, "comments", translate("Comments"))
dns_comments.rmempty  = true

return m
