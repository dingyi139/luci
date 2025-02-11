-- Copyright 2018 DingYi <dingyi139@gmail.com>
module("luci.controller.pptpd", package.seeall)

function index()
    if not nixio.fs.access("/etc/config/pptpd") then return end

    entry({"admin", "vpn"}, firstchild(), "VPN", 50).dependent = false
    entry({"admin", "vpn", "pptpd"}, alias("admin", "vpn", "pptpd", "settings"),
          _("PPTP VPN Server"), 5)
    entry({"admin", "vpn", "pptpd", "settings"}, cbi("pptpd/settings"),
          _("General Settings"), 10).leaf = true
    entry({"admin", "vpn", "pptpd", "users"}, cbi("pptpd/users"),
          _("Users Manager"), 20).leaf = true
    entry({"admin", "vpn", "pptpd", "online"}, form("pptpd/online"),
          _("Online Users"), 30).leaf = true
    entry({"admin", "vpn", "pptpd", "status"}, call("status")).leaf = true
end

function status()
    local e = {}
    e.status = luci.sys.call("pidof %s >/dev/null" % "pptpd") == 0
    luci.http.prepare_content("application/json")
    luci.http.write_json(e)
end
