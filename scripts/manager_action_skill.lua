-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerModHandler("skill", modRoll);
	ActionsManager.registerResultHandler("skill", onRoll);
end

function performNPCRoll(draginfo, rActor, sSkill, nSkill)
	local rRoll = {};
	rRoll.sType = "skill";
	rRoll.aDice = { "d20" };
	
	rRoll.sDesc = "[SKILL] " .. sSkill;
	rRoll.nMod = nSkill;

	if User.isHost() and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function getRoll(rActor, nodeSkill, nTargetDC, bSecretRoll)
	local rRoll = {};
	rRoll.sType = "skill";
	rRoll.aDice = { "d20" };

	local sSkill = DB.getValue(nodeSkill, "name", "");

	local aDice = DB.getValue(nodeSkill, "dice");
	if aDice then
		rRoll.aDice = aDice;
	end

	rRoll.nMod = DB.getValue(nodeSkill, "total", 0);
	rRoll.sAbility = DB.getValue(nodeSkill, "stat", "");

	rRoll.sDesc = "[SKILL] " .. sSkill;

	rRoll.bSecret = bSecretRoll;

	return rRoll;
end

function performRoll(draginfo, rActor, nodeSkill, nTargetDC, bSecretRoll)
	local rRoll = getRoll(rActor, nodeSkill, bSecretRoll);

	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function modRoll(rSource, rTarget, rRoll)
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	-- Check modifier buttons
	local bDiceSwap = ModifierStack.getModifierKey("PLUS1D") or ModifierStack.getModifierKey("PLUS2D") or ModifierStack.getModifierKey("MINUS1D") or ModifierStack.getModifierKey("MINUS2D");

	if rSource then
		local bEffects = false;

		local sSkill = StringManager.trim(string.match(rRoll.sDesc, "%[SKILL%] ([^[]+)"));

		local aSkillFilter = {};
		if sSkill then
			table.insert(aSkillFilter, sSkill:lower());
		end

		local nEffectCount;
		local aSkillAddDice, nSkillAddMod, nSkillEffectCount = EffectManagerDCC.getEffectsBonus(rSource, {"SKILL"}, false, aSkillFilter);
		if (nSkillEffectCount > 0) then
			bEffects = true;
			for _,v in ipairs(aSkillAddDice) do
				table.insert(aAddDice, v);
			end
			nAddMod = nAddMod + nSkillAddMod;
		end

		if bDiceSwap then
			ActionsManager2.encodeDiceSwap(rRoll);
		end

		-- Get ability modifiers
		local sAbility = rRoll.sAbility;
		local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, sAbility);
		if nBonusEffects > 0 then
			bEffects = true;
			nAddMod = nAddMod + nBonusStat;
		end

		-- If effects happened, then add note
		if bEffects then
			local sEffects = "";
			local sMod = StringManager.convertDiceToString(aAddDice, nAddMod, true);
			if sMod ~= "" then
				sEffects = "[" .. Interface.getString("effects_tag") .. " " .. sMod .. "]";
			else
				sEffects = "[" .. Interface.getString("effects_tag") .. "]";
			end
			table.insert(aAddDesc, sEffects);
		end
	end
	
	-- Add action die tag	
	if #(rRoll.aDice) == 1 then
		rRoll.sDesc = rRoll.sDesc .. " (" .. rRoll.aDice[1] .. ")";
	end

	if #aAddDesc > 0 then
		rRoll.sDesc = rRoll.sDesc .. " " .. table.concat(aAddDesc, " ");
	end

	for _,vDie in ipairs(aAddDice) do
		if vDie:sub(1,1) == "-" then
			table.insert(rRoll.aDice, "-p" .. vDie:sub(3));
		else
			table.insert(rRoll.aDice, "p" .. vDie:sub(2));
		end
	end
	rRoll.nMod = rRoll.nMod + nAddMod;
end

function onRoll(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	Comm.deliverChatMessage(rMessage);
end
