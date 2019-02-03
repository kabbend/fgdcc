-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

-- Ruleset action types
actions = {
	["dice"] = { bUseModStack = true },
	["table"] = { },
	["cast"] = { sTargeting = "all", bUseModStack = true },
	["castsave"] = { sTargeting = "each" },
	["powersave"] = { sTargeting = "each" },
	["attack"] = { sIcon = "action_attack", sTargeting = "each", bUseModStack = true },
	["damage"] = { sIcon = "action_damage", sTargeting = "all", bUseModStack = true },
	["heal"] = { sIcon = "action_heal", sTargeting = "all", bUseModStack = true },
	["effect"] = { sIcon = "action_effect", sTargeting = "all" },
	["init"] = { bUseModStack = true },
	["save"] = { bUseModStack = true },
	["check"] = { bUseModStack = true },
	["skill"] = { bUseModStack = true },
	["deed"] = {bUseModStack = true },
	["critical"] = {bUseModStack = true },
	["fumble"] = {bUseModStack = true },
};

targetactions = {
	"cast",
	"attack",
	"damage",
	"heal",
	"effect"
};

currencies = { "PP", "GP", "EP", "SP", "CP" };
currencyDefault = "GP";

function onInit()	
	-- Languages
	languages = {
		[Interface.getString("language_value_common")] = "",
		[Interface.getString("language_value_chaos")] = "",
		[Interface.getString("language_value_law")] = "",
		[Interface.getString("language_value_neutrality")] = "",
		[Interface.getString("language_value_dwarf")] = "Dwarven",
		[Interface.getString("language_value_elf")] = "Elven",
		[Interface.getString("language_value_halfling")] = "",
		[Interface.getString("language_value_gnome")] = "Dwarven",
		[Interface.getString("language_value_bugbear")] = "Dwarven",
		[Interface.getString("language_value_goblin")] = "Dwarven",
		[Interface.getString("language_value_gnoll")] = "Infernal",
		[Interface.getString("language_value_harpy")] = "Elven",
		[Interface.getString("language_value_hobgoblin")] = "Dwarven",
		[Interface.getString("language_value_kobold")] = "Elven",
		[Interface.getString("language_value_lizardman")] = "Draconic",
		[Interface.getString("language_value_minotaur")] = "Dwarven",
		[Interface.getString("language_value_ogre")] = "Dwarven",
		[Interface.getString("language_value_orc")] = "Dwarven",
		[Interface.getString("language_value_serpent-man")] = "Infernal",
		[Interface.getString("language_value_troglodyte")] = "Draconic",
		[Interface.getString("language_value_angelic")] = "Celestial",
		[Interface.getString("language_value_centaur")] = "Elven",
		[Interface.getString("language_value_demonic")] = "Infernal",
		[Interface.getString("language_value_dragon")] = "Draconic",
		[Interface.getString("language_value_pixie")] = "Elven",
		[Interface.getString("language_value_giant")] = "Dwarven",
		[Interface.getString("language_value_undercommon")] = "Elven",
		[Interface.getString("language_value_thievescant")] = "Dwarven",
	}
	languagefonts = {
		[Interface.getString("language_value_celestial")] = "Celestial",
		[Interface.getString("language_value_draconic")] = "Draconic",
		[Interface.getString("language_value_dwarvish")] = "Dwarven",
		[Interface.getString("language_value_elvish")] = "Elven",
		[Interface.getString("language_value_infernal")] = "Infernal",
		[Interface.getString("language_value_primordial")] = "Primordial",
	}
end

function getAbilityBonus(c)
	if c <= 3 then
		return -3;
	elseif c < 6 then
		return -2;
	elseif c < 9 then
		return -1;
	elseif c < 13 then
		return 0;
	elseif c < 16 then
		return 1;
	elseif c < 18 then
		return 2;
	elseif c < 20 then
		return 3;
	elseif c < 22 then
		return 4;
	elseif c < 24 then
		return 5;
	elseif c >= 24 then
		return 6;
	else
		return 0;
	end
end

function decreaseActionDie(sActionDie)
	if sActionDie == "d30" then
		return "d24";
	elseif sActionDie == "d24" then
		return "d20";
	elseif sActionDie == "d20" then
		return "d16";
	elseif sActionDie == "d16" then
		return "d14";
	elseif sActionDie == "d14" then
		return "d12";
	elseif sActionDie == "d12" then
		return "d10";
	elseif sActionDie == "d10" then
		return "d8";
	elseif sActionDie == "d8" then
		return "d7";
	elseif sActionDie == "d7" then
		return "d6";
	elseif sActionDie == "d6" then
		return "d5";
	elseif sActionDie == "d5" then
		return "d4";
	elseif sActionDie == "d4" then
		return "d3";
	else
		return sActionDie;
	end
end

function increaseActionDie(sActionDie)
	if sActionDie == "d24" then
		return "d30";
	elseif sActionDie == "d20" then
		return "d24";
	elseif sActionDie == "d16" then
		return "d20";
	elseif sActionDie == "d14" then
		return "d16";
	elseif sActionDie == "d12" then
		return "d14";
	elseif sActionDie == "d10" then
		return "d12";
	elseif sActionDie == "d8" then
		return "d10";
	elseif sActionDie == "d7" then
		return "d8";
	elseif sActionDie == "d6" then
		return "d7";
	elseif sActionDie == "d5" then
		return "d6";
	elseif sActionDie == "d4" then
		return "d5";
	elseif sActionDie == "d3" then
		return "d4";
	else
		return sActionDie;
	end
end

function getCharSelectDetailHost(nodeChar)
	local sValue = "";
	local nLevel = DB.getValue(nodeChar, "level", 0);
	if nLevel > 0 then
		sValue = "Level " .. math.floor(nLevel*100)*0.01;
	end
	return sValue;
end

function requestCharSelectDetailClient()
	return "name,#level";
end

function receiveCharSelectDetailClient(vDetails)
	return vDetails[1], "Level " .. math.floor(vDetails[2]*100)*0.01;
end

function getCharSelectDetailLocal(nodeLocal)
	local vDetails = {};
	table.insert(vDetails, DB.getValue(nodeLocal, "name", ""));
	table.insert(vDetails, DB.getValue(nodeLocal, "level", 0));
	return receiveCharSelectDetailClient(vDetails);
end

function getDistanceUnitsPerGrid()
	return 5;
end
