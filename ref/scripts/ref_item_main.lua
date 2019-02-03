-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
end

function updateControl(sControl, bReadOnly, bID)
	if not self[sControl] then
		return false;
	end
		
	if not bID then
		return self[sControl].update(bReadOnly, true);
	end
	
	return self[sControl].update(bReadOnly);
end

function update()
	local nodeRecord = getDatabaseNode();
	
	local bWeapon, sTypeLower, sSubtypeLower = ItemManager2.isWeapon(nodeRecord);
	local bArmor = ItemManager2.isArmor(nodeRecord);
	
	local bSection3 = false;
	if updateControl("cost", true, true) then bSection3 = true; end
	if updateControl("weight", true, true) then bSection3 = true; end
	
	local bSection4 = false;
	if updateControl("bonus", true, bWeapon or bArmor) then bSection4 = true; end
	if updateControl("damage", true, bWeapon) then bSection4 = true; end
	
	if updateControl("ac", true, bArmor) then bSection4 = true; end
	if updateControl("checkpenalty", true, bArmor) then bSection4 = true; end
	if updateControl("speedpenalty", true, bArmor) then bSection4 = true; end
	
	divider3.setVisible(bSection3 and bSection4);
end
