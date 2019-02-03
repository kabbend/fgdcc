-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local aFieldMap = {};

function onInit()
	if User.isHost() then
		DB.addHandler("charsheet.*.classes", "onChildUpdate", linkPCClasses);
	end
end

function linkPCClasses(nodeClass)
	if not nodeClass then
		return;
	end
	local nodeChar = nodeClass.getParent();
	
	local nodePS = PartyManager.mapChartoPS(nodeChar);
	if not nodePS then
		return;
	end
	
	DB.setValue(nodePS, "classlevel", "string", CharManager.getClassLevelSummary(nodeChar));
end

function linkPCFields(nodePS)
	local nodeChar = PartyManager.mapPStoChar(nodePS);
	
	PartyManager.linkRecordField(nodeChar, nodePS, "name", "string");
	PartyManager.linkRecordField(nodeChar, nodePS, "token", "token", "token");

	PartyManager.linkRecordField(nodeChar, nodePS, "occupation", "string");	
	PartyManager.linkRecordField(nodeChar, nodePS, "alignment", "string");
	PartyManager.linkRecordField(nodeChar, nodePS, "exp", "number");
	PartyManager.linkRecordField(nodeChar, nodePS, "expneeded", "number");
	
	PartyManager.linkRecordField(nodeChar, nodePS, "hp.total", "number", "hptotal");
	PartyManager.linkRecordField(nodeChar, nodePS, "hp.wounds", "number", "wounds");
	
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.strength.score", "number", "strength");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.agility.score", "number", "agility");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.stamina.score", "number", "stamina");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.personality.score", "number", "personality");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.luck.score", "number", "luck");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.intelligence.score", "number", "intelligence");

	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.strength.bonus", "number", "strcheck");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.agility.bonus", "number", "agicheck");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.stamina.bonus", "number", "stacheck");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.personality.bonus", "number", "percheck");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.luck.bonus", "number", "luckcheck");
	PartyManager.linkRecordField(nodeChar, nodePS, "abilities.intelligence.bonus", "number", "intcheck");

	PartyManager.linkRecordField(nodeChar, nodePS, "ac.total", "number", "ac");
	
	PartyManager.linkRecordField(nodeChar, nodePS, "saves.reflex.total", "number", "reflex");
	PartyManager.linkRecordField(nodeChar, nodePS, "saves.fortitude.total", "number", "fortitude");
	PartyManager.linkRecordField(nodeChar, nodePS, "saves.willpower.total", "number", "willpower");
	
	if nodeChar then
		linkPCClasses(nodeChar.getChild("classes"));
	end
end

--
-- DROP HANDLING
--

function addEncounter(nodeEnc)
	if not nodeEnc then
		return;
	end
	
	local nodePSEnc = DB.createChild("partysheet.encounters");
	DB.copyNode(nodeEnc, nodePSEnc);
end

function addQuest(nodeQuest)
	if not nodeQuest then
		return;
	end
	
	local nodePSQuest = DB.createChild("partysheet.quests");
	DB.copyNode(nodeQuest, nodePSQuest);
end

--
-- XP DISTRIBUTION
--

function awardQuestsToParty(nodeEntry)
	local nXP = 0;
	if nodeEntry then
		if DB.getValue(nodeEntry, "xpawarded", 0) == 0 then
			nXP = DB.getValue(nodeEntry, "xp", 0);
			DB.setValue(nodeEntry, "xpawarded", "number", 1);
		end
	else
		for _,v in pairs(DB.getChildren("partysheet.quests")) do
			if DB.getValue(v, "xpawarded", 0) == 0 then
				nXP = nXP + DB.getValue(v, "xp", 0);
				DB.setValue(v, "xpawarded", "number", 1);
			end
		end
	end
	if nXP ~= 0 then
		awardXP(nXP);
	end
end

function awardEncountersToParty(nodeEntry)
	local nXP = 0;
	if nodeEntry then
		if DB.getValue(nodeEntry, "xpawarded", 0) == 0 then
			nXP = DB.getValue(nodeEntry, "exp", 0);
			DB.setValue(nodeEntry, "xpawarded", "number", 1);
		end
	else
		for _,v in pairs(DB.getChildren("partysheet.encounters")) do
			if DB.getValue(v, "xpawarded", 0) == 0 then
				nXP = nXP + DB.getValue(v, "exp", 0);
				DB.setValue(v, "xpawarded", "number", 1);
			end
		end
	end
	if nXP ~= 0 then
		awardXP(nXP);
	end
end

function awardXP(nXP) 
	-- Determine members of party
	local aParty = {};
	for _,v in pairs(DB.getChildren("partysheet.partyinformation")) do
		local sClass, sRecord = DB.getValue(v, "link");
		if sClass == "charsheet" and sRecord then
			local nodePC = DB.findNode(sRecord);
			if nodePC then
				local sName = DB.getValue(v, "name", "");
				table.insert(aParty, { name = sName, node = nodePC } );
			end
		end
	end

	-- Determine split
	-- local nAverageSplit;
	-- if nXP >= #aParty then
		-- nAverageSplit = math.floor((nXP / #aParty) + 0.5);
	-- else
		-- nAverageSplit = 0;
	-- end
	-- local nFinalSplit = math.max((nXP - ((#aParty - 1) * nAverageSplit)), 0);
	
	-- Award XP
	for _,v in ipairs(aParty) do
		-- local nAmount;
		-- if k == #aParty then
			-- nAmount = nFinalSplit;
		-- else
			-- nAmount = nAverageSplit;
		-- end
		
		if nXP > 0 then
			local nNewAmount = DB.getValue(v.node, "exp", 0) + nXP;
			DB.setValue(v.node, "exp", "number", nNewAmount);
		end

		-- v.given = nAmount;
	end
	
	-- Output results
	local msg = {font = "msgfont"};
	msg.icon = "xp";
	for _,v in ipairs(aParty) do
		msg.text = "[" .. nXP .. " XP] -> " .. v.name;
		Comm.deliverChatMessage(msg);
	end

	msg.icon = "portrait_gm_token";
	msg.text = Interface.getString("ps_message_xpaward") .. " (" .. nXP .. ")";
	Comm.deliverChatMessage(msg);
end

function awardXPtoPC(nXP, nodePC)
	local nCharXP = DB.getValue(nodePC, "exp", 0);
	nCharXP = nCharXP + nXP;
	DB.setValue(nodePC, "exp", "number", nCharXP);
							
	local msg = {font = "msgfont"};
	msg.icon = "xp";
	msg.text = "[" .. nXP .. " XP] -> " .. DB.getValue(nodePC, "name");
	Comm.deliverChatMessage(msg, "");

	local sOwner = nodePC.getOwner();
	if (sOwner or "") ~= "" then
		Comm.deliverChatMessage(msg, sOwner);
	end
end
