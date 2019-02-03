-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

function onInit()
	-- Set the displays to what should be shown
	setTargetingVisible();
	setActiveVisible();
	setDefensiveVisible();
	setSpacingVisible();
	setEffectsVisible();

	-- Acquire token reference, if any
	linkToken();
	
	-- Set up the PC links
	onLinkChanged();
	onFactionChanged();
	onHealthChanged();
	
	-- Register the deletion menu item for the host
	registerMenuItem(Interface.getString("list_menu_deleteitem"), "delete", 6);
	registerMenuItem(Interface.getString("list_menu_deleteconfirm"), "delete", 6, 7);
end

function updateDisplay()
	local sFaction = friendfoe.getStringValue();

	if DB.getValue(getDatabaseNode(), "active", 0) == 1 then
		name.setFont("sheetlabel");
		nonid_name.setFont("sheetlabel");
		
		active_spacer_top.setVisible(true);
		active_spacer_bottom.setVisible(true);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend_active");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral_active");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe_active");
		else
			setFrame("ctentrybox_active");
		end
	else
		name.setFont("sheettext");
		nonid_name.setFont("sheettext");
		
		active_spacer_top.setVisible(false);
		active_spacer_bottom.setVisible(false);
		
		if sFaction == "friend" then
			setFrame("ctentrybox_friend");
		elseif sFaction == "neutral" then
			setFrame("ctentrybox_neutral");
		elseif sFaction == "foe" then
			setFrame("ctentrybox_foe");
		else
			setFrame("ctentrybox");
		end
	end
end

function linkToken()
	local imageinstance = token.populateFromImageNode(tokenrefnode.getValue(), tokenrefid.getValue());
	if imageinstance then
		TokenManager.linkToken(getDatabaseNode(), imageinstance);
	end
end

function onMenuSelection(selection, subselection)
	if selection == 6 and subselection == 7 then
		delete();
	end
end

function delete()
	local node = getDatabaseNode();
	if not node then
		close();
		return;
	end
	
	-- Remember node name
	local sNode = node.getNodeName();
	
	-- Clear any effects first, so that saves aren't triggered when initiative advanced
	effects.reset(false);

	-- Move to the next actor, if this CT entry is active
	if DB.getValue(node, "active", 0) == 1 then
		CombatManager.nextActor();
	end

	-- Delete the database node and close the window
	node.delete();

	-- Update list information (global subsection toggles, targeting)
	windowlist.onVisibilityToggle();
	windowlist.onEntrySectionToggle();
end

function onLinkChanged()
	-- If a PC, then set up the links to the char sheet
	local sClass, sRecord = link.getValue();
	if sClass == "charsheet" then
		linkPCFields();
		name.setLine(false);
	end
	onIDChanged();
end

function onHealthChanged()
	local sColor, nPercentWounded, nPercentNonlethal, sStatus = ActorManager2.getWoundColor("ct", getDatabaseNode());
	
	wounds.setColor(sColor);
	nonlethal.setColor(sColor);
	status.setValue(sStatus);
	
	local sClass,_ = link.getValue();
	if sClass ~= "charsheet" then
		idelete.setVisibility((nPercentWounded >= 1));
	end
end

function onIDChanged()
	local nodeRecord = getDatabaseNode();
	local sClass = DB.getValue(nodeRecord, "link", "", "");
	if sClass == "npc" then
		local bID = LibraryData.getIDState("npc", nodeRecord, true);
		name.setVisible(bID);
		nonid_name.setVisible(not bID);
		isidentified.setVisible(true);
	else
		name.setVisible(true);
		nonid_name.setVisible(false);
		isidentified.setVisible(false);
	end
end

function onFactionChanged()
	-- Update the entry frame
	updateDisplay();

	-- If not a friend, then show visibility toggle
	if friendfoe.getStringValue() == "friend" then
		tokenvis.setVisible(false);
	else
		tokenvis.setVisible(true);
	end
end

function onVisibilityChanged()
	TokenManager.updateVisibility(getDatabaseNode());
	windowlist.onVisibilityToggle();
end

function onActiveChanged()
	setActiveVisible();
end

function linkPCFields()
	local nodeChar = link.getTargetDatabaseNode();
	if nodeChar then
		name.setLink(nodeChar.createChild("name", "string"), true);

		hp.setLink(nodeChar.createChild("hp.total", "number"));
		hptemp.setLink(nodeChar.createChild("hp.temporary", "number"));
		nonlethal.setLink(nodeChar.createChild("hp.nonlethal", "number"));
		wounds.setLink(nodeChar.createChild("hp.wounds", "number"));
		
		fortitudesave.setLink(nodeChar.createChild("saves.fortitude.total", "number"), true);
		reflexsave.setLink(nodeChar.createChild("saves.reflex.total", "number"), true);
		willpowersave.setLink(nodeChar.createChild("saves.willpower.total", "number"), true);

		init.setLink(nodeChar.createChild("initiative.total", "number"), true);
		ac_final.setLink(nodeChar.createChild("ac.total", "number"), true);
		speed.setLink(nodeChar.createChild("speed.total", "number"), true);
	end
end

--
-- SECTION VISIBILITY FUNCTIONS
--

function setTargetingVisible()
	local v = false;
	if activatetargeting.getValue() == 1 then
		v = true;
	end

	targetingicon.setVisible(v);
	
	sub_targeting.setVisible(v);
	
	frame_targeting.setVisible(v);

	target_summary.onTargetsChanged();
end

function setActiveVisible()
	local v = false;
	if activateactive.getValue() == 1 then
		v = true;
	end

	local sClass, sRecord = link.getValue();
	local bNPC = (sClass ~= "charsheet");
	if bNPC and active.getValue() == 1 then
		v = true;
	end
	
	activeicon.setVisible(v);

	init.setVisible(v);
	initlabel.setVisible(v);
	speed.setVisible(v);
	speedlabel.setVisible(v);
	actiondice.setVisible(v);
	actiondicelabel.setVisible(v);
	crittable.setVisible(v);
	crittablelabel.setVisible(v);
	
	spacer_active.setVisible(v);
	
	if bNPC then
		attacks.setVisible(v);
		if v and not attacks.getNextWindow(nil) then
			attacks.createWindow();
		end
		attacks_label.setVisible(v);
	else
		attacks.setVisible(false);
		attacks_label.setVisible(false);
	end
	
	frame_active.setVisible(v);
end

function setDefensiveVisible()
	local v = false;
	if activatedefensive.getValue() == 1 then
		v = true;
	end
		
	defensiveicon.setVisible(v);

	ac_final.setVisible(v);
	ac_final_label.setVisible(v);

	fortitudesave.setVisible(v);
	fortitudelabel.setVisible(v);
	reflexsave.setVisible(v);
	reflexlabel.setVisible(v);
	willpowersave.setVisible(v);
	willpowerlabel.setVisible(v);

	specialqualities.setVisible(v);
	specialqualitieslabel.setVisible(v);
	
	frame_defensive.setVisible(v);
end
	
function setSpacingVisible()
	local v = false;
	if activatespacing.getValue() == 1 then
		v = true;
	end

	spacingicon.setVisible(v);
	
	space.setVisible(v);
	spacelabel.setVisible(v);
	reach.setVisible(v);
	reachlabel.setVisible(v);
	
	spacer_space.setVisible(v);
	
	frame_spacing.setVisible(v);
end

function setEffectsVisible()
	local v = false;
	if activateeffects.getValue() == 1 then
		v = true;
	end
	
	effecticon.setVisible(v);
	
	effects.setVisible(v);
	effects_iadd.setVisible(v);
	for _,w in pairs(effects.getWindows()) do
		w.idelete.setValue(0);
	end

	frame_effects.setVisible(v);

	effect_summary.onEffectsChanged();
end
