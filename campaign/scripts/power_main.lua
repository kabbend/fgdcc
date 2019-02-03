-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	onSummaryChanged();
	update();
end

function onSummaryChanged()
	local nLevel = level.getValue();
	local sSource = source.getValue();
	local sSchool = school.getValue();
	
	local aText = {};
	if nLevel > 0 then
		table.insert(aText, Interface.getString("level") .. " " .. nLevel);
	end
	if sSource ~= "" then
		table.insert(aText, " " .. sSource);
	end
	if sSchool ~= "" then
		table.insert(aText, " (" .. sSchool .. ")");
	end
	
	summary_label.setValue(StringManager.capitalize(table.concat(aText, " ")));
end

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end
	
	return self[sControl].update(bReadOnly, bForceHide);
end

function update()
	local bReadOnly = WindowManager.getReadOnlyState(getDatabaseNode());

	local bSection1 = false;
	if updateControl("shortdescription", bReadOnly) then bSection1 = true; end;
	
	local bSection2 = false;
	if updateControl("level", bReadOnly, bReadOnly) then bSection2 = true; end;
	if updateControl("source", bReadOnly, bReadOnly) then bSection2 = true; end;
	if updateControl("school", bReadOnly, bReadOnly) then bSection2 = true; end;
	if (not bReadOnly) or (level.getValue() == 0 and source.getValue() == "" and school.getValue() == "") then
		summary_label.setVisible(false);
	else
		summary_label.setVisible(true);
		bSection2 = true;
	end
	
	local bSection3 = false;
	if updateControl("castingtime", bReadOnly) then bSection3 = true; end;
	if updateControl("range", bReadOnly) then bSection3 = true; end;
	if updateControl("duration", bReadOnly) then bSection3 = true; end;
	if updateControl("save", bReadOnly) then bSection3 = true; end;

	local bSection4 = false;
	if updateControl("general", bReadOnly) then bSection4 = true; end;
	if updateControl("manifestation", bReadOnly) then bSection4 = true; end;
	if updateControl("corruption", bReadOnly) then bSection4 = true; end;
	if updateControl("misfire", bReadOnly) then bSection4 = true; end;

	local bSection5 = false;
	if updateControl("description", bReadOnly) then bSection5 = true; end;
	
	divider.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
	divider4.setVisible((bSection1 or bSection2 or bSection3 or bSection4) and bSection5);
end
