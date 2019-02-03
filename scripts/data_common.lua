-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Abilities (database names)
abilities = {
	"strength",
	"agility",
	"stamina",
	"personality",
	"intelligence",
	"luck",
};

ability_ltos = {
	["strength"] = "STR",
	["agility"] = "AGI",
	["stamina"] = "STA",
	["personality"] = "PER",
	["intelligence"] = "INT",
	["luck"] = "LUCK",
};

ability_stol = {
	["STR"] = "strength",
	["AGI"] = "agility",
	["STA"] = "stamina",
	["PER"] = "personality",
	["INT"] = "intelligence",
	["LUCK"] = "luck",
};

-- Saves
save_ltos = {
	["fortitude"] = "FORT",
	["reflex"] = "REF",
	["willpower"] = "WILL",
};

save_stol = {
	["FORT"] = "fortitude",
	["REF"] = "reflex",
	["WILL"] = "willpower",
};

-- Basic class values (not display values)
classes = {
	"cleric",
	"thief",
	"warrior",
	"wizard",
	"dwarf",
	"elf",
	"halfling",
};

-- Values for wound comparison
healthstatusfull = "healthy";
healthstatushalf = "bloodied";
healthstatuswounded = "wounded";

-- Values for alignment comparison
alignment_lawchaos = {
	["lawful"] = 1,
	["chaotic"] = 3,
	["l"] = 1,
	["c"] = 3,
};

alignment_goodevil = {
};
alignment_neutral = "n";

-- Values for size comparison
creaturesize = {
	["tiny"] = 1,
	["small"] = 2,
	["medium"] = 3,
	["large"] = 4,
	["huge"] = 5,
	["gargantuan"] = 6,
	["t"] = 1,
	["s"] = 2,
	["m"] = 3,
	["l"] = 4,
	["h"] = 5,
	["g"] = 6,
};

-- Values for creature type comparison
creaturedefaulttype = "humanoid";
creaturehalftype = "half-";
creaturehalftypesubrace = "human";
creaturetype = {
	"aberration",
	"beast",
	"celestial",
	"construct",
	"dragon",
	"elemental",
	"fey",
	"fiend",
	"giant",
	"humanoid",
	"monstrosity",
	"ooze",
	"plant",
	"undead",
};
creaturesubtype = {
	"aarakocra",
	"bullywug",
	"demon",
	"devil",
	"dragonborn",
	"dwarf",
	"elf", 
	"gith",
	"gnoll",
	"gnome", 
	"goblinoid",
	"grimlock",
	"halfling",
	"human",
	"kenku",
	"kuo-toa",
	"kobold",
	"lizardfolk",
	"living construct",
	"merfolk",
	"orc",
	"quaggoth",
	"sahuagin",
	"shapechanger",
	"thri-kreen",
	"titan",
	"troglodyte",
	"yuan-ti",
	"yugoloth",
};

-- Values supported in effect conditionals
conditionaltags = {
};

-- Conditions supported in effect conditionals and for token widgets
conditions = {
	"blinded",
	"bound",
	"charmed",
	"confused",
	"cursed",
	"dazed",
	"deafened",
	"entangled",
	"exhausted",
	"frightened",
	"grappled",
	"helpless",
	"incorporeal",
	"intoxicated",
	"invisible",
	"kneeling",
	"nauseated",
	"paralyzed",
	"petrified",
	"poisoned",
	"prone",
	"restrained",
	"sickened",
	"sitting",
	"sleeping",
	"slowed",
	"squeezing",
	"stunned",
	"turned",
	"unconscious"
};

-- Bonus/penalty effect types for token widgets
bonuscomps = {
	"INIT",
	"CHECK",
	"AC",
	"ATK",
	"DMG",
	"HEAL",
	"SAVE",
	"SPELL",
	"STR",
	"AGI",
	"STA",
	"PER",
	"INT",
	"LUCK"
};

-- Condition effect types for token widgets
condcomps = {
	["behind cover"] = "cond_cover",
	["blinded"] = "cond_blinded",
	["bound"] = "cond_restrained",
	["charmed"] = "cond_charmed",
	["confused"] = "cond_confused",
	["dazed"] = "cond_dazed",
	["deafened"] = "cond_deafened",
	["entangled"] = "cond_entangled",
	["frightened"] = "cond_frightened",
	["helpless"] = "cond_helpless",
	["incorporeal"] = "cond_incorporeal",
	["invisible"] = "cond_invisible",
	["nauseated"] = "cond_nauseated",
	["paralyzed"] = "cond_paralyzed",
	["petrified"] = "cond_petrified",
	["prone"] = "cond_prone",
	["sickened"] = "cond_sickened",
	["sleeping"] = "cond_unconscious",
	["slowed"] = "cond_slowed",
	["stunned"] = "cond_stunned",
	["turned"] = "cond_turned",
	["unconscious"] = "cond_unconscious"
};

-- Other visible effect types for token widgets
othercomps = {
	["COVER"] = "cond_cover",
	["IMMUNE"] = "cond_immune",
	["RESIST"] = "cond_resist",
	["VULN"] = "cond_vuln",
	["REGEN"] = "cond_regen",
	["DMGO"] = "cond_ongoing"
};

-- Effect components which can be targeted
targetableeffectcomps = {
	"COVER",
	"AC",
	"SAVE",
	"ATK",
	"DMG",
	"IMMUNE",
	"VULN",
	"RESIST"
};

connectors = {
	"and",
	"or"
};

-- Range types supported
rangetypes = {
	"melee",
	"ranged"
};

-- Damage types supported
energytypes = {
	"acid",
	"cold",
	"fire",
	"force",
	"lightning",
	"necrotic",
	"poison",
	"psychic",
	"radiant",
	"sonic",
	"thunder",
};

immunetypes = {
	"acid",  		-- ENERGY DAMAGE TYPES
	"cold",
	"electricity",
	"fire",
	"sonic",
	"nonlethal",	-- SPECIAL DAMAGE TYPES
	"poison",		-- OTHER IMMUNITY TYPES
	"sleep",
	"paralysis",
	"petrification",
	"charm",
	"sleep",
	"fear",
	"disease",
	"mind-affecting",
};

dmgtypes = {
	"acid",		-- ENERGY TYPES
	"cold",
	"fire",
	"force",
	"lightning",
	"necrotic",
	"poison",
	"psychic",
	"radiant",
	"sonic",
	"thunder",
	"adamantine", 	-- WEAPON PROPERTY DAMAGE TYPES
	"bludgeoning",
	"cold iron",
	"magic",
	"piercing",
	"silver",
	"slashing",
	"nonlethal",	-- SPECIAL DAMAGE TYPES
};

specialdmgtypes = {
	"nonlethal",
};

-- Bonus types supported in power descriptions
bonustypes = {
};
stackablebonustypes = {
};

-- Coin labels
currency = { "PP", "EP", "GP", "SP", "CP" };

function onInit()
	-- -- Skills
	skilldata = {
		[Interface.getString("skill_value_backstab")] = { lookup = "backstab" },
		[Interface.getString("skill_value_sneaksilently")] = { lookup = "sneaksilently", stat = 'agility' },
		[Interface.getString("skill_value_hideinshadows")] = { lookup = "hideinshadows", stat = 'agility' },
		[Interface.getString("skill_value_pickpocket")] = { lookup = "pickpocket", stat = 'agility' },
		[Interface.getString("skill_value_climbsheersurfaces")] = { lookup = "climbsheersurfaces", stat = 'agility' },
		[Interface.getString("skill_value_picklock")] = { lookup = "picklock", stat = 'agility' },
		[Interface.getString("skill_value_findtrap")] = { lookup = "findtrap", stat = 'intelligence' },
		[Interface.getString("skill_value_disabletrap")] = { lookup = "disabletrap", stat = 'agility' },
		[Interface.getString("skill_value_forgedocument")] = { lookup = "forgedocument", stat = 'agility' },
		[Interface.getString("skill_value_disguiseself")] = { lookup = "disguiseself", stat = 'personality' },
		[Interface.getString("skill_value_readlanguages")] = { lookup = "readlanguages", stat = 'intelligence' },
		[Interface.getString("skill_value_handlepoison")] = { lookup = "handlepoison" },
		[Interface.getString("skill_value_castspellfromscroll")] = { lookup = "castspellfromscroll", stat = 'intelligence' },
		[Interface.getString("skill_value_undergroundskills")] = { lookup = "undergroundskills" },
		[Interface.getString("skill_value_heightenedsenses")] = { lookup = "heightenedsenses" },
	};

	-- Party sheet drop down list data
	psabilitydata = {
		Interface.getString("strength"),
		Interface.getString("agility"),
		Interface.getString("stamina"),
		Interface.getString("personality"),
		Interface.getString("intelligence"),
		Interface.getString("luck"),
	};

	pssavedata = {
		Interface.getString("reflex"),
		Interface.getString("fortitude"),
		Interface.getString("willpower"),
	};
end
