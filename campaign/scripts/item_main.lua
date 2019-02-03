-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	update();
	
	OptionsManager.registerCallback("HREN", onOptionChanged);
	onOptionChanged();
end

function onClose()
	OptionsManager.unregisterCallback("HREN", onOptionChanged);
end

function VisDataCleared()
	update();
end

function InvisDataAdded()
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

function onOptionChanged()
	local sOptionHREN = OptionsManager.getOption("HREN");
	local bShowVariant = (sOptionHREN == "variant");
	weight_label.setVisible(bShowVariant);
	weight.setVisible(bShowVariant);
end

function update()
	local nodeRecord = getDatabaseNode();
	local bReadOnly = WindowManager.getReadOnlyState(nodeRecord);
	local bID = LibraryData.getIDState("item", nodeRecord);
	
	local bWeapon, sTypeLower, sSubtypeLower = ItemManager2.isWeapon(nodeRecord);
	local bArmor = ItemManager2.isArmor(nodeRecord);
	
	local bSection1 = false;
	if User.isHost() then
		if updateControl("nonid_name", bReadOnly, true) then bSection1 = true; end;
	else
		updateControl("nonid_name", false);
	end
	if (User.isHost() or not bID) then
		if updateControl("nonidentified", bReadOnly, true) then bSection1 = true; end;
	else
		updateControl("nonidentified", false);
	end

	local bSection2 = false;
	if updateControl("type", bReadOnly, bID) then bSection2 = true; end
	if updateControl("subtype", bReadOnly, bID) then bSection2 = true; end
	
	local bSection3 = false;
	if updateControl("cost", bReadOnly, bID) then bSection3 = true; end
	if updateControl("weight", bReadOnly, bID) then bSection3 = true; end
	
	local bSection4 = false;
	if updateControl("bonus", bReadOnly, bID and (bWeapon or bArmor)) then bSection4 = true; end
	
	if updateControl("damage", bReadOnly, bID and bWeapon) then bSection4 = true; end
	if updateControl("ranges", bReadOnly, bID and bWeapon) then bSection4 = true; end
	
	if updateControl("ac", bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl("checkpenalty", bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl("speedpenalty", bReadOnly, bID and bArmor) then bSection4 = true; end
	if updateControl("fumbledie", bReadOnly, bID and bArmor) then bSection4 = true; end
		
	local bSection5 = bID;
	description.setVisible(bID);
	description.setReadOnly(bReadOnly);
		
	divider.setVisible(bSection1 and bSection2);
	divider2.setVisible((bSection1 or bSection2) and bSection3);
	divider3.setVisible((bSection1 or bSection2 or bSection3) and bSection4);
	divider4.setVisible((bSection1 or bSection2 or bSection3 or bSection4) and bSection5);
end
