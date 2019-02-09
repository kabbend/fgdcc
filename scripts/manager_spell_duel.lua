

local counterspell = {
	["defenderhigh"] = {
			"Mitigate d4: roll d4 and subtract this from the attacker spell check. Attacker spell still carries through at this lower spell check; defender spell is cancelled.",
			"Mitigate d6: roll d6 and subtract this from the attacker spell check. Attacker spell still carries through at this lower spell check; defender spell is cancelled.",
			"Mitigate d8: roll d8 and subtract this from the attacker spell check. Attacker spell still carries through at this lower spell check; defender spell is cancelled.",
			"Mutual mitigation d10: roll d10 and subtract this from the attacker spell check and the defender spell check. Both spells take effect simultaneously at this lower spell check result.",
			"Mutual cancellation: both attacker and defender spells are cancelled.",
			"Push-through d6: roll d6 and subtract from defender spell check. Defender spell takes effect at this result, and attacker spell is cancelled.",
			"Push-through d4: roll d4 and subtract from defender spell check. Defender spell takes effect at this result, and attacker spell is cancelled.",
			"Overwhelm: attacker spell is cancelled, and defender spell takes effect at normal result.",
			"Reflect: defender spell is cancelled, and attacker spell reflects back on him at the spell check result rolled.",
			"Reflect and overwhelm: defender spell takes effect at normal result, and attacker spell reflects back on him at the spell check result rolled."
		},
	["attackerhigh"] = {
			"Push-through d4: roll d4 and subtract this from defender spell check. Defender spell takes effect at this lower result, and attacker spell takes effect simultaneously at normal spell check result.",
			"Push-through d8: roll d8 and subtract this from defender spell check. Defender spell takes effect at this lower result, and attacker spell takes effect first at normal spell check result.",
			"Overwhelm: attacker spell takes effect and defender spell is cancelled.",
			"Overwhelm: attacker spell takes effect and defender spell is cancelled.",
			"Overwhelm: attacker spell takes effect and defender spell is cancelled.",
			"Overwhelm and reflect d8: roll d8 and subtract this from defender spell check. Attacker spell takes effect simultaneously at normal spell check result, and defender spell check is reflected back on him at this lower spell check result.",
			"Overwhelm and reflect d8: roll d8 and subtract this from defender spell check. Attacker spell takes effect first at normal spell check result, and defender spell check is reflected back on him at this lower spell check result.",
			"Overwhelm and reflect d6: roll d6 and subtract this from defender spell check. Attacker spell takes effect first at normal spell check result, and defender spell check is reflected back on him at this lower spell check result.",
			"Overwhelm and reflect d4: roll d4 and subtract this from defender spell check. Attacker spell takes effect first at normal spell check result, and defender spell check is reflected back on him at this lower spell check result.",
			"Reflect and overwhelm: attacker spell takes effect at normal spell check result, and defender spell check is reflected back on him at normal spell check."
		}
};

local phlo = {
	"Pocket dimension. Both casters are instantaneously transferred to a pocket dimension that is spontaneously created by the interaction between their spells. They remain within the pocket dimension until one is killed, at which point the interaction of their spells ceases and the survivor is transferred back to the material plane one millisecond after his departure. Observers see only a brief flicker and the disappearance of the loser, whose body is lost forever. The pocket dimension appears as (roll 1d6) (1) a mountaintop surrounded by red clouds, (2) a bubble adrift in space, (3) a sweltering island in a sea of lava, (4) an upside- down forest where the trees grow down from the sky above, (5) a dust mote atop the point of a needle, (6) the left nostril of an intergalactic whale.",
	"Alignment rift. Both casters are transferred to an alignment plane. If both are the same alignment, they go to that plane; if they are opposed, or if either is neutral, they transfer to the plane of neutrality. They return to the material plane after (roll 1d4) (1) one caster is killed (both bodies return), (2) 1d8 days, (3) 3d6 rounds for each caster, rolled separately, (4) The End of Days.",
	"Time accelerates. Both casters see everything around them slow down; in reality, they are accelerating, and surrounding characters see them move at incredible speeds. Resolve an additional 2d4 rounds of combat between the casters only; no other characters may act in this time. At the end of this time, they slow back into the mainstream flow of time.",
	"Time slows. The casters perceive the world around them as normal but observers see their reactions slow to a crawl. Roll 1d3 and resolve that many rounds of combat among other participants before the casters can react again.",
	"Backward loop in time. The casters are tossed backward in time to relive the last few moments repeatedly. Roll 1d4 and repeat the last spell interaction that many times, re-rolling spell checks and incrementing momentum trackers but ignoring any subsequent Phlogiston Disturbance results (treat same-check results as 'both spells cancelled'). For example, if the attacker cast magic missile and the defender cast magic shield, the two would repeat 1d4 repetitions of that same spell check result. No spell can be lost during this time – a below-minimum result indicates only a failure, and the spell cast repeats on the next loop. When this time loop is concluded, the two casters re-enter the normal initiative count.",
	"Spells merge. In a freak of eldritch energy, the two spells merge to create something greater than both. This result requires judge mediation. Generally speaking, the resulting effect is centered directly between the two casters and is either: (a) twice as powerful as the normal spell (if two opposing spells had cancelled each other), or (b) some weird agglomeration of spell effects (if two different spells were used). For example, if two fireballs were cast, there may be a super-fireball that impacts between the two casters. Or, if fire resistance countered fireball, a flameless fireball could be set off, generating concussive noise and astounding force but no flames.",
	"Supernatural influence. The casters create a rift in space and some supernatural influence filters through. Both spells fail and roll 1d4: (1) a randomly determined elemental energy suffuses the surrounding around, causing minor effects (for example, flames and heat fill the air to cause 1 damage to everyone within 50' or a massive rainstorm erupts centered on the casters); (2) negative energy drains through, granting +1d8 hit points to all un-dead and demons nearby; (3) shadow energy fills the air, limiting eyesight to half normal range; (4) ethereal mists swirl about, and 1d4 randomly determined ghosts enter the world.",
	"Supernatural summoning. The combined spell results inadvertently pull a supernatural creature through the fabric of space and time. Randomly determine the nature of the supernatural creature: (roll 1d3) (1) elemental, (2) demon, (3) celestial. The creature has 1d4+1 HD. Determine the creature's reaction by rolling 1d5: (1) hostile to all, (2) hostile to one caster (randomly determined) and neutral to other, (3) friendly to one caster (randomly determined) and hostile to other, (4) neutral to all parties, (5) friendly to all parties.",
	"Demonic invasion. 1d4 randomly determined demons are summoned at the exact midpoint between the two casters. Determine their reaction randomly as with result 8 above. The demons are of a type as determined here: (roll 1d4) (1) type I, (2) type II, (3) type III, (4) type IV.",
	"Mutual corruption. Both spells fail, and both casters suffer 1d4+1 corruption results. Roll corruption as normal for the spells involved."
	};

function onInit()
	Comm.registerSlashHandler("sd", slashCommandHandlerSpellDuel);
end

function mysplit(inputstr, sep)
                        if sep == nil then sep = "%s" end
                                local t={}
                                for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                                table.insert(t, str)
                                end
                                return t
                        end

function slashCommandHandlerSpellDuel(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );

	local aUsageMessage = { text = "/sd attackerCheck defenderCheck (both >= 12)" , secret = true };

	-- we expect arg1 = attacker roll, arg 2 = defender roll, and both values are numeric and >= 12
	if (not args) or #args ~= 2 or args[1] == "" or args[2] == "" then 
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end
	local nAtt, nDef = tonumber(args[1]), tonumber(args[2]);
	if not nAtt or not nDef or (nAtt < 12 or nDef < 12) then 
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end

	-- compare rolls. Max value = 28
	if nAtt > 28 then nAtt = 28 end
	if nDef > 28 then nDef = 28 end

	-- if same, roll on phlogiston table
	if nAtt == nDef then
		-- roll on phlo table, max. 10
		local nRoll = math.random(10);
		local sText = phlo[nRoll]; 
		local aMessage = { text = " => [Phlogiston Disturbance!, roll " .. nRoll .. "] " .. sText , secret = true };
		Comm.addChatMessage(aMessage) ; 
		return;
	end

	local countercolumn = "";
	local higher, lower = 0 , 0

	if nAtt > nDef then
		countercolumn = "attackerhigh"; 
		higher, lower = nAtt, nDef;
	else
		countercolumn = "defenderhigh";		
		higher, lower = nDef, nAtt;
	end

	local nDiff = higher - lower;
	local die;

	if nDiff == 1 then
		die = 3;
	elseif nDiff == 2 then
		die = 4;
	elseif nDiff == 3 or nDiff == 4 then
		die = 5;
	elseif nDiff == 5 or nDiff == 6 then
		die = 6;
	elseif nDiff == 7 or nDiff == 8 then
		die = 7;
	elseif nDiff == 9 or nDiff == 10 then
		die = 8;
	elseif nDiff == 11 or nDiff == 12 then
		die = 10;
	elseif nDiff == 13 or nDiff == 14 then
		die = 12;
	elseif nDiff == 15 then
		die = 14;
	else 
		die = 16;
	end
	
	-- roll on table, max. 10
	local nRoll = math.random(die);
	if nRoll > 10 then nRoll = 10; end
	
	local sText = counterspell[countercolumn][nRoll]; 
	local aMessage = { text = " => [" .. countercolumn .. ", die d" .. die .. ", roll " .. nRoll .. " ] " .. sText , secret = true };
	Comm.addChatMessage(aMessage) ; 

end


