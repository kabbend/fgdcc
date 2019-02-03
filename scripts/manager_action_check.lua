-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerModHandler("check", modRoll);
	ActionsManager.registerResultHandler("check", onRoll);
end

function performPartySheetRoll(draginfo, rActor, sCheck)
	local rRoll = getRoll(rActor, sCheck);
	
	local nTargetDC = DB.getValue("partysheet.checkdc", 0);
	if nTargetDC == 0 then
		nTargetDC = nil;
	end
	rRoll.nTarget = nTargetDC;
	if DB.getValue("partysheet.hiderollresults", 0) == 1 then
		rRoll.bSecret = true;
		rRoll.bTower = true;
	end

	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performRoll(draginfo, rActor, sCheck, nTargetDC, bSecretRoll)
	local rRoll = getRoll(rActor, sCheck, nTargetDC, bSecretRoll);
	
	if User.isHost() and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function getRoll(rActor, sCheck, nTargetDC, bSecretRoll)
	local rRoll = {};
	rRoll.sType = "check";
	rRoll.aDice = { "d20" };
	rRoll.nMod = ActorManager2.getAbilityBonus(rActor, sCheck);

	rRoll.sDesc = "[CHECK]";
	rRoll.sDesc = rRoll.sDesc .. " " .. StringManager.capitalize(sCheck);

	rRoll.bSecret = bSecretRoll;

	rRoll.nTarget = nTargetDC;

	return rRoll;
end

function modRoll(rSource, rTarget, rRoll)
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	-- Check modifier buttons
	local bDiceSwap = ModifierStack.getModifierKey("PLUS1D") or ModifierStack.getModifierKey("PLUS2D") or ModifierStack.getModifierKey("MINUS1D") or ModifierStack.getModifierKey("MINUS2D");
	
	if rSource then
		local bEffects = false;

		-- Get ability used
		local sActionStat = nil;
		local sAbility = string.match(rRoll.sDesc, "%[CHECK%] (%w+)");
		if sAbility then
			sAbility = string.lower(sAbility);
		end

		-- Build filter
		local aCheckFilter = {};
		if sAbility then
			table.insert(aCheckFilter, sAbility);
		end

		-- Get roll effect modifiers
		local nEffectCount;
		aAddDice, nAddMod, nEffectCount = EffectManagerDCC.getEffectsBonus(rSource, {"CHECK"}, false, aCheckFilter);
		if (nEffectCount > 0) then
			bEffects = true;
		end

		if bDiceSwap then
			ActionsManager2.encodeDiceSwap(rRoll);
		end
		
		-- Get ability modifiers
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

	if rRoll.nTarget then
		local nTotal = ActionsManager.total(rRoll);
		local nTargetDC = tonumber(rRoll.nTarget) or 0;
		
		rMessage.text = rMessage.text .. " (vs. DC " .. nTargetDC .. ")";
		if nTotal >= nTargetDC then
			rMessage.text = rMessage.text .. " [SUCCESS]";
		else
			rMessage.text = rMessage.text .. " [FAILURE]";
		end
	end
	
	Comm.deliverChatMessage(rMessage);
end