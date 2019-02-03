-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	registerMenuItem(Interface.getString("list_menu_createitem"), "insert", 5);
end

function onAbilityChanged()
	for _,w in ipairs(getWindows()) do
		w.idelete.setVisibility(bEditMode);
	end
end

function onListChanged()
	update();
end

function update()
	local bEditMode = (window.parentcontrol.window.skills_iedit.getValue() == 1);
	for _,w in ipairs(getWindows()) do
		w.idelete.setVisibility(bEditMode);
	end
end

function addEntry(bFocus)
	local w = createWindow();
	if bFocus and w then
		w.name.setFocus();
	end
	return w;
end

function onMenuSelection(item)
	if item == 5 then
		addEntry(true);
	end
end

function addSkillReference(nodeSource)
	if not nodeSource then
		return;
	end
	
	local sName = StringManager.trim(DB.getValue(nodeSource, "name", ""));
	if sName == "" then
		return;
	end
	
	local wSkill = nil;
	for _,w in pairs(getWindows()) do
		if StringManager.trim(w.name.getValue()) == sName then
			wSkill = w;
			break;
		end
	end
	if not wSkill then
		wSkill = createWindow();
		
		wSkill.name.setValue(sName);
		if DataCommon.skilldata[sName] then
			wSkill.stat.setStringValue(DataCommon.skilldata[sName].stat);
		else
			wSkill.stat.setStringValue(DB.getValue(nodeSource, "stat", ""):lower());
		end
	end
	if wSkill then
		DB.setValue(wSkill.getDatabaseNode(), "text", "formattedtext", DB.getValue(nodeSource, "text", ""));
	end
end
