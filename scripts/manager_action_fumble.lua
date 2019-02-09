-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local fTable = {
	{ r1 = -99, r2 = 0, text = "Votre attaque rate sa cible d un bon kilometre mais vous ne subissez pas d autres effets indesirables." },
	{ r1 = 1, r2 = 1, text = "Votre attaque pathetique fait de vous la risee de vos compagnons mais ne vous inflige aucun degats" },
	{ r1 = 2, r2 = 2, text = "Vous glissez mais pouvez vous retablir avec un Jet en Reflexes (Diff.10) reussit. En cas d echec vous vous etalez par terre de tout votre long et y restez le round suivant." },
	{ r1 = 3, r2 = 3, text = "Vous manquez de perdre votre arme mais la recuperez au dernier moment. Votre mauvaise prise vous inflige neanmoins un malus de -2 a votre prochaine attaque." },
	{ r1 = 4, r2 = 4, text = "Votre arme est endommagee* (la corde d un arc casse, la garde d une epee glisse...). L arme peut-etre reparee en 10 minutes mais en l etat elle est inutilisable." },
	{ r1 = 5, r2 = 5, text = "Vous tombez comme une merde. Vous etes etale sur le sol et devez utiliser une action pour vous relever au round suivant." },
	{ r1 = 6, r2 = 6, text = "Votre arme se prends dans votre armure (ou vos vetements). Vous devez passer le round suivant a les separer. Le bonus a la CA de votre armure est reduit de 1 tant que vous n avez pas consacre 10 minutes a la reajuster." },
	{ r1 = 7, r2 = 7, text = "Votre arme vous echappe des mains. Votre prochaine action va consister a la ramasser ou a en sortir une nouvelle." },
	{ r1 = 8, r2 = 8, text = "Votre attaque finit dans obstacle imprevu mais solide (un mur, le sol...). Une arme normale est brisee, une arme magique n est pas affectee." },
	{ r1 = 9, r2 = 9, text = "Vous trebuchez et offrez une magnifique ouverture a vos adversaires. La prochaine attaque qui vous vise benefice d un +2." },
	{ r1 = 10, r2 = 10, text = "Pensez a entretenir votre armure ! Differentes parties de votre armure s emmelent ou se coincent ; vous ne pouvez rien faire pendant 1D3 rounds. Les personnages sans armures ne sont pas affectes par ce resultat." },
	{ r1 = 11, r2 = 11, text = "Votre attaque vous fait perdre votre equilibre. Vous subissez un malus de -4 a votre prochaine attaque." },
	{ r1 = 12, r2 = 12, text = "Votre attaque frole dangereusement un de vos allies (determine au hasard). Refaites un jet d attaque en utilisant le meme de contre l allie en question." },
	{ r1 = 13, r2 = 13, text = "Vous vous etalez lamentablement sur le sol, ce qui vous coute 1D3 points de vie. Vous etes maintenant allonge et devez utilisez votre prochaine action pour vous lever." },
	{ r1 = 14, r2 = 14, text = "Vous voila etendu sur le dos comme une tortue, a vous agiter sans parvenir a vous relever. Vous passerez le prochain round par terre et ne pourrez vous relever qu au suivant." },
	{ r1 = 15, r2 = 15, text = "Votre incompetence finit par vous couter cher : vous vous blessez vous-meme (degats normaux)." },
	{ r1 = 16, r2 = 99, text = "Non seulement vous parvenez a vous blesser (degats normaux +1) mais pour couronner le tout vous basculez cul par-dessus tete et vous retrouvez au sol. Impossible de vous relever tant que vous ne reussissez par un jet d Agilite (Diff. 16)." }
};

function onInit()

	ActionsManager.registerModHandler("fumble", modRoll);
	ActionsManager.registerResultHandler("fumble", onRoll);
end

function getRollMessage(nRollValue)
        for _,tableEntry in ipairs( fTable ) do
                if tableEntry.r1 <= nRollValue and tableEntry.r2 >= nRollValue then return tableEntry.text end
        end
        return "(unknown table)";
end

function getRoll(rActor)
	local rRoll = {};
	rRoll.sType = "fumble";
	rRoll.sDesc = "[FUMBLE]";
	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	local bIsSourcePC = (nodeActor and sActorType == "pc");
	
	rRoll.aDice = DB.getValue(nodeActor, "fumbledie", {"d4"});
	rRoll.nMod = 0 - DB.getValue(nodeActor, "abilities.luck.bonus", 0);
	if bIsSourcePC then
		rRoll.nMod = rRoll.nMod + DB.getValue(nodeActor, "fumblebonus", 0);
	else		
		local nLuckScore = DB.getValue(nodeActor, "abilities.luck.score", 0);
		if nLuckScore == 0 then
			rRoll.nMod = 0;
		end		
	end
		
	-- Fumble die message
	local sFumbleDie = rRoll.aDice[1];
	rRoll.sDesc = rRoll.sDesc .. " (" .. sFumbleDie;
	if rRoll.nMod > 0 then
		rRoll.sDesc = rRoll.sDesc .. "+" .. rRoll.nMod;
	elseif rRoll.nMod < 0 then
		rRoll.sDesc = rRoll.sDesc .. rRoll.nMod;
	end	
	rRoll.sDesc = rRoll.sDesc .. ")";
	
	return rRoll;
end

function performRoll(draginfo, rActor)
	local rRoll = getRoll(rActor);
	
	ActionsManager.performAction(draginfo, rActor, rRoll);
end

function modRoll(rSource, rTarget, rRoll)
	local aAddDesc = {};
	local aAddDice = {};
	local nAddMod = 0;
	
	if rSource then
		local bEffects = false;

		-- Get ability modifiers
		local nBonusStat, nBonusEffects = ActorManager2.getAbilityEffectsBonus(rSource, "luck");
		if nBonusEffects > 0 then
			bEffects = true;
			nAddMod = nAddMod - nBonusStat;
		end

		-- If effects, then add them
		if bEffects then
			local sEffects = "";
			local sMod = StringManager.convertDiceToString(aAddDice, nAddMod, true);
			if sMod ~= "" then
				sEffects = "[" .. Interface.getString("effects_tag") .. " " .. sMod .. "]";
			else
				sEffects = "[" .. Interface.getString("effects_tag") .. "]";
			end
			table.insert(aAddDesc, sEffects);
		end
	end
	
	if #aAddDesc > 0 then
		rRoll.sDesc = rRoll.sDesc .. " " .. table.concat(aAddDesc, " ");
	end
	
	for _,vDie in ipairs(aAddDice) do
		if vDie:sub(1,1) == "-" then
			table.insert(rRoll.aDice, "-p" .. vDie:sub(3));
		else
			table.insert(rRoll.aDice, "p" .. vDie:sub(2));
		end
	end
	
	rRoll.nMod = rRoll.nMod + nAddMod;
end

function onRoll(rSource, rTarget, rRoll)
	local nTotal = ActionsManager.total(rRoll);

	local rMessage = ActionsManager.createActionMessage(rSource, rRoll);

	rMessage.text = rMessage.text .. " => " .. getRollMessage(nTotal);

	Comm.deliverChatMessage(rMessage);
end
