-- Copyright 2008 Steven Barth <steven@midlink.org>
-- Copyright 2011 Jo-Philipp Wich <jow@openwrt.org>
-- Licensed to the public under the Apache License 2.0.

if luci.http.formvalue("cbid.luci.1._list") then
	luci.http.redirect(luci.dispatcher.build_url("admin/system/flashops/backupfiles") .. "?display=list")
elseif luci.http.formvalue("cbid.luci.1._edit") then
	luci.http.redirect(luci.dispatcher.build_url("admin/system/flashops/backupfiles") .. "?display=edit")
	return
end

m = SimpleForm("luci", translate("Backup file list"))
m:append(Template("admin_system/backupfiles"))

if luci.http.formvalue("display") ~= "list" then
	f = m:section(SimpleSection, nil)

	l = f:option(Button, "_list", translate("Show current backup file list"))
	l.inputtitle = translate("Open list...")
	l.inputstyle = "apply"

	c = f:option(TextValue, "_custom")
	c.forcewrite = true
	c.rmempty = true
	c.cols = 70
	c.rows = 30

	c.cfgvalue = function(self, section)
		return nixio.fs.readfile("/etc/sysupgrade.conf")
	end

	m.handle = function(self, state, data)
		if state == FORM_VALID then
			if data._custom then
				nixio.fs.writefile("/etc/sysupgrade.conf", data._custom:gsub("\r\n", "\n"))
			else
				nixio.fs.writefile("/etc/sysupgrade.conf", "")
			end
		end
		return true
	end
else
	m.submit = false
	m.reset  = false

	f = m:section(SimpleSection, nil)

	l = f:option(Button, "_edit", translate("Back to configuration"))
	l.inputtitle = translate("Close list...")
	l.inputstyle = "link"


	d = f:option(DummyValue, "_detected")
	d.rawhtml = true
	d.cfgvalue = function(s)
		local list = io.popen(
			"( find $(sed -ne '/^[[:space:]]*$/d; /^#/d; p' /etc/sysupgrade.conf " ..
			"/lib/upgrade/keep.d/* 2>/dev/null) -type f 2>/dev/null; " ..
			"opkg list-changed-conffiles ) | sort -u"
		)

		if list then
			local files = { "<ul>" }

			while true do
				local ln = list:read("*l")
				if not ln then
					break
				else
					files[#files+1] = "<li>"
					files[#files+1] = luci.util.pcdata(ln)
					files[#files+1] = "</li>"
				end
			end

			list:close()
			files[#files+1] = "</ul>"

			return table.concat(files, "")
		end

		return "<em>" .. translate("No files found") .. "</em>"
	end

end

return m
