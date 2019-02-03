-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

COLOR_HEALTH_UNCONSCIOUS = "6C2DC7";
COLOR_TOKEN_HEALTH_UNCONSCIOUS = "8C3BFF";

function getPercentWounded(sNodeType, node)
	local nHP = 0;
	local nTemp = 0;
	local nWounds = 0;
	local nNonlethal = 0;
	
	if sNodeType == "ct" then
		nHP = math.max(DB.getValue(node, "hp", 0), 0);
		nTemp = math.max(DB.getValue(node, "hptemp", 0), 0);
		nWounds = math.max(DB.getValue(node, "wounds", 0), 0);
		nNonlethal = math.max(DB.getValue(node, "nonlethal", 0), 0);
	elseif sNodeType == "pc" then
		nHP = math.max(DB.getValue(node, "hp.total", 0), 0);
		nTemp = math.max(DB.getValue(node, "hp.temporary", 0), 0);
		nWounds = math.max(DB.getValue(node, "hp.wounds", 0), 0);
		nNonlethal = math.max(DB.getValue(node, "hp.nonlethal", 0), 0);
	end
	
	local nPercentWounded = 0;
	local nPercentNonlethal = 0;
	if nHP > 0 then
		nPercentWounded = nWounds / nHP;
		nPercentNonlethal = (nWounds + nNonlethal) / (nHP + nTemp);
	end
	
	local sStatus;

	if nPercentWounded >= 1 then
		sStatus = "Dying";
	elseif nPercentNonlethal >= 1 then
		sStatus = "Unconscious";
	elseif nPercentNonlethal > 0 then
		local bDetailedStatus = OptionsManager.isOption("WNDC", "detailed");
	
		if bDetailedStatus then
			if nPercentNonlethal >= .75 then
				sStatus = "Critical";
			elseif nPercentNonlethal >= .5 then
				sStatus = "Heavy";
			elseif nPercentNonlethal >= .25 then
				sStatus = "Moderate";
			else
				sStatus = "Light";
			end
		else
			if nPercentNonlethal >= .5 then
				sStatus = "Heavy";
			else
				sStatus = "Wounded";
			end
		end
	else
		sStatus = "Healthy";
	end
	
	return nPercentWounded, nPercentNonlethal, sStatus;
end

-- Based on the percent wounded, change the font color for the Wounds field
function getWoundColor(sNodeType, node)
	local nPercentWounded, nPercentNonlethal, sStatus = getPercentWounded(sNodeType, node);
	
	local sColor;
	if sStatus == "Unconscious" then
		sColor = COLOR_HEALTH_UNCONSCIOUS;
	else
		sColor = ColorManager.getHealthColor(nPercentNonlethal, false);
	end

	return sColor, nPercentWounded, nPercentNonlethal, sStatus;
end

-- Based on the percent wounded, change the token health bar color
function getWoundBarColor(sNodeType, node)
	local nPercentWounded, nPercentNonlethal, sStatus = getPercentWounded(sNodeType, node);
	
	local sColor;
	if sStatus == "Unconscious" then
		sColor = COLOR_TOKEN_HEALTH_UNCONSCIOUS;
	else
		sColor = ColorManager.getTokenHealthColor(nPercentNonlethal, true);
	end

	return sColor, nPercentWounded, nPercentNonlethal, sStatus;
end

function getAbilityEffectsBonus(rActor, sAbility)
	if not rActor or not sAbility then
		return 0, 0;
	end
	
	local sAbilityEffect = DataCommon.ability_ltos[sAbility];
	if not sAbilityEffect then
		return 0, 0;
	end
	
	local nAbilityMod, nAbilityEffects = EffectManagerDCC.getEffectsBonus(rActor, sAbilityEffect, true);

	local nAbilityScore = getAbilityScore(rActor, sAbility);
	if nAbilityScore > 0 then
		local nAffectedScore = math.max(nAbilityScore + nAbilityMod, 0);
		
		local nCurrentBonus = GameSystem.getAbilityBonus(nAbilityScore);
		local nAffectedBonus = GameSystem.getAbilityBonus(nAffectedScore);
		
		nAbilityMod = nAffectedBonus - nCurrentBonus;
	else
		if nAbilityMod > 0 then
			nAbilityMod = math.floor(nAbilityMod / 2);
		else
			nAbilityMod = math.ceil(nAbilityMod / 2);
		end
	end

	return nAbilityMod, nAbilityEffects;
end

function getClassLevel(nodeActor, sValue)
	local sClassName = DataCommon.class_valuetoname[sValue];
	if not sClassName then
		return 0;
	end
	sClassName = sClassName:lower();
	
	for _, vNode in pairs(DB.getChildren(nodeActor, "classes")) do
		if DB.getValue(vNode, "name", ""):lower() == sClassName then
			return DB.getValue(vNode, "level", 0);
		end
	end
	
	return 0;
end

function getAbilityScore(rActor, sAbility)
	if not sAbility then
		return -1;
	end
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	if not nodeActor then
		return -1;
	end

	local nStatScore = -1;
	
	local sShort = string.sub(string.lower(sAbility), 1, 3);
	if sShort == "lev" then
		if sActorType == "pc" then
			nStatScore = DB.getValue(nodeActor, "casterlevel", 0);
		else
			local sHD = StringManager.trim(DB.getValue(nodeActor, "hd", ""));
			nStatScore = 0;
			for sLevelSub in sHD:gmatch("(%d+)[dD](%d+)") do
				nStatScore = nStatScore + (tonumber(sLevelSub) or 0);
			end
		end
	elseif sShort == "str" then
		nStatScore = DB.getValue(nodeActor, "abilities.strength.score", 0);
	elseif sShort == "agi" then
		nStatScore = DB.getValue(nodeActor, "abilities.agility.score", 0);
	elseif sShort == "sta" then
		nStatScore = DB.getValue(nodeActor, "abilities.stamina.score", 0);
	elseif sShort == "int" then
		nStatScore = DB.getValue(nodeActor, "abilities.intelligence.score", 0);
	elseif sShort == "per" then
		nStatScore = DB.getValue(nodeActor, "abilities.personality.score", 0);
	elseif sShort == "luc" then
		nStatScore = DB.getValue(nodeActor, "abilities.luck.score", 0);
	end
	
	return nStatScore;
end

function getAbilityBonus(rActor, sAbility)
	if not sAbility then
		return 0;
	end
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	if not nodeActor then
		return 0;
	end
	
	local nStatScore = getAbilityScore(rActor, sAbility);	
	if nStatScore < 0 then
		return 0;
	end

	local nStatVal = 0;
	if StringManager.contains(DataCommon.abilities, sAbility) then
		nStatVal = GameSystem.getAbilityBonus(nStatScore);
	else
		nStatVal = nStatScore;
	end

	return nStatVal;
end

function getDefenseValue(rAttacker, rDefender, rRoll)
	if not rDefender or not rRoll then
		return nil, 0, 0, 0;
	end
	
	local sAttack = rRoll.sDesc;
	
	-- Base calculations
	local sAttackType = "M";
	if rRoll.sType == "attack" then
		sAttackType = string.match(sAttack, "%[ATTACK.*%((%w+)%)%]");
	end
	local bCover = string.match(sAttack, "%[COVER");

	local nDefense = 10;
	local sDefenseStat = "agility";

	local sDefenderType, nodeDefender = ActorManager.getTypeAndNode(rDefender);
	if not nodeDefender then
		return nil, 0, 0, 0;
	end

	if sDefenderType == "pc" then
		if rRoll.sType == "attack" then
			nDefense = DB.getValue(nodeDefender, "ac.total", 10);
		end
		sDefenseStat = "agility";
	elseif sDefenderType == "ct" then
		if rRoll.sType == "attack" then
			nDefense = DB.getValue(nodeDefender, "ac_final", 10);
		end
	else
		if rRoll.sType == "attack" then
			local sAC = DB.getValue(nodeDefender, "ac", "");
			nDefense = tonumber(string.match(sAC, "^%s*(%d+)")) or 10;
		else
			local sAC = DB.getValue(nodeDefender, "ac", "");
			local nAC = tonumber(string.match(sAC, "^%s*(%d+)")) or 10;
		end
	end
	nDefenseStatMod = getAbilityBonus(rDefender, sDefenseStat);
	
	-- Effects
	local nAttackEffectMod = 0;
	local nDefenseEffectMod = 0;
	local nMissChance = 0;
	if ActorManager.hasCT(rDefender) then
		local nBonusAC = 0;
		local nBonusStat = 0;
		local nBonusSituational = 0;

		local aAttackFilter = {};
		if sAttackType == "M" then
			table.insert(aAttackFilter, "melee");
		elseif sAttackType == "R" then
			table.insert(aAttackFilter, "ranged");
		end

		local aBonusTargetedAttackDice, nBonusTargetedAttack = EffectManagerDCC.getEffectsBonus(rAttacker, "ATK", false, aAttackFilter, rDefender, true);
		nAttackEffectMod = nAttackEffectMod + StringManager.evalDice(aBonusTargetedAttackDice, nBonusTargetedAttack);

		local aACEffects, nACEffectCount = EffectManagerDCC.getEffectsBonusByType(rDefender, {"AC"}, true, aAttackFilter, rAttacker);
		for _,v in pairs(aACEffects) do
			nBonusAC = nBonusAC + v.mod;
		end

		nBonusStat = getAbilityEffectsBonus(rDefender, sDefenseStat);

		if EffectManagerDCC.hasEffect(rDefender, "Behind cover") or bCover then
			nBonusSituational = nBonusSituational + 2;
		end
		if EffectManagerDCC.hasEffect(rDefender, "Blinded") then
			nBonusSituational = nBonusSituational - 2;
		end
		if EffectManagerDCC.hasEffect(rDefender, "Kneeling") or 
				EffectManagerDCC.hasEffect(rDefender, "Sitting") or
				EffectManagerDCC.hasEffect(rDefender, "Prone") then
			if sAttackType == "M" then
				nBonusSituational = nBonusSituational - 2;
			elseif sAttackType == "R" then
				nBonusSituational = nBonusSituational + 2;
			end
		end
		
		nDefenseEffectMod = nBonusAC + nBonusStat + nBonusSituational;
	end
	
	-- Results
	return nDefense + nDefenseEffectMod - nAttackEffectMod, nAttackEffectMod, nDefenseEffectMod, nMissChance;
end

function isAlignment(rActor, sAlignCheck)
	local nCheckLawChaosAxis = 0;
	local nCheckGoodEvilAxis = 0;
	local aCheckSplit = StringManager.split(sAlignCheck:lower(), " ", true);
	for _,v in ipairs(aCheckSplit) do
		if nCheckLawChaosAxis == 0 and DataCommon.alignment_lawchaos[v] then
			nCheckLawChaosAxis = DataCommon.alignment_lawchaos[v];
		end
		if nCheckGoodEvilAxis == 0 and DataCommon.alignment_goodevil[v] then
			nCheckGoodEvilAxis = DataCommon.alignment_goodevil[v];
		end
	end
	if nCheckLawChaosAxis == 0 and nCheckGoodEvilAxis == 0 then
		return false;
	end
	
	local nActorLawChaosAxis = 2;
	local nActorGoodEvilAxis = 2;
	local sType, nodeActor = ActorManager.getTypeAndNode(rActor);
	local sField = "alignment";
	local aActorSplit = StringManager.split(DB.getValue(nodeActor, sField, ""):lower(), " ", true);
	for _,v in ipairs(aActorSplit) do
		if nActorLawChaosAxis == 2 and DataCommon.alignment_lawchaos[v] then
			nActorLawChaosAxis = DataCommon.alignment_lawchaos[v];
		end
		if nActorGoodEvilAxis == 2 and DataCommon.alignment_goodevil[v] then
			nActorGoodEvilAxis = DataCommon.alignment_goodevil[v];
		end
	end
	
	local bLCReturn = true;
	if nCheckLawChaosAxis > 0 then
		if nActorLawChaosAxis > 0 then
			bLCReturn = (nActorLawChaosAxis == nCheckLawChaosAxis);
		else
			bLCReturn = false;
		end
	end
	
	local bGEReturn = true;
	if nCheckGoodEvilAxis > 0 then
		if nActorGoodEvilAxis > 0 then
			bGEReturn = (nActorGoodEvilAxis == nCheckGoodEvilAxis);
		else
			bGEReturn = false;
		end
	end
	
	return (bLCReturn and bGEReturn);
end

function isSize(rActor, sSizeCheck)
	local sSizeCheckLower = StringManager.trim(sSizeCheck:lower());

	local sCheckOp = sSizeCheckLower:match("^[<>]?=?");
	if sCheckOp then
		sSizeCheckLower = StringManager.trim(sSizeCheckLower:sub(#sCheckOp + 1));
	end
	
	local nCheckSize = 0;
	if DataCommon.creaturesize[sSizeCheckLower] then
		nCheckSize = DataCommon.creaturesize[sSizeCheckLower];
	end
	if nCheckSize == 0 then
		return false;
	end
	
	local nActorSize = 0;
	local sType, nodeActor = ActorManager.getTypeAndNode(rActor);
	local sField = "size";
	local aActorSplit = StringManager.split(DB.getValue(nodeActor, sField, ""):lower(), " ", true);
	for _,v in ipairs(aActorSplit) do
		if nActorSize == 0 and DataCommon.creaturesize[v] then
			nActorSize = DataCommon.creaturesize[v];
			break;
		end
	end
	if nActorSize == 0 then
		nActorSize = 3;
	end
	
	local bReturn = true;
	if sCheckOp then
		if sCheckOp == "<" then
			bReturn = (nActorSize < nCheckSize);
		elseif sCheckOp == ">" then
			bReturn = (nActorSize > nCheckSize);
		elseif sCheckOp == "<=" then
			bReturn = (nActorSize <= nCheckSize);
		elseif sCheckOp == ">=" then
			bReturn = (nActorSize >= nCheckSize);
		else
			bReturn = (nActorSize == nCheckSize);
		end
	else
		bReturn = (nActorSize == nCheckSize);
	end
	
	return bReturn;
end

function getCreatureTypeHelper(sTypeCheck, bUseDefaultType)
	local aCheckSplit = StringManager.split(sTypeCheck:lower(), ", %(%)", true);
	
	local aTypeCheck = {};
	local aSubTypeCheck = {};
	
	-- Handle half races
	local nHalfRace = 0;
	for k = 1, #aCheckSplit do
		if aCheckSplit[k]:sub(1, #DataCommon.creaturehalftype) == DataCommon.creaturehalftype then
			aCheckSplit[k] = aCheckSplit[k]:sub(#DataCommon.creaturehalftype + 1);
			nHalfRace = nHalfRace + 1;
		end
	end
	if nHalfRace == 1 then
		if not StringManager.contains (aCheckSplit, DataCommon.creaturehalftypesubrace) then
			table.insert(aCheckSplit, DataCommon.creaturehalftypesubrace);
		end
	end
	
	-- Check each word combo in the creature type string against standard creature types and subtypes
	for k = 1, #aCheckSplit do
		for _,sMainType in ipairs(DataCommon.creaturetype) do
			local aMainTypeSplit = StringManager.split(sMainType, " ", true);
			if #aMainTypeSplit > 0 then
				local bMatch = true;
				for i = 1, #aMainTypeSplit do
					if aMainTypeSplit[i] ~= aCheckSplit[k - 1 + i] then
						bMatch = false;
						break;
					end
				end
				if bMatch then
					table.insert(aTypeCheck, sMainType);
					k = k + (#aMainTypeSplit - 1);
				end
			end
		end
		for _,sSubType in ipairs(DataCommon.creaturesubtype) do
			local aSubTypeSplit = StringManager.split(sSubType, " ", true);
			if #aSubTypeSplit > 0 then
				local bMatch = true;
				for i = 1, #aSubTypeSplit do
					if aSubTypeSplit[i] ~= aCheckSplit[k - 1 + i] then
						bMatch = false;
						break;
					end
				end
				if bMatch then
					table.insert(aSubTypeCheck, sSubType);
					k = k + (#aSubTypeSplit - 1);
				end
			end
		end
	end
	
	-- Make sure we have a default creature type (if requested)
	if bUseDefaultType then
		if #aTypeCheck == 0 then
			table.insert(aTypeCheck, DataCommon.creaturedefaulttype);
		end
	end
	
	-- Combine into a single list
	for _,vSubType in ipairs(aSubTypeCheck) do
		table.insert(aTypeCheck, vSubType);
	end
	
	return aTypeCheck;
end

function isCreatureType(rActor, sTypeCheck)
	local aTypeCheck = getCreatureTypeHelper(sTypeCheck, false);
	if #aTypeCheck == 0 then
		return false;
	end
	
	local sType, nodeActor = ActorManager.getTypeAndNode(rActor);
	local sField = "race";
	if sType ~= "pc" then
		sField = "type";
	end
	local aTypeActor = getCreatureTypeHelper(DB.getValue(nodeActor, sField, ""), true);
	
	local bReturn = false;
	for kCheck,vCheck in ipairs(aTypeCheck) do
		if StringManager.contains(aTypeActor, vCheck) then
			bReturn = true;
			break;
		end
	end
	return bReturn;
end
