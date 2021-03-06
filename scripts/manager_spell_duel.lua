
--
-- Counterspell table
--

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

--
-- Phlogiston disturbance table
--

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

--
-- Corruption tables
--

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

--
-- Disapproval table
--

local disT = {
	"The cleric must atone for his sins. He must do nothing but utter chants and intonations for the next 10 minutes, starting as soon as he is able (i.e., if he is in combat, he can wait until the danger is over).",
	"The cleric must pray for forgiveness immediately. He must spend at least one hour in prayer, beginning as soon as he is able (i.e., if he is in combat, he can wait until the danger is over). Failure to finish the full hour of prayers within the next 120 minutes is looked upon unfavorably; he incurs a -1 penalty to all spell checks until he completes the full hour.",
	"The cleric must increase his god power by recruiting a new follower. If he does not convert one new follower to his deity worship by the next sunrise, he takes a -1 penalty to all checks on the following day. This penalty resets after 24 hours",
	"The cleric immediately incurs an additional -1 penalty to all spell checks that lasts until the next day.",
	"The cleric must undergo the test of humility. For the remainder of the day, he must defer to all other characters and creatures as if they were his superiors. Failure (at the discretion of the judge) means he immediately loses all spellcasting ability (including healing and laying on hands) for the remainder of the day.",
	"The cleric incurs an immediate -1 penalty to all attempts to lay on hands until he goes on a quest to heal the crippled. This quest is of his own design, but generally speaking must result in significant aid to the crippled, blind, lamed, sickly, etc. Once the quest is completed, the deity revokes the penalty. While the penalty remains, it applies to all attempts to lay on hands, even if the 'normal' disapproval range has been reduced back to a natural 1.",
	"The cleric must endure a test of faith. He gains an illness that costs him 1 point each of Strength, Agility, and Stamina. The ability score loss heals at the normal rate of 1 point per day. The cleric may not use magic to heal the loss. If the cleric endures the test to the satisfaction of the deity, he retains his magical abilities. If not (judge discretion), his disapproval range immediately increases by another point.",
	"The cleric immediately incurs a -4 penalty to spell checks on the specific spell that resulted in disapproval (including laying on hands and turning unholy, if those were the acts that produced disapproval). This lasts until the next day.",
	"The cleric immediately incurs an additional -2 penalty to all spell checks that lasts until the next day.",
	"The cleric loses access to one randomly determined level 1 spell. This spell cannot be cast until the next day.",
	"The cleric is ordered by his deity to meditate on his faith and come to a better understanding of what he has done to earn disapproval. The cleric incurs an immediate and permanent -2 penalty to all spell checks. The only way to lift this penalty is for the cleric to meditate. For every full day of meditation, the cleric can make a DC 15 Will save. Success means the spell check penalties are removed.",
	"The cleric is temporarily disowned by his deity. For the rest of the day, the character cannot accumulate XP and may not gain class levels as a cleric. After the time period expires, the character begins to accumulate XP again as normal but does not accrue 'back pay' (so to speak) for XP missed while he was disowned.",
	"The cleric loses access to two randomly determined level 1 spells. These spells cannot be cast until the next day.",
	"The cleric deity wishes to test whether the cleric is a man of the faith or a man of the flesh. Calculate the cleric total net worth in gold pieces. The cleric immediately incurs a permanent -4 penalty to all spell checks. The only way to remove this penalty is for the cleric to sacrifice his material possessions. For every 10 percent of his net worth sacrificed to the deity, one point of penalty is removed. Or, in other words, sacrificing 40 percent of what he owns will return the cleric to a normal spell check penalty. A sacrifice can be destruction, consecration, donation, transformation into a temple or statue, etc.",
	"The deity is not forgiving on this day. When the cleric rests for the night, he does not 'reset' his disapproval range at the next morning – it carries over from this day to the next. The disapproval ranged resets as normal on the following day.",
	"Cleric is temporarily barred from using his lay on hands ability. The deity will not grant healing powers for the next 1d4 days. After that time, the cleric regains the use of his healing abilities.",
	"The cleric loses access to 1d4+1 spells, randomly determined from all the character knows. These spells cannot be cast for the next 24 hours.",
	"Cleric is temporarily unable to turn unholy creatures. The cleric regains the ability after 1d4 days.",
	"The cleric is stained with the mark of the unfaithful. This physical mark appears like a brand, tattoo, or birthmark, with the symbol determined by the cleric faith. The symbol is automatically visible to all worshippers of the cleric faith, even through clothing, but may be invisible to others. To all who see and comment on the mark, the cleric must explain his sin and describe what he is doing as penance. If he continues to sustain his faith for a week while retaining the mark, it disappears.",
	"The cleric ability to lay on hands is restricted. The ability works only once per day per creature healed – no single character can be healed more than once per day. After 24 hours, the ability use reverts to normal."
	};

--
-- Generic misfire 
--

local misT = {
	"Nearest ally is partially transformed into an animal (Will save to resist; DC = 10 + (2x spell level)). Roll 1d6 to determine body part: 1 = arms; 2 = legs; 3 = skin; 4 = head; 5-6 = body. Roll 1d8 for animal type: 1 = chicken; 2 = gorilla; 3 = cow; 4 = lizard; 5 = snake; 6 = horse; 7 = dragon; 8 = eagle. The duration of this effect is 1d7 days. On a roll of 7, re-roll as 1d7 weeks. On a second 7, re-roll as 1d7 months.",
	"Different spell effect! The wizard inadvertently channels the wrong spell energies. Randomly determine a different spell of the same level. Have the wizard make a spell check roll for that spell. If the spell check is a failure, nothing happens. If it is a success, follow the results.",
	"Rain! But it’s not water. The wizard inadvertently causes a torrential downpour of (roll 1d6): 1 =  ower pet- als; 2 = garden snails; 3 = cow dung; 4 = rotten vegetables; 5 = iron ingots; 6 = snakes (5% chance they are poisonous).",
	"Explosion centered on nearest creature! That creature takes 1d3 damage per spell level.",
	"Transformation! One randomly determined creature among the six closest is transformed into (roll 1d6): 1 = stone; 2 = crystal; 3 = earth; 4 = iron; 5 = water; 6 = fire. (Will save to resist, DC = 10 + (2x spell level)). There is a 10% chance the transformation is permanent; otherwise, the creature returns to normal in 1d7 days.",
	"Inadvertent corruption! Roll d12+5 on the minor corruption table and apply the result to one randomly de- termined creature among the six closest (no Will save to resist).",
	"Fireworks! Brilliant colored lights explode all around the caster, creating thundering booms. This effect deals no damage but draws attention to the caster.",
	"Cloud of ash! Everyone within 20’ of the caster is coated in fine ash."
	};


function onInit()
	Comm.registerSlashHandler("sd", slashCommandHandlerSpellDuel);
	Comm.registerSlashHandler("co", slashCommandHandlerCorruption);
	Comm.registerSlashHandler("dis", slashCommandHandlerDisapproval);
	Comm.registerSlashHandler("mis", slashCommandHandlerMisfire);
	Comm.registerSlashHandler("?", slashCommandHandlerHelp);
	Comm.registerSlashHandler("help", slashCommandHandlerHelp);
	Comm.registerSlashHandler("spell", slashCommandHandlerSpell);
	Comm.registerSlashHandler("wiz", slashCommandHandlerMagicUser);
	Comm.registerSlashHandler("cle", slashCommandHandlerMagicUser);
end

function mysplit(inputstr, sep)
                        if sep == nil then sep = "%s" end
                                local t={}
                                for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                                table.insert(t, str)
                                end
                                return t
                        end

function slashCommandHandlerMagicUser(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );
	local source;
	if sCommand == "wiz" then
		source = "Wizard";
	else
		source = "Cleric";
	end

	local aUsageMessage = { text = sCommand .. " maxlevel" , secret = true };

	-- we expect arg1 =  Hit Dice
	if (not args) or (#args ~= 1) then 
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end
	local maxlevel = tonumber( args[1] );
	if not maxlevel or maxlevel == 0 then
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end

	-- create an array of array ( = an array for each level ) where we will store existing spells
	local eligible = {};
	for i=1,maxlevel do
		eligible[i] = {};
	end
	
	local child = DB.getChildrenGlobal(  "reference.spelldata@DCC RPG Spells" );
	for _,spell in ipairs(child) do
		local name = spell.getName();
		local lvl = DB.getValue( spell , "level" , 0 );
		local domain = DB.getValue( spell , "source" , "" );
		local general = DB.getValue( spell , "general" , "" );
		if (general ~= "") and (domain == source ) and ( lvl > 0 ) and ( lvl <= maxlevel ) then 
			table.insert( eligible[lvl] , name );
		end
	end

	-- then randomly select one spell per level
	aMessage = { text = "Selected spells :" , secret = true, font = "callingcode" };
	local offset = 0;
	for i=1,maxlevel do
		if #eligible[i] > 0 then
		  local r = math.random( #eligible[i] );
		  aMessage.text = aMessage.text .. "\nlevel " .. i .. "  " .. eligible[i][r] .. "  (" .. source .. ")";
		  local w = Interface.openWindow ("reference_spell" , "reference.spelldata." .. eligible[i][r] .. "@DCC RPG Spells" );
		  w.setSize( 800 , 600 );
		  w.setPosition( 380 + offset , 100 + offset );
		  offset = offset + 30;
		end
	end
	Comm.addChatMessage(aMessage) ; 
	

end

function slashCommandHandlerSpell(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );

	local aUsageMessage = { text = "/spell spellname [level]" , secret = true };

	-- we expect arg1 = spell name, and optional arg2 = spell level 
	-- spell name supersedes level, ie. if the level is given but does not match the unique spell we find, we ignore it
	-- and display that spell anyway. Conversely, if several spells match, we take the one with that level.
	if (not args) or (#args ~= 1 and #args ~=2 ) then 
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end

	-- get level if given, or keep it nil
	local requestedLevel = nil;
	if #args == 2 then
		requestedLevel = tonumber( args[2] );
	end

	-- try to find it
	local child = DB.getChildrenGlobal(  "reference.spelldata@DCC RPG Spells" );
	for _,spell in ipairs(child) do
		local name = spell.getName();
		if name == args[1] then
			-- found a perfect match. open window. we ignore the level if given
			local w = Interface.openWindow ("reference_spell" , "reference.spelldata." .. args[1] .. "@DCC RPG Spells" );
			w.setSize( 800 , 600 );
			w.setPosition( 380 , 100 );
			return;
		end	
	end

	-- if here, not found...

	local aMessage = { secret = true, font = "callingcode" };

	-- display similar names, starting with the given argument
	local similar = {};
	local size = string.len(args[1]); -- how many characters do we have to match, depending on what the user typed in

	local levelMatchNumber = 0;	-- how many similar names are matching the level ? only one would be good !
	local levelMatchName = nil;	-- last similar name matching the level

	for _,spell in ipairs(child) do
		local name = spell.getName();
		local lvl = DB.getValue( spell , "level" , 0 );
		local domain = DB.getValue( spell , "source" , "" );
		local general = DB.getValue( spell , "general" , "" );
		local filled = "  ";
		if (general ~= "") then filled = "* "; end
		local first = string.sub(name, 1, size);
		if first == args[1] then	
			table.insert( similar , { name = name, domain = domain, level = lvl , filled = filled } );
			if requestedLevel and lvl == requestedLevel then
				levelMatchNumber = levelMatchNumber + 1;
				levelMatchName = name;
			end
		end
	end
		
	if #similar == 1 then
		-- found only one similar. Open it. we ignore the level if given
		aMessage = { text = "It seems to be '" .. similar[1].name .. "' ? Opening it now.", secret = true, font = "callingcode" };
		Comm.addChatMessage(aMessage) ; 
		local w = Interface.openWindow ("reference_spell" , "reference.spelldata." .. similar[1].name .. "@DCC RPG Spells" );
		w.setSize( 800 , 600 );
		w.setPosition( 380 , 100 );
		return;

	elseif #similar > 1 and levelMatchNumber == 1 then
		-- found several matches but only one with the correct level. open it.
		aMessage = { text = "It seems to be '" .. levelMatchName .. "' with that level ? Opening it now.", secret = true, font = "callingcode" };
		Comm.addChatMessage(aMessage) ; 
		local w = Interface.openWindow ("reference_spell" , "reference.spelldata." .. levelMatchName .. "@DCC RPG Spells" );
		w.setSize( 800 , 600 );
		w.setPosition( 380 , 100 );
		return;


	elseif #similar > 1 then
		-- too many and the level is useless. display them all.
		aMessage = { text = "Spell not found. Did you mean :" , secret = true, font = "callingcode" };
		for _,n in ipairs(similar) do
			aMessage.text = aMessage.text .. "\n" .. n.filled .. n.name .. "  (" .. n.domain .. " , " .. n.level .. ")";
		end
		Comm.addChatMessage(aMessage) ; 
		return;
	end

	-- if no similar name, display all spells starting with same letter
	aMessage = { text = "Spell not found. Did you mean :" , secret = true, font = "callingcode" };
	local letter = string.sub(args[1], 1, 1);
	for _,spell in ipairs(child) do
		local name = spell.getName();
		local lvl = DB.getValue( spell , "level" , 0 );
		local domain = DB.getValue( spell , "source" , "" );
		local general = DB.getValue( spell , "general" , "" );
		local filled = "  ";
		if (general ~= "") then filled = "* "; end
		local first = string.sub(name, 1, 1);
		if first == letter then	
			aMessage.text = aMessage.text .. "\n" .. filled .. name .. "  (" .. domain .. " , " .. lvl .. ")";	
		end
	end
	Comm.addChatMessage(aMessage) ; 
	
end

function slashCommandHandlerHelp(sCommand, sParams)

	local aUsageMessage = { text = "/spell spellname [level] : Open a particular spell table, possibly matching that level" , secret = true };
	aUsageMessage.text = aUsageMessage.text .. "\n\n/equip : display list of common equipment";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/fumble check : Roll on fumble table";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/crit 1,2,3,4,5,I,II,III,IV,V,U,M,G,DN check : Roll on critical table";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/dis check : Roll on disapproval table. Check is N x d4 - luck mod";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/mis check : Roll on generic misfire table. Check is 1d8";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/co mMgG spellLevel [check] : Roll for corruption. Letter gives the table, (m)inor, (M)ajor or (gG)reater. Spell level is mandatory, roll check is optional. If roll given, must not take spell level into account, just the die roll 1d10 + luck mod";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/sd attackerCheck defenderCheck : Roll for spell duel, given the two spell checks. Checks must be greater than 12 (otherwise no need to roll). Determines appropriate die then roll it automatically. In case of equal checks, roll directly on Phlogiston table";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/wiz maxlevel  or  /cle maxlevel : Randomly choose a spell per level for an NPC, defined by maxlevel value (1-5)";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/loot [low|med|high|very] : Determines random loot";
	aUsageMessage.text = aUsageMessage.text .. "\n\n/name[s] : Choose random names for various races, towns, clan and taverns";

	Comm.addChatMessage(aUsageMessage) ; 
end


function slashCommandHandlerMisfire(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );

	local aUsageMessage = { text = "/mis check (check = 1d8)" , secret = true };

	-- we expect arg1 = a roll number 
	if (not args) or (#args ~= 1) then 
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end

	-- get roll value
	local nRoll = tonumber( args[1] );
	if not nRoll then
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end
		
	-- adjust roll if needed
	if nRoll < 1 then 
		nRoll = 1;
	elseif nRoll > 8 then
		nRoll = 8;
	end

	local sText = misT[nRoll]; 
	local aMessage = { text = " => [misfire , roll is " .. nRoll .. "] " .. sText , secret = true, font = "callingcode" };
	Comm.addChatMessage(aMessage) ; 

end

function slashCommandHandlerDisapproval(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );

	local aUsageMessage = { text = "/dis check (check = Nd4 - luck)" , secret = true };

	-- we expect arg1 = a roll number 
	if (not args) or (#args ~= 1) then 
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end

	-- get roll value
	local nRoll = tonumber( args[1] );
	if not nRoll then
		Comm.addChatMessage(aUsageMessage) ; 
		return;
	end
		
	-- adjust roll if needed
	if nRoll < 1 then 
		nRoll = 1;
	elseif nRoll > 20 then
		nRoll = 20;
	end

	local sText = disT[nRoll]; 
	local aMessage = { text = " => [disapproval , roll is " .. nRoll .. "] " .. sText , secret = true, font = "callingcode" };
	Comm.addChatMessage(aMessage) ; 

end

function slashCommandHandlerCorruption(sCommand, sParams)

	-- parse params
	local args = mysplit( sParams );

	local aUsageMessage = { text = "/co [mMG] spellLevel (roll d10+luck)\nm=minor,M=Major,G or g=Greater" , secret = true };

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
	local rollSentence = "";

	-- roll die if not given
	if nRoll == 0 then
		nInitialRoll = math.random(10);
		rollSentence = "ed";
		nRoll = nInitialRoll - nSpellLevel;
	else
		nInitialRoll = nRoll;
		rollSentence = " is";
		nRoll = nInitialRoll - nSpellLevel;
		nRoll = nRoll - nSpellLevel;
	end

	-- adjust value if needed
	if nRoll < 1 then 
		nRoll = 1;
	elseif nRoll > 10 then
		nRoll = 10;
	end

	local sText = coT[sCoTable][nRoll]; 
	local aMessage = { text = " => [corruption " .. sCoTable .. " on spell level " .. nSpellLevel .. ", roll" .. rollSentence .. " " .. nInitialRoll .. ", result is " .. nRoll .. "] " .. sText , secret = true, font = "callingcode" };
	Comm.addChatMessage(aMessage) ; 

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
		local aMessage = { text = " => [Phlogiston Disturbance!, roll " .. nRoll .. "] " .. sText , secret = true, font = "callingcode" };
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
	local aMessage = { text = " => [" .. countercolumn .. ", die d" .. die .. ", roll " .. nRoll .. "] " .. sText , secret = true, font = "callingcode" };
	Comm.addChatMessage(aMessage) ; 

end


