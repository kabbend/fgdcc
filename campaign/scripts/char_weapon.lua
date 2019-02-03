-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local node = getDatabaseNode();
	DB.addHandler(node.getNodeName(), "onChildUpdate", onDataChanged);
	DB.addHandler(DB.getPath(DB.getChild(node, "..."), "abilities.*.score"), "onUpdate", onDataChanged);
	DB.addHandler(DB.getPath(DB.getChild(node, "..."), "attack"), "onUpdate", onDataChanged);
	DB.addHandler(DB.getPath(DB.getChild(node, "..."), "deedresult"), "onUpdate", onDataChanged);
	onDataChanged();
end

function onClose()
	local node = getDatabaseNode();
	DB.removeHandler(node.getNodeName(), "onChildUpdate", onDataChanged);
	DB.removeHandler(DB.getPath(DB.getChild(node, "..."), "abilities.*.score"), "onUpdate", onDataChanged);
	DB.removeHandler(DB.getPath(DB.getChild(node, "..."), "attack"), "onUpdate", onDataChanged);
	DB.removeHandler(DB.getPath(DB.getChild(node, "..."), "deedresult"), "onUpdate", onDataChanged);
end

local m_sClass = "";
local m_sRecord = "";
function onLinkChanged()
	local node = getDatabaseNode();
	local sClass, sRecord = DB.getValue(node, "shortcut", "", "");
	if sClass ~= m_sClass or sRecord ~= m_sRecord then
		m_sClass = sClass;
		m_sRecord = sRecord;
		
		local sInvList = DB.getPath(DB.getChild(node, "..."), "inventorylist") .. ".";
		if sRecord:sub(1, #sInvList) == sInvList then
			carried.setLink(DB.findNode(DB.getPath(sRecord, "carried")));
		end
	end
end

function onDataChanged()
	onLinkChanged();
	onAttackChanged();
	onDamageChanged();
	
	local bRanged = (type.getValue() == 1);
	label_ammo.setVisible(bRanged);
	maxammo.setVisible(bRanged);
	ammocounter.setVisible(bRanged);
end

function highlightAttack(bOnControl)
	if bOnControl then
		attackshade.setFrame("rowshade");
	else
		attackshade.setFrame(nil);
	end
end
		
function onAttackAction(draginfo)
	local nodeWeapon = getDatabaseNode();
	local nodeChar = nodeWeapon.getChild("...")
	local rActor = ActorManager.getActor("pc", nodeChar);
	local rAction = {};	

	rAction.label = name.getValue();	
	rAction.stat = DB.getValue(nodeWeapon, "attackstat", "");
	if type.getValue() == 2 then
		rAction.twf = "on";
		rAction.hand = DB.getValue(nodeWeapon, "weaponhand", "primary");
		rAction.range = "M";
		if rAction.stat == "" then
			rAction.stat = "strength";
		end
	elseif type.getValue() == 1 then
		rAction.range = "R";
		if rAction.stat == "" then
			rAction.stat = "agility";
		end
	else
		rAction.range = "M";
		if rAction.stat == "" then
			rAction.stat = "strength";
		end
	end
	rAction.modifier = DB.getValue(nodeChar, "attack") + DB.getValue(nodeWeapon, "attackbonus", 0) + ActorManager2.getAbilityBonus(rActor, rAction.stat);
	rAction.dice = DB.getValue(nodeWeapon, "attackdice", {"d20"});
	
	--if deed.getValue() == 1 then
	-- rAction.modifier = rAction.modifier + DB.getValue(nodeChar, "deedresult", 0);
	--end		
	rAction.bWeapon = true;	
	
	-- Decrement ammo
	local nMaxAmmo = DB.getValue(nodeWeapon, "maxammo", 0);
	if nMaxAmmo > 0 then
		local nUsedAmmo = DB.getValue(nodeWeapon, "ammo", 0);
		if nUsedAmmo >= nMaxAmmo then
			ChatManager.Message(Interface.getString("char_message_atkwithnoammo"), true, rActor);
		else
			DB.setValue(nodeWeapon, "ammo", "number", nUsedAmmo + 1);
		end
	end
	
	-- Determine crit range
	local nCritThreshold = DB.getValue(nodeChar, "critrange") or 20;
	local bTwoWeaponFighting = (rAction.twf == "on");
	if nCritThreshold < 20 and not bTwoWeaponFighting then
		rAction.crit = nCritThreshold;
	else
		rAction.crit = 20;
	end
	
	ActionAttack.performRoll(draginfo, rActor, rAction);
	return true;
end

function onDamageAction(draginfo)
	local nodeWeapon = getDatabaseNode();
	local nodeChar = nodeWeapon.getChild("...")
	local rActor = ActorManager.getActor("pc", nodeChar);
	
	local rAction = {};	
	rAction.bWeapon = true;
	rAction.label = DB.getValue(nodeWeapon, "name", "");	
	if type.getValue() == 1 then
		rAction.range = "R";
	else
		rAction.range = "M";
	end

	local sBaseAbility = "strength";
	if type.getValue() == 1 then
		sBaseAbility = "";
	end
	
	rAction.clauses = {};
	local aDamageNodes = UtilityManager.getSortedTable(DB.getChildren(nodeWeapon, "damagelist"));
	local bAddDeed = false; 
	for _,v in ipairs(aDamageNodes) do
		local sDmgAbility = DB.getValue(v, "stat", "");
		if sDmgAbility == "base" then
			sDmgAbility = sBaseAbility;
		end
		local aDmgDice = DB.getValue(v, "dice", {});
		local nDmgMod = DB.getValue(v, "bonus", 0) + ActorManager2.getAbilityBonus(rActor, sDmgAbility);
		local sDmgType = DB.getValue(v, "type", "");
		
		if deed.getValue() == 1 and not bAddDeed then
			nDmgMod = nDmgMod + DB.getValue(nodeChar, "deedresult", 0);
			bAddDeed = true;
		end		
		
		table.insert(rAction.clauses, { dice = aDmgDice, stat = sDmgAbility, modifier = nDmgMod, dmgtype = sDmgType });
	end
	
	ActionDamage.performRoll(draginfo, rActor, rAction);
	return true;
end
	
function onAttackChanged()
	local nodeWeapon = getDatabaseNode();
	local nodeChar = nodeWeapon.getChild("...")
	local rActor = ActorManager.getActor("pc", nodeChar);

	local sAbility = DB.getValue(nodeWeapon, "attackstat", "");
	if sAbility == "" then
		if type.getValue() == 1 then
			sAbility = "agility";
		else
			sAbility = "strength";
		end
	end	
	local nMod = DB.getValue(nodeWeapon, "attackbonus", 0) + ActorManager2.getAbilityBonus(rActor, sAbility) + DB.getValue(nodeChar, "attack");

	--if deed.getValue() ~= 0 then
	--	nMod = nMod + DB.getValue(nodeChar, "deedresult", 0);
	--end
	
	attackview.setValue(nMod);
end

function onDamageChanged()
	local nodeWeapon = getDatabaseNode();
	local nodeChar = nodeWeapon.getChild("...")
	local rActor = ActorManager.getActor("pc", nodeChar);
	
	local sBaseAbility = "strength";
	if type.getValue() == 1 then
		sBaseAbility = "";
	end
	
	local aDamage = {};
	local aDamageNodes = UtilityManager.getSortedTable(DB.getChildren(nodeWeapon, "damagelist"));
	local bAddDeed = false; 
	for _,v in ipairs(aDamageNodes) do
		local nMod = DB.getValue(v, "bonus", 0);
		local sAbility = DB.getValue(v, "stat", "");
		if sAbility == "base" then
			sAbility = sBaseAbility;
		end
		if sAbility ~= "" then
			nMod = nMod + ActorManager2.getAbilityBonus(rActor, sAbility);
		end

		if deed.getValue() ~= 0 and not bAddDeed then
			nMod = nMod + DB.getValue(nodeChar, "deedresult", 0);
			bAddDeed = true;
		end
		
		local aDice = DB.getValue(v, "dice", {});
		if #aDice > 0 or nMod ~= 0 then
			local sDamage = StringManager.convertDiceToString(DB.getValue(v, "dice", {}), nMod);
			local sType = DB.getValue(v, "type", "");
			if sType ~= "" then
				sDamage = sDamage .. " " .. sType;
			end
			table.insert(aDamage, sDamage);
		end
	end

	damageview.setValue(table.concat(aDamage, "\n"));
end
