

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

local coT = {
	["m"] = {
		"Character develops horrid pustules on his face. These pustules do not heal and impose a -1 penalty to Personality.",
		"Character skin on one random portion of his body appears to melt. Like wax, it flows and reforms into odd puddles and shapes. This is an ongoing, constant motion that itches constantly and repulses others. Determine location randomly (1d6): (1) face; (2) arms; (3) legs; (4) torso; (5) hands; (6) feet.",
		"One of the character legs grows 1d6 foot. Character now walks with an odd gait.",
		"Eyes affected. Roll 1d4: (1) eyes glow with unearthly color; (2) eyes gain light sensitivity (-1 to all rolls in daylight); (3) character gains infravision (sees heat signatures at range of 100 ); (4) eyes become large and unblinking, like a fish.",
		"Character develops painful lesions on his chest and legs and open sores on his hands and feet that do not heal.",
		"Ears mutate. Roll 1d5: (1) ears become pointed; (2) ears fall off (character still hears normally); (3) ears enlarge and look like an elephant; (4) ears elongate and look like a donkey (character also gains braying laugh); (5) ears shrivel and fold back.",
		"Chills. Character shakes constantly and cannot remain quiet due to chattering teeth.",
		"Character facial appearance is permanently disfigured according to the magic that was summoned. If fire magic was used, his eyebrows are scorched and his skin glows red; if cold magic was used, his skin is pasty white and his lips are blue. If ambiguous magic was used, his appearance grows gaunt and he permanently loses 5 pounds.",
		"Character hair is suffused with dark energy. Roll 1d4: (1) hair turns bone white; (2) hair turns pitch black; (3) hair falls out completely; (4) hair sticks straight up.",
		"Character passes out. He is unconscious for 1d6 hours or until awakened by vigorous means."
		},
	["M"] = {
		"Febrile. Character slowly weakens over 1d4 months, suffering a -1 penalty to Strength for each month.",
		"A duplicate of the character face grows on his back. It looks just like his normal face. The eyes, nose, and mouth can be operated independently",
		"Consumption. Character body feeds on its own mass. Character loses 2d10 pounds in one month and suffers a -1 penalty to Stamina.",
		"Corpulence. Character gains 6d12 pounds in one month. The weight gain imposes a -1 penalty to Agility, and the character speed is reduced by 5 .",
		"Character crackles with energy of a type associated with the spells he most commonly casts. The energy could manifest as flames, lightning, cold waves, etc",
		"Character height changes by 1d20-10 inches. There is no change in weight; the character body grows thin and tall or short and fat.",
		"Demonic taint. Roll 1d3: (1) character fingers elongate into claws, and he gains an attack for 1d6 damage; (2) character feet transform into cloven hoofs; (3) character legs become goat-like.",
		"Character skin changes to an unearthly shade. Roll 1d8: (1) albino; (2) pitch black; (3) clear; (4) shimmering quality; (5) deep blue; (6) malevolent yellow; (7) ashen and pallid; (8) texture and color of fishy scales; (9) thick bear-like fur; (10) reptilian scales.",
		"Small horns grow on the character forehead. This appears as a ridge-like, simian forehead for the first month; then buds for the second month; goat horns after the third month; and finally, bull horns after six months.",
		"Character tongue forks and his nostrils narrow to slits. The character is able to smell with his tongue like a snake."
		},
	["G"] = {
		"A sliver of soul energy is claimed by a demon lord. Character experiences unearthly pain, suffering 3d6 damage, a permanent -2 penalty to all ability scores, and an additional -2 penalty to Luck.",
		"Decay. Character flesh falls off in zombie-like chunks. Character loses 1d4 hp per day. Only magical healing can stave off the decay.",
		"Character head becomes bestial in a painful overnight transformation. Roll 1d6: (1) snake; (2) goat; (3) bull; (4) rat; (5) insect; (6) fish.",
		"Character limbs are replaced by suckered tentacles. One limb is replaced at random each month for four months. At the end of four months, it is impossible to hide the character inhuman nature.",
		"Small tentacles grow around the character mouth and ears. The tentacles are maggot-sized at first, but grow at rate of 1” per month to a mature length of 12”.",
		"Third eye. Roll 1d4 for location: (1) middle of forehead; (2) palm of hand; (3) chest; (4) back of head.",
		"Fingers on one hand fuse while the thumb enlarges. After one week, the hand has transformed into a crab claw. Character gains a natural attack for 1d6 damage and can no longer grasp normal weapons and objects.",
		"Character grows a tail over 1d7 days. Roll 1d6: (1) scorpion tail that can attack for 1d4 damage plus poison (DC 10 Fort save or target loses 1d4 Str permanently); (2) scaly snake tail; (3) forked demon tail (grants +1 Agility); (4) fleshy tail ending in a useable third hand; (5) fused cartilaginous links ending in spiked stump that can attack for 1d6 damage; (6) bushy horse s tail.",
		"Bodily transformation. Roll 1d6: (1) character grows scales across his entire body; (2) character grows gills; (3) character prouts feathers; (4) character develops webbed toes and feet.",
		"Character grows a beak in place of his mouth. Transformation starts as a puckering of the lips that slowly turns into a fullfledged bird or squid beak over the next 1d12 months. Character gains a bite attack for 1d3 damage."
		}
	};

function onInit()
	Comm.registerSlashHandler("sd", slashCommandHandlerSpellDuel);
	Comm.registerSlashHandler("co", slashCommandHandlerCorruption);
end

function mysplit(inputstr, sep)
                        if sep == nil then sep = "%s" end
                                local t={}
                                for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                                table.insert(t, str)
                                end
                                return t
                        end

function slashCommandHandlerCorruption(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );

	local aUsageMessage = { text = "/co [mMG] spellLevel (roll d10+luck) / m=minor,M=Major,G or g=Greater" , secret = true };

	-- we expect arg1 = a letter, arg 2 = spell level, and eventually a roll number 
	if (not args) or (#args ~= 2 and #args ~= 3) then 
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end

	-- get table
	local sCoTable = args[1];
	if sCoTable ~= "m" and sCoTable ~= "M" and sCoTable ~= "G" and sCoTable ~= "g" then
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end
	if sCoTable == "g" then sCoTable = "G"; end

	-- get spell level
	local nSpellLevel = tonumber( args[2] );
	if not nSpellLevel then
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end

	-- get roll eventually
	local nRoll = 0;
	if #args == 3 then
		nRoll = tonumber(args[3]);
		if not nRoll then
			Comm.addChatMessage(aUsageMessage) ; 
			return;
		end
	end

	local nInitialRoll;

	-- roll die if not given
	if nRoll == 0 then
		nInitialRoll = math.random(10);
		nRoll = nInitialRoll - nSpellLevel;
	else
		nInitialRoll = nRoll;
		nRoll = nRoll - nSpellLevel;
	end

	-- adjust value if needed
	if nRoll < 1 then 
		nRoll = 1;
	elseif nRoll > 10 then
		nRoll = 10;
	end

	local sText = coT[sCoTable][nRoll]; 
	local aMessage = { text = " => [corruption " .. sCoTable .. " on spell level " .. nSpellLevel .. ", roll " .. nInitialRoll .. ", result=" .. nRoll .. "] " .. sText , secret = true };
	Comm.addChatMessage(aMessage) ; 
	return;

end

function slashCommandHandlerSpellDuel(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );

	local aUsageMessage = { text = "/sd attackerCheck defenderCheck (>= 12)" , secret = true };

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
	local aMessage = { text = " => [" .. countercolumn .. ", die d" .. die .. ", roll " .. nRoll .. "] " .. sText , secret = true };
	Comm.addChatMessage(aMessage) ; 

end


