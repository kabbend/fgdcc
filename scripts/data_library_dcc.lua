-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function getItemIsIdentified(vRecord, vDefault)
	return LibraryData.getIDState("item", vRecord, true);
end

function sortNPCHDValues(aFilterValues)
	local function fNPCSortValue(a)
		local v = tonumber(a) or 0;
		return v;
	end
	table.sort(aFilterValues, function(a,b) return fNPCSortValue(a) < fNPCSortValue(b); end);
	return aFilterValues;
end

function getNPCHDValue(vNode)
	local v = StringManager.trim(DB.getValue(vNode, "hd", ""));
	local sHD = v:match("^(%d*)d+");
	if sHD then
		v = StringManager.trim(sHD);
	end
	return v;
end

function getNPCTypeValue(vNode)
	local v = StringManager.trim(DB.getValue(vNode, "type", ""));
	local sType = v:match("^[^(%s]+");
	if sType then
		v = StringManager.trim(sType);
	end
	v = StringManager.capitalize(v);
	return v;
end

function getItemRecordDisplayClass(vNode)
	local sRecordDisplayClass = "item";
	if vNode then
		local sBasePath, sSecondPath = UtilityManager.getDataBaseNodePathSplit(vNode);
		if sBasePath == "reference" then
			if sSecondPath == "equipmentdata" then
				local sTypeLower = StringManager.trim(DB.getValue(DB.getPath(vNode, "type"), ""):lower());
				if sTypeLower == "weapon" then
					sRecordDisplayClass = "reference_weapon";
				elseif sTypeLower == "armor" then
					sRecordDisplayClass = "reference_armor";
				elseif sTypeLower == "mounts and related gear" then
					sRecordDisplayClass = "reference_mountsandrelatedgear";
				elseif sTypeLower == "vehicle" then
					sRecordDisplayClass = "reference_vehicle";
				else
					sRecordDisplayClass = "reference_equipment";
				end
			end
		end
	end
	return sRecordDisplayClass;
end

function isItemIdentifiable(vNode)
	return (getItemRecordDisplayClass(vNode) == "item");
end

function getSpellSourceValue(vNode)
	return StringManager.split(DB.getValue(vNode, "source", ""), ",", true);
end

function getSpellLevelValue(vNode)
	local v = DB.getValue(vNode, "level", 0);
	if (v >= 1) and (v <= 9) then
		v = tostring(v);
	else
		v = Interface.getString("library_recordtype_value_spell_level_0");
	end
	return v;
end

aRecordOverrides = {
	["quest"] = { 
		aDataMap = { "quest", "reference.questdata" }, 
	},
	["image"] = { 
		aDataMap = { "image", "reference.imagedata" }, 
	},
	["npc"] = { 
		aDataMap = { "npc", "reference.npcdata" },
		aGMListButtons = { "button_npc_letter", "button_npc_hd", "button_npc_type" };
		aCustomFilters = {
			["HD"] = { sField = "hd", fGetValue = getNPCHDValue, fSort = sortNPCHDValues },
			["Type"] = { sField = "type", fGetValue = getNPCTypeValue },
		},
	},
	["item"] = { 
		fIsIdentifiable = isItemIdentifiable,
		aDataMap = { "item", "reference.equipmentdata" }, 
		fRecordDisplayClass = getItemRecordDisplayClass,
		aRecordDisplayClasses = { "item", "reference_armor", "reference_weapon", "reference_equipment", "reference_mountsandrelatedgear", "reference_vehicle" },
		aGMListButtons = { "button_item_armor", "button_item_weapons" };
		aPlayerListButtons = { "button_item_armor", "button_item_weapons" };
		aCustomFilters = {
			["Type"] = { sField = "type" },
		},
	},
	["class"] = {
		bExport = true,
		aDataMap = { "class", "reference.classdata" }, 
		aDisplayIcon = { "button_classes", "button_classes_down" },
		sRecordDisplayClass = "reference_class", 
	},
	["skill"] = {
		bExport = true, 
		aDataMap = { "skill", "reference.skilldata" }, 
		aDisplayIcon = { "button_skills", "button_skills_down" },
		sRecordDisplayClass = "reference_skill", 
	},
	["spell"] = {
		bExport = true,
		aDataMap = { "spell", "reference.spelldata" }, 
		aDisplayIcon = { "button_spells", "button_spells_down" },
		sRecordDisplayClass = "power",
		aCustomFilters = {
			["Source"] = { sField = "source", fGetValue = getSpellSourceValue },
			["Level"] = { sField = "level", sType = "number" };
		}, 
	},
};

aDefaultSidebarState = {
	["create"] = "charsheet,class,item,skill,spell",
};

aListViews = {
	["npc"] = {
		["byletter"] = {
			sTitleRes = "npc_grouped_title_byletter",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "npc_grouped_label_name", nWidth=250 },
				{ sName = "hd", sType = "string", sHeadingRes = "npc_grouped_label_hd", sTooltipRe = "npc_grouped_tooltip_hd", bCentered=true },
			},
			aFilters = { },
			aGroups = { { sDBField = "name", nLength = 1 } },
			aGroupValueOrder = { },
		},
		["byhd"] = {
			sTitleRes = "npc_grouped_title_byhd",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "npc_grouped_label_name", nWidth=250 },
				{ sName = "hd", sType = "string", sHeadingRes = "npc_grouped_label_hd", sTooltipRe = "npc_grouped_tooltip_hd", nWidth=80, bCentered=true  },
			},
			aFilters = { },
			aGroups = { { sDBField = "hd_short", sPrefix = "HD" } },
			aGroupValueOrder = { "HD", "HD 0", "HD 1", "HD 2", "HD 3", "HD 4", "HD 5", "HD 6", "HD 7", "HD 8", "HD 9", "HD 10", 
									"HD 11", "HD 12", "HD 13", "HD 14", "HD 15", "HD 16", "HD 17", "HD 18", "HD 19", "HD 20", 
									"HD 21", "HD 22", "HD 23", "HD 24", "HD 25", "HD 26", "HD 27", "HD 28", "HD 29", "HD 30", },
		},
		["bytype"] = {
			sTitleRes = "npc_grouped_title_bytype",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "npc_grouped_label_name", nWidth=250 },
				{ sName = "hd", sType = "string", sHeadingRes = "npc_grouped_label_hd", sTooltipRe = "npc_grouped_tooltip_hd", bCentered=true },
			},
			aFilters = { },
			aGroups = { { sDBField = "type" } },
			aGroupValueOrder = { },
		},
	},
	["item"] = {
		["armor"] = {
			sTitleRes = "item_grouped_title_armor",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "item_grouped_label_name", nWidth=150 },
				{ sName = "ac", sType = "number", sHeadingRes = "item_grouped_label_ac", sTooltipRes = "item_grouped_tooltip_ac", nWidth=40, bCentered=true, nSortOrder=1 },
				{ sName = "checkpenalty", sType = "number", sHeadingRes = "item_grouped_label_checkpenalty", sTooltipRes = "item_grouped_tooltip_checkpenalty", nWidth=70, bCentered=true },
				{ sName = "speedpenalty", sType = "number", sHeadingRes = "item_grouped_label_speedpenalty", sTooltipRes = "item_grouped_tooltip_speedpenalty", bCentered=true },
				{ sName = "fumbledie", sType = "string", sHeadingRes = "item_grouped_label_fumbledie", sTooltipRes = "item_grouped_tooltip_fumbledie", nWidth=100, bCentered=true },
				{ sName = "cost", sType = "string", sHeadingRes = "item_grouped_label_cost", bCentered=true },
			},
			aFilters = { 
				{ sDBField = "type", vFilterValue = "Armor" }, 
				{ sCustom = "item_isidentified" } 
			},
			aGroups = { { sDBField = "subtype" } },
			aGroupValueOrder = { "Light Armor", "Medium Armor", "Heavy Armor", "Shield" },
		},
		["weapon"] = {
			sTitleRes = "item_grouped_title_weapons",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "item_grouped_label_name", nWidth=150 },
				{ sName = "damage", sType = "string", sHeadingRes = "item_grouped_label_damage", nWidth=150, bCentered=true },
				{ sName = "ranges", sType = "string", sHeadingRes = "item_grouped_label_range", nWidth=100, bCentered=true },
				{ sName = "cost", sType = "string", sHeadingRes = "item_grouped_label_cost", bCentered=true },
			},
			aFilters = { 
				{ sDBField = "type", vFilterValue = "Weapon" }, 
				{ sCustom = "item_isidentified" } 
			},
			aGroups = { { sDBField = "subtype" } },
			aGroupValueOrder = { "Simple Melee Weapons", "Simple Ranged Weapons", "Martial Weapons", "Martial Melee Weapons", "Martial Ranged Weapons" },
		},
		["vehiclemount"] = {
			sTitleRes = "item_grouped_title_vehiclemount",
			aColumns = {
				{ sName = "name", sType = "string", sHeadingRes = "item_grouped_label_name", nWidth=150 },
				{ sName = "cost", sType = "string", sHeadingRes = "item_grouped_label_cost", nWidth=70, bCentered=true },
				{ sName = "speed", sType = "string", sHeadingRes = "item_grouped_label_speed", nWidth=60, bCentered=true },
				{ sName = "carryingcapacity", sType = "string", sHeadingRes = "item_grouped_label_carryingcapacity", sTooltipRes="item_grouped_tooltip_carryingcapacity", nWidth=70, bCentered=true },
			},
			aFilters = { { sDBField = "type", vFilterValue = "Mounts and Related Gear" } },
			aGroups = { { sDBField = "subtype" } },
			aGroupValueOrder = { },
		},
	},
};

function onInit()
	LibraryData.setCustomFilterHandler("item_isidentified", getItemIsIdentified);
	for kDefSidebar,vDefSidebar in pairs(aDefaultSidebarState) do
		DesktopManager.setDefaultSidebarState(kDefSidebar, vDefSidebar);
	end
	for kRecordType,vRecordType in pairs(aRecordOverrides) do
		LibraryData.overrideRecordTypeInfo(kRecordType, vRecordType);
	end
	for kRecordType,vRecordListViews in pairs(aListViews) do
		for kListView, vListView in pairs(vRecordListViews) do
			LibraryData.setListView(kRecordType, kListView, vListView);
		end
	end
	LibraryData.setRecordTypeInfo("vehicle", nil);
end

