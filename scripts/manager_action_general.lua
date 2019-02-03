-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	ActionsManager.registerModHandler("dice", modRoll);
end

function modRoll(rSource, rTarget, rRoll)	
	if #(rRoll.aDice) == 1 then
		ActionsManager2.encodeDiceSwap(rRoll);
	end
end
