-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

OOB_MSGTYPE_APPLYSAVE = "applysave";

function onInit()
	OOBManager.registerOOBMsgHandler(OOB_MSGTYPE_APPLYSAVE, handleApplySave);

	ActionsManager.registerModHandler("save", modSave);
	ActionsManager.registerResultHandler("save", onSave);
end

function handleApplySave(msgOOB)
	local rSource = ActorManager.getActor(msgOOB.sSourceType, msgOOB.sSourceNode);
	local rTarget = ActorManager.getActor(msgOOB.sTargetType, msgOOB.sTargetNode);
	
	local rAction = {};
	rAction.bSecret = (tonumber(msgOOB.nSecret) == 1);
	rAction.sDesc = msgOOB.sDesc;
	rAction.nTotal = tonumber(msgOOB.nTotal) or 0;
	rAction.sSaveDesc = msgOOB.sSaveDesc;
	rAction.nTarget = tonumber(msgOOB.nTarget) or 0;
	rAction.sResult = msgOOB.sResult;
	rAction.bRemoveOnMiss = (tonumber(msgOOB.nRemoveOnMiss) == 1);
	
	applySave(rSource, rTarget, rAction);
end

function notifyApplySave(rSource, rRoll)
	local msgOOB = {};
	msgOOB.type = OOB_MSGTYPE_APPLYSAVE;
	
	if rRoll.bTower then
		msgOOB.nSecret = 1;
	else
		msgOOB.nSecret = 0;
	end
	msgOOB.sDesc = rRoll.sDesc;
	msgOOB.nTotal = ActionsManager.total(rRoll);
	msgOOB.sSaveDesc = rRoll.sSaveDesc;
	msgOOB.nTarget = rRoll.nTarget;
	msgOOB.sResult = rRoll.sResult;
	if rRoll.bRemoveOnMiss then msgOOB.nRemoveOnMiss = 1; end

	local sSourceType, sSourceNode = ActorManager.getTypeAndNodeName(rSource);
	msgOOB.sSourceType = sSourceType;
	msgOOB.sSourceNode = sSourceNode;

	if rRoll.sSource ~= "" then
		msgOOB.sTargetType = "ct";
		msgOOB.sTargetNode = rRoll.sSource;
	else
		msgOOB.sTargetType = "";
		msgOOB.sTargetNode = "";
	end

	Comm.deliverOOBMessage(msgOOB, "");
end

function performPartySheetRoll(draginfo, rActor, sSave)
	local rRoll = getRoll(rActor, sSave);
	
	local nTargetDC = DB.getValue("partysheet.savedc", 0);
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

function performVsRoll(draginfo, rActor, sSave, nTargetDC, bSecretRoll, rSource, bRemoveOnMiss, sSaveDesc)
	local rRoll = getRoll(rActor, sSave);
	
	if bSecretRoll then
		rRoll.bSecret = true;
	end
	rRoll.nTarget = nTargetDC;
	if bRemoveOnMiss then
		rRoll.bRemoveOnMiss = "true";
	end
	if sSaveDesc then
		rRoll.sSaveDesc = sSaveDesc;
	end
	if rSource then
		rRoll.sSource = ActorManager.getCTNodeName(rSource);
	end

	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function performRoll(draginfo, rActor, sSave)
	local rRoll = getRoll(rActor, sSave);
	
	if User.isHost() and CombatManager.isCTHidden(ActorManager.getCTNode(rActor)) then
		rRoll.bSecret = true;
	end

	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function getRoll(rActor, sSave)
	local rRoll = {};
	rRoll.sType = "save";
	rRoll.aDice = { "d20" };
	rRoll.nMod = nMod;
	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	if nodeActor then
		if sActorType == "pc" then
			rRoll.nMod = DB.getValue(nodeActor, "saves." .. sSave .. ".total", 0);
		else
			rRoll.nMod = DB.getValue(nodeActor, sSave .. "save", 0);
		end
	end
	
	rRoll.sDesc = "[SAVE] " .. StringManager.capitalize(sSave);
	if sAddText and sAddText ~= "" then
		rRoll.sDesc = rRoll.sDesc .. " " .. sAddText;
	end
	
	return rRoll;
end

function modSave(rSource, rTarget, rRoll)
	local sSave = string.match(rRoll.sDesc, "%[SAVE%] (%w+)");
	if sSave then
		sSave = sSave:lower();
	end

	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;

	-- Check modifier buttons	
	local bDiceSwap = ModifierStack.getModifierKey("PLUS1D") or ModifierStack.getModifierKey("PLUS2D") or ModifierStack.getModifierKey("MINUS1D") or ModifierStack.getModifierKey("MINUS2D");
	
	if rSource then
		local bEffects = false;

		-- Build filter
		local aSaveFilter = {};
		if sSave then
			table.insert(aSaveFilter, sSave);
		end

		-- Get effect modifiers
		local rSaveSource = nil;
		if rRoll.sSource then
			rSaveSource = ActorManager.getActor("ct", rRoll.sSource);
		end
		local aAddDice, nAddMod, nEffectCount = EffectManagerDCC.getEffectsBonus(rSource, {"SAVE"}, false, aSaveFilter, rSaveSource);
		if nEffectCount > 0 then
			bEffects = true;
		end
		
		if bDiceSwap then
			ActionsManager2.encodeDiceSwap(rRoll);
		end

		-- Get ability modifiers
		local sAbility;
		if sSave == "reflex" then
			sAbility = "agility";
		elseif sSave == "fortitude" then
			sAbility = "stamina";
		elseif sSave == "willpower" then
			sAbility = "personality";
		end
		
		local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, sAbility);
		if nBonusEffects > 0 then
			bEffects = true;
			nAddMod = nAddMod + nBonusStat;
		end
	
		-- Add action die tag	
		if #(rRoll.aDice) == 1 then
			rRoll.sDesc = rRoll.sDesc .. " (" .. rRoll.aDice[1] .. ")";
		end	
	
		-- If effects apply, then add note
		if bEffects then
			for _, vDie in ipairs(aAddDice) do
				if vDie:sub(1,1) == "-" then
					table.insert(rRoll.aDice, "-p" .. vDie:sub(3));
				else
					table.insert(rRoll.aDice, "p" .. vDie:sub(2));
				end
			end
			rRoll.nMod = rRoll.nMod + nAddMod;
			
			local sEffects = "";
			local sMod = StringManager.convertDiceToString(aAddDice, nAddMod, true);
			if sMod ~= "" then
				sEffects = "[" .. Interface.getString("effects_tag") .. " " .. sMod .. "]";
			else
				sEffects = "[" .. Interface.getString("effects_tag") .. "]";
			end
			rRoll.sDesc = rRoll.sDesc .. " " .. sEffects;
		end
	end
end

function onSave(rSource, rTarget, rRoll)
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	Comm.deliverChatMessage(rMessage);

	if rRoll.nTarget then
		notifyApplySave(rSource, rRoll);
	end
end

function applySave(rSource, rOrigin, rAction, sUser)	
	local msgShort = {font = "msgfont"};
	local msgLong = {font = "msgfont"};
	
	msgShort.text = "Save";
	msgLong.text = "Save [" .. rAction.nTotal ..  "]";
	if rAction.nTarget > 0 then
		msgLong.text = msgLong.text .. "[vs. DC " .. rAction.nTarget .. "]";
	end
	msgShort.text = msgShort.text .. " ->";
	msgLong.text = msgLong.text .. " ->";
	if rSource then
		msgShort.text = msgShort.text .. " [for " .. ActorManager.getDisplayName(rSource) .. "]";
		msgLong.text = msgLong.text .. " [for " .. ActorManager.getDisplayName(rSource) .. "]";
	end
	if rOrigin then
		msgShort.text = msgShort.text .. " [vs " .. ActorManager.getDisplayName(rOrigin) .. "]";
		msgLong.text = msgLong.text .. " [vs " .. ActorManager.getDisplayName(rOrigin) .. "]";
	end
	
	msgShort.icon = "roll_cast";
	
	local sAttack = "";
	local bHalfMatch = false;
	if rAction.sSaveDesc then
		sAttack = rAction.sSaveDesc:match("%[SAVE VS[^]]*%] ([^[]+)") or "";
		bHalfMatch = (rAction.sSaveDesc:match("%[HALF ON SAVE%]") ~= nil);
	end
	rAction.sResult = "";
	
	if rAction.nTarget > 0 then
		if rAction.nTotal >= rAction.nTarget then
			msgLong.text = msgLong.text .. " [SUCCESS]";
			
			if rSource then
				local bHalfDamage = bHalfMatch;
				local bAvoidDamage = false;
				
				if bHalfDamage then
					rAction.sResult = "half";
					rAction.bRemoveOnMiss = false;
				end
				
				if rOrigin and rAction.bRemoveOnMiss then
					TargetingManager.removeTarget(ActorManager.getCTNodeName(rOrigin), ActorManager.getCTNodeName(rSource));
				end
			end
		else
			msgLong.text = msgLong.text .. " [FAILURE]";
		end
	end
	
	ActionsManager.outputResult(rAction.bSecret, rSource, rOrigin, msgLong, msgShort);
	
	if rSource and rOrigin then
		ActionDamage.setDamageState(rOrigin, rSource, StringManager.trim(sAttack), rAction.sResult);
	end
end