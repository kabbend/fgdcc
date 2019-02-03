-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local critT = {
	["I"] = {
		{ r1 = -99, r2 = 0, text = "" },
		{ r1 = 1, r2 = 1, text = "" },
		{ r1 = 2, r2 = 2, text = "" },
		{ r1 = 3, r2 = 3, text = "" },
		{ r1 = 4, r2 = 4, text = "" },
		{ r1 = 5, r2 = 5, text = "" },
		{ r1 = 6, r2 = 6, text = "" },
		{ r1 = 7, r2 = 7, text = "" },
		{ r1 = 8, r2 = 8, text = "" },
		{ r1 = 9, r2 = 9, text = "" },
		{ r1 = 10, r2 = 10, text = "" },
		{ r1 = 11, r2 = 11, text = "" },
		{ r1 = 12, r2 = 12, text = "" },
		{ r1 = 13, r2 = 13, text = "" },
		{ r1 = 14, r2 = 14, text = "" },
		{ r1 = 15, r2 = 15, text = "" },
		{ r1 = 16, r2 = 16, text = "" },
		{ r1 = 17, r2 = 17, text = "" },
		{ r1 = 18, r2 = 18, text = "" },
		{ r1 = 19, r2 = 19, text = "" },
		{ r1 = 20, r2 = 20, text = "" },
		{ r1 = 21, r2 = 21, text = "" },
		{ r1 = 22, r2 = 22, text = "" },
		{ r1 = 23, r2 = 23, text = "" },
		{ r1 = 24, r2 = 24, text = "" },
		{ r1 = 25, r2 = 25, text = "" },
		{ r1 = 26, r2 = 26, text = "" },
		{ r1 = 27, r2 = 27, text = "" },
		{ r1 = 28, r2 = 99, text = "" }
		},
	["II"] = {
		{ r1 = -99, r2 = 0, text = "Une seconde d hesitation vous fait rater le coup parfait !" },
		{ r1 = 1, r2 = 1, text = "Vous ratez les organes vitaux de votre adversaire et n obtenez que 2D3 points de degats supplementaires." },
		{ r1 = 2, r2 = 2, text = "Vous coupez une des oreilles de votre adversaire qui subit 1D6 points de degats supplementaires." },
		{ r1 = 3, r2 = 3, text = "Vous parvenez a toucher votre adversaire dans le dos. +2D6 degats" },
		{ r1 = 4, r2 = 4, text = "Vous faites tituber votre adversaire, vous pouvez l attaquer a nouveau." },
		{ r1 = 5, r2 = 5, text = "Vous frappez votre adversaire dans les reins, il reste sonne pendant un round (et mange +3D3 points de degats)." },
		{ r1 = 6, r2 = 6, text = "Votre adversaire est submerge par votre attaque, sa vitesse et le nombre de ses actions est divise par deux." },
		{ r1 = 7, r2 = 7, text = "Votre adversaire a parle de votre mere en termes peu elogieux : +3D4 points de degats." },
		{ r1 = 8, r2 = 8, text = "Votre coup fait couler du sang dans les yeux de votre adversaire, il est aveugle pendant 1D4 rounds." },
		{ r1 = 9, r2 = 9, text = "Vous faites tomber votre adversaire, attaquez-le une seconde fois !" },
		{ r1 = 10, r2 = 10, text = "Coup magistral qui vous vaut l admiration de tous les combattants : +2D6 points de degats." },
		{ r1 = 11, r2 = 11, text = "Votre coup tranche le larynx de votre ennemi dont l eloquence se voit reduite a des bruits de succions indistincts." },
		{ r1 = 12, r2 = 12, text = "Coup brutal ! Votre adversaire doit reussir un jet de Vigueur (diff.10 + niveau de votre PJ) ou s evanouir sous la violence du coup." },
		{ r1 = 13, r2 = 13, text = "Vos attaques successives desorientent votre adversaire qui subit un malus de -4 a ses attaques pendant 1D4 rounds." },
		{ r1 = 14, r2 = 14, text = "Pleine tete ! Votre adversaire doit reussir un jet de Vigueur (diff.10 + niveau de votre PJ) sinon il est assomme." },
		{ r1 = 15, r2 = 15, text = "Votre coup envoie votre adversaire au sol. +2D6 points de degats." },
		{ r1 = 16, r2 = 16, text = "Un coup rapide au visage fait eclater l oeil de votre adversaire comme un raisin trop mur. Il ne peut pas agir pendant 1D3 rounds (et devient borgne)." },
		{ r1 = 17, r2 = 17, text = "Poumon perfore ! +2D6 points de degats. Votre adversaire n a droit qu a une action au round suivant." },
		{ r1 = 18, r2 = 18, text = "Coup devastateur a l arriere de la tete. +1D8 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.10 + niveau de votre PJ) ou il s effondre sous la violence du coup." },
		{ r1 = 19, r2 = 19, text = "Artere sectionnee ! Geyser de sang ! 1D10 points de degats supplementaires ! Votre adversaire doit reussir un jet de Vigueur (diff.10 + niveau de votre PJ) ou il perd conscience suite a une hemorragie massive." },
		{ r1 = 20, r2 = 20, text = "Ca va saigner, c est la trachee ! 2D6 points de degats supplementaires. Votre adversaire doit reussir un jet de Vigueur (diff.13 + niveau de votre PJ) ou il meurt au bout d 1D4 rounds" },
		{ r1 = 21, r2 = 21, text = "Colonne vertebrale fracassee ! 3D6 points de degats supplementaires. Votre adversaire doit réussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou il devient paraplegique." },
		{ r1 = 22, r2 = 22, text = "Vous avez embroche votre adversaire (et un certains nombre d organes internes au passage). +2D6 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.13 + niveau de votre PJ) ou il meurt au bout d 1D4 rounds." },
		{ r1 = 23, r2 = 23, text = "Votre coup transperce l oreille de votre adversaire et atteint directement le cerveau. Plus aucune trace de cerumen et votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou mourir sur le champ. Meme s il survit il encaisse 2D6 points de degats supplementaires." },
		{ r1 = 24, r2 = 99, text = "En plein coeur ! +3D6 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.20 + niveau de votre PJ) ou il meurt sur le coup." },
		},
	["III"] = {
		{ r1 = -99, r2 = 0, text = "La rage vous empeche de faire la difference entre vos amis et vos allies. Infligez 1D12 points de degats supplementaires a un adversaire pendant que votre allie le plus proche encaisse 1D6 points de dégats." },
		{ r1 = 1, r2 = 1, text = "Votre attaque manque de precision mais pas de sauvagerie. +1D6 points de degats." },
		{ r1 = 2, r2 = 2, text = "Votre attaque balaye votre adversaire qui se retrouve couche sur le sol au prochain round." },
		{ r1 = 3, r2 = 3, text = "Votre adversaire se jette sur votre arme suite a une feinte malheureuse. 1D8 points de degats supplementaires." },
		{ r1 = 4, r2 = 4, text = "La puissance de votre coup met votre adversaire a genoux, attaquez-le une nouvelle fois !" },
		{ r1 = 5, r2 = 5, text = "Le nez de votre adversaire eclate dans une gerbe de sang. +1D6 points de degats. Votre adversaire perd le sens de l odorat pendant 1D4 heures." },
		{ r1 = 6, r2 = 6, text = "Coup brutal au torse. 1D8 points de degats supplementaires et quelques cotes casses pour votre adversaire." },
		{ r1 = 7, r2 = 7, text = "Vous desarmez votre adversaire dont l arme vole a 1D8 metres." },
		{ r1 = 8, r2 = 8, text = "Un bon coup sur l oreille de votre adversaire le rend sourd pendant 1D6 jours. +1D6 points de degats." },
		{ r1 = 9, r2 = 9, text = "Vous eclatez un des femurs de votre adversaire. +2D6 points de dégats et -10  a la vitesse de votre adversaire." },
		{ r1 = 10, r2 = 10, text = "L arme de votre adversaire se brise sous votre coup, projetant des eclats et des debris tout autour de vous." },
		{ r1 = 11, r2 = 11, text = "La violence de votre coup provoque une hemorragie interne chez votre adversaire. S il ne recoit pas des soins magiques il meurt dans un delai d 1D5 heures." },
		{ r1 = 12, r2 = 12, text = "Le plat de votre arme atterrit violemment sur le crane de votre adversaire. Il doit reussir un jet de Vigueur (diff.10 + niveau de votre PJ) ou s evanouir sous la violence du choc." },
		{ r1 = 13, r2 = 13, text = "Votre coup éclate la machoire de votre adversaire dans une pluie de sang et de dents. +1D8 points de degats." },
		{ r1 = 14, r2 = 14, text = "Votre adversaire met en doute la conduite exemplaire de votre maman. +2D8 points de degats." },
		{ r1 = 15, r2 = 15, text = "Votre coup deboite l epaule de votre adversaire. +1D8 points de degats. Le bras non arme de votre adversaire pend mollement le long de son corps." },
		{ r1 = 16, r2 = 16, text = "Votre attaque transforme la main armee de votre adversaire en une masse sanguinolente : il subit un malus de -4 à ces attaques jusqu à ce qu il soit soigne." },
		{ r1 = 17, r2 = 17, text = "Votre attaque balaye votre adversaire qui se retrouve au sol, attaquez-le une nouvelle fois !" },
		{ r1 = 18, r2 = 18, text = "La violence de votre coup envoie des eclats d os dans le cerveau de votre adversaire qui commence à perdre sa matière grise par les narines. +1D8 points de degats et votre adversaire perd 1D4 points en Intelligence et en Presence." },
		{ r1 = 19, r2 = 19, text = "Vous percutez votre adversaire à la vitesse d un cheval au galop. +2D8 points de degats." },
		{ r1 = 20, r2 = 20, text = "Coup à la poitrine qui sonne l adversaire pendant 1D3 rounds. +1D8 points de degats." },
		{ r1 = 21, r2 = 21, text = "Votre coup éclate un des femurs de votre adversaire et le projette au sol. La vitesse de votre adversaire est divisee par 2, ajoutez 2D8 points de degats et saupoudrez avec une attaque supplementaire." },
		{ r1 = 22, r2 = 22, text = "Les os du bras armé de votre adversaire sont brises par votre attaque : l arme tombe au sol et le bras est inutilisable." },
		{ r1 = 23, r2 = 23, text = "Votre coup deforme le crane de votre adversaire qui subit 2D8 points de degats supplémentaires. Il perd egalement 1D4 points d Intelligence et de Presence de facon permanente." },
		{ r1 = 24, r2 = 24, text = "Coup magistral a la gorge. +2D8 points de degats. La victime titube en essayant de reprendre son souffle pendant 1D4 rounds." },
		{ r1 = 25, r2 = 25, text = "Des cotes brisees par votre attaque perforent les poumons de votre adversaire. La victime perd la moitie des points de vie qui lui restait et vomit du sang en quantite industrielle." },
		{ r1 = 26, r2 = 26, text = "Votre attaque defigure litteralement votre adversaire qui perd ses deux yeux et subit en prime 2D8 points de degats supplementaires. Doit-on preciser que l infortunee victime est desormais aveugle ?" },
		{ r1 = 27, r2 = 27, text = "Coup devastateur a la poitrine. +3D8 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou sombrer dans l inconscience." },
		{ r1 = 28, r2 = 99, text = "Votre coup brise la colonne vertebrale de votre adversaire. +3D8 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou il est paralyse." }
		},
	["IV"] = {
		{ r1 = -99, r2 = 0, text = "" },
		{ r1 = 1, r2 = 1, text = "" },
		{ r1 = 2, r2 = 2, text = "" },
		{ r1 = 3, r2 = 3, text = "" },
		{ r1 = 4, r2 = 4, text = "" },
		{ r1 = 5, r2 = 5, text = "" },
		{ r1 = 6, r2 = 6, text = "" },
		{ r1 = 7, r2 = 7, text = "" },
		{ r1 = 8, r2 = 8, text = "" },
		{ r1 = 9, r2 = 9, text = "" },
		{ r1 = 10, r2 = 10, text = "" },
		{ r1 = 11, r2 = 11, text = "" },
		{ r1 = 12, r2 = 12, text = "" },
		{ r1 = 13, r2 = 13, text = "" },
		{ r1 = 14, r2 = 14, text = "" },
		{ r1 = 15, r2 = 15, text = "" },
		{ r1 = 16, r2 = 16, text = "" },
		{ r1 = 17, r2 = 17, text = "" },
		{ r1 = 18, r2 = 18, text = "" },
		{ r1 = 19, r2 = 19, text = "" },
		{ r1 = 20, r2 = 20, text = "" },
		{ r1 = 21, r2 = 21, text = "" },
		{ r1 = 22, r2 = 22, text = "" },
		{ r1 = 23, r2 = 23, text = "" },
		{ r1 = 24, r2 = 24, text = "" },
		{ r1 = 25, r2 = 25, text = "" },
		{ r1 = 26, r2 = 26, text = "" },
		{ r1 = 27, r2 = 27, text = "" },
		{ r1 = 28, r2 = 99, text = "" }
		},
	["V"] = {
		{ r1 = -99, r2 = 0, text = "" },
		{ r1 = 1, r2 = 1, text = "" },
		{ r1 = 2, r2 = 2, text = "" },
		{ r1 = 3, r2 = 3, text = "" },
		{ r1 = 4, r2 = 4, text = "" },
		{ r1 = 5, r2 = 5, text = "" },
		{ r1 = 6, r2 = 6, text = "" },
		{ r1 = 7, r2 = 7, text = "" },
		{ r1 = 8, r2 = 8, text = "" },
		{ r1 = 9, r2 = 9, text = "" },
		{ r1 = 10, r2 = 10, text = "" },
		{ r1 = 11, r2 = 11, text = "" },
		{ r1 = 12, r2 = 12, text = "" },
		{ r1 = 13, r2 = 13, text = "" },
		{ r1 = 14, r2 = 14, text = "" },
		{ r1 = 15, r2 = 15, text = "" },
		{ r1 = 16, r2 = 16, text = "" },
		{ r1 = 17, r2 = 17, text = "" },
		{ r1 = 18, r2 = 18, text = "" },
		{ r1 = 19, r2 = 19, text = "" },
		{ r1 = 20, r2 = 20, text = "" },
		{ r1 = 21, r2 = 21, text = "" },
		{ r1 = 22, r2 = 22, text = "" },
		{ r1 = 23, r2 = 23, text = "" },
		{ r1 = 24, r2 = 24, text = "" },
		{ r1 = 25, r2 = 25, text = "" },
		{ r1 = 26, r2 = 26, text = "" },
		{ r1 = 27, r2 = 27, text = "" },
		{ r1 = 28, r2 = 99, text = "" }
		},
	["M"] = {
		{ r1 = -99, r2 = 0, text = "" },
		{ r1 = 1, r2 = 1, text = "" },
		{ r1 = 2, r2 = 2, text = "" },
		{ r1 = 3, r2 = 3, text = "" },
		{ r1 = 4, r2 = 4, text = "" },
		{ r1 = 5, r2 = 5, text = "" },
		{ r1 = 6, r2 = 6, text = "" },
		{ r1 = 7, r2 = 7, text = "" },
		{ r1 = 8, r2 = 8, text = "" },
		{ r1 = 9, r2 = 9, text = "" },
		{ r1 = 10, r2 = 10, text = "" },
		{ r1 = 11, r2 = 11, text = "" },
		{ r1 = 12, r2 = 12, text = "" },
		{ r1 = 13, r2 = 13, text = "" },
		{ r1 = 14, r2 = 14, text = "" },
		{ r1 = 15, r2 = 15, text = "" },
		{ r1 = 16, r2 = 16, text = "" },
		{ r1 = 17, r2 = 17, text = "" },
		{ r1 = 18, r2 = 18, text = "" },
		{ r1 = 19, r2 = 19, text = "" },
		{ r1 = 20, r2 = 20, text = "" },
		{ r1 = 21, r2 = 21, text = "" },
		{ r1 = 22, r2 = 22, text = "" },
		{ r1 = 23, r2 = 23, text = "" },
		{ r1 = 24, r2 = 24, text = "" },
		{ r1 = 25, r2 = 25, text = "" },
		{ r1 = 26, r2 = 26, text = "" },
		{ r1 = 27, r2 = 27, text = "" },
		{ r1 = 28, r2 = 99, text = "" }
		},
	};

function onInit()
	ActionsManager.registerModHandler("critical", modRoll);
	ActionsManager.registerResultHandler("critical", onRoll);
end

function mysplit(inputstr, sep)
  			if sep == nil then sep = "%s" end
        			local t={}
        			for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                		table.insert(t, str)
        			end
        			return t
			end

function getRoll(rActor)
	local rRoll = {};
	rRoll.sType = "critical";
	rRoll.sDesc = "[CRITICAL]";

	
	local sActorType, nodeActor = ActorManager.getTypeAndNode(rActor);
	local bIsSourcePC = (nodeActor and sActorType == "pc");
	
	local sCritTable = "";
	local sCritDie = "d4";
	rRoll.nMod = DB.getValue(nodeActor, "abilities.luck.bonus", 0);
	
	if bIsSourcePC then

		-- for a PC, crittable is really the table (eg. "I" or "II")
		-- the die is stored separately

		rRoll.aDice = DB.getValue(nodeActor, "critdie", {"d4"});
		rRoll.nMod = rRoll.nMod + DB.getValue(nodeActor, "critbonus", 0);
		sCritDie = rRoll.aDice[1];
		sCritTable = DB.getValue(nodeActor, "crittable", "I");

	else

		-- for a NPC, crittable is a combination of both, separated by / (eg. "II/d4")

		local sCrit = DB.getValue(nodeActor, "crittable", "");
		if sCrit ~= "" then
			local t = mysplit( sCrit , "/" );
			if t[1] then sCritTable = t[1]:match("%s*[%a]+"); end
			if t[2] then sCritDie = t[2]:match("%s*([d%d]+)"); end
		else
			sCritTable = "M";	
		end
		rRoll.aDice = StringManager.convertStringToDice(sCritDie);
		
		local nLuckScore = DB.getValue(nodeActor, "abilities.luck.score", 0);
		if nLuckScore == 0 then
			rRoll.nMod = 0;
		end
	end

	-- Crit die message
	rRoll.sDesc = rRoll.sDesc .. " (" .. sCritDie;
	if rRoll.nMod > 0 then
		rRoll.sDesc = rRoll.sDesc .. "+" .. rRoll.nMod;
	elseif rRoll.nMod < 0 then
		rRoll.sDesc = rRoll.sDesc .. rRoll.nMod;
	end
	if sCritTable ~= "" then
		rRoll.sDesc = rRoll.sDesc .. "/Table " .. sCritTable .. ")";
		rRoll.sCritTable = sCritTable;
	else
		rRoll.sDesc = rRoll.sDesc .. "/Table I)";
		rRoll.sCritTable = "I";
	end
	
	return rRoll;
end

function getRollMessage(sCritTable, nRollValue)
	if not critT[sCritTable] then return "(unknown table)" end;
	for _,tableEntry in ipairs( critT[sCritTable] ) do
		if tableEntry.r1 <= nRollValue and tableEntry.r2 >= nRollValue then return tableEntry.text end
	end
	return "(unknown table)";
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
			nAddMod = nAddMod + nBonusStat;
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

	rMessage.text = rMessage.text .. " => " .. getRollMessage(rRoll.sCritTable, nTotal);

	Comm.deliverChatMessage(rMessage);
end
