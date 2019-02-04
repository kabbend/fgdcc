-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	CombatManager.setCustomSort(CombatManager.sortfuncDnD);

	CombatManager.setCustomAddNPC(addNPC);
	CombatManager.setCustomNPCSpaceReach(getNPCSpaceReach);

	CombatManager.setCustomCombatReset(resetInit);
end

--
-- ADD FUNCTIONS
--

function getNPCSpaceReach(nodeNPC)
	local nSpace = GameSystem.getDistanceUnitsPerGrid();
	local nReach = nSpace;
	
	local sSize = StringManager.trim(DB.getValue(nodeNPC, "size", ""):lower());
	if sSize == "large" then
		nSpace = nSpace * 2;
	elseif sSize == "huge" then
		nSpace = nSpace * 3;
	elseif sSize == "gargantuan" then
		nSpace = nSpace * 4;
	end

	return nSpace, nReach;
end

function addNPC(sClass, nodeNPC, sName)
	local nodeEntry, nodeLastMatch = CombatManager.addNPCHelper(nodeNPC, sName);
	
	-- Determine size
	local sSize = StringManager.trim(DB.getValue(nodeEntry, "size", ""):lower());
	if sSize == "large" then
		DB.setValue(nodeEntry, "space", "number", 10);
	elseif sSize == "huge" then
		DB.setValue(nodeEntry, "space", "number", 15);
	elseif sSize == "gargantuan" then
		DB.setValue(nodeEntry, "space", "number", 20);
	end
	
	-- Set current hit points
	local sOptHRNH = OptionsManager.getOption("HRNH");
	local nHP = DB.getValue(nodeNPC, "hp", 0);
	local sHD = StringManager.trim(DB.getValue(nodeNPC, "hd", ""));
	if sOptHRNH == "max" and sHD ~= "" then
		nHP = StringManager.evalDiceString(sHD, true, true);
	elseif sOptHRNH == "random" and sHD ~= "" then
		--nHP = math.max(StringManager.evalDiceString(sHD, true), 1);
		local aDice, nMod = StringManager.convertStringToDice(sHD);
		local result = nMod;
		for _,die in ipairs(aDice) do
			local higher = tonumber( die:match("%d+") );
			local lower = math.ceil(higher/2);
			local r = math.random(lower, higher);
			result = result + r;
		end
		nHP = result;
	end
	DB.setValue(nodeEntry, "hp", "number", nHP);

	-- Defensive properties
	local sAC = DB.getValue(nodeNPC, "ac", "10");
	DB.setValue(nodeEntry, "ac_final", "number", tonumber(string.match(sAC, "^(%d+)")) or 10);

	-- Offensive properties
	local nodeAttacks = nodeEntry.createChild("attacks");
	if nodeAttacks then
		for _,v in pairs(nodeAttacks.getChildren()) do
			v.delete();
		end
		
		local nAttacks = 0;
		
		local sAttack = DB.getValue(nodeNPC, "atk", "");
		if sAttack ~= "" then
			local nodeValue = nodeAttacks.createChild();
			if nodeValue then
				DB.setValue(nodeValue, "value", "string", sAttack);
				nAttacks = nAttacks + 1;
			end
		end
		
		if nAttacks == 0 then
			nodeAttacks.createChild();
		end
	end

	-- Track additional damage types and intrinsic effects
	local aEffects = {};
	local aAddDamageTypes = {};
	
	-- DECODE SPECIAL QUALITIES
	local sSpecialQualities = string.lower(DB.getValue(nodeNPC, "specialqualities", ""));
	
	local aSQWords = StringManager.parseWords(sSpecialQualities);
	local i = 1;
	while aSQWords[i] do
		-- DAMAGE REDUCTION
		if StringManager.isWord(aSQWords[i], "dr") or (StringManager.isWord(aSQWords[i], "damage") and StringManager.isWord(aSQWords[i+1], "reduction")) then
			if aSQWords[i] ~= "dr" then
				i = i + 1;
			end
			
			if StringManager.isNumberString(aSQWords[i+1]) then
				i = i + 1;
				local sDRAmount = aSQWords[i];
				local aDRTypes = {};
				
				while aSQWords[i+1] do
					if StringManager.isWord(aSQWords[i+1], { "and", "or" }) then
						table.insert(aDRTypes, aSQWords[i+1]);
					elseif StringManager.isWord(aSQWords[i+1], DataCommon.dmgtypes) then
						table.insert(aDRTypes, aSQWords[i+1]);
					else
						break;
					end

					i = i + 1;
				end
				
				local sDREffect = "DR: " .. sDRAmount;
				if #aDRTypes > 0 then
					sDREffect = sDREffect .. " " .. table.concat(aDRTypes, " ");
				end
				table.insert(aEffects, sDREffect);
			end

		-- REGENERATION
		elseif StringManager.isWord(aSQWords[i], "regeneration") then
			if StringManager.isNumberString(aSQWords[i+1]) then
				i = i + 1;
				local sRegenAmount = aSQWords[i];
				local aRegenTypes = {};
				
				while aSQWords[i+1] do
					if StringManager.isWord(aSQWords[i+1], { "and", "or" }) then
						table.insert(aRegenTypes, aSQWords[i+1]);
					elseif StringManager.isWord(aSQWords[i+1], DataCommon.dmgtypes) then
						table.insert(aRegenTypes, aSQWords[i+1]);
					else
						break;
					end

					i = i + 1;
				end
				i = i - 1;
				
				local sRegenEffect = "REGEN: " .. sRegenAmount;
				if #aRegenTypes > 0 then
					sRegenEffect = sRegenEffect .. " " .. table.concat(aRegenTypes, " ");
				end
				table.insert(aEffects, sRegenEffect);
			end
			
		-- RESISTANCE
		elseif StringManager.isWord(aSQWords[i], "resistance") and StringManager.isWord(aSQWords[i+1], "to") then
			i = i + 1;
		
			while aSQWords[i+1] do
				if StringManager.isWord(aSQWords[i+1], "and") then
					-- SKIP
				elseif StringManager.isWord(aSQWords[i+1], DataCommon.energytypes) and StringManager.isNumberString(aSQWords[i+2]) then
					i = i + 1;
					table.insert(aEffects, "RESIST: " .. aSQWords[i+1] .. " " .. aSQWords[i]);
				else
					break;
				end

				i = i + 1;
			end

		elseif StringManager.isWord(aSQWords[i], "resist") then
			while aSQWords[i+1] do
				if StringManager.isWord(aSQWords[i+1], DataCommon.energytypes) and StringManager.isNumberString(aSQWords[i+2]) then
					i = i + 1;
					table.insert(aEffects, "RESIST: " .. aSQWords[i+1] .. " " .. aSQWords[i]);
				elseif not StringManager.isWord(aSQWords[i+1], "and") then
					break;
				end
				
				i = i + 1;
			end
			
		-- VULNERABILITY
		elseif StringManager.isWord(aSQWords[i], {"vulnerability", "vulnerable"}) and StringManager.isWord(aSQWords[i+1], "to") then
			i = i + 1;
		
			while aSQWords[i+1] do
				if StringManager.isWord(aSQWords[i+1], "and") then
					-- SKIP
				elseif StringManager.isWord(aSQWords[i+1], DataCommon.energytypes) then
					table.insert(aEffects, "VULN: " .. aSQWords[i+1]);
				else
					break;
				end

				i = i + 1;
			end
			
		-- IMMUNITY
		elseif StringManager.isWord(aSQWords[i], "immunity") and StringManager.isWord(aSQWords[i+1], "to") then
			i = i + 1;
		
			while aSQWords[i+1] do
				if StringManager.isWord(aSQWords[i+1], "and") then
					-- SKIP
				elseif StringManager.isWord(aSQWords[i+1], DataCommon.immunetypes) then
					table.insert(aEffects, "IMMUNE: " .. aSQWords[i+1]);
					if StringManager.isWord(aSQWords[i+2], "effects") then
						i = i + 1;
					end
				elseif StringManager.isWord(aSQWords[i+1], DataCommon.dmgtypes) then
					table.insert(aEffects, "IMMUNE: " .. aSQWords[i+1]);
				else
					break;
				end

				i = i + 1;
			end
		elseif StringManager.isWord(aSQWords[i], "immune") then
			while aSQWords[i+1] do
				if StringManager.isWord(aSQWords[i+1], "and") then
					--SKIP
				elseif StringManager.isWord(aSQWords[i+1], DataCommon.immunetypes) then
					table.insert(aEffects, "IMMUNE: " .. aSQWords[i+1]);
					if StringManager.isWord(aSQWords[i+2], "effects") then
						i = i + 1;
					end
				elseif StringManager.isWord(aSQWords[i+1], DataCommon.dmgtypes) then
					table.insert(aEffects, "IMMUNE: " .. aSQWords[i+1]);
				else
					break;
				end

				i = i + 1;
			end
		
		-- TRAITS
		elseif StringManager.isWord(aSQWords[i], "incorporeal") then
			table.insert(aEffects, "Incorporeal");
		end
	
		-- ITERATE SPECIAL QUALITIES DECODE
		i = i + 1;
	end

	-- FINISH ADDING EXTRA DAMAGE TYPES
	if #aAddDamageTypes > 0 then
		table.insert(aEffects, "DMGTYPE: " .. table.concat(aAddDamageTypes, ","));
	end

	-- ADD DECODED EFFECTS
	if #aEffects > 0 then
		EffectManager.addEffect("", "", nodeEntry, { sName = table.concat(aEffects, "; "), nDuration = 0, nGMOnly = 1 }, false);
	end

	-- Roll initiative and sort
	local sOptINIT = OptionsManager.getOption("INIT");
	if sOptINIT == "group" then
		if nodeLastMatch then
			local nLastInit = DB.getValue(nodeLastMatch, "initresult", 0);
			DB.setValue(nodeEntry, "initresult", "number", nLastInit);
		else
			DB.setValue(nodeEntry, "initresult", "number", math.random(20) + DB.getValue(nodeEntry, "init", 0));
		end
	elseif sOptINIT == "on" then
		DB.setValue(nodeEntry, "initresult", "number", math.random(20) + DB.getValue(nodeEntry, "init", 0));
	end

	return nodeEntry;
end

--
-- PARSE CT ATTACK LINE
--

function parseAttackLine(rActor, sLine)
	-- SETUP
	local rAttackRolls = {};
	local rDamageRolls = {};
	local rAttackCombos = {};

	-- Check the anonymous NPC attacks option
	local sOptANPC = OptionsManager.getOption("ANPC");

	-- PARSE 'OR'/'AND' PHRASES
	sLine = sLine:gsub("–", "-");
	local aPhrasesOR, aSkipOR = ActionDamage.decodeAndOrClauses(sLine);

	-- PARSE EACH ATTACK
	local nAttackIndex = 1;
	local nLineIndex = 1;
	local aCurrentCombo = {};
	local nStarts, nEnds, sAll, sAttackCount, sAttackLabel, sAttackModifier, sAttackType, nDamageStart, sDamage, nDamageEnd;
	for kOR, vOR in ipairs(aPhrasesOR) do
			
		for kAND, sAND in ipairs(vOR) do

			-- Look for the right patterns
			nStarts, nEnds, sAll, sAttackCount, sAttackLabel, sAttackModifier, sAttackType, nDamageStart, sDamage, nDamageEnd 
					= string.find(sAND, '((%+?%d*) ?([%w%s,%[%]%(%)%+%-]*) ([d%dF%+%-][%+%-%d/]+)([^%(]*)%(()([^%)]*)()%))');
			if not nStarts then
				nStarts, nEnds, sAll, sAttackLabel, nDamageStart, sDamage, nDamageEnd 
						= sAND:find('(([%w%s,%[%]%(%)%+%-]*)%(()([^%)]*)()%))');
				if nStarts then
					sAttackCount = "";
					sAttackModifier = "+0";
					sAttackType = "";
				end
			end
			
			-- Make sure we got a match
			if nStarts then
				local rAttack = {};
				rAttack.startpos = nLineIndex + nStarts - 1;
				rAttack.endpos = nLineIndex + nEnds;
				
				local rDamage = {};
				rDamage.startpos = nLineIndex + nDamageStart - 1;
				rDamage.endpos = nLineIndex + nDamageEnd - 1;
				
				-- Clean up the attack count field (i.e. magical weapon bonuses up front, no attack count)
				local bMagicAttack = false;
				local nAttackCount = 1;
				if string.sub(sAttackCount, 1, 1) == "+" then
					bMagicAttack = true;
					if sOptANPC ~= "on" then
						sAttackLabel = sAttackCount .. " " .. sAttackLabel;
					end
					local nAttackPlus = tonumber(sAttackCount) or 1;
				elseif #sAttackCount then
					nAttackCount = tonumber(sAttackCount) or 1;
					if nAttackCount < 1 then
						nAttackCount = 1;
					end
				end
			

				-- Capitalize first letter of label
				sAttackLabel = StringManager.capitalize(sAttackLabel);
				
				-- If the anonymize option is on, then remove any label text within parentheses or brackets
				if sOptANPC == "on" then
					-- Strip out label information enclosed in ()
					sAttackLabel = string.gsub(sAttackLabel, "%s?%b()", "");

					-- Strip out label information enclosed in []
					sAttackLabel = string.gsub(sAttackLabel, "%s?%b[]", "");
				end
							
				rAttack.label = sAttackLabel;
				rAttack.count = nAttackCount;
				
				local sDieType = sAttackModifier:match("^d([%dF]+)");				
				if sDieType then
					local aDice, nMod = StringManager.convertStringToDice(sAttackModifier);
					rAttack.dice = aDice;
					rAttack.modifier = nMod;
				else
					rAttack.modifier = sAttackModifier;
				end
				
				rDamage.label = sAttackLabel;
				
				local bRanged = false;
				local aTypeWords = StringManager.parseWords(string.lower(sAttackType));
				for kWord, vWord in pairs(aTypeWords) do
					if vWord == "ranged" then
						bRanged = true;
					end
				end
			
				-- Determine attack type
				if bRanged then
					rAttack.range = "R";
					rDamage.range = "R";
					rAttack.stat = "agility";
				else
					rAttack.range = "M";
					rDamage.range = "M";
					rAttack.stat = "strength";
				end
				
				-- Determine critical information
				rAttack.crit = 20;
				nCritStart, nCritEnd, sCritThreshold = string.find(sDamage, "/(%d+)%-20");
				
				if sCritThreshold then
					rAttack.crit = tonumber(sCritThreshold) or 20;
					if rAttack.crit < 2 or rAttack.crit > 20 then
						rAttack.crit = 20;
					end
				end
				
				-- Determine damage clauses
				rDamage.clauses = {};

				local aClausesDamage = {};
				local nIndexDamage = 1;
				local nStartDamage, nEndDamage;
				while nIndexDamage < #sDamage do
					nStartDamage, nEndDamage = string.find(sDamage, ' plus ', nIndexDamage);
					if nStartDamage then
						table.insert(aClausesDamage, string.sub(sDamage, nIndexDamage, nStartDamage - 1));
						nIndexDamage = nEndDamage;
					else
						table.insert(aClausesDamage, string.sub(sDamage, nIndexDamage));
						nIndexDamage = #sDamage;
					end
				end

				for kClause, sClause in pairs(aClausesDamage) do
					local aDamageAttrib = StringManager.split(sClause, "/", true);
					
					local aWordType = {};
					local sDamageRoll, sDamageTypes = string.match(aDamageAttrib[1], "^([d%d%+%-%s]+)([%w%s,]*)");
					if sDamageRoll then
						if sDamageTypes then
							if string.match(sDamageTypes, " and ") then
								sDamageTypes = string.gsub(sDamageTypes, " and .*$", "");
							end
							table.insert(aWordType, sDamageTypes);
						end
						
						local sCrit;
						for nAttrib = 2, #aDamageAttrib do
							sCrit, sDamageTypes = string.match(aDamageAttrib[nAttrib], "^x(%d)([%w%s,]*)");
							if not sCrit then
								sDamageTypes = string.match(aDamageAttrib[nAttrib], "^%d+%-20%s?([%w%s,]*)");
							end
							
							if sDamageTypes then
								table.insert(aWordType, sDamageTypes);
							end
						end
				
						local aWordDice, nWordMod = StringManager.convertStringToDice(sDamageRoll);
						if #aWordDice > 0 or nWordMod ~= 0 then
							local rDamageClause = { dice = {} };
							for kDie, vDie in ipairs(aWordDice) do
								table.insert(rDamageClause.dice, vDie);
							end
							rDamageClause.modifier = nWordMod;
							
							if not bRanged then
								rDamageClause.stat = "strength";
							end

							local aDamageType = ActionDamage.getDamageTypesFromString(table.concat(aWordType, ","));
							if bMagicAttack then
								table.insert(aDamageType, "magic");
							end
							rDamageClause.dmgtype = table.concat(aDamageType, ",");
							
							table.insert(rDamage.clauses, rDamageClause);
						end
					end
				end

				if #(rDamage.clauses) > 0 then
					if bRanged then
						local nDmgBonus = rDamage.clauses[1].modifier;
						if nDmgBonus > 0 then
							local nStatBonus = ActorManager2.getAbilityBonus(rActor, "strength");
							if (nDmgBonus >= nStatBonus) then
								rDamage.statmult = 1;
							end
						end
					else
						local nDmgBonus = rDamage.clauses[1].modifier;
						local nStatBonus = ActorManager2.getAbilityBonus(rActor, "strength");
						
						if (nStatBonus > 0) and (nDmgBonus > 0) then
							if nDmgBonus >= math.floor(nStatBonus * 1.5) then
								rDamage.statmult = 1.5;
							elseif nDmgBonus >= nStatBonus then
								rDamage.statmult = 1;
							else
								rDamage.statmult = 0.5;
							end
						elseif (nStatBonus == 1) and (nDmgBonus == 0) then
							rDamage.statmult = 0.5;
						end
					end
				end

				-- Add to roll list
				table.insert(rAttackRolls, rAttack);
				table.insert(rDamageRolls, rDamage);

				-- Add to combo
				table.insert(aCurrentCombo, nAttackIndex);
				nAttackIndex = nAttackIndex + 1;
			end

			nLineIndex = nLineIndex + #sAND;
			nLineIndex = nLineIndex + aSkipOR[kOR][kAND];
		end
	
		-- Finish combination
		if #aCurrentCombo > 0 then
			table.insert(rAttackCombos, aCurrentCombo);
			aCurrentCombo = {};
		end
	end
	
	return rAttackRolls, rDamageRolls, rAttackCombos;
end

--
-- RESET FUNCTIONS
--

function resetInit()
	function resetCombatantInit(nodeCT)
		DB.setValue(nodeCT, "initresult", "number", 0);
	end
	CombatManager.callForEachCombatant(resetCombatantInit);
end

function resetHealth(nodeCT, bLong)
	if bLong then
		-- Clear temporary hit points and subdual damage
		DB.setValue(nodeCT, "hptemp", "number", 0);
		DB.setValue(nodeCT, "nonlethal", "number", 0);
		
		-- Heal 1 hit point
		local nWounds = DB.getValue(nodeCT, "wounds", 0);
		nWounds = nWounds - 1;
		if nWounds < 0 then
			nWounds = 0;
		end
		DB.setValue(nodeCT, "wounds", "number", nWounds);	
	end
end

function clearExpiringEffects()
	function checkEffectExpire(nodeEffect)
		local sLabel = DB.getValue(nodeEffect, "label", "");
		local nDuration = DB.getValue(nodeEffect, "duration", 0);
		local sApply = DB.getValue(nodeEffect, "apply", "");
		
		if nDuration ~= 0 or sApply ~= "" or sLabel == "" then
			nodeEffect.delete();
		end
	end
	CombatManager.callForEachCombatantEffect(checkEffectExpire);
end

function rest(bLong)
	CombatManager.resetInit();
	clearExpiringEffects();

	for _,v in pairs(CombatManager.getCombatantNodes()) do
		local bHandled = false;
		local sClass, sRecord = DB.getValue(v, "link", "", "");
		if sClass == "charsheet" and sRecord ~= "" then
			local nodePC = DB.findNode(sRecord);
			if nodePC then
				CharManager.rest(nodePC, bLong);
				bHandled = true;
			end
		end
		
		if not bHandled then
			resetHealth(v, bLong);
		end
	end
end

function rollRandomInit(nMod)
	local nInitResult = math.random(20);

	nInitResult = nInitResult + nMod;
	return nInitResult;
end

function rollEntryInit(nodeEntry)
	if not nodeEntry then
		return;
	end
	
	-- Start with the base initiative bonus
	local nInit = DB.getValue(nodeEntry, "init", 0);
	
	-- Get any effect modifiers
	local rActor = ActorManager.getActorFromCT(nodeEntry);
	local aEffectDice, nEffectBonus = EffectManagerDCC.getEffectsBonus(rActor, "INIT");
	nInit = nInit + StringManager.evalDice(aEffectDice, nEffectBonus);
	
	-- For PCs, we always roll unique initiative
	local sClass, sRecord = DB.getValue(vChild, "link", "", "");
	if sClass == "charsheet" then
		local nInitResult = rollRandomInit(nInit);
		DB.setValue(nodeEntry, "initresult", "number", nInitResult);
		return;
	end
	
	-- For NPCs, if NPC init option is not group, then roll unique initiative
	local sOptINIT = OptionsManager.getOption("INIT");
	if sOptINIT ~= "group" then
		local nInitResult = rollRandomInit(nInit);
		DB.setValue(nodeEntry, "initresult", "number", nInitResult);
		return;
	end

	-- For NPCs with group option enabled
	
	-- Get the entry's database node name and creature name
	local sStripName = CombatManager.stripCreatureNumber(DB.getValue(nodeEntry, "name", ""));
	if sStripName == "" then
		local nInitResult = rollRandomInit(nInit);
		DB.setValue(nodeEntry, "initresult", "number", nInitResult);
		return;
	end
		
	-- Iterate through list looking for other creature's with same name and faction
	local nLastInit = nil;
	local sEntryFaction = DB.getValue(nodeEntry, "friendfoe", "");
	for _,v in pairs(CombatManager.getCombatantNodes()) do
		if v.getName() ~= nodeEntry.getName() then
			if DB.getValue(v, "friendfoe", "") == sEntryFaction then
				local sTemp = CombatManager.stripCreatureNumber(DB.getValue(v, "name", ""));
				if sTemp == sStripName then
					local nChildInit = DB.getValue(v, "initresult", 0);
					if nChildInit ~= -10000 then
						nLastInit = nChildInit;
					end
				end
			end
		end
	end
	
	-- If we found similar creatures, then match the initiative of the last one found
	if nLastInit then
		DB.setValue(nodeEntry, "initresult", "number", nLastInit);
	else
		local nInitResult = rollRandomInit(nInit);
		DB.setValue(nodeEntry, "initresult", "number", nInitResult);
	end
end

function rollInit(sType)
	CombatManager.rollTypeInit(sType, rollEntryInit);
end

--
--	COMBAT ACTION FUNCTIONS
--

function addRightClickDiceToClauses(rRoll)
	if #rRoll.clauses > 0 then
		local nOrigDamageDice = 0;
		for _,vClause in ipairs(rRoll.clauses) do
			nOrigDamageDice = nOrigDamageDice + #vClause.dice;
		end
		if #rRoll.aDice > nOrigDamageDice then
			local v = rRoll.clauses[#rRoll.clauses].dice;
			for i = nOrigDamageDice + 1,#rRoll.aDice do
				table.insert(rRoll.clauses[1].dice, rRoll.aDice[i]);
			end
		end
	end
end
