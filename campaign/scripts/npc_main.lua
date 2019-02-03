-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function updateControl(sControl, bReadOnly, bForceHide)
	if not self[sControl] then
		return false;
	end

	return self[sControl].update(bReadOnly, bForceHide);
end

function update()	
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState("npc", nodeRecord);

	local bSection1 = false;
	if User.isHost() then
		if updateControl("nonid_name", bReadOnly) then bSection1 = true; end;
	else
		updateControl("nonid_name", bReadOnly, true);
	end
	
	updateControl("atk", bReadOnly);
	updateControl("crittable", bReadOnly);
	updateControl("ac", bReadOnly);
	updateControl("hd", bReadOnly);	
	updateControl("speed", bReadOnly);
	updateControl("actiondice", bReadOnly);
	updateControl("specialqualities", bReadOnly);	
	updateControl("alignment", bReadOnly);
	
	updateControl("type", bReadOnly);
	updateControl("size", bReadOnly);
	
	updateControl("languages", bReadOnly);
	updateControl("treasure", bReadOnly);
end
