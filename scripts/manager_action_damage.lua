 -- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYDMG = "applydmg";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYDMG, handleApplyDamage);

	ActionsManager.registerModHandler("damage", modDamage);
	ActionsManager.registerPostRollHandler("damage", onDamageRoll);
	ActionsManager.registerResultHandler("damage", onDamage);
end

function handleApplyDamage(msgOOB)
	local rSource = ActorManager.getActor(msgOOB.sSourceType, msgOOB.sSourceNode);
	local rTarget = ActorManager.getActor(msgOOB.sTargetType, msgOOB.sTargetNode);
	if rTarget then
		rTarget.nOrder = msgOOB.nTargetOrder;
	end
	
	local nTotal = tonumber(msgOOB.nTotal) or 0;
	applyDamage(rSource, rTarget, (tonumber(msgOOB.nSecret) == 1), msgOOB.sDamage, nTotal);
end

function notifyApplyDamage(rSource, rTarget, bSecret, sDesc, nTotal)
	if not rTarget then
		return;
	end
	local sTargetType, sTargetNode = ActorManager.getTypeAndNodeName(rTarget);
	if sTargetType ~= "pc" and sTargetType ~= "ct" then
		return;
	end

	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYDMG;
	
	if bSecret then
		msgOOB.nSecret = 1;
	else
		msgOOB.nSecret = 0;
	end
	msgOOB.nTotal = nTotal;
	msgOOB.sDamage = sDesc;
	msgOOB.sTargetType = sTargetType;
	msgOOB.sTargetNode = sTargetNode;
	msgOOB.nTargetOrder = rTarget.nOrder;

	local sSourceType, sSourceNode = ActorManager.getTypeAndNodeName(rSource);
	msgOOB.sSourceType = sSourceType;
	msgOOB.sSourceNode = sSourceNode;

	Comm.deliverOOBMessage(msgOOB, "");
end

function getRoll(rActor, rAction)
	local rRoll = {};
	rRoll.sType = "damage";
	rRoll.aDice = {};
	rRoll.nMod = 0;
	rRoll.bWeapon = rAction.bWeapon;

	rRoll.sDesc = "[DAMAGE";
	if rAction.order and rAction.order > 1 then
		rRoll.sDesc = rRoll.sDesc .. " #" .. rAction.order;
	end
	if rAction.range then
		rRoll.sDesc = rRoll.sDesc .. " (" .. rAction.range ..")";
		rRoll.range = rAction.range;
	end
	rRoll.sDesc = rRoll.sDesc .. "] " .. rAction.label;
	
	-- Save the damage properties in the roll structure
	rRoll.clauses = rAction.clauses;
	
	-- Add the dice and modifiers
	for _,vClause in ipairs(rRoll.clauses) do
		for _,vDie in ipairs(vClause.dice) do
			table.insert(rRoll.aDice, vDie);
		end
		rRoll.nMod = rRoll.nMod + vClause.modifier;
	end
	
	-- Encode the damage types
	encodeDamageTypes(rRoll);

	return rRoll;
end

function performRoll(draginfo, rActor, rAction)
	local rRoll = getRoll(rActor, rAction);
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function modDamage(rSource, rTarget, rRoll)
	decodeDamageTypes(rRoll);
	CombatManager2.addRightClickDiceToClauses(rRoll);
	
	-- Set up
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	-- Build attack type filter
	local aAttackFilter = {};
	if rRoll.range == "R" then
		table.insert(aAttackFilter, "ranged");
	elseif rRoll.range == "M" then
		table.insert(aAttackFilter, "melee");
	end
	
	-- Track how many damage clauses before effects applied
	local nPreEffectClauses = #(rRoll.clauses);
		
	-- If source actor, then get modifiers
	if rSource then
		local bEffects = false;
		local aEffectDice = {};
		local nEffectMod = 0;
		
		-- Apply ability modifiers
		for _,vClause in ipairs(rRoll.clauses) do
			local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, vClause.stat);
			if nBonusEffects > 0 then
				bEffects = true;
				local nMult = vClause.statmult or 1;
				if nBonusStat > 0 and nMult ~= 1 then
					nBonusStat = math.floor(nMult * nBonusStat);
				end
				nEffectMod = nEffectMod + nBonusStat;
				vClause.modifier = vClause.modifier + nBonusStat;
				rRoll.nMod = rRoll.nMod + nBonusStat;
			end
		end
		
		-- Apply general damage modifiers
		local aEffects, nEffectCount = EffectManagerDCC.getEffectsBonusByType(rSource, "DMG", true, aAttackFilter, rTarget);
		if nEffectCount > 0 then
			local sEffectBaseType = "";
			if #(rRoll.clauses) > 0 then
				sEffectBaseType = rRoll.clauses[1].dmgtype or "";
			end
			
			for _,v in pairs(aEffects) do
				local aEffectDmgType = {};
				for _,sType in ipairs(v.remainder) do
					if StringManager.contains(DataCommon.dmgtypes, sType) then
						table.insert(aEffectDmgType, sType);
					end
				end
				
				bEffects = true;
		
				local rClause = {};
				
				rClause.dice = {};
				for _,vDie in ipairs(v.dice) do
					table.insert(aEffectDice, vDie);
					table.insert(rClause.dice, vDie);
					if vDie:sub(1,1) == "-" then
						table.insert(rRoll.aDice, "-p" .. vDie:sub(3));
					else
						table.insert(rRoll.aDice, "p" .. vDie:sub(2));
					end
				end

				nEffectMod = nEffectMod + v.mod;
				rClause.modifier = v.mod;
				rRoll.nMod = rRoll.nMod + v.mod;
				
				rClause.stat = "";

				if #aEffectDmgType == 0 then
					table.insert(aEffectDmgType, sEffectBaseType);
				end
				rClause.dmgtype = table.concat(aEffectDmgType, ",");

				table.insert(rRoll.clauses, rClause);
			end
		end
		
		-- Apply damage type modifiers
		local aEffects = EffectManagerDCC.getEffectsByType(rSource, "DMGTYPE", {});
		local aAddTypes = {};
		for _,v in ipairs(aEffects) do
			for _,v2 in ipairs(v.remainder) do
				local aSplitTypes = StringManager.split(v2, ",", true);
				for _,v3 in ipairs(aSplitTypes) do
					table.insert(aAddTypes, v3);
				end
			end
		end
		if #aAddTypes > 0 then
			for _,vClause in ipairs(rRoll.clauses) do
				local aSplitTypes = StringManager.split(vClause.dmgtype, ",", true);
				for _,v2 in ipairs(aAddTypes) do
					if not StringManager.contains(aSplitTypes, v2) then
						if vClause.dmgtype ~= "" then
							vClause.dmgtype = vClause.dmgtype .. "," .. v2;
						else
							vClause.dmgtype = v2;
						end
					end
				end
			end
		end
		
		-- Apply condition modifiers
		if EffectManagerDCC.hasEffect(rSource, "Incorporeal") then
			bEffects = true;
			table.insert(aAddDesc, "[INCORPOREAL]");
		end

		-- Add note about effects
		if bEffects then
			local sEffects = "";
			local sMod = StringManager.convertDiceToString(aEffectDice, nEffectMod, true);
			if sMod ~= "" then
				sEffects = "[" .. Interface.getString("effects_tag") .. " " .. sMod .. "]";
			else
				sEffects = "[" .. Interface.getString("effects_tag") .. "]";
			end
			table.insert(aAddDesc, sEffects);
		end
	end

	-- Handle short range
	local bShortRange = ModifierStack.getModifierKey("SHORT_RANGE");
	if bShortRange and rRoll.range == "R" then
		table.insert(aAddDesc, "[SHORT RANGE]");

		-- Apply strength bonus to damage
		local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);
		local nStrengthBonus =  DB.getValue(nodeActor, "abilities.strength.bonus", 0);	
		rRoll.nMod = rRoll.nMod + nStrengthBonus;
		
		-- Add additional strength bonus from effects
		local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, "strength");		
		if nBonusEffects > 0 then
			rRoll.nMod = rRoll.nMod + nBonusStat;
		end
	end

	-- Handle damage modifiers
	local bMax = ModifierStack.getModifierKey("DMG_MAX");
	if bMax then
		table.insert(aAddDesc, "[MAX]");
	end
	local bHalf = ModifierStack.getModifierKey("DMG_HALF");
	if bHalf then
		table.insert(aAddDesc, "[HALF]");
	end
	
	-- Add note about effects
	if bEffects then
		local sEffects = "";
		local sMod = StringManager.convertDiceToString(aEffectDice, nEffectMod, true);
		if sMod ~= "" then
			sEffects = "[" .. Interface.getString("effects_tag") .. " " .. sMod .. "]";
		else
			sEffects = "[" .. Interface.getString("effects_tag") .. "]";
		end
		table.insert(aAddDesc, sEffects);
	end
	
	-- Add notes to roll description
	if #aAddDesc > 0 then
		rRoll.sDesc = rRoll.sDesc .. " " .. table.concat(aAddDesc, " ");
	end
	
	-- Add damage type info to roll description
	encodeDamageTypes(rRoll);
end

function onDamageRoll(rSource, rRoll)
	decodeDamageTypes(rRoll, true);
end

function onDamage(rSource, rTarget, rRoll)	
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	rMessage.text = string.gsub(rMessage.text, " %[MOD:[^]]*%]", "");

	-- Send the chat message
	local bShowMsg = true;
	if rTarget and rTarget.nOrder and rTarget.nOrder ~= 1 then
		bShowMsg = false;
	end
	if bShowMsg then
		Comm.deliverChatMessage(rMessage);
	end

	-- Apply damage to the PC or CT entry referenced
	local nTotal = ActionsManager.total(rRoll);
	notifyApplyDamage(rSource, rTarget, rMessage.secret, rMessage.text, nTotal);
end

--
-- UTILITY FUNCTIONS
--

function encodeDamageTypes(rRoll)
	for _,vClause in ipairs(rRoll.clauses) do
		if vClause.dmgtype and vClause.dmgtype ~= "" then
			local sDice = StringManager.convertDiceToString(vClause.dice, vClause.modifier);
			rRoll.sDesc = rRoll.sDesc .. string.format(" [TYPE: %s (%s) (%s) (%s)]", vClause.dmgtype, sDice, vClause.stat or "", vClause.statmult or 1);
		end
	end
end

function decodeDamageTypes(rRoll, bFinal)
	-- Process each type clause in the damage description as encoded previously
	local nMainDieIndex = 0;
	rRoll.clauses = {};
	for sDamageType, sDamageDice, sDamageAbility, sDamageAbilityMult in string.gmatch(rRoll.sDesc, "%[TYPE: ([^(]*) %(([^)]*)%) %((%w*)%) %(([%w,]*)%)%]") do
		local rClause = {};
		rClause.dmgtype = StringManager.trim(sDamageType);
		rClause.stat = sDamageAbility;
		rClause.statmult = tonumber(sDamageAbilityMult) or 1;
		rClause.dice, rClause.modifier = StringManager.convertStringToDice(sDamageDice);
		rClause.nTotal = rClause.modifier;
		for kDie,vDie in ipairs(rClause.dice) do
			nMainDieIndex = nMainDieIndex + 1;
			if rRoll.aDice[nMainDieIndex] then
				rClause.nTotal = rClause.nTotal + (rRoll.aDice[nMainDieIndex].result or 0);
			end
		end
		
		table.insert(rRoll.clauses, rClause);
	end

	-- Process each type clause in the damage description (DRAG ROLL RESULT)
	local nClauses = #(rRoll.clauses);
	for sDamageType, sDamageDice in string.gmatch(rRoll.sDesc, "%[TYPE: ([^(]*) %(([^)]*)%)]") do
		local sTotal = string.match(sDamageDice, "=(%d+)");
		if sTotal then
			local nTotal = tonumber(sTotal) or 0;
			
			local rClause = {};
			rClause.dmgtype = StringManager.trim(sDamageType);
			rClause.stat = "";
			rClause.dice = {};
			rClause.modifier = nTotal;
			rClause.nTotal = nTotal;

			table.insert(rRoll.clauses, rClause);
		end
	end
	
	-- Add untyped clause if no TYPE tag found
	if #(rRoll.clauses) == 0 then
		local rClause = {};
		rClause.dmgtype = "";
		rClause.stat = "";
		rClause.dice = {};
		rClause.modifier = rRoll.nMod;
		rClause.nTotal = rRoll.nMod;
		for _,vDie in ipairs(rRoll.aDice) do
			if type(vDie) == "table" then
				table.insert(rClause.dice, vDie.type);
				rClause.nTotal = rClause.nTotal + (vDie.result or 0); 
			else
				table.insert(rClause.dice, vDie);
			end
		end

		table.insert(rRoll.clauses, rClause);
	end
	
	-- Handle drag results that are halved or doubled
	if #(rRoll.aDice) == 0 then
		local nResultTotal = 0;
		for i = nClauses + 1, #(rRoll.clauses) do
			nResultTotal = rRoll.clauses[i].nTotal;
		end
		if nResultTotal > 0 and nResultTotal ~= rRoll.nMod then
			if math.floor(nResultTotal / 2) == rRoll.nMod then
				for _,vClause in ipairs(rRoll.clauses) do
					vClause.modifier = math.floor(vClause.modifier / 2);
					vClause.nTotal = math.floor(vClause.nTotal / 2);
				end
			elseif nResultTotal * 2 == rRoll.nMod then
				for _,vClause in ipairs(rRoll.clauses) do
					vClause.modifier = 2 * vClause.modifier;
					vClause.nTotal = 2 * vClause.nTotal;
				end
			end
		end
	end
	
	-- Remove damage type information from roll description
	rRoll.sDesc = string.gsub(rRoll.sDesc, " %[TYPE:[^]]*%]", "");
	
	if bFinal then
		local nFinalTotal = ActionsManager.total(rRoll);

		-- Handle minimum damage
		if nFinalTotal < 0 and rRoll.aDice and #rRoll.aDice > 0 then
			rRoll.sDesc = rRoll.sDesc .. " [MIN DAMAGE]";
			rRoll.nMod = rRoll.nMod - nFinalTotal;
			nFinalTotal = 0;
		end

		-- Capture any manual modifiers and adjust damage types accordingly
		-- NOTE: Positive values are added to first damage clause, Negative values reduce damage clauses until none remain
		local nClausesTotal = 0;
		for _,vClause in ipairs(rRoll.clauses) do
			nClausesTotal = nClausesTotal + vClause.nTotal;
		end
		if nFinalTotal ~= nClausesTotal then
			local nRemainder = nFinalTotal - nClausesTotal;
			if nRemainder > 0 then
				if #(rRoll.clauses) == 0 then
					table.insert(rRoll.clauses, { dmgtype = "", stat = "", dice = {}, modifier = nRemainder, nTotal = nRemainder})
				else
					rRoll.clauses[1].modifier = rRoll.clauses[1].modifier + nRemainder;
					rRoll.clauses[1].nTotal = rRoll.clauses[1].nTotal + nRemainder;
				end
			else
				for _,vClause in ipairs(rRoll.clauses) do
					if vClause.nTotal >= -nRemainder then
						vClause.modifier = vClause.modifier + nRemainder;
						vClause.nTotal = vClause.nTotal + nRemainder;
						break;
					else
						vClause.modifier = vClause.modifier - vClause.nTotal;
						nRemainder = nRemainder + vClause.nTotal;
						vClause.nTotal = 0;
					end
				end
			end
		end
		
		-- Collapse damage clauses into smallest set, then add to roll description as text
		local aDamage = getDamageStrings(rRoll.clauses);
		for _, rDamage in ipairs(aDamage) do
			local sDice = StringManager.convertDiceToString(rDamage.aDice, rDamage.nMod);
			local sDmgTypeOutput = rDamage.sType;
			if sDmgTypeOutput == "" then
				sDmgTypeOutput = "untyped";
			end
			rRoll.sDesc = rRoll.sDesc .. string.format(" [TYPE: %s (%s=%d)]", sDmgTypeOutput, sDice, rDamage.nTotal);
		end
	end
end

-- Collapse damage clauses by damage type (in the original order, if possible)
function getDamageStrings(clauses)
	local aOrderedTypes = {};
	local aDmgTypes = {};
	for _,vClause in ipairs(clauses) do
		local rDmgType = aDmgTypes[vClause.dmgtype];
		if not rDmgType then
			rDmgType = {};
			rDmgType.aDice = {};
			rDmgType.nMod = 0;
			rDmgType.nTotal = 0;
			rDmgType.sType = vClause.dmgtype;
			aDmgTypes[vClause.dmgtype] = rDmgType;
			table.insert(aOrderedTypes, rDmgType);
		end

		for _,vDie in ipairs(vClause.dice) do
			table.insert(rDmgType.aDice, vDie);
		end
		rDmgType.nMod = rDmgType.nMod + vClause.modifier;
		rDmgType.nTotal = rDmgType.nTotal + (vClause.nTotal or 0);
	end
	
	return aOrderedTypes;
end

function getDamageTypesFromString(sDamageTypes)
	local sLower = string.lower(sDamageTypes);
	local aSplit = StringManager.split(sLower, ",", true);
	
	local aDamageTypes = {};
	for _,v in ipairs(aSplit) do
		if StringManager.contains(DataCommon.dmgtypes, v) then
			table.insert(aDamageTypes, v);
		end
	end
	
	return aDamageTypes;
end

--
-- DAMAGE APPLICATION
--

function getParenDepth(sText, nIndex)
	local nDepth = 0;
	
	local cStart = string.byte("(");
	local cEnd = string.byte(")");
	
	for i = 1, nIndex do
		local cText = string.byte(sText, i);
		if cText == cStart then
			nDepth = nDepth + 1;
		elseif cText == cEnd then
			nDepth = nDepth - 1;
		end
	end
	
	return nDepth;
end

function decodeAndOrClauses(sText)
	local nIndexOR;
	local nStartOR, nEndOR, nStartAND, nEndAND;
	local nStartOR2, nEndOR2;
	local nParen;
	local sPhraseOR;

	local aClausesOR = {};
	local aSkipOR = {};
	local nIndexOR = 1;
	while nIndexOR < #sText do
		local nTempIndex = nIndexOR;
		repeat
			nParen = 0;
			nStartOR, nEndOR = string.find(sText, "%s+or%s+", nTempIndex);
			nStartOR2, nEndOR2 = string.find(sText, "%s*;%s*", nTempIndex);
			
			if nStartOR2 and (not nStartOR or nStartOR > nStartOR2) then
				nStartOR = nStartOR2;
				nEndOR = nEndOR2;
			end
			
			if nStartOR then
				nParen = getParenDepth(sText, nStartOR);
				if nParen ~= 0 then
					nTempIndex = nEndOR + 1;
				end
			end
		until not nStartOR or nParen == 0;
		
		if nStartOR then
			sPhraseOR = string.sub(sText, nIndexOR, nStartOR - 1);
		else
			sPhraseOR = string.sub(sText, nIndexOR);
		end

		local aClausesAND = {};
		local aSkipAND = {};
		local nIndexAND = 1;
		while nIndexAND < #sPhraseOR do
			nTempIndex = nIndexAND;
			repeat
				nParen = 0;
				nStartAND, nEndAND = string.find(sPhraseOR, "%s+and%s+", nTempIndex);
				
				if nStartAND then
					nParen = getParenDepth(sText, nIndexOR + nStartAND);
					if nParen ~= 0 then
						nTempIndex = nEndAND + 1;
					end
				end
			until not nStartAND or nParen == 0;
			
			if nStartAND then
				table.insert(aClausesAND, string.sub(sPhraseOR, nIndexAND, nStartAND - 1));
				nIndexAND = nEndAND + 1;
				table.insert(aSkipAND, nEndAND - nStartAND + 1);
			else
				table.insert(aClausesAND, string.sub(sPhraseOR, nIndexAND));
				nIndexAND = #sPhraseOR;
				if nStartOR then
					table.insert(aSkipAND, nEndOR - nStartOR + 1);
				else
					table.insert(aSkipAND, 0);
				end
			end
		end
		
		if nStartOR then
			nIndexOR = nEndOR + 1;
		else
			nIndexOR = #sText;
		end

		table.insert(aClausesOR, aClausesAND);
		table.insert(aSkipOR, aSkipAND);
	end
	
	return aClausesOR, aSkipOR;
end

function matchAndOrClauses(aClausesOR, aMatchWords)
	for kClauseOR, aClausesAND in ipairs(aClausesOR) do
		local bMatchAND = true;
		local nMatchAND = 0;

		for kClauseAND, sClause in ipairs(aClausesAND) do
			nMatchAND = nMatchAND + 1;

			if not StringManager.contains(aMatchWords, sClause) then
				bMatchAND = false;
				break;
			end
		end
		
		if bMatchAND and nMatchAND > 0 then
			return true;
		end
	end
		
	return false;
end

function getReductionType(rSource, rTarget, sEffectType)
	local aEffects = EffectManagerDCC.getEffectsByType(rTarget, sEffectType, {}, rSource);
	
	local aFinal = {};
	for _,v in pairs(aEffects) do
		local rReduction = {};
		
		rReduction.mod = v.mod;
		rReduction.aNegatives = {};
		for _,vType in pairs(v.remainder) do
			if #vType > 1 and ((vType:sub(1,1) == "!") or (vType:sub(1,1) == "~")) then
				if StringManager.contains(DataCommon.dmgtypes, vType:sub(2)) then
					table.insert(rReduction.aNegatives, vType:sub(2));
				end
			end
		end

		for _,vType in pairs(v.remainder) do
			if vType ~= "untyped" and vType ~= "" and vType:sub(1,1) ~= "!" and vType:sub(1,1) ~= "~" then
				if StringManager.contains(DataCommon.dmgtypes, vType) or vType == "all" then
					aFinal[vType] = rReduction;
				end
			end
		end
	end
	
	return aFinal;
end

function checkReductionTypeHelper(rMatch, aDmgType)
	if not rMatch or (rMatch.mod ~= 0) then
		return false;
	end
	if #(rMatch.aNegatives) > 0 then
		local bMatchNegative = false;
		for _,vNeg in pairs(rMatch.aNegatives) do
			if StringManager.contains(aDmgType, vNeg) then
				bMatchNegative = true;
				break;
			end
		end
		return not bMatchNegative;
	end
	return true;
end

function checkReductionType(aReduction, aDmgType)
	for _,sDmgType in pairs(aDmgType) do
		if checkReductionTypeHelper(aReduction[sDmgType], aDmgType) or checkReductionTypeHelper(aReduction["all"], aDmgType) then
			return true;
		end
	end
	
	return false;
end

function checkNumericalReductionTypeHelper(rMatch, aDmgType, nLimit)
	if not rMatch or (rMatch.mod == 0) then
		return 0;
	end

	local bMatch = false;
	if #rMatch.aNegatives > 0 then
		local bMatchNegative = false;
		for _,vNeg in pairs(rMatch.aNegatives) do
			if StringManager.contains(aDmgType, vNeg) then
				bMatchNegative = true;
				break;
			end
		end
		if not bMatchNegative then
			bMatch = true;
		end
	else
		bMatch = true;
	end
	
	local nAdjust = 0;
	if bMatch then
		nAdjust = rMatch.mod - (rMatch.nApplied or 0);
		if nLimit then
			nAdjust = math.min(nAdjust, nLimit);
		end
		rMatch.nApplied = (rMatch.nApplied or 0) + nAdjust;
	end
	
	return nAdjust;
end

function checkNumericalReductionType(aReduction, aDmgType, nLimit)
	local nAdjust = 0;
	
	for _,sDmgType in pairs(aDmgType) do
		if nLimit then
			local nSpecificAdjust = checkNumericalReductionTypeHelper(aReduction[sDmgType], aDmgType, nLimit);
			nAdjust = nAdjust + nSpecificAdjust;
			local nGlobalAdjust = checkNumericalReductionTypeHelper(aReduction["all"], aDmgType, nLimit - nSpecificAdjust);
			nAdjust = nAdjust + nGlobalAdjust;
		else
			nAdjust = nAdjust + checkNumericalReductionTypeHelper(aReduction[sDmgType], aDmgType);
			nAdjust = nAdjust + checkNumericalReductionTypeHelper(aReduction["all"], aDmgType);
		end
	end
	
	return nAdjust;
end

function getDamageAdjust(rSource, rTarget, nDamage, rDamageOutput)
	local nDamageAdjust = 0;
	local bVulnerable = false;
	local bResist = false;
	local nNonlethal = 0;
	
	-- Get damage adjustment effects
	local aImmune = getReductionType(rSource, rTarget, "IMMUNE");
	local aVuln = getReductionType(rSource, rTarget, "VULN");
	local aResist = getReductionType(rSource, rTarget, "RESIST");
	local aDR = EffectManagerDCC.getEffectsByType(rTarget, "DR", {}, rSource);
	
	local bIncorporealSource = EffectManagerDCC.hasEffect(rSource, "Incorporeal", rTarget);
	local bIncorporealTarget = EffectManagerDCC.hasEffect(rTarget, "Incorporeal", rSource);
	local bApplyIncorporeal = (bIncorporealSource ~= bIncorporealTarget);
	
	-- Handle immune all
	if aImmune["all"] then
		nDamageAdjust = 0 - nDamage;
		bResist = true;
		return nDamageAdjust, bVulnerable, bResist;
	end
	
	-- Iterate through damage type entries for vulnerability, resistance and immunity
	local nVulnApplied = 0;
	local bResistCarry = false;
	for k, v in pairs(rDamageOutput.aDamageTypes) do
		-- Get individual damage types for each damage clause
		local aSrcDmgClauseTypes = {};
		local aTemp = StringManager.split(k, ",", true);
		local bHasEnergyType = false;
		for _,vType in ipairs(aTemp) do
			if vType ~= "untyped" and vType ~= "" then
				table.insert(aSrcDmgClauseTypes, vType);
				if not bHasEnergyType and StringManager.contains(DataCommon.energytypes, vType) then
					bHasEnergyType = true;
				end
			end
		end
		
		-- Handle standard immunity, vulnerability and resistance
		local bLocalVulnerable = checkReductionType(aVuln, aSrcDmgClauseTypes);
		local bLocalResist = checkReductionType(aResist, aSrcDmgClauseTypes);
		local bLocalImmune = checkReductionType(aImmune, aSrcDmgClauseTypes);
		
		-- Handle incorporeal
		if bApplyIncorporeal then
			bLocalResist = true;
		end
		
		-- Calculate adjustment
		-- Vulnerability = double
		-- Resistance = half
		-- Immunity = none
		local nLocalDamageAdjust = 0;
		if bLocalImmune then
			nLocalDamageAdjust = -v;
			bResist = true;
		else
			-- Handle numerical resistance
			local nLocalResist = checkNumericalReductionType(aResist, aSrcDmgClauseTypes, nLocalDamageAdjust + v);
			if nLocalResist ~= 0 then
				nLocalDamageAdjust = nLocalDamageAdjust - nLocalResist;
				bResist = true;
			end
			-- Handle numerical vulnerability
			local nLocalVulnerable = checkNumericalReductionType(aVuln, aSrcDmgClauseTypes);
			if nLocalVulnerable ~= 0 then
				nLocalDamageAdjust = nLocalDamageAdjust + nLocalVulnerable;
				bVulnerable = true;
			end
			-- Handle standard resistance
			if bLocalResist then
				local nResistOddCheck = (nLocalDamageAdjust + v) % 2;
				local nAdj = math.ceil((nLocalDamageAdjust + v) / 2);
				nLocalDamageAdjust = nLocalDamageAdjust - nAdj;
				if nResistOddCheck == 1 then
					if bResistCarry then
						nLocalDamageAdjust = nLocalDamageAdjust + 1;
						bResistCarry = false;
					else
						bResistCarry = true;
					end
				end
				bResist = true;
			end
			-- Handle standard vulnerability
			if bLocalVulnerable then
				nLocalDamageAdjust = nLocalDamageAdjust + (nLocalDamageAdjust + v);
				bVulnerable = true;
			end
		end
		
		-- Handle damage reduction
		if not bHasEnergyType and (v + nLocalDamageAdjust) > 0 then
			local bMatchAND, nMatchAND, bMatchDMG, aClausesOR;
			
			local bApplyDR;
			for _,vDR in pairs(aDR) do
				local kDR = table.concat(vDR.remainder, " ");
				
				if kDR == "" or kDR == "-" or kDR == "all" then
					bApplyDR = true;
				else
					bApplyDR = true;
					aClausesOR = decodeAndOrClauses(kDR);
					if matchAndOrClauses(aClausesOR, aSrcDmgClauseTypes) then
						bApplyDR = false;
					end
				end

				if bApplyDR then
					local nApplied = vDR.nApplied or 0;
					if nApplied < vDR.mod then
						local nChange = math.min((vDR.mod - nApplied), v + nLocalDamageAdjust);
						vDR.nApplied = nApplied + nChange;
						nLocalDamageAdjust = nLocalDamageAdjust - nChange;
						bResist = true;
					end
				end
			end
		end
	
		-- Calculate nonlethal damage
		local nNonlethalAdjust = 0;
		if (v + nLocalDamageAdjust) > 0 then
			local bNonlethal = false;
			for keyDmgType, sDmgType in pairs(aSrcDmgClauseTypes) do
				if sDmgType == "nonlethal" then
					bNonlethal = true;
					break;
				end
			end
			if bNonlethal then
				nNonlethalAdjust = v + nLocalDamageAdjust;
			end
		end
		
		-- Apply adjustment to this damage type clause
		nDamageAdjust = nDamageAdjust + nLocalDamageAdjust - nNonlethalAdjust;
		nNonlethal = nNonlethal + nNonlethalAdjust;
	end

	-- Results
	return nDamageAdjust, nNonlethal, bVulnerable, bResist;
end

function decodeDamageText(nDamage, sDamageDesc)
	local rDamageOutput = {};
	rDamageOutput.sOriginal = sDamageDesc;

	if string.match(sDamageDesc, "%[HEAL") then
		if string.match(sDamageDesc, "%[TEMP%]") then
			rDamageOutput.sType = "temphp";
			rDamageOutput.sTypeOutput = "Temporary hit points";
		else
			rDamageOutput.sType = "heal";
			rDamageOutput.sTypeOutput = "Heal";
		end
		rDamageOutput.sVal = string.format("%01d", nDamage);
		rDamageOutput.nVal = nDamage;

	elseif nDamage < 0 then
		rDamageOutput.sType = "heal";
		rDamageOutput.sTypeOutput = "Heal";
		rDamageOutput.sVal = string.format("%01d", (0 - nDamage));
		rDamageOutput.nVal = 0 - nDamage;

	else
		rDamageOutput.sType = "damage";
		rDamageOutput.sTypeOutput = "Damage";
		rDamageOutput.sVal = string.format("%01d", nDamage);
		rDamageOutput.nVal = nDamage;

		-- Determine range
		rDamageOutput.sRange = string.match(sDamageDesc, "%[DAMAGE %((%w)%)%]") or "";
		rDamageOutput.aDamageFilter = {};
		if rDamageOutput.sRange == "M" then
			table.insert(rDamageOutput.aDamageFilter, "melee");
		elseif rDamageOutput.sRange == "R" then
			table.insert(rDamageOutput.aDamageFilter, "ranged");
		end

		-- Determine damage energy types
		local nDamageRemaining = nDamage;
		rDamageOutput.aDamageTypes = {};
		for sDamageType, sDamageDice, sDamageSubTotal in string.gmatch(sDamageDesc, "%[TYPE: ([^(]*) %(([%d%+%-dD]+)%=(%d+)%)%]") do
			local nDamageSubTotal = (tonumber(sDamageSubTotal) or 0);
			rDamageOutput.aDamageTypes[sDamageType] = nDamageSubTotal + (rDamageOutput.aDamageTypes[sDamageType] or 0);
			if not rDamageOutput.sFirstDamageType then
				rDamageOutput.sFirstDamageType = sDamageType;
			end
			
			nDamageRemaining = nDamageRemaining - nDamageSubTotal;
		end
		if nDamageRemaining > 0 then
			rDamageOutput.aDamageTypes[""] = nDamageRemaining;
		elseif nDamageRemaining < 0 then
			ChatManager.SystemMessage("Total mismatch in damage type totals");
		end
	end
	
	return rDamageOutput;
end

function applyDamage(rSource, rTarget, bSecret, sDamage, nTotal)
	-- Get health fields
	local sTargetType, nodeTarget = ActorManager.getTypeAndNode(rTarget);
	if sTargetType ~= "pc" and sTargetType ~= "ct" then
		return;
	end

	local nTotalHP, nTempHP, nNonlethal, nWounds;	
	if sTargetType == "pc" then
		nTotalHP = DB.getValue(nodeTarget, "hp.total", 0);
		nTempHP = DB.getValue(nodeTarget, "hp.temporary", 0);
		nNonlethal = DB.getValue(nodeTarget, "hp.nonlethal", 0);
		nWounds = DB.getValue(nodeTarget, "hp.wounds", 0);
	else
		nTotalHP = DB.getValue(nodeTarget, "hp", 0);
		nTempHP = DB.getValue(nodeTarget, "hptemp", 0);
		nNonlethal = DB.getValue(nodeTarget, "nonlethal", 0);
		nWounds = DB.getValue(nodeTarget, "wounds", 0);
	end

	-- Prepare for notifications
	local aNotifications = {};
	local bRemoveTarget = false;

	-- Remember current health status
	local _,_,sOriginalStatus = ActorManager2.getPercentWounded(sTargetType, nodeTarget);

	-- Decode damage/heal description
	local rDamageOutput = decodeDamageText(nTotal, sDamage);
	
	-- Healing
	if rDamageOutput.sType == "heal" then
		if nWounds <= 0 and nNonlethal <= 0 then
			table.insert(aNotifications, "[NOT WOUNDED]");
		else
			-- Calculate heal amounts
			local nHealAmount = rDamageOutput.nVal;
			
			local nNonlethalHealAmount = math.min(nHealAmount, nNonlethal);
			nNonlethal = nNonlethal - nNonlethalHealAmount;

			local nOriginalWounds = nWounds;
			
			local nWoundHealAmount = math.min(nHealAmount, nWounds);
			nWounds = nWounds - nWoundHealAmount;
			
			-- Display actual heal amount
			rDamageOutput.nVal = nWoundHealAmount + nNonlethalHealAmount;
			if nWoundHealAmount > 0 then
				rDamageOutput.sVal = "" .. nWoundHealAmount;
				if nNonlethalHealAmount > 0 then
					rDamageOutput.sVal = rDamageOutput.sVal .. " (+" .. nNonlethalHealAmount .. " NL)";
				end
			elseif nNonlethalHealAmount > 0 then
				rDamageOutput.sVal = "" .. nNonlethalHealAmount .. " NL";
			else
				rDamageOutput.sVal = string.format("%01d", nWoundHealAmount);
			end
		end

	-- Temporary hit points
	elseif rDamageOutput.sType == "temphp" then
		nTempHP = nTempHP + nTotal;

	-- Damage
	else
		-- Apply any targeted damage effects 
		-- NOTE: Dice determined randomly, instead of rolled
		if rSource and rTarget and rTarget.nOrder then
			local aTargetedDamage = EffectManagerDCC.getEffectsBonusByType(rSource, {"DMG"}, true, rDamageOutput.aDamageFilter, rTarget, true);

			local nDamageEffectTotal = 0;
			local nDamageEffectCount = 0;
			for k, v in pairs(aTargetedDamage) do
				local aSplitByDmgType = StringManager.split(k, ",", true);
				local nSubTotal = StringManager.evalDice(v.dice, v.mod);
				
				local sDamageType = rDamageOutput.sFirstDamageType;
				if sDamageType then
					sDamageType = sDamageType .. "," .. k;
				else
					sDamageType = k;
				end

				rDamageOutput.aDamageTypes[sDamageType] = (rDamageOutput.aDamageTypes[sDamageType] or 0) + nSubTotal;
				
				nDamageEffectTotal = nDamageEffectTotal + nSubTotal;
				nDamageEffectCount = nDamageEffectCount + 1;
			end
			nTotal = nTotal + nDamageEffectTotal;

			if nDamageEffectCount > 0 then
				if nDamageEffectTotal ~= 0 then
					local sFormat = "[" .. Interface.getString("effects_tag") .. " %+d]";
					table.insert(aNotifications, string.format(sFormat, nDamageEffectTotal));
				else
					table.insert(aNotifications, "[" .. Interface.getString("effects_tag") .. "]");
				end
			end
		end
		
		-- Handle half and double damage
		local isHalf = string.match(sDamage, "%[HALF%]");
		local isDouble = string.match(sDamage, "%[DOUBLE%]");
		local sAttack = string.match(sDamage, "%[DAMAGE[^]]*%] ([^[]+)");
		if sAttack then
			local sDamageState = getDamageState(rSource, rTarget, StringManager.trim(sAttack));
			if sDamageState == "half" then
				isHalf = true;
			end
			if sDamageState == "double" then
				isDouble = true;
			end
		end
		if isHalf then
			table.insert(aNotifications, "[HALF]");
			local bCarry = false;
			for kType, nType in pairs(rDamageOutput.aDamageTypes) do
				local nOddCheck = nType % 2;
				rDamageOutput.aDamageTypes[kType] = math.floor(nType / 2);
				if nOddCheck == 1 then
					if bCarry then
						rDamageOutput.aDamageTypes[kType] = rDamageOutput.aDamageTypes[kType] + 1;
						bCarry = false;
					else
						bCarry = true;
					end
				end
			end
			nTotal = math.max(math.floor(nTotal / 2), 1);
		end
		if isDouble then
			table.insert(aNotifications, "[DOUBLE]");
			local bCarry = false;
			for kType, nType in pairs(rDamageOutput.aDamageTypes) do
				local nOddCheck = nType % 2;
				rDamageOutput.aDamageTypes[kType] = math.floor(nType * 2);
				if nOddCheck == 1 then
					if bCarry then
						rDamageOutput.aDamageTypes[kType] = rDamageOutput.aDamageTypes[kType] + 1;
						bCarry = false;
					else
						bCarry = true;
					end
				end
			end
			nTotal = math.max(math.floor(nTotal * 2), 1);
		end
					
		-- Apply damage type adjustments
		local nDamageAdjust, nNonlethalDmgAmount, bVulnerable, bResist = getDamageAdjust(rSource, rTarget, nTotal, rDamageOutput);
		local nAdjustedDamage = nTotal + nDamageAdjust;
		if nAdjustedDamage < 0 then
			nAdjustedDamage = 0;
		end
		if bResist then
			if nAdjustedDamage <= 0 then
				table.insert(aNotifications, "[RESISTED]");
			else
				table.insert(aNotifications, "[PARTIALLY RESISTED]");
			end
		end
		if bVulnerable then
			table.insert(aNotifications, "[VULNERABLE]");
		end
		
		-- Reduce damage by temporary hit points
		if nTempHP > 0 and nAdjustedDamage > 0 then
			if nAdjustedDamage > nTempHP then
				nAdjustedDamage = nAdjustedDamage - nTempHP;
				nTempHP = 0;
				table.insert(aNotifications, "[PARTIALLY ABSORBED]");
			else
				nTempHP = nTempHP - nAdjustedDamage;
				nAdjustedDamage = 0;
				table.insert(aNotifications, "[ABSORBED]");
			end
		end

		-- Apply remaining damage
		if nNonlethalDmgAmount > 0 then
			nNonlethal = math.max(nNonlethal + nNonlethalDmgAmount, 0);
		end
		if nAdjustedDamage > 0 then
			nWounds = math.max(nWounds + nAdjustedDamage, 0);
		end
		
		-- Update the damage output variable to reflect adjustments
		rDamageOutput.nVal = nAdjustedDamage;
		if nAdjustedDamage > 0 then
			rDamageOutput.sVal = string.format("%01d", nAdjustedDamage);
			if nNonlethalDmgAmount > 0 then
				rDamageOutput.sVal = rDamageOutput.sVal .. string.format(" (+%01d NL)", nNonlethalDmgAmount);
			end
		elseif nNonlethalDmgAmount > 0 then
			rDamageOutput.sVal = string.format("%01d NL", nNonlethalDmgAmount);
		else
			rDamageOutput.sVal = "0";
		end
	end

	-- Set health fields
	if sTargetType == "pc" then
		DB.setValue(nodeTarget, "hp.temporary", "number", nTempHP);
		DB.setValue(nodeTarget, "hp.wounds", "number", nWounds);
		DB.setValue(nodeTarget, "hp.nonlethal", "number", nNonlethal);
	else
		DB.setValue(nodeTarget, "hptemp", "number", nTempHP);
		DB.setValue(nodeTarget, "wounds", "number", nWounds);
		DB.setValue(nodeTarget, "nonlethal", "number", nNonlethal);
	end

	-- Check for status change
	local bShowStatus = false;
	if ActorManager.getFaction(rTarget) == "friend" then
		bShowStatus = not OptionsManager.isOption("SHPC", "off");
	else
		bShowStatus = not OptionsManager.isOption("SHNPC", "off");
	end
	if bShowStatus then
		local _,_,sNewStatus = ActorManager2.getPercentWounded(sTargetType, nodeTarget);
		if sOriginalStatus ~= sNewStatus then
			table.insert(aNotifications, "[" .. Interface.getString("combat_tag_status") .. ": " .. sNewStatus .. "]");
		end
	end
	
	-- Output results
	messageDamage(rSource, rTarget, bSecret, rDamageOutput.sTypeOutput, sDamage, rDamageOutput.sVal, table.concat(aNotifications, " "));	
	
	-- Remove target after applying damage
	if bRemoveTarget and rSource and rTarget then
		TargetingManager.removeTarget(ActorManager.getCTNodeName(rSource), ActorManager.getCTNodeName(rTarget));
	end
end

function messageDamage(rSource, rTarget, bSecret, sDamageType, sDamageDesc, sTotal, sExtraResult)
	if not (rTarget or sExtraResult ~= "") then
		return;
	end
	
	local msgShort = {font = "msgfont"};
	local msgLong = {font = "msgfont"};

	if sDamageType == "Heal" or sDamageType == "Temporary hit points" then
		msgShort.icon = "roll_heal";
		msgLong.icon = "roll_heal";
	else
		msgShort.icon = "roll_damage";
		msgLong.icon = "roll_damage";
	end

	msgShort.text = sDamageType .. " ->";
	msgLong.text = sDamageType .. " [" .. sTotal .. "] ->";
	if rTarget then
		msgShort.text = msgShort.text .. " [to " .. ActorManager.getDisplayName(rTarget) .. "]";
		msgLong.text = msgLong.text .. " [to " .. ActorManager.getDisplayName(rTarget) .. "]";
	end
	
	if sExtraResult and sExtraResult ~= "" then
		msgLong.text = msgLong.text .. " " .. sExtraResult;
	end
	
	ActionsManager.messageResult(bSecret, rSource, rTarget, msgLong, msgShort);
end

--
-- TRACK DAMAGE STATE
--

local aDamageState = {};

function applyDamageState(rSource, rTarget, sAttack, sState)
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYDMGSTATE;
	
	msgOOB.sSourceNode = ActorManager.getCTNodeName(rSource);
	msgOOB.sTargetNode = ActorManager.getCTNodeName(rTarget);
	
	msgOOB.sAttack = sAttack;
	msgOOB.sState = sState;

	Comm.deliverOOBMessage(msgOOB, "");
end

function handleApplyDamageState(msgOOB)
	local rSource = ActorManager.getActor("ct", msgOOB.sSourceNode);
	local rTarget = ActorManager.getActor("ct", msgOOB.sTargetNode);
	
	if User.isHost() then
		setDamageState(rSource, rTarget, msgOOB.sAttack, msgOOB.sState);
	end
end

function setDamageState(rSource, rTarget, sAttack, sState)
	if not User.isHost() then
		applyDamageState(rSource, rTarget, sAttack, sState);
		return;
	end
	
	local sSourceCT = ActorManager.getCTNodeName(rSource);
	local sTargetCT = ActorManager.getCTNodeName(rTarget);
	if sSourceCT == "" or sTargetCT == "" then
		return;
	end
	
	if not aDamageState[sSourceCT] then
		aDamageState[sSourceCT] = {};
	end
	if not aDamageState[sSourceCT][sAttack] then
		aDamageState[sSourceCT][sAttack] = {};
	end
	if not aDamageState[sSourceCT][sAttack][sTargetCT] then
		aDamageState[sSourceCT][sAttack][sTargetCT] = {};
	end
	aDamageState[sSourceCT][sAttack][sTargetCT] = sState;
end

function getDamageState(rSource, rTarget, sAttack)
	local sSourceCT = ActorManager.getCTNodeName(rSource);
	local sTargetCT = ActorManager.getCTNodeName(rTarget);
	if sSourceCT == "" or sTargetCT == "" then
		return "";
	end
	
	if not aDamageState[sSourceCT] then
		return "";
	end
	if not aDamageState[sSourceCT][sAttack] then
		return "";
	end
	if not aDamageState[sSourceCT][sAttack][sTargetCT] then
		return "";
	end
	
	local sState = aDamageState[sSourceCT][sAttack][sTargetCT];
	aDamageState[sSourceCT][sAttack][sTargetCT] = nil;
	return sState;
end
