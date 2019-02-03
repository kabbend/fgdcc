-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()

	ActionsManager.registerModHandler("fumble", modRoll);
	ActionsManager.registerResultHandler("fumble", onRoll);
end

function getRoll(rActor)
	local rRoll = {};
	rRoll.sType = "fumble";
	rRoll.sDesc = "[FUMBLE]";
	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	local bIsSourcePC = (nodeActor and sActorType == "pc");
	
	rRoll.aDice = DB.getValue(nodeActor, "fumbledie", {"d4"});
	rRoll.nMod = 0 - DB.getValue(nodeActor, "abilities.luck.bonus", 0);
	if bIsSourcePC then
		rRoll.nMod = rRoll.nMod + DB.getValue(nodeActor, "fumblebonus", 0);
	else		
		local nLuckScore = DB.getValue(nodeActor, "abilities.luck.score", 0);
		if nLuckScore == 0 then
			rRoll.nMod = 0;
		end		
	end
		
	-- Fumble die message
	local sFumbleDie = rRoll.aDice[1];
	rRoll.sDesc = rRoll.sDesc .. " (" .. sFumbleDie;
	if rRoll.nMod > 0 then
		rRoll.sDesc = rRoll.sDesc .. "+" .. rRoll.nMod;
	elseif rRoll.nMod < 0 then
		rRoll.sDesc = rRoll.sDesc .. rRoll.nMod;
	end	
	rRoll.sDesc = rRoll.sDesc .. ")";
	
	return rRoll;
end

function performRoll(draginfo, rActor)
	local rRoll = getRoll(rActor);
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function modRoll(rSource, rTarget, rRoll)
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	if rSource then
		local bEffects = false;

		-- Get ability modifiers
		local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, "luck");
		if nBonusEffects > 0 then
			bEffects = true;
			nAddMod = nAddMod - nBonusStat;
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

function onRoll(rSource, rTarget, rRoll)
	local nTotal = ActionsManager.total(rRoll);

	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	Comm.deliverChatMessage(rMessage);
end
