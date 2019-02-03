-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local bFilter = true;
function setFilter(bNewFilter)
	bFilter = bNewFilter;
end
function getFilter()
	return bFilter;
end

function onInit()
	if not windowlist.isReadOnly() then
		registerMenuItem(Interface.getString("list_menu_deleteitem"), "delete", 6);
		registerMenuItem(Interface.getString("list_menu_deleteconfirm"), "delete", 6, 7);

		registerMenuItem(Interface.getString("power_menu_addaction"), "pointer", 3);
		registerMenuItem(Interface.getString("power_menu_addcast"), "radial_sword", 3, 2);
		registerMenuItem(Interface.getString("power_menu_adddamage"), "radial_damage", 3, 3);
		registerMenuItem(Interface.getString("power_menu_addheal"), "radial_heal", 3, 4);
		registerMenuItem(Interface.getString("power_menu_addeffect"), "radial_effect", 3, 5);
	end
	
	onDisplayChanged();
	windowlist.onChildWindowAdded(self);
end

function onDisplayChanged()
	sDisplayMode = DB.getValue(getDatabaseNode(), "...powerdisplaymode", "");

	if sDisplayMode == "summary" then
		--header.subwindow.group.setVisible(false);
		header.subwindow.shortdescription.setVisible(true);
		header.subwindow.actionsmini.setVisible(false);
	elseif sDisplayMode == "action" then
		header.subwindow.group.setVisible(false);
		header.subwindow.shortdescription.setVisible(false);
		header.subwindow.actionsmini.setVisible(true);
	else
		--header.subwindow.group.setVisible(true);
		header.subwindow.shortdescription.setVisible(false);
		header.subwindow.actionsmini.setVisible(false);
	end
end

function createAction(sType)
	local nodeAttack = getDatabaseNode();
	if nodeAttack then
		local nodeActions = nodeAttack.createChild("actions");
		if nodeActions then
			local nodeAction = nodeActions.createChild();
			if nodeAction then
				DB.setValue(nodeAction, "type", "string", sType);
			end
		end
	end
end

function onMenuSelection(selection, subselection)
	if selection == 6 and subselection == 7 then
		getDatabaseNode().delete();
	-- elseif selection == 4 then
		-- PowerManager.parsePCPower(getDatabaseNode());
		-- activatedetail.setValue(1);
	elseif selection == 3 then
		if subselection == 2 then
			createAction("cast");
			activatedetail.setValue(1);
		elseif subselection == 3 then
			createAction("damage");
			activatedetail.setValue(1);
		elseif subselection == 4 then
			createAction("heal");
			activatedetail.setValue(1);
		elseif subselection == 5 then
			createAction("effect");
			activatedetail.setValue(1);
		end
	end
end

function toggleDetail()
	local status = (activatedetail.getValue() == 1);
	
	actions.setVisible(status);

	for _,v in pairs(actions.getWindows()) do
		v.updateDisplay();
	end
end

function getDescription(bShowFull)
	local node = getDatabaseNode();
	
	local s = DB.getValue(node, "name", "");
	
	if bShowFull then
		local sShort = DB.getValue(node, "shortdescription", "");
		if sShort ~= "" then
			s = s .. " - " .. sShort;
		end
	end

	return s;
end

function usePower(bShowFull)

	-- power node
	local node = getDatabaseNode();

	-- who am i ?
	local rActor = ActorManager.getActor("pc", node.getChild("..."));

	-- create a roll
	-- FIXME : is it always d20 ?
	local rRoll = {};
        rRoll.sType = "cast";
        rRoll.aDice = { "d20" };
	rRoll.sSpellName = getDescription(bShowFull);

	-- retrieve some information on the spell, to pass to called routine
        rRoll.nMod = DB.getValue( node.getChild("...") , "spellcheck_total", "") or 0;
        rRoll.nCasterLevel = DB.getValue( node.getChild("...") , "level", "") or 0;
	rRoll.nPowerLevel = DB.getValue(node, "level", "") or 1;
	rRoll.nPowerSource = DB.getValue(node, "source", "");
	rRoll.nPowerFail = DB.getValue(node, "fail", "");
	rRoll.nPowerLost = DB.getValue(node, "lost", "");
	rRoll.sSpellID = node.getName();

	-- set a human readable description
        rRoll.sDesc = "[SPELL " .. getDescription(bShowFull) .. " " .. rRoll.nPowerLevel .. ", " .. rRoll.nPowerSource .. "]";

	-- should never get there (as the cast button should be invisible). But we test in case of...
	local currentLostStatus = DB.getValue(node, "is_lost",0);
	if currentLostStatus == 1 then 
		local rMessage = {};
        	rMessage.sender = rActor.sName;
        	rMessage.icon = "roll_cast";
		rMessage.text = rRoll.sDesc .. " [THIS SPELL IS LOST FOR NOW!]";
		Comm.deliverChatMessage(rMessage);
		return;
	end

	-- go roll
	ActionsManager.performAction(draginfo, rActor, rRoll );
end
