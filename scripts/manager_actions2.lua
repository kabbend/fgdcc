-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function encodeDiceSwap(rRoll)
	if ModifierStack.getModifierKey("PLUS1D") then
		rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
		rRoll.sDesc = rRoll.sDesc .. " [+1D," .. rRoll.aDice[1] .. "]";
	end
	
	if ModifierStack.getModifierKey("PLUS2D") then
		rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
		rRoll.aDice[1] = GameSystem.increaseActionDie(rRoll.aDice[1]);
		rRoll.sDesc = rRoll.sDesc .. " [+2D," .. rRoll.aDice[1] .. "]";
	end
	
	if ModifierStack.getModifierKey("MINUS1D") then
		rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
		rRoll.sDesc = rRoll.sDesc .. " [-1D," .. rRoll.aDice[1] .. "]";
	end
	
	if ModifierStack.getModifierKey("MINUS2D") then
		rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
		rRoll.aDice[1] = GameSystem.decreaseActionDie(rRoll.aDice[1]);
		rRoll.sDesc = rRoll.sDesc .. " [-2D," .. rRoll.aDice[1] .. "]";
	end
end
