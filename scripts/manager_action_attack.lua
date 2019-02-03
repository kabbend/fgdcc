-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYATK = "applyatk";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYATK, handleApplyAttack);

	ActionsManager.registerTargetingHandler("attack", onTargeting);	
	ActionsManager.registerModHandler("attack", modAttack);
	ActionsManager.registerResultHandler("attack", onAttack);
end

function handleApplyAttack(msgOOB)
	local rSource = ActorManager.getActor(msgOOB.sSourceType, msgOOB.sSourceNode);
	local rTarget = ActorManager.getActor(msgOOB.sTargetType, msgOOB.sTargetNode);
	
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	applyAttack(rSource, rTarget, (tonumber(msgOOB.nSecret) == 1), msgOOB.sAttackType, msgOOB.sDesc, nTotal, msgOOB.sResults);
end

function notifyApplyAttack(rSource, rTarget, bSecret, sAttackType, sDesc, nTotal, sResults)
	if not rTarget then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYATK;
	
	if bSecret then
		msgOOB.nSecret = 1;
	else
		msgOOB.nSecret = 0;
	end
	msgOOB.sAttackType = sAttackType;
	msgOOB.nTotal = nTotal;
	msgOOB.sDesc = sDesc;
	msgOOB.sResults = sResults;

	local sSourceType, sSourceNode = ActorManager.getTypeAndNodeName(rSource);
	msgOOB.sSourceType = sSourceType;
	msgOOB.sSourceNode = sSourceNode;

	local sTargetType, sTargetNode = ActorManager.getTypeAndNodeName(rTarget);
	msgOOB.sTargetType = sTargetType;
	msgOOB.sTargetNode = sTargetNode;

	Comm.deliverOOBMessage(msgOOB, "");
end

function onTargeting(rSource, aTargeting, rRolls)
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

function performPartySheetVsRoll(draginfo, rActor, rAction)
	local rRoll = getRoll(nil, rAction);
	
	if DB.getValue("partysheet.hiderollresults", 0) == 1 then
		rRoll.bSecret = true;
		rRoll.bTower = true;
	end
	
	ActionsManager.actionDirect(nil, "attack", { rRoll }, { { rActor } });
end

function performRoll(draginfo, rActor, rAction)
	local rRoll = getRoll(rActor, rAction);

	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function getRoll(rActor, rAction)
	local rRoll = {};
	rRoll.sType = "attack";
	rRoll.aDice = rAction.dice or { "d20" };
	rRoll.nMod = rAction.modifier or 0;
	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	local bIsSourcePC = (nodeActor and sActorType == "pc");

	-- Build the description label
	rRoll.sDesc = "[ATTACK";
	if rAction.order and rAction.order > 1 then
		rRoll.sDesc = rRoll.sDesc .. " #" .. rAction.order;
	end	
	if rAction.range then
		rRoll.sDesc = rRoll.sDesc .. " (" .. rAction.range .. ")";
	end
	rRoll.sDesc = rRoll.sDesc .. "] " .. rAction.label;

	-- Add crit range
	if rAction.crit and rAction.crit < 20 then
		rRoll.sDesc = rRoll.sDesc .. " [CRIT " .. rAction.crit .. "]";
	end
	
	-- Add ability modifiers
	if rAction.stat then
		if (rAction.range == "M" and rAction.stat ~= "strength") or (rAction.range == "R" and rAction.stat ~= "agility") then
			local sAbilityEffect = DataCommon.ability_ltos[rAction.stat];
			if sAbilityEffect then
				rRoll.sDesc = rRoll.sDesc .. " [MOD:" .. sAbilityEffect .. "]";
			end
		end
	end
		
	-- Check off hand
	if bIsSourcePC and rAction.twf == "on" then
		rRoll.sTWF = rAction.twf;
		if rAction.hand == "offhand" then
			rRoll.sHand = rAction.hand;
			rRoll.sDesc = rRoll.sDesc .. " [OFF HAND]";
		else
			rRoll.sHand = "primary";
			rRoll.sDesc = rRoll.sDesc .. " [PRIMARY HAND]";
		end
	end
	
	-- Get action die for NPCs
	if (sActorType == "npc" or sActorType == "ct") and not rRoll.aDice then
		local sNPCActionDie = DB.getValue(nodeActor, "actiondice");
		local aRulesetDice = Interface.getDice();
		local sDieCount, sDieNotation, sDieType = sNPCActionDie:match("^(%d*)([a-zA-Z])([d%dF]+)");
		if sDieType then
			sDieNotation = sDieNotation:lower();
			sDieType = sDieNotation .. sDieType;
			if StringManager.contains (aRulesetDice, sDieType) or (sDieNotation == "d") then
				local aDice = StringManager.convertStringToDice(sDieType);
				rRoll.aDice = aDice;
			else
				rRoll.aDice = { "d20" };
			end
		end
	end
	
	return rRoll;
end

function modAttack(rSource, rTarget, rRoll)
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	-- Check modifier buttons
	local bMedRange = ModifierStack.getModifierKey("MED_RANGE");
	local bLongRange = ModifierStack.getModifierKey("LONG_RANGE");
	local bHigherGround = ModifierStack.getModifierKey("HIGHER_GROUND");
	local bFireIntoMelee = ModifierStack.getModifierKey("FIRE_INTO_MELEE");
	local bCover = ModifierStack.getModifierKey("DEF_COVER");
	local bDiceSwap = ModifierStack.getModifierKey("PLUS1D") or ModifierStack.getModifierKey("PLUS2D") or ModifierStack.getModifierKey("MINUS1D") or ModifierStack.getModifierKey("MINUS2D");
	
	local aAttackFilter = {};
	if rSource then	
		-- Determine attack type
		local sAttackType = string.match(rRoll.sDesc, "%[ATTACK.*%((%w+)%)%]");

		if not sAttackType then
			sAttackType = "M";
		end

		-- Determine ability used
		local sActionStat = nil;
		local sModStat = rRoll.sDesc:match("%[MOD:(%w+)%]");
		if sModStat then
			sActionStat = DataCommon.ability_stol[sModStat];
		end
		if not sActionStat then
			if sAttackType == "M" then
				sActionStat = "strength";
			elseif sAttackType == "R" then
				sActionStat = "agility";
			end
		end

		-- Build attack filter
		if sAttackType == "M" then
			table.insert(aAttackFilter, "melee");
		elseif sAttackType == "R" then
			table.insert(aAttackFilter, "ranged");
		end	
				
		-- Get attack effect modifiers
		local bEffects = false;
		local nEffectCount;
		aAddDice, nAddMod, nEffectCount = EffectManagerDCC.getEffectsBonus(rSource, {"ATK"}, false, aAttackFilter);
		if (nEffectCount > 0) then
			bEffects = true;
		end
		
		-- If two-weapon fighting, check for agility modifiers and adjust action die if necessary
		local bIsTwoWeaponFighting = (rRoll.sTWF == "on");	
		
		if bIsTwoWeaponFighting then		
			local bIsPrimaryHand = (rRoll.sHand == "primary");			
			local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);

			-- Calculate affected agility score	
			local nAbilityMod, nAbilityEffects = EffectManagerDCC.getEffectsBonus(rSource, "AGI", true);
			local nAbilityScore = ActorManager2.getAbilityScore(rSource, "agility");
			local nAffectedScore = math.max(nAbilityScore + nAbilityMod, 0);

			-- A halfling is always considered to have a minimum Agility of 16 when fighting with two weapons			
			local bIsHalfling = (string.lower(DB.getValue(nodeActor, "class", "")) == "halfling");

			if bIsHalfling then
				if nAbilityScore < 16 then
					nAbilityScore = 16;
				end
				if nAffectedScore < 16 then
					nAffectedScore = 16;
				end
			end	
			
			-- If agility score has been modified, adjust action die for two-weapon fighting
			if nAffectedScore ~= nAbilityScore then
				if bIsPrimaryHand then
					if nAbilityScore >=18 then
						if nAffectedScore > 11 and nAffectedScore < 18 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 8 and nAffectedScore < 12 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore <= 8 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						end
					elseif nAbilityScore > 11 and nAbilityScore < 18 then
						if nAffectedScore >= 18 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 8 and nAffectedScore < 12 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore <=8 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						end
					elseif nAbilityScore > 8 and nAbilityScore < 12 then
						if nAffectedScore >= 18 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 11 and nAffectedScore < 18 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore <=8 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						end
					elseif nAbilityScore <=8 then
						if nAffectedScore >= 18 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 11 and nAffectedScore < 18 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 8 and nAffectedScore < 12 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						end
					end
				else
					if nAbilityScore >=16 then
						if nAffectedScore > 11 and nAffectedScore < 16 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 8 and nAffectedScore < 12 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore <= 8 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						end
					elseif nAbilityScore > 11 and nAbilityScore < 16 then
						if nAffectedScore >= 16 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 8 and nAffectedScore < 12 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore <=8 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						end
					elseif nAbilityScore > 8 and nAbilityScore < 12 then
						if nAffectedScore >= 16 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 11 and nAffectedScore < 16 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore <=8 then
							rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
						end
					elseif nAbilityScore <=8 then
						if nAffectedScore >= 16 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 11 and nAffectedScore < 16 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						elseif nAffectedScore > 8 and nAffectedScore < 12 then
							rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
						end
					end
				end
			end
		end
		
		-- Get condition modifiers		
		if bLongRange and sAttackType == "R" then
			table.insert(aAddDesc, "[LONG RANGE -1D]");
			rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
		elseif bMedRange and sAttackType == "R" then
			table.insert(aAddDesc, "[MEDIUM RANGE -2]");
			nAddMod = nAddMod - 2;
		end
		if bCover then
			table.insert(aAddDesc, "[COVER -2]");
			nAddMod = nAddMod - 2;
		end
		if bHigherGround and sAttackType == "M" then
			table.insert(aAddDesc, "[ON HIGHER GROUND +1]");
			nAddMod = nAddMod + 1;
		end
		if bFireIntoMelee and sAttackType == "R" then
			table.insert(aAddDesc, "[FIRING INTO MELEE -1]");
			nAddMod = nAddMod - 1;
		end
		
		if EffectManagerDCC.hasEffect(rSource, "Invisible") and sAttackType == "M"  then
			bEffects = true;
			nAddMod = nAddMod + 2;
		end
		if EffectManagerDCC.hasEffectCondition(rSource, "Squeezing") then
			bEffects = true;
			rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
		end
		if EffectManagerDCC.hasEffectCondition(rSource, "Entangled") then
			bEffects = true;
			rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
		end
		if bDiceSwap then
			ActionsManager2.encodeDiceSwap(rRoll);
		end
		
		if EffectManagerDCC.hasEffect(rTarget, "Entangled") then
			bEffects = true;		
			rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
		end
		if EffectManagerDCC.hasEffect(rTarget, "Helpless") or 
				EffectManagerDCC.hasEffect(rTarget, "Paralyzed") or
				EffectManagerDCC.hasEffect(rTarget, "Sleeping") or 
				EffectManagerDCC.hasEffect(rTarget, "Bound") or
				EffectManagerDCC.hasEffect(rTarget, "Grappled") or
				EffectManagerDCC.hasEffect(rTarget, "Restrained") or
				EffectManagerDCC.hasEffect(rTarget, "Stunned") or
				EffectManagerDCC.hasEffect(rTarget, "Unconscious") then
			bEffects = true;		
			rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
		end

		-- Get ability modifiers
		local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, sActionStat);
		if nBonusEffects > 0 then
			bEffects = true;
			nAddMod = nAddMod + nBonusStat;
		end
	

		if #(rRoll.aDice) == 2 then
			-- find lowest one, we assume it is deed die
			local action, deed = tonumber(string.match(rRoll.aDice[1], "d(%d+)")), tonumber(string.match(rRoll.aDice[2], "d(%d+)"));
			local tmp
			if deed > action then tmp = rRoll.aDice[1]; rRoll.aDice[1] = rRoll.aDice[2]; rRoll.aDice[2] = tmp; end
			rRoll.sDesc = rRoll.sDesc .. " (" .. rRoll.aDice[1] .. ")";
			rRoll.sDesc = rRoll.sDesc .. " (DEED " .. rRoll.aDice[2] .. ")";
		else
			rRoll.sDesc = rRoll.sDesc .. " (" .. rRoll.aDice[1] .. ")";
		end	

	
		-- Determine crit range
		local sActionDie = string.match(rRoll.aDice[1], "d(%d+)");
		local nActionDie = tonumber(sActionDie) or 20;
		
		if nActionDie > 20 then
			local sCritThreshold = string.match(rRoll.sDesc, "%[CRIT (%d+)%]");
			local nCritThreshold = tonumber(sCritThreshold) or 20;
			if nCritThreshold < 20 then
				nCritThreshold = nCritThreshold + (nActionDie - 20);
				if string.match(rRoll.sDesc, " %[CRIT %d+%]") then
					rRoll.sDesc = string.gsub(rRoll.sDesc, " %[CRIT %d+%]", " [CRIT " .. nCritThreshold .. "]");
				else
					rRoll.sDesc = rRoll.sDesc ..  " [CRIT " .. nCritThreshold .. "]";
				end
			else
				rRoll.sDesc = rRoll.sDesc ..  " [CRIT " .. nActionDie .. "]";
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

function onAttack(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);	
	
	local rAction = {};
	rAction.nTotal = ActionsManager.total(rRoll);
	rAction.aMessages = {};

	local nDefenseVal, nAtkEffectsBonus, nDefEffectsBonus = ActorManager2.getDefenseValue(rSource, rTarget, rRoll);
	if nAtkEffectsBonus ~= 0 then
		local sFormat = "[" .. Interface.getString("effects_tag") .. " %+d]"
		table.insert(rAction.aMessages, string.format(sFormat, nAtkEffectsBonus));
	end
	if nDefEffectsBonus ~= 0 then
		local sFormat = "[" .. Interface.getString("effects_def_tag") .. " %+d]"
		table.insert(rAction.aMessages, string.format(sFormat, nDefEffectsBonus));
	end

	-- Determine action die and crit range
	local sActionDie;
	if rSource then
		sActionDie = string.match(rRoll.aDice[1].type, "d(%d+)");
	end
	local nActionDie = tonumber(sActionDie) or 20;

	local sCritThreshold = string.match(rRoll.sDesc, "%[CRIT (%d+)%]");
	local nCritThreshold = tonumber(sCritThreshold) or 20;
	if nCritThreshold < 2 then
		nCritThreshold = 2;
	end
	if (nActionDie == nCritThreshold and nActionDie > 20) or nActionDie < nCritThreshold then
		rMessage.text = string.gsub(rMessage.text, " %[CRIT %d+%]", "");
	end

	-- Check success
	rAction.nFirstDie = 0;
	if #(rRoll.aDice) > 0 then
		rAction.nFirstDie = rRoll.aDice[1].result or 0;
	end
	if #(rRoll.aDice) == 2 then
		local nDeed = rRoll.aDice[2].result or 0;
		local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);
        	DB.setValue(nodeActor, "deedresult", "number", nDeed);
	else
		local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);
        	DB.setValue(nodeActor, "deedresult", "number", 0);
	end

	-- Determine critical hits for dual-wielding
	local bIsTwoWeaponFighting = (rRoll.sTWF == "on");
	
	if bIsTwoWeaponFighting then
		local bIsPrimaryHand = (rRoll.sHand == "primary");		
		local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);		
		
		-- Check agility score
		local nAbilityMod, nAbilityEffects = EffectManagerDCC.getEffectsBonus(rSource, "AGI", true);
		local nAbilityScore = ActorManager2.getAbilityScore(rSource, "agility");
		local nAffectedScore = math.max(nAbilityScore + nAbilityMod, 0);	
		
		-- A halfling is always considered to have a minimum Agility of 16 when fighting with two weapons	
		local bIsHalfling = (string.lower(DB.getValue(nodeActor, "class", "")) == "halfling");	

		if bIsHalfling and nAffectedScore < 16 then
			nAffectedScore = 16;
		end
		
		-- Adjust critical hit threshold for two-weapon fighting
		if bIsHalfling or (bIsPrimaryHand and nAffectedScore >=16) then
			nCritThreshold = nActionDie;
		end

		if rAction.nFirstDie == nCritThreshold then
			if not nDefenseVal then
				if nAffectedScore >= 16 and bIsPrimaryHand then
					rAction.sResult = "crit";
					table.insert(rAction.aMessages, "[CRITICAL HIT]");
				end
			elseif rAction.nTotal >= nDefenseVal then
				-- Primary hand scores a critical hit on a max die roll that also beats target's AC for agility 16+ (or halfling)
				if nAffectedScore >= 16 and bIsPrimaryHand then
					rAction.sResult = "crit";
					table.insert(rAction.aMessages, "[CRITICAL HIT]");
				else
					rAction.sResult = "hit";
					table.insert(rAction.aMessages, "[HIT]");
				end
			elseif rAction.nTotal <= nDefenseVal then
				-- Primary hand scores an automatic critical hit on a max die roll for agility 18+ (or halfling)
				if bIsHalfling or (nAffectedScore >=18 and bIsPrimaryHand) then
					rAction.sResult = "crit";
					table.insert(rAction.aMessages, "[CRITICAL HIT]");
				else
					rAction.sResult = "miss";
					table.insert(rAction.aMessages, "[MISS]");
				end
			end
			
		elseif rAction.nFirstDie == 1 then
			if bIsHalfling then
				rAction.sResult = "fumble";
				table.insert(rAction.aMessages, "[CHECK FUMBLE]");
			else
				rAction.sResult = "fumble";
				table.insert(rAction.aMessages, "[FUMBLE]");
			end
			
		elseif nDefenseVal then
			if rAction.nTotal >= nDefenseVal then
				rAction.sResult = "hit";
				table.insert(rAction.aMessages, "[HIT]");
			else
				rAction.sResult = "miss";
				table.insert(rAction.aMessages, "[MISS]");
			end
		end
		
	-- Determine critical hits as normal (i.e. not dual-wielding)
	elseif rAction.nFirstDie >= nCritThreshold then
		if not nDefenseVal then
			rAction.sResult = "crit";
			table.insert(rAction.aMessages, "[CRITICAL HIT]");
			
		elseif rAction.nTotal >= nDefenseVal then
			rAction.sResult = "crit";
			table.insert(rAction.aMessages, "[CRITICAL HIT]");
			
		elseif rAction.nTotal <= nDefenseVal then
			-- While higher-level warriors threaten critical hits on rolls other than 20, only a natural 20 is an automatic hit
			if nActionDie >= 20 and rAction.nFirstDie == nActionDie then
				rAction.sResult = "crit";
				table.insert(rAction.aMessages, "[CRITICAL HIT]");
			else
				rAction.sResult = "miss";
				table.insert(rAction.aMessages, "[MISS]");			
			end
		end
		
	elseif rAction.nFirstDie == 1 then
		rAction.sResult = "fumble";
		table.insert(rAction.aMessages, "[FUMBLE]");
		
	elseif nDefenseVal then
		if rAction.nTotal >= nDefenseVal then
			rAction.sResult = "hit";
			table.insert(rAction.aMessages, "[HIT]");
		else
			rAction.sResult = "miss";
			table.insert(rAction.aMessages, "[MISS]");
		end
	end

	if not rTarget and #(rAction.aMessages) > 0 then
		rMessage.text = rMessage.text .. " " .. table.concat(rAction.aMessages, " ");
	end
	
	Comm.deliverChatMessage(rMessage);

	if rTarget then
		notifyApplyAttack(rSource, rTarget, rMessage.secret, rRoll.sType, rRoll.sDesc, rAction.nTotal, table.concat(rAction.aMessages, " "));

		-- REMOVE TARGET ON MISS OPTION
		if (rAction.sResult == "miss" or rAction.sResult == "fumble") then
			local bRemoveTarget = false;
			if OptionsManager.isOption("RMMT", "on") then
				bRemoveTarget = true;
			elseif rRoll.bRemoveOnMiss then
				bRemoveTarget = true;
			end
			
			if bRemoveTarget then
				TargetingManager.removeTarget(ActorManager.getCTNodeName(rSource), ActorManager.getCTNodeName(rTarget));
			end
		end
    end

	-- AUTO FUMBLE/CRIT ROLL OPTION
	if rAction.sResult == "crit" and (OptionsManager.isOption("HRFC", "both") or OptionsManager.isOption("HRFC", "criticalhit")) then
		ActionCritical.performRoll(nil, rSource);
	end
	if rAction.sResult == "fumble" and (OptionsManager.isOption("HRFC", "both") or OptionsManager.isOption("HRFC", "fumble")) then
		ActionFumble.performRoll(nil, rSource);
	end

end

function applyAttack(rSource, rTarget, bSecret, sAttackType, sDesc, nTotal, sResults)
	local msgShort = {font = "msgfont"};
	local msgLong = {font = "msgfont"};

	msgShort.text = "Attack ->";
	msgLong.text = "Attack [" .. nTotal .. "] ->";
	if rTarget then
		msgShort.text = msgShort.text .. " [at " .. ActorManager.getDisplayName(rTarget) .. "]";
		msgLong.text = msgLong.text .. " [at " .. ActorManager.getDisplayName(rTarget) .. "]";
	end
	if sResults ~= "" then
		msgLong.text = msgLong.text .. " " .. sResults;
	end
	
	msgShort.icon = "roll_attack";
	if string.match(sResults, "%[CRITICAL HIT%]") then
		msgLong.icon = "roll_attack_crit";
	elseif string.match(sResults, "HIT%]") then
		msgLong.icon = "roll_attack_hit";
	elseif string.match(sResults, "MISS%]") or string.match(sResults, "%[FUMBLE%]") then
		msgLong.icon = "roll_attack_miss";
	else
		msgLong.icon = "roll_attack";
	end
		
	ActionsManager.messageResult(bSecret, rSource, rTarget, msgLong, msgShort);
end
