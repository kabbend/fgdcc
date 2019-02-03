-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	local node = window.getDatabaseNode();
	
	local sType = DB.getValue(node, "type", "");
	local sSubType = DB.getValue(node, "subtype", "");

	local aValues = {};

	if sSubType ~= "" then
		if sType ~= "" then
			sType = sType .. " ";
		end
		sType = sType .. "(" .. sSubType .. ")";
	end
	table.insert(aValues, sType);

	setValue(table.concat(aValues, ", "));
	
	super.onInit();
end
