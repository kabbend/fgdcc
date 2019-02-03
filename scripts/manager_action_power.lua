-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYSAVEVS = "applysavevs";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYSAVEVS, handleApplySaveVs);

	ActionsManager.registerTargetingHandler("cast", onPowerTargeting);
	ActionsManager.registerTargetingHandler("powersave", onPowerTargeting);
	
	ActionsManager.registerModHandler("cast", modPowerCast);
	
	ActionsManager.registerResultHandler("cast", onPowerCast);
	ActionsManager.registerResultHandler("castsave", onCastSave);
	ActionsManager.registerResultHandler("powersave", onPowerSave);
end

function handleApplySaveVs(msgOOB)
	local rSource = ActorManager.getActor(msgOOB.sSourceType, msgOOB.sSourceNode);
	local rTarget = ActorManager.getActor(msgOOB.sTargetType, msgOOB.sTargetNode);
	
	local sSaveShort, sSaveDC = string.match(msgOOB.sDesc, "%[(%w+) DC (%d+)%]")
	if sSaveShort then
		local sSave = DataCommon.save_stol[sSaveShort];
		if sSave then
			ActionSave.performVsRoll(nil, rTarget, sSave, msgOOB.nDC, (tonumber(msgOOB.nSecret) == 1), rSource, msgOOB.bRemoveOnMiss, msgOOB.sDesc);
		end
	end
end

function notifyApplySaveVs(rSource, rTarget, bSecret, sDesc, nDC, bRemoveOnMiss)
	if not rTarget then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYSAVEVS;
	
	if bSecret then
		msgOOB.nSecret = 1;
	else
		msgOOB.nSecret = 0;
	end
	msgOOB.sDesc = sDesc;
	msgOOB.nDC = nDC;

	local sSourceType, sSourceNode = ActorManager.getTypeAndNodeName(rSource);
	msgOOB.sSourceType = sSourceType;
	msgOOB.sSourceNode = sSourceNode;

	local sTargetType, sTargetNode = ActorManager.getTypeAndNodeName(rTarget);
	msgOOB.sTargetType = sTargetType;
	msgOOB.sTargetNode = sTargetNode;

	if bRemoveOnMiss then
		msgOOB.bRemoveOnMiss = 1;
	end

	if ActorManager.getType(rTarget) == "pc" then
		local nodePC = ActorManager.getCreatureNode(rTarget);
		if nodePC then
			if User.isHost() then
				local sOwner = DB.getOwner(nodePC);
				if sOwner ~= "" then
					for _,vUser in ipairs(User.getActiveUsers()) do
						if vUser == sOwner then
							for _,vIdentity in ipairs(User.getActiveIdentities(vUser)) do
								if nodePC.getName() == vIdentity then
									Comm.deliverOOBMessage(msgOOB, sOwner);
									return;
								end
							end
						end
					end
				end
			else
				if DB.isOwner(nodePC) then
					handleApplySaveVs(msgOOB);
					return;
				end
			end
		end
	end

	Comm.deliverOOBMessage(msgOOB, "");
end

function onPowerTargeting(rSource, aTargeting, rRolls)
	local bRemoveOnMiss = false;
	local sOptRMMT = OptionsManager.getOption("RMMT");
	if sOptRMMT == "on" then
		bRemoveOnMiss = true;
	elseif sOptRMMT == "multi" then
		local aTargets = {};
		for _,vTargetGroup in ipairs(aTargeting) do
			for _,vTarget in ipairs(vTargetGroup) do
				table.insert(aTargets, vTarget);
			end
		end
		bRemoveOnMiss = (#aTargets > 1);
	end
	
	if bRemoveOnMiss then
		for _,vRoll in ipairs(rRolls) do
			vRoll.bRemoveOnMiss = "true";
		end
	end
	
	return aTargeting;
end

function getPowerCastRoll(rActor, rAction)
	local rRoll = {};
	rRoll.sType = "cast";
	rRoll.aDice = rAction.dice or {"d20"};
	rRoll.nMod = rAction.modifier or 0;
	
	rRoll.sCasterType = rAction.castertype;
	rRoll.nPowerLevel = tonumber(rAction.powerlevel);
	
	if rAction.stat then
		rRoll.sAbility = rAction.stat;
	end
	if rAction.stat2 then
		rRoll.sAbility2 = rAction.stat2;
	end	
	
	rRoll.sDesc = "[CAST";
	if rAction.order and rAction.order > 1 then
		rRoll.sDesc = rRoll.sDesc .. " #" .. rAction.order;
	end
	rRoll.sDesc = rRoll.sDesc .. "] " .. rAction.label;

	return rRoll;
end

function getSaveVsRoll(rActor, rAction)
	local rRoll = {};
	rRoll.sType = "powersave";
	rRoll.aDice = {};
	rRoll.nMod = rAction.savemod or 0;
	
	rRoll.sDesc = "[SAVE VS";
	if rAction.order and rAction.order > 1 then
		rRoll.sDesc = rRoll.sDesc .. " #" .. rAction.order;
	end
	rRoll.sDesc = rRoll.sDesc .. "] " .. rAction.label;
	if DataCommon.save_ltos[rAction.save] then
		rRoll.sDesc = rRoll.sDesc .. " [" .. DataCommon.save_ltos[rAction.save] .. " DC " .. rRoll.nMod .. "]";
	end
	-- if rAction.magic then
		-- rRoll.sDesc = rRoll.sDesc .. " [MAGIC]";
	-- end
	if rAction.onmissdamage == "half" then
		rRoll.sDesc = rRoll.sDesc .. " [HALF ON SAVE]";
	end
	
	return rRoll;
end

function performSaveVsRoll(draginfo, rActor, rAction)
	local rRoll = getSaveVsRoll(rActor, rAction);
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function modPowerCast(rSource, rTarget, rRoll)
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;

	-- Check modifier buttons	
	local bDiceSwap = ModifierStack.getModifierKey("PLUS1D") or ModifierStack.getModifierKey("PLUS2D") or ModifierStack.getModifierKey("MINUS1D") or ModifierStack.getModifierKey("MINUS2D");
	
	if rSource then
		-- Get spell effect modifiers
		local bEffects = false;
		local nEffectCount;
		
		if rRoll.sCasterType == "memorization" then
			aAddDice, nAddMod, nEffectCount = EffectManagerDCC.getEffectsBonus(rSource, {"SPELL"}, false);
			if (nEffectCount > 0) then
				bEffects = true;
			end
		end
		
		if bDiceSwap then
			ActionsManager2.encodeDiceSwap(rRoll);
		end
		
		-- Get ability modifiers
		local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, rRoll.sAbility);
		if nBonusEffects > 0 then
			bEffects = true;
			nAddMod = nAddMod + nBonusStat;
		end
		
		if rRoll.sAbility2 then
			nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, rRoll.sAbility2);
			if nBonusEffects > 0 then
				bEffects = true;
				nAddMod = nAddMod + nBonusStat;
			end
		end
	
		-- If effects, then add them
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

function onPowerCast(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	rMessage.icon = "roll_cast";
	
	if rTarget then
		rMessage.text = rMessage.text .. " [at " .. ActorManager.getDisplayName(rTarget) .. "]";
	end
	
	local rAction = {};
	rAction.nTotal = ActionsManager.total(rRoll);
	rAction.aMessages = {};

	-- who am i ?
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);

	local path = "powers." .. rRoll.sSpellID .. ".is_lost";
	local nN = nodeActor.getChild(path);  

	-- determine spell source, either Wizard or Cleric. If not given by spell, find it in the
	-- player classes. If not obvious in player classes, set it to Wizard by default.
	local nPowerSource = rRoll.nPowerSource;
	if nPowerSource ~= "Wizard" and nPowerSource ~= "Cleric" then
		-- we need to use the character class, not the power source
		nPowerSource = "Wizard";  -- by default...
		local rClasses = DB.getChildren(nodeActor, "classes");
		for _, rClass in pairs(rClasses) do
			-- we take the first eligible class out there
			cn = DB.getValue(rClass,"name");
			if cn == "Cleric" or cn == "Wizard" then
				nPowerSource = cn;
				break;
			end
		end
	end

	-- Determine information for spells
	local nPowerLevel = tonumber(rRoll.nPowerLevel) or 1;
	local nLostThreshold = tonumber(rRoll.nPowerLost) or 0;
	local nSuccessThreshold = tonumber(rRoll.nPowerFail) or 0;
	local nLevel = tonumber(rRoll.nCasterLevel) or 0;
	if nSuccessThreshold > 0 then
		nSuccessThreshold = nSuccessThreshold + 1 
	else
		nSuccessThreshold = 10 + 2 * nPowerLevel;
	end
		
	-- Set critical hit threshold
	local nCritThreshold = 20;		
	if rRoll.aDice[1].type == "d30" then
		nCritThreshold = 30;
	elseif rRoll.aDice[1].type == "d24" then
		nCritThreshold = 24;
	end	
			
	-- Check success
	rAction.nFirstDie = 0;
	if #(rRoll.aDice) > 0 then
		rAction.nFirstDie = rRoll.aDice[1].result or 0;
	end	

	-- if Cleric power, get current disapproval range (minimum 1), for further testing
	nDisapprovalRange = DB.getValue(nodeActor , "disapprovalrange", 1)
	if nDisapprovalRange == 0 then nDisapprovalRange = 1 end
	if nPowerSource == "Cleric" then
		table.insert(rAction.aMessages, "[DIS " .. nDisapprovalRange .. "]");
	end

	if rAction.nFirstDie >= nCritThreshold then
		-- critical for both Cleric and Wizard
		rAction.sResult = "crit";
		table.insert(rAction.aMessages, "[CRIT HIT, DOUBLE CASTER LVL]");
		-- Normally, this is the caster level, not the level... but come on, level will always be set properly
		-- so we prefer this one.
		local nCritBonus = DB.getValue(nodeActor, "level", 1);
		rAction.nTotal = rAction.nTotal + nCritBonus;
		rMessage.diemodifier = rMessage.diemodifier + nCritBonus;
		
	elseif nPowerSource == "Cleric" and rAction.nFirstDie <= nDisapprovalRange then
		-- Cleric failure
		rAction.sResult = "fumble";
		local nLuckBonus = DB.getValue(nodeActor , "abilities.luck.bonus", 0);
		table.insert(rAction.aMessages, "[DISAPPROVAL, ROLL " .. rAction.nFirstDie .. "d4-" .. nLuckBonus .. " !]");
		DB.setValue(nodeActor , "disapprovalrange", "number" , nDisapprovalRange + 1)
			
	elseif nPowerSource == "Wizard" and rAction.nFirstDie == 1 then
		-- Wizard fumble
		rAction.sResult = "fumble";
		table.insert(rAction.aMessages, "[LOST, FAILURE, CORRUPTION!]");
 		DB.setValue(nodeActor, path , "number", 1);
			
	elseif rAction.nTotal >= nSuccessThreshold then
		-- success for both Cleric and Wizard
		rAction.sResult = "hit";
		table.insert(rAction.aMessages, "[SUCCESS]");
		
	elseif nPowerSource == "Wizard" and rAction.nTotal > nLostThreshold then
		-- Wizard failure, but spell not lost
		rAction.sResult = "miss";
		table.insert(rAction.aMessages, "[FAILURE BUT NOT LOST]");

	elseif nPowerSource == "Cleric" and rAction.nTotal < nSuccessThreshold then
		-- if cleric spell fails, increase the current range
		rAction.sResult = "miss";
		DB.setValue(nodeActor , "disapprovalrange", "number" , nDisapprovalRange + 1)
		table.insert(rAction.aMessages, "[FAILURE][DIS+1]");

	else 
		-- Wizard lost
		rAction.sResult = "miss";
		table.insert(rAction.aMessages, "[FAILURE AND LOST]");
 		DB.setValue(nodeActor, path , "number", 1);
	end
		
	DB.setValue(nodeActor, "spellcheckresult", "number", rAction.nTotal);
	local nBest = DB.getValue(nodeActor, "spellcheckbest", 0);
	if rAction.nTotal > nBest then
		DB.setValue(nodeActor, "spellcheckbest", "number", rAction.nTotal);
	end
			
	if #(rAction.aMessages) > 0 then
		rMessage.text = rMessage.text .. " " .. table.concat(rAction.aMessages, " ");
	end
	
	Comm.deliverChatMessage(rMessage);
end

function onCastSave(rSource, rTarget, rRoll)
	if rTarget then
		local sSaveShort, sSaveDC = rRoll.sDesc:match("%[(%w+) DC (%d+)%]")
		if sSaveShort then
			local sSave = DataCommon.save_stol[sSaveShort];
			if sSave then
				notifyApplySaveVs(rSource, rTarget, rRoll.bSecret, rRoll.sDesc, rRoll.nMod, rRoll.bRemoveOnMiss);
				return true;
			end
		end
	end

	return false;
end

function onPowerSave(rSource, rTarget, rRoll)
	if onCastSave(rSource, rTarget, rRoll) then
		return;
	end

	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	Comm.deliverChatMessage(rMessage);
end
