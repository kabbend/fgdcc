-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

FEATURE_LANGUAGES = "languages";
FEATURE_THIEVES_CANT = "thieves' cant";

function onInit()
	ItemManager.setCustomCharAdd(onCharItemAdd);
	ItemManager.setCustomCharRemove(onCharItemDelete);
	initWeaponIDTracking();
end

function outputUserMessage(sResource, ...)
	local sFormat = Interface.getString(sResource);
	local sMsg = string.format(sFormat, ...);
	ChatManager.SystemMessage(sMsg);
end

--
-- CLASS MANAGEMENT
--

function sortClasses(a,b)
	return DB.getValue(a, "name", "") < DB.getValue(b, "name", "");
end

function getClassLevelSummary(nodeChar, bShort)
	if not nodeChar then
		return "";
	end
	
	local aClasses = {};

	local aSorted = {};
	for _,nodeChild in pairs(DB.getChildren(nodeChar, "classes")) do
		table.insert(aSorted, nodeChild);
	end
	table.sort(aSorted, sortClasses);
			
	for _,nodeChild in pairs(aSorted) do
		local sClass = DB.getValue(nodeChild, "name", "");
		local nLevel = DB.getValue(nodeChild, "level", 0);
		if nLevel > 0 then
			if bShort then
				sClass = sClass:sub(1,3);
			end
			table.insert(aClasses, sClass .. " level " .. math.floor(nLevel*100)*0.01);
		end
	end

	local sSummary = table.concat(aClasses, " / ");
	return sSummary;
end

--
-- ITEM/FOCUS MANAGEMENT
--

function onCharItemAdd(nodeItem)
	local sTypeLower = StringManager.trim(DB.getValue(DB.getPath(nodeItem, "type"), ""):lower());
	if StringManager.contains({"mounts and related gear" }, sTypeLower) then
		DB.setValue(nodeItem, "carried", "number", 0);
	else
		DB.setValue(nodeItem, "carried", "number", 1);
	end

	addToArmorDB(nodeItem);	
	addToWeaponDB(nodeItem);
end

function onCharItemDelete(nodeItem)
	removeFromArmorDB(nodeItem);
	removeFromWeaponDB(nodeItem);
end

function updateEncumbrance(nodeChar)
	local nEncTotal = 0;

	local nCount, nWeight;
	for _,vNode in pairs(DB.getChildren(nodeChar, "inventorylist")) do
		if DB.getValue(vNode, "carried", 0) ~= 0 then
			nCount = DB.getValue(vNode, "count", 0);
			if nCount < 1 then
				nCount = 1;
			end
			nWeight = DB.getValue(vNode, "weight", 0);
			
			nEncTotal = nEncTotal + (nCount * nWeight);
		end
	end

	DB.setValue(nodeChar, "encumbrance.load", "number", nEncTotal);
end

--
-- ARMOR MANAGEMENT
-- 

function removeFromArmorDB(nodeItem)
	-- Parameter validation
	if not ItemManager2.isArmor(nodeItem) then
		return;
	end

	-- If this armor was worn, recalculate AC
	if DB.getValue(nodeItem, "carried", 0) == 2 then
		DB.setValue(nodeItem, "carried", "number", 1);
	end
end

function addToArmorDB(nodeItem)
	-- Parameter validation
	local bIsArmor, _, sSubtypeLower = ItemManager2.isArmor(nodeItem);
	if not bIsArmor then
		return;
	end
	local bIsShield = (sSubtypeLower == "shield");

	-- Determine whether to auto-equip armor
	local bArmorAllowed = true;
	local bShieldAllowed = true;
	local nodeChar = nodeItem.getChild("...");
	if (bArmorAllowed and not bIsShield) or (bShieldAllowed and bIsShield) then
		local bArmorEquipped = false;
		local bShieldEquipped = false;
		for _,v in pairs(DB.getChildren(nodeItem, "..")) do
			if DB.getValue(v, "carried", 0) == 2 then
				local bIsItemArmor, _, sItemSubtypeLower = ItemManager2.isArmor(v);
				if bIsItemArmor then
					if (sItemSubtypeLower == "shield") then
						bShieldEquipped = true;
					else
						bArmorEquipped = true;
					end
				end
			end
		end
		if bShieldAllowed and bIsShield and not bShieldEquipped then
			DB.setValue(nodeItem, "carried", "number", 2);
		elseif bArmorAllowed and not bIsShield and not bArmorEquipped then
			DB.setValue(nodeItem, "carried", "number", 2);
		end
	end
end

function calcItemArmorClass(nodeChar)
	local nMainArmorTotal = 0;
	local nMainShieldTotal = 0;
	local nMainCheckPenalty = 0;
	local nMainSpeedPenalty = 0;
	local sMainFumbleDie = "d4";
	local nMainFumbleDie = 4;

	for _,vNode in pairs(DB.getChildren(nodeChar, "inventorylist")) do
		if DB.getValue(vNode, "carried", 0) == 2 then
			local bIsArmor, _, sSubtypeLower = ItemManager2.isArmor(vNode);
			if bIsArmor then
				local bID = LibraryData.getIDState("item", vNode, true);
				
				local bIsShield = (sSubtypeLower == "shield");
				if bIsShield then
					if bID then
						nMainShieldTotal = nMainShieldTotal + DB.getValue(vNode, "ac", 0) + DB.getValue(vNode, "bonus", 0);
					else
						nMainShieldTotal = nMainShieldTotal + DB.getValue(vNode, "ac", 0);
					end				
					
					local nItemCheckPenalty = DB.getValue(vNode, "checkpenalty", 0);
					if nItemCheckPenalty < 0 then
						if nMainCheckPenalty < 0 then
							nMainCheckPenalty = nMainCheckPenalty + nItemCheckPenalty;
						else
							nMainCheckPenalty = nItemCheckPenalty;
						end
					end			
					
					local nItemSpeedPenalty = DB.getValue(vNode, "speedpenalty", 0);
					if nItemSpeedPenalty < 0 then
						if nMainSpeedPenalty < 0 then
							nMainSpeedPenalty = math.min(nMainSpeedPenalty, nItemSpeedPenalty);
						else
							nMainSpeedPenalty = nItemSpeedPenalty;
						end
					end	
									
					local sItemFumbleDie = DB.getValue(vNode, "fumbledie");
					local nItemFumbleDie = tonumber(string.match(sItemFumbleDie, "d(%d+)"));
					if nItemFumbleDie > nMainFumbleDie then
						sMainFumbleDie = sItemFumbleDie;
						nMainFumbleDie = nItemFumbleDie;
					end
				else
					if bID then
						nMainArmorTotal = nMainArmorTotal + DB.getValue(vNode, "ac", 0) + DB.getValue(vNode, "bonus", 0);
					else
						nMainArmorTotal = nMainArmorTotal + DB.getValue(vNode, "ac", 0);
					end
					
					local nItemCheckPenalty = DB.getValue(vNode, "checkpenalty", 0);
					if nItemCheckPenalty < 0 then
						if nMainCheckPenalty < 0 then
							nMainCheckPenalty = nMainCheckPenalty + nItemCheckPenalty;
						else
							nMainCheckPenalty = nItemCheckPenalty;
						end
					end		
					
					local nItemSpeedPenalty = DB.getValue(vNode, "speedpenalty", 0);
					if nItemSpeedPenalty < 0 then
						if nMainSpeedPenalty < 0 then
							nMainSpeedPenalty = math.min(nMainSpeedPenalty, nItemSpeedPenalty);
						else
							nMainSpeedPenalty = nItemSpeedPenalty;
						end
					end
					
					local sItemFumbleDie = DB.getValue(vNode, "fumbledie");
					local nItemFumbleDie = tonumber(string.match(sItemFumbleDie, "d(%d+)")) or 0;
					if nItemFumbleDie > nMainFumbleDie then
						sMainFumbleDie = sItemFumbleDie;
						nMainFumbleDie = nItemFumbleDie;
					end
				end
			end
		end
	end

	local aMainFumbleDie = StringManager.convertStringToDice(sMainFumbleDie);
	
	DB.setValue(nodeChar, "ac.sources.armor", "number", nMainArmorTotal);
	DB.setValue(nodeChar, "ac.sources.shield", "number", nMainShieldTotal);
	DB.setValue(nodeChar, "speed.armor", "number", nMainSpeedPenalty);
	DB.setValue(nodeChar, "checkpenalty", "number", nMainCheckPenalty);
	DB.setValue(nodeChar, "fumbledie", "dice", aMainFumbleDie);
end

--
-- WEAPON MANAGEMENT
--

function removeFromWeaponDB(nodeItem)
	if not nodeItem then
		return false;
	end

	-- Check to see if any of the weapon nodes linked to this item node should be deleted
	local sItemNode = nodeItem.getNodeName();
	local sItemNode2 = "....inventorylist." .. nodeItem.getName();
	local bFound = false;
	for _,v in pairs(DB.getChildren(nodeItem, "...weaponlist")) do
		local sClass, sRecord = DB.getValue(v, "shortcut", "", "");
		if sRecord == sItemNode or sRecord == sItemNode2 then
			bFound = true;
			v.delete();
		end
	end

	return bFound;
end

function addToWeaponDB(nodeItem)
	-- Parameter validation
	if not ItemManager2.isWeapon(nodeItem) then
		return;
	end
	
	-- Get the weapon list we are going to add to
	local nodeChar = nodeItem.getChild("...");
	local nodeWeapons = nodeChar.createChild("weaponlist");
	if not nodeWeapons then
		return;
	end
	
	-- Set new weapons as equipped
	DB.setValue(nodeItem, "carried", "number", 2);

	-- Determine identification
	local nItemID = 0;
	if LibraryData.getIDState("item", nodeItem, true) then
		nItemID = 1;
	end
	
	-- Grab some information from the source node to populate the new weapon entries
	local sName;
	if nItemID == 1 then
		sName = DB.getValue(nodeItem, "name", "");
	else
		sName = DB.getValue(nodeItem, "nonid_name", "");
		if sName == "" then
			sName = Interface.getString("item_unidentified");
		end
		sName = "** " .. sName .. " **";
	end
	local nBonus = 0;
	if nItemID == 1 then
		nBonus = DB.getValue(nodeItem, "bonus", 0);
	end

	local sType = DB.getValue(nodeItem, "subtype", ""):lower();
	local bMelee = true;
	local bRanged = false;
	if sType:find("ranged") or sType:find("missile") then
		bMelee = false;
		bRanged = true;
	end
	
	-- Parse damage field
	local sDamage = DB.getValue(nodeItem, "damage", "");
	
	local aDmgClauses = {};
	local aWords = StringManager.parseWords(sDamage);
	local i = 1;
	while aWords[i] do
		local aDiceString = {};
		
		while StringManager.isDiceString(aWords[i]) do
			table.insert(aDiceString, aWords[i]);
			i = i + 1;
		end
		if #aDiceString == 0 then
			break;
		end
		
		local aDamageTypes = {};
		while StringManager.contains(DataCommon.dmgtypes, aWords[i]) do
			table.insert(aDamageTypes, aWords[i]);
			i = i + 1;
		end
		if bMagic then
			table.insert(aDamageTypes, "magic");
		end
		
		local rDmgClause = {};
		rDmgClause.aDice, rDmgClause.nMod = StringManager.convertStringToDice(table.concat(aDiceString, " "));
		rDmgClause.dmgtype = table.concat(aDamageTypes, ",");
		table.insert(aDmgClauses, rDmgClause);
		
		if StringManager.contains({ "+", "plus" }, aWords[i]) then
			i = i + 1;
		end
	end
	
	-- Create weapon entries
	if bMelee then
		local nodeWeapon = nodeWeapons.createChild();
		if nodeWeapon then
			DB.setValue(nodeWeapon, "isidentified", "number", nItemID);
			DB.setValue(nodeWeapon, "shortcut", "windowreference", "item", "....inventorylist." .. nodeItem.getName());
			
			local sAttackAbility = "";
			local sDamageAbility = "base";
			
			DB.setValue(nodeWeapon, "name", "string", sName);
			DB.setValue(nodeWeapon, "type", "number", 0);

			DB.setValue(nodeWeapon, "attackstat", "string", sAttackAbility);			
			DB.setValue(nodeWeapon, "attackbonus", "number", nBonus);

			local nodeDmgList = DB.createChild(nodeWeapon, "damagelist");
			if nodeDmgList then
				for kClause,rClause in ipairs(aDmgClauses) do
					local nodeDmg = DB.createChild(nodeDmgList);
					if nodeDmg then
						DB.setValue(nodeDmg, "dice", "dice", rClause.aDice);
						if kClause == 1 then
							DB.setValue(nodeDmg, "stat", "string", sDamageAbility);
							DB.setValue(nodeDmg, "bonus", "number", nBonus + rClause.nMod);
						else
							DB.setValue(nodeDmg, "bonus", "number", rClause.nMod);
						end
						DB.setValue(nodeDmg, "type", "string", rClause.dmgtype);
					end
				end
			end
		end
	end

	if bRanged then
		local nodeWeapon = nodeWeapons.createChild();
		if nodeWeapon then
			DB.setValue(nodeWeapon, "isidentified", "number", nItemID);
			DB.setValue(nodeWeapon, "shortcut", "windowreference", "item", "....inventorylist." .. nodeItem.getName());
			
			local sAttackAbility = "";
			local sDamageAbility = "";
			
			DB.setValue(nodeWeapon, "name", "string", sName);
			DB.setValue(nodeWeapon, "type", "number", 1);

			DB.setValue(nodeWeapon, "attackstat", "string", sAttackAbility);
			DB.setValue(nodeWeapon, "attackbonus", "number", nBonus);

			local nodeDmgList = DB.createChild(nodeWeapon, "damagelist");
			if nodeDmgList then
				for kClause,rClause in ipairs(aDmgClauses) do
					local nodeDmg = DB.createChild(nodeDmgList);
					if nodeDmg then
						DB.setValue(nodeDmg, "dice", "dice", rClause.aDice);
						if kClause == 1 then
							DB.setValue(nodeDmg, "stat", "string", sDamageAbility);
							DB.setValue(nodeDmg, "bonus", "number", nBonus + rClause.nMod);
						else
							DB.setValue(nodeDmg, "bonus", "number", rClause.nMod);
						end
						DB.setValue(nodeDmg, "type", "string", rClause.dmgtype);
					end
				end
			end
		end
	end
end

function initWeaponIDTracking()
	DB.addHandler("charsheet.*.inventorylist.*.isidentified", "onUpdate", onItemIDChanged);
end

function onItemIDChanged(nodeItemID)
	local nodeItem = nodeItemID.getChild("..");
	local nodeChar = nodeItemID.getChild("....");
	
	local sPath = nodeItem.getPath();
	for _,vWeapon in pairs(DB.getChildren(nodeChar, "weaponlist")) do
		local _,sRecord = DB.getValue(vWeapon, "shortcut", "", "");
		if sRecord == sPath then
			checkWeaponIDChange(vWeapon);
		end
	end
end

function checkWeaponIDChange(nodeWeapon)
	local _,sRecord = DB.getValue(nodeWeapon, "shortcut", "", "");
	if sRecord == "" then
		return;
	end
	local nodeItem = DB.findNode(sRecord);
	if not nodeItem then
		return;
	end
	
	local bItemID = LibraryData.getIDState("item", DB.findNode(sRecord), true);
	local bWeaponID = (DB.getValue(nodeWeapon, "isidentified", 1) == 1);
	if bItemID == bWeaponID then
		return;
	end
	
	local sName;
	if bItemID then
		sName = DB.getValue(nodeItem, "name", "");
	else
		sName = DB.getValue(nodeItem, "nonid_name", "");
		if sName == "" then
			sName = Interface.getString("item_unidentified");
		end
		sName = "** " .. sName .. " **";
	end
	DB.setValue(nodeWeapon, "name", "string", sName);
	
	local nBonus = 0;
	if bItemID then
		DB.setValue(nodeWeapon, "attackbonus", "number", DB.getValue(nodeWeapon, "attackbonus", 0) + DB.getValue(nodeItem, "bonus", 0));
		local aDamageNodes = UtilityManager.getSortedTable(DB.getChildren(nodeWeapon, "damagelist"));
		if #aDamageNodes > 0 then
			DB.setValue(aDamageNodes[1], "bonus", "number", DB.getValue(aDamageNodes[1], "bonus", 0) + DB.getValue(nodeItem, "bonus", 0));
		end
	else
		DB.setValue(nodeWeapon, "attackbonus", "number", DB.getValue(nodeWeapon, "attackbonus", 0) - DB.getValue(nodeItem, "bonus", 0));
		local aDamageNodes = UtilityManager.getSortedTable(DB.getChildren(nodeWeapon, "damagelist"));
		if #aDamageNodes > 0 then
			DB.setValue(aDamageNodes[1], "bonus", "number", DB.getValue(aDamageNodes[1], "bonus", 0) - DB.getValue(nodeItem, "bonus", 0));
		end
	end
	
	if bItemID then
		DB.setValue(nodeWeapon, "isidentified", "number", 1);
	else
		DB.setValue(nodeWeapon, "isidentified", "number", 0);
	end
end

--
-- ACTIONS
--

function rest(nodeChar, bLong)
	PowerManager.resetPowers(nodeChar, bLong);
	resetHealth(nodeChar, bLong);
end

function resetHealth(nodeChar, bLong)
	if bLong then
		-- Clear temporary hit points and subdual damage
		DB.setValue(nodeChar, "hp.temporary", "number", 0);
		DB.setValue(nodeChar, "hp.nonlethal", "number", 0);
		
		-- Heal 1 hit point
		local nWounds = DB.getValue(nodeChar, "hp.wounds", 0);
		nWounds = nWounds - 1;
		if nWounds < 0 then
			nWounds = 0;
		end
		DB.setValue(nodeChar, "hp.wounds", "number", nWounds);
	end	
end

--
-- CHARACTER SHEET DROPS
--

function addInfoDB(nodeChar, sClass, sRecord)
	-- Validate parameters
	if not nodeChar then
		return false;
	end
	
	if sClass == "reference_class" then
		addClassRef(nodeChar, sClass, sRecord);
	elseif sClass == "reference_classproficiency" then
		addClassProficiencyDB(nodeChar, sClass, sRecord);
	elseif sClass == "reference_classfeature" then
		addClassFeatureDB(nodeChar, sClass, sRecord);
	elseif sClass == "reference_skill" then
		addSkillRef(nodeChar, sClass, sRecord);
	else
		return false;
	end
	
	return true;
end

function resolveRefNode(sRecord)
	local nodeSource = DB.findNode(sRecord);
	if not nodeSource then
		local sRecordSansModule = StringManager.split(sRecord, "@")[1];
		nodeSource = DB.findNode(sRecordSansModule .. "@*");
		if not nodeSource then
			ChatManager.SystemMessage(Interface.getString("char_error_missingrecord"));
		end
	end
	return nodeSource;
end

function addClassProficiencyDB(nodeChar, sClass, sRecord)
	local nodeSource = resolveRefNode(sRecord);
	if not nodeSource then
		return;
	end
	
	local sText = DB.getValue(nodeSource, "text", "");
	if sText == "" then
		return;
	end
	
	local sType = nodeSource.getName();
	
	-- Armor or Weapon Proficiencies
	if StringManager.contains({"armor", "weapons"}, sType) then
		local sText = DB.getText(nodeSource, "text");
		addProficiencyDB(nodeChar, sType, sText);

	-- Skill Proficiencies
	elseif sType == "skills" then
		-- Parse the skill choice text
		local sText = DB.getText(nodeSource, "text");
			
		for sSkill in string.gmatch(sText, "(%a[%a%s]+)%,?") do
			local sTrim = StringManager.trim(sSkill);
			addSkillDB(nodeChar, sTrim);
		end
	end
end

function addProficiencyDB(nodeChar, sType, sText)
	-- Get the list we are going to add to
	local nodeList = nodeChar.createChild("proficiencylist");
	if not nodeList then
		return nil;
	end

	-- If proficiency is not none, then add it to the list
	if sText == "None" then
		return nil;
	end
	
	-- Make sure this item does not already exist
	for _,vProf in pairs(nodeList.getChildren()) do
		if DB.getValue(vProf, "name", "") == sText then
			return vProf;
		end
	end
	
	local nodeEntry = nodeList.createChild();
	local sValue;
	if sType == "armor" then
		sValue = Interface.getString("char_label_addprof_armor");
	elseif sType == "weapons" then
		sValue = Interface.getString("char_label_addprof_weapon");
	end
	sValue = sValue .. ": " .. sText;
	DB.setValue(nodeEntry, "name", "string", sValue);

	-- Announce
	outputUserMessage("char_abilities_message_profadd", DB.getValue(nodeEntry, "name", ""), DB.getValue(nodeChar, "name", ""));
	return nodeEntry;
end

function addSkillDB(nodeChar, sSkill)
	-- Get the list we are going to add to
	local nodeList = nodeChar.createChild("skilllist");
	if not nodeList then
		return nil;
	end
	
	-- Make sure this item does not already exist
	local nodeSkill = nil;
	for _,vSkill in pairs(nodeList.getChildren()) do
		if DB.getValue(vSkill, "name", "") == sSkill then
			nodeSkill = vSkill;
			break;
		end
	end
		
	-- Add the item
	if not nodeSkill then
		nodeSkill = nodeList.createChild();
		DB.setValue(nodeSkill, "name", "string", sSkill);
		if DataCommon.skilldata[sSkill] then
			DB.setValue(nodeSkill, "stat", "string", DataCommon.skilldata[sSkill].stat);
		end
	end

	-- Announce
	outputUserMessage("char_abilities_message_skilladd", DB.getValue(nodeSkill, "name", ""), DB.getValue(nodeChar, "name", ""));
	return nodeSkill;
end

function addClassFeatureDB(nodeChar, sClass, sRecord, nodeClass)
	local nodeSource = resolveRefNode(sRecord);
	if not nodeSource then
		return;
	end
	
	-- Get the list we are going to add to
	local nodeList = nodeChar.createChild("featurelist");
	if not nodeList then
		return false;
	end
	
	-- Get the class name
	local sClassName = DB.getValue(nodeSource, "...name", "");
	
	-- Make sure this item does not already exist
	local sOriginalName = DB.getValue(nodeSource, "name", "");
	local sOriginalNameLower = StringManager.trim(sOriginalName:lower());
	local sFeatureName = sOriginalName;
	for _,v in pairs(nodeList.getChildren()) do
		if DB.getValue(v, "name", ""):lower() == sOriginalNameLower then
			return false;
		end
	end
		
	-- Pull the feature level
	local nFeatureLevel = DB.getValue(nodeSource, "level", 0);

	-- Add the item
	local vNew = nodeList.createChild();
	DB.copyNode(nodeSource, vNew);
	DB.setValue(vNew, "name", "string", sFeatureName);
	DB.setValue(vNew, "source", "string", DB.getValue(nodeSource, "...name", ""));
	DB.setValue(vNew, "locked", "number", 1);
	
	if sOriginalNameLower == FEATURE_LANGUAGES then
		local sText = DB.getText(nodeSource, "text");
		
		local sLanguages = sText:match("automatically knows ([^.]+)");
		if not sLanguages then
			sLanguages = sText:match("knows ([^.]+)");
		end
		if not sLanguages then
			return false;
		end

		sLanguages = sLanguages:gsub("and ", ",");
		sLanguages = sLanguages:gsub("the dwarven racial language", "Dwarf");
		sLanguages = sLanguages:gsub("the elven racial language", "Elf");
		sLanguages = sLanguages:gsub("the halfling racial language", "Halfling");
		sLanguages = sLanguages:gsub(", as described in Appendix L", "");

		for s in string.gmatch(sLanguages, "(%a[%a%s]+)%,?") do
			s = StringManager.capitalize(s);
			addLanguageDB(nodeChar, s);
		end
		
	elseif sOriginalNameLower == FEATURE_THIEVES_CANT then
		addLanguageDB(nodeChar, "Thieves' Cant");
	end
	
	-- Announce
	outputUserMessage("char_abilities_message_featureadd", DB.getValue(vNew, "name", ""), DB.getValue(nodeChar, "name", ""));
	return true;
end

function addLanguageDB(nodeChar, sLanguage)
	-- Get the list we are going to add to
	local nodeList = nodeChar.createChild("languagelist");
	if not nodeList then
		return false;
	end
	
	-- Make sure this item does not already exist
	for _,v in pairs(nodeList.getChildren()) do
		if DB.getValue(v, "name", "") == sLanguage then
			return false;
		end
	end

	-- Add the item
	local vNew = nodeList.createChild();
	DB.setValue(vNew, "name", "string", sLanguage);

	-- Announce
	outputUserMessage("char_abilities_message_languageadd", DB.getValue(vNew, "name", ""), DB.getValue(nodeChar, "name", ""));
	return true;
end

function addClassRef(nodeChar, sClass, sRecord)
	local nodeSource = resolveRefNode(sRecord)
	if not nodeSource then
		return;
	end

	-- Get the list we are going to add to
	local nodeList = nodeChar.createChild("classes");
	if not nodeList then
		return;
	end
	
	-- Notify
	local sFormat = Interface.getString("char_abilities_message_classadd");
	local sMsg = string.format(sFormat, DB.getValue(nodeSource, "name", ""), DB.getValue(nodeChar, "name", ""));
	ChatManager.SystemMessage(sMsg);
	
	-- Translate Hit Die
	local bHDFound = false;
	local nHDMult = 1;
	local nHDSides = 6;
	local sHD = DB.getText(nodeSource, "hp.hitdice.text");
	if sHD then
		local sMult, sSides = sHD:match("(%d)d(%d+)");
		if sMult and sSides then
			nHDMult = tonumber(sMult);
			nHDSides = tonumber(sSides);
			bHDFound = true;
		end
	end
	if not bHDFound then
		ChatManager.SystemMessage(Interface.getString("char_error_addclasshd"));
	end

	-- Keep some data handy for comparisons
	local sClassName = DB.getValue(nodeSource, "name", "");
	local sClassNameLower = StringManager.trim(sClassName):lower();

	-- Check to see if the character already has this class; or create a new class entry
	local nodeClass = nil;
	local sRecordSansModule = StringManager.split(sRecord, "@")[1];
	local aCharClassNodes = nodeList.getChildren();
	for _,v in pairs(aCharClassNodes) do
		local _,sExistingClassPath = DB.getValue(v, "shortcut", "", "");
		local sExistingClassPathSansModule = StringManager.split(sExistingClassPath, "@")[1];
		if sExistingClassPathSansModule == sRecordSansModule then
			nodeClass = v;
			break;
		end
	end
	if not nodeClass then
		for _,v in pairs(aCharClassNodes) do
			local sExistingClassName = StringManager.trim(DB.getValue(v, "name", "")):lower();
			if (sExistingClassName == sClassNameLower) and (sExistingClassName ~= "") then
				nodeClass = v;
				break;
			end
		end
	end
	local bExistingClass = false;
	if nodeClass then
		bExistingClass = true;
	else
		nodeClass = nodeList.createChild();
	end

	-- Any way you get here, overwrite or set the class reference link with the most current
	DB.setValue(nodeClass, "shortcut", "windowreference", sClass, sRecord);
	
	-- Add basic class information
	local nLevel = 1;
	if bExistingClass then
		nLevel = DB.getValue(nodeClass, "level", 1) + 1;
	else
		DB.setValue(nodeClass, "name", "string", sClassName);
		local aDice = {};
		for i = 1, nHDMult do
			table.insert(aDice, "d" .. nHDSides);
		end
		DB.setValue(nodeClass, "hddie", "dice", aDice);
	end
	DB.setValue(nodeClass, "level", "number", nLevel);
	
	-- Calculate total level
	local nTotalLevel = 0;
	for _,vClass in pairs(nodeList.getChildren()) do
		nTotalLevel = nTotalLevel + DB.getValue(vClass, "level", 0);
	end
	
	-- Add hit points based on level added
	local nHP = DB.getValue(nodeChar, "hp.total", 0);
	local nStaBonus = DB.getValue(nodeChar, "abilities.stamina.bonus", 0);
	local nAddHP = 0;

	for i = 1, nHDMult do
		nAddHP = nAddHP + math.random(nHDSides);
	end
	local sFormat = Interface.getString("char_abilities_message_hpaddrandom");
	local sMsg = string.format(sFormat, DB.getValue(nodeSource, "name", ""), DB.getValue(nodeChar, "name", "")) .. " (" .. nAddHP .. "+" .. nStaBonus .. ")";
	if (nAddHP + nStaBonus) < 1 then
		nHP = nHP + 1;
		sMsg = sMsg .. " [MIN HP]";
	else		
		nHP = nHP + nAddHP + nStaBonus;
	end
	ChatManager.SystemMessage(sMsg);
	DB.setValue(nodeChar, "hp.total", "number", nHP);
	
	-- Add proficiencies
	if not bExistingClass then
		if nTotalLevel == 1 then
			for _,v in pairs(DB.getChildren(nodeSource, "proficiencies")) do
				addClassProficiencyDB(nodeChar, "reference_classproficiency", v.getPath());
			end
		end
	end
	
	-- Add features
	local rClassAdd = { nodeChar = nodeChar, nodeSource = nodeSource, nLevel = nLevel, nodeClass = nodeClass };
	addClassFeatureHelper(nil, rClassAdd);
	
	-- Add languages
	if not bExistingClass then
		if nTotalLevel == 1 then
			addLanguageDB(nodeChar, "Common");
		end
	end
end

function addClassFeatureHelper(aSelection, rClassAdd)
	local nodeSource = rClassAdd.nodeSource;
	local nodeChar = rClassAdd.nodeChar;
	
	-- Add features
	local aMatchingClassNodes = {};
	local sClassNameLower = StringManager.trim(DB.getValue(nodeSource, "name", "")):lower();
	local aMappings = LibraryData.getMappings("class");
	for _,vMapping in ipairs(aMappings) do
		for _,vNode in pairs(DB.getChildrenGlobal(vMapping)) do
			local sExistingClassName = StringManager.trim(DB.getValue(vNode, "name", "")):lower();
			if (sExistingClassName == sClassNameLower) and (sExistingClassName ~= "") then
				table.insert(aMatchingClassNodes, vNode);
				if nodeSource then
					nodeSource = nil;
				end
			end
		end
	end
	if nodeSource then
		table.insert(aMatchingClassNodes, nodeSource);
	end
	local aAddedFeatures = {};
	for _,vNode in ipairs(aMatchingClassNodes) do
		for _,vFeature in pairs(DB.getChildren(vNode, "features")) do
			if (DB.getValue(vFeature, "level", 0) == rClassAdd.nLevel) then
				local sFeatureName = DB.getValue(vFeature, "name", "");
				local sFeatureNameLower = StringManager.trim(sFeatureName):lower();
				if not aAddedFeatures[sFeatureNameLower] then
					addClassFeatureDB(nodeChar, "reference_classfeature", vFeature.getPath(), rClassAdd.nodeClass);
					aAddedFeatures[sFeatureNameLower] = true;
				end
			end
		end
	end
end

function addSkillRef(nodeChar, sClass, sRecord)
	local nodeSource = resolveRefNode(sRecord);
	if not nodeSource then
		return;
	end
	
	-- Add skill entry
	local nodeSkill = addSkillDB(nodeChar, DB.getValue(nodeSource, "name", ""));
	if nodeSkill then
		DB.setValue(nodeSkill, "text", "formattedtext", DB.getValue(nodeSource, "text", ""));
	end
end

-- function hasFeature(nodeChar, sFeature)
	-- local sFeatureLower = sFeature:lower();
	-- for _,v in pairs(DB.getChildren(nodeChar, "featurelist")) do
		-- if DB.getValue(v, "name", ""):lower() == sFeatureLower then
			-- return true;
		-- end
	-- end
	
	-- return false;
-- end
