-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function action(draginfo)
	local aParty = {};
	for _,v in pairs(window.list.getWindows()) do
		local rActor = ActorManager.getActor("pc", v.link.getTargetDatabaseNode());
		if rActor then
			table.insert(aParty, rActor);
		end
	end
	if #aParty == 0 then
		aParty = nil;
	end
	
	local rAction = {};
	rAction.label = Interface.getString("ps_message_groupatk");
	rAction.modifier = window.bonus.getValue();
	
	ModifierStack.lock();
	for _,v in pairs(aParty) do
		ActionAttack.performPartySheetVsRoll(nil, v, rAction);
	end
	ModifierStack.unlock(true);
	
	return true;
end

function onButtonPress()
	return action();
end			

