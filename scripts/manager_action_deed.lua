-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerResultHandler("deed", onRoll);
end

function getRoll(rActor, bSecretRoll)
	local rRoll = {};
	rRoll.sType = "deed";
	rRoll.sDesc = "[DEED]";
	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	rRoll.aDice = DB.getValue(nodeActor, "deeddie", {"d3"});
	rRoll.nMod = DB.getValue(nodeActor, "deedbonus", 0);	
	
	local sDeedDie = rRoll.aDice[1];
	rRoll.sDesc = rRoll.sDesc .. " (" .. sDeedDie;
	if rRoll.nMod > 0 then
		rRoll.sDesc = rRoll.sDesc .. "+" .. rRoll.nMod;
	end
	rRoll.sDesc = rRoll.sDesc .. ")";

	rRoll.bSecret = bSecretRoll;

	return rRoll;
end

function performRoll(draginfo, rActor, bSecretRoll)
	local rRoll = getRoll(rActor, bSecretRoll);
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function onRoll(rSource, rTarget, rRoll)
	local nTotal = ActionsManager.total(rRoll);
	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rSource);	
	DB.setValue(nodeActor, "deedresult", "number", nTotal);
	
	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);
	
	Comm.deliverChatMessage(rMessage);
end
