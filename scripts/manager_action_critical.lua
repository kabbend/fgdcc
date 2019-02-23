-- 
-- Please see the license.html file included with this distribution for 
-- attribution and copyright information.
--

local critT = {
	["I"] = {
		{ r1 = -99, r2 = 0, text = "La puissance de votre coup vous fait lacher votre arme. Vous infligez 1D6 points de degats supplementaires mais vous etes maintenant desarme." },
		{ r1 = 1, r2 = 1, text = "Coup vicelard : +1D3 points de degats." },
		{ r1 = 2, r2 = 2, text = "En plein dans l oeil ! +1D4 points de degats accompagnes par un enorme coquard." },
		{ r1 = 3, r2 = 3, text = "Le plat de votre arme atterrit sur le crane de votre adversaire. +1D3 points de degats, votre adversaire agira en dernier le round suivant." },
		{ r1 = 4, r2 = 4, text = "Un bon coup dans le genou ! +1D4 points de degats, la vitesse de l'adversaire diminue de 10 pieds jusqu'a ce qu'il soit soigne." },
		{ r1 = 5, r2 = 5, text = "Un coup bien place au torse : 1D6 points de degats supplementaires." },
		{ r1 = 6, r2 = 6, text = "Vous desarmez votre adversaire. Vous avez droit a une attaque gratuite si votre adversaire tente de recuperer son arme." },
		{ r1 = 7, r2 = 7, text = "Vous ecrasez la main de votre adversaire. +2D3 points de degats et deux doigts casses au menu !" },
		{ r1 = 8, r2 = 8, text = "Ca ne saigne pas mais ca fait mal ! Votre adversaire pousse un hurlement d'agonie (et n'attaquera pas au round suivant)." },
		{ r1 = 9, r2 = 9, text = "Nez eclate ! Infligez 2D4 points de degats supplementaires et regardez le sang inonder le visage de votre adversaire." },
		{ r1 = 10, r2 = 10, text = "Vous faites perdre l'equilibre à votre adversaire qui tombe au sol et y reste jusqu'à la fin du round." },
		{ r1 = 11, r2 = 11, text = "Votre coup transperce la pitoyable defense de votre adversaire, armure comprise. +2D4 points de degats." },
		{ r1 = 12, r2 = 12, text = "Coup aux parties. Votre adversaire doit reussir un jet de Vigueur (Diff.15) ou passer les deux rounds suivants a sautiller sur place." },
		{ r1 = 13, r2 = 13, text = "Coup vicieux dans la cheville. La vitesse de votre adversaire est divisee par deux (jusqu'a ce qu'il soit soigne)" },
		{ r1 = 14, r2 = 14, text = "C'est l'arcade sourciliere qui prend : le sang aveugle votre adversaire pendant 1D3 rounds." },
		{ r1 = 15, r2 = 15, text = "Vous desarmez votre adversaire. Son arme vole à 1D3 metres." },
		{ r1 = 16, r2 = 16, text = "Vous echappez de justesse a une contre-attaque de votre adversaire. Vous infligez des degats normaux mais avez droit immediatement à une autre attaque. En cas de succes celle-ci inflige +1D6 points de degats." },
		{ r1 = 17, r2 = 17, text = "Coup à la gorge. Votre adversaire titube pendant 2 rounds, incapable de parler, de lancer un sort ou d'attaquer." },
		{ r1 = 18, r2 = 18, text = "Votre attaque decontenance votre adversaire qui maudit votre chance insolente. +2D6 points de degats." },
		{ r1 = 19, r2 = 19, text = "Coup miraculeux. Votre adversaire doit reussir un jet de Vigueur (diff.20) ou il perd connaissance." },
		{ r1 = 20, r2 = 99, text = "Votre attaque fait craquer le crane de votre ennemi. 2D6 points de degats supplementaires et si votre adversaire ne porte pas de casque il perd 1D4 points d'Intelligence de façon permanente." },
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
		{ r1 = 21, r2 = 21, text = "Colonne vertebrale fracassee ! 3D6 points de degats supplementaires. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou il devient paraplegique." },
		{ r1 = 22, r2 = 22, text = "Vous avez embroche votre adversaire (et un certains nombre d organes internes au passage). +2D6 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.13 + niveau de votre PJ) ou il meurt au bout d 1D4 rounds." },
		{ r1 = 23, r2 = 23, text = "Votre coup transperce l oreille de votre adversaire et atteint directement le cerveau. Plus aucune trace de cerumen et votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou mourir sur le champ. Meme s il survit il encaisse 2D6 points de degats supplementaires." },
		{ r1 = 24, r2 = 99, text = "En plein coeur ! +3D6 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.20 + niveau de votre PJ) ou il meurt sur le coup." },
		},
	["III"] = {
		{ r1 = -99, r2 = 0, text = "La rage vous empeche de faire la difference entre vos amis et vos allies. Infligez 1D12 points de degats supplementaires a un adversaire pendant que votre allie le plus proche encaisse 1D6 points de degats." },
		{ r1 = 1, r2 = 1, text = "Votre attaque manque de precision mais pas de sauvagerie. +1D6 points de degats." },
		{ r1 = 2, r2 = 2, text = "Votre attaque balaye votre adversaire qui se retrouve couche sur le sol au prochain round." },
		{ r1 = 3, r2 = 3, text = "Votre adversaire se jette sur votre arme suite a une feinte malheureuse. 1D8 points de degats supplementaires." },
		{ r1 = 4, r2 = 4, text = "La puissance de votre coup met votre adversaire a genoux, attaquez-le une nouvelle fois !" },
		{ r1 = 5, r2 = 5, text = "Le nez de votre adversaire eclate dans une gerbe de sang. +1D6 points de degats. Votre adversaire perd le sens de l odorat pendant 1D4 heures." },
		{ r1 = 6, r2 = 6, text = "Coup brutal au torse. 1D8 points de degats supplementaires et quelques cotes casses pour votre adversaire." },
		{ r1 = 7, r2 = 7, text = "Vous desarmez votre adversaire dont l arme vole a 1D8 metres." },
		{ r1 = 8, r2 = 8, text = "Un bon coup sur l oreille de votre adversaire le rend sourd pendant 1D6 jours. +1D6 points de degats." },
		{ r1 = 9, r2 = 9, text = "Vous eclatez un des femurs de votre adversaire. +2D6 points de degats et -10  a la vitesse de votre adversaire." },
		{ r1 = 10, r2 = 10, text = "L arme de votre adversaire se brise sous votre coup, projetant des eclats et des debris tout autour de vous." },
		{ r1 = 11, r2 = 11, text = "La violence de votre coup provoque une hemorragie interne chez votre adversaire. S il ne recoit pas des soins magiques il meurt dans un delai d 1D5 heures." },
		{ r1 = 12, r2 = 12, text = "Le plat de votre arme atterrit violemment sur le crane de votre adversaire. Il doit reussir un jet de Vigueur (diff.10 + niveau de votre PJ) ou s evanouir sous la violence du choc." },
		{ r1 = 13, r2 = 13, text = "Votre coup eclate la machoire de votre adversaire dans une pluie de sang et de dents. +1D8 points de degats." },
		{ r1 = 14, r2 = 14, text = "Votre adversaire met en doute la conduite exemplaire de votre maman. +2D8 points de degats." },
		{ r1 = 15, r2 = 15, text = "Votre coup deboite l epaule de votre adversaire. +1D8 points de degats. Le bras non arme de votre adversaire pend mollement le long de son corps." },
		{ r1 = 16, r2 = 16, text = "Votre attaque transforme la main armee de votre adversaire en une masse sanguinolente : il subit un malus de -4 à ces attaques jusqu à ce qu il soit soigne." },
		{ r1 = 17, r2 = 17, text = "Votre attaque balaye votre adversaire qui se retrouve au sol, attaquez-le une nouvelle fois !" },
		{ r1 = 18, r2 = 18, text = "La violence de votre coup envoie des eclats d os dans le cerveau de votre adversaire qui commence à perdre sa matière grise par les narines. +1D8 points de degats et votre adversaire perd 1D4 points en Intelligence et en Presence." },
		{ r1 = 19, r2 = 19, text = "Vous percutez votre adversaire à la vitesse d un cheval au galop. +2D8 points de degats." },
		{ r1 = 20, r2 = 20, text = "Coup à la poitrine qui sonne l adversaire pendant 1D3 rounds. +1D8 points de degats." },
		{ r1 = 21, r2 = 21, text = "Votre coup eclate un des femurs de votre adversaire et le projette au sol. La vitesse de votre adversaire est divisee par 2, ajoutez 2D8 points de degats et saupoudrez avec une attaque supplementaire." },
		{ r1 = 22, r2 = 22, text = "Les os du bras arme de votre adversaire sont brises par votre attaque : l arme tombe au sol et le bras est inutilisable." },
		{ r1 = 23, r2 = 23, text = "Votre coup deforme le crane de votre adversaire qui subit 2D8 points de degats supplémentaires. Il perd egalement 1D4 points d Intelligence et de Presence de facon permanente." },
		{ r1 = 24, r2 = 24, text = "Coup magistral a la gorge. +2D8 points de degats. La victime titube en essayant de reprendre son souffle pendant 1D4 rounds." },
		{ r1 = 25, r2 = 25, text = "Des cotes brisees par votre attaque perforent les poumons de votre adversaire. La victime perd la moitie des points de vie qui lui restait et vomit du sang en quantite industrielle." },
		{ r1 = 26, r2 = 26, text = "Votre attaque defigure litteralement votre adversaire qui perd ses deux yeux et subit en prime 2D8 points de degats supplementaires. Doit-on preciser que l infortunee victime est desormais aveugle ?" },
		{ r1 = 27, r2 = 27, text = "Coup devastateur a la poitrine. +3D8 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou sombrer dans l inconscience." },
		{ r1 = 28, r2 = 99, text = "Votre coup brise la colonne vertebrale de votre adversaire. +3D8 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou il est paralyse." }
		},
	["IV"] = {
		{ r1 = -99, r2 = 0, text = "La rage vous empeche de faire la difference entre vos amis et vos allies. Infligez 1D12 points de degats supplementaires a un adversaire pendant que votre allie le plus proche encaisse 1D6 points de dégats." },
		{ r1 = 1, r2 = 1, text = "La ferocite de votre attaque ferait passer un demon pour en enfant de choeur. +2D12 points de degats." },
		{ r1 = 2, r2 = 2, text = "Votre attaque laisse la main arme de votre adversaire pendouiller au bout de ce qui reste de son poignet. +1D12 points de degats." },
		{ r1 = 3, r2 = 3, text = "Votre attaque balaye votre adversaire qui se retrouve au sol, vous infligez 1D12 points de degats supplementaires et vous pouvez l attaquer une nouvelle fois!" },
		{ r1 = 4, r2 = 4, text = "Un coup remontant propulse le cartilage du nez de votre adversaire dans son cerveau. +1D12 points de degats et la victime perd 1D6 point d Intelligence." },
		{ r1 = 5, r2 = 5, text = "Vous brisez l arme de votre adversaire. Si celui-ci n a pas d armes, vous infligez 2D12 points de degats supplémentaires." },
		{ r1 = 6, r2 = 6, text = "Vous sentez le sternum de votre adversaire se briser sous votre coup. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) ou tomber dans l inconscience suite à l effondrement de ses organes internes." },
		{ r1 = 7, r2 = 7, text = "Vos assauts repetes font reculer votre adversaire qui doit renoncer à sa prochaine attaque et subit de surcroit 2D12 points de degats supplementaires." },
		{ r1 = 8, r2 = 8, text = "La violence de votre attaque laisse votre adversaire completement hebete. +1D8 points de degats et une attaque supplementaire devraient vous permettre de l achever." },
		{ r1 = 9, r2 = 9, text = "Votre coup ecrase la gorge de votre adversaire jusqu a ce que sa trachee touche sa colonne vertebrale réduisant en puree tout ce qui se trouve au milieu. 2D12 points de degats supplementaires et votre adversaire devient muet pour 1D4 semaines." },
		{ r1 = 10, r2 = 10, text = "Votre coup touche la tempe de votre adversaire. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) sinon il est aveugle par le sang et la douleur." },
		{ r1 = 11, r2 = 11, text = "Votre coup reduit le visage de votre adversaire en une masse sanguinolente. Résultat 2D12 points de degats supplementaires et un adversaire qui a du mal a prononcer les consonnes" },
		{ r1 = 12, r2 = 12, text = "Voile rouge ! La rage qui vous habite vous permet d infliger 1D12 points de degats supplementaires." },
		{ r1 = 13, r2 = 13, text = "Un coup violent au torse reduit les organes internes de votre ennemi en puree. +2D12 points de degats." },
		{ r1 = 14, r2 = 14, text = "Un coup à la colonne vertebrale engourdit les membres inferieurs de la cible. Celle-ci subit un malus de -4 à sa CA le temps de reapprendre a marcher." },
		{ r1 = 15, r2 = 15, text = "Votre coup projette l ennemi sur le sol ensanglante. Il se recroqueville en position foetale pendant 1D4 rounds." },
		{ r1 = 16, r2 = 16, text = "Votre coup eclate le bouclier de votre adversaire. +2D12 points de degats. Si l adversaire n a pas de bouclier il est sonne par la douleur pendant 1D4 rounds." },
		{ r1 = 17, r2 = 17, text = "Une des rotules de votre adversaire viens d exploser dans un nuage rouge. La vitesse de votre ennemi est reduite à 0 et vous avez droit a une nouvelle attaque." },
		{ r1 = 18, r2 = 18, text = "Lobotomie frontale. +1D12 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) sinon il est frappe d amnesie. Quoiqu il arrive il est sonne pendant 1D4 rounds." },
		{ r1 = 19, r2 = 19, text = "Vous renvoyez l arme de votre adversaire vers son visage. Il subit les degats de son arme X3 en pleine face. Il lâche ensuite son arme, encore abasourdi par sa maladresse et la violence de votre attaque." },
		{ r1 = 20, r2 = 20, text = "Votre coup ecrase la moelle epiniere de votre adversaire. +3D12 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff.15 + niveau de votre PJ) sinon il est paralyse de facon permanente." },
		{ r1 = 21, r2 = 21, text = "Votre coup transforme les organes internes de votre adversaire en gelee de groseilles. Il doit faire face a une mort inevitable dans 1D8 rounds." },
		{ r1 = 22, r2 = 22, text = "Vous eviscerez votre ennemi qui meurt au bout d 1D6 rounds pendant que ses tripes se deversent sur le sol." },
		{ r1 = 23, r2 = 23, text = "Un coup a la poitrine fait exploser le coeur. +3D12 points de degats. Votre adversaire doit réussir un jet de Vigueur (diff.15 + niveau de votre PJ) sinon il meurt sur le coup." },
		{ r1 = 24, r2 = 99, text = "Vous ecrasez la tete de votre adversaire comme un melon trop mur. +3D12 points de degats. Votre adversaire doit reussir un jet de Vigueur (diff. 20 + niveau de votre PJ) sinon il meurt au bout d 1D3 rounds." },
		},
	["V"] = {
		{ r1 = -99, r2 = 0, text = "La rage vous empeche de faire la difference entre vos amis et vos allies. Infligez 3D8 points de degats supplementaires a un adversaire pendant que votre allie le plus proche encaisse 1D4 points de degats." },
		{ r1 = 1, r2 = 1, text = "Vous brisez l arme de votre adversaire. Si celui-ci n a pas d armes, vous infligez 3D12 points de degats supplementaires." },
		{ r1 = 2, r2 = 2, text = "Vos assauts repetes font reculer votre adversaire de 10 . Tout adversaire à proximite le blesse par accident (degats normaux)." },
		{ r1 = 3, r2 = 3, text = "Vous debouchez une des oreilles de votre adversaire. +1D12 points de degats et la victime devient sourde de cette oreille." },
		{ r1 = 4, r2 = 4, text = "Coup aux tripes. Votre adversaire doit reussir un jet de Vigueur (diff.20 + niveau de votre PJ) où il passera les deux prochains rounds à vomir la bile venue de son estomac perfore." },
		{ r1 = 5, r2 = 5, text = "Votre adversaire jette son arme et demande grace. Infligez 1D12 points de degats supplementaires et attaquez-le une nouvelle fois." },
		{ r1 = 6, r2 = 6, text = "Votre coup scalpe votre adversaire qui est aveugle par le sang qui ne cesse de couler dans ses yeux. En fait il est aveugle jusqu à ce qu il soit soigne." },
		{ r1 = 7, r2 = 7, text = "Votre adversaire s est emmêle sur votre arme, reduisant sa CA de -6, profitez-en pour l attaquer une nouvelle fois." },
		{ r1 = 8, r2 = 12, text = "Voile rouge ! La rage* qui vous habite vous permet d infliger 1D12 points de degats supplementaires." },
		{ r1 = 13, r2 = 14, text = "Vous repoussez l arme de votre adversaire vers lui. Il subit les degats de son arme X4 en pleine face. Il lache ensuite son arme, encore abasourdi par sa maladresse et la violence de votre attaque." },
		{ r1 = 15, r2 = 15, text = "Votre coup eclate le bouclier de votre adversaire. +2D12 points de degats. Si l adversaire n a pas de bouclier il doit reussir un jet de Vigueur (diff. 20 + niveau de votre PJ) ou tombe inconscient en raison de la douleur." },
		{ r1 = 16, r2 = 16, text = "Un coup sur le crane de votre adversaire reduit sa taille de 15cm. Les degats nerveux occasionne par cette blessure reduisent la CA de l adversaire de -4." },
		{ r1 = 17, r2 = 17, text = "Vous eviscerez votre ennemi et regardez ses entrailles qui se repandent sur le sol, il meurt sur le coup." },
		{ r1 = 18, r2 = 18, text = "Votre coup reduit le visage de votre adversaire en une masse sanguinolente. Votre adversaire devient immediatement aveugle et sourd et ne peut plus emettre que des gargouillis depourvus de sens." },
		{ r1 = 19, r2 = 19, text = "Votre coup decalotte le crane de votre adversaire. Il meurt après que son cerveau ait ete expose aux yeux de tous pendant 3D3 rounds." },
		{ r1 = 20, r2 = 20, text = "Vous tranchez le bras non-arme de votre adversaire. +2D12 points de degats. Vous ruinez egalement les espoirs de votre adversaire de devenir un maitre du combat à deux mains." },
		{ r1 = 21, r2 = 21, text = "Votre attaque semble guider par les dieux. +3D12 points de degats. Si la cible meurt vous pouvez attaquer un autre adversaire se trouvant dans un rayon de 10  autour de vous." },
		{ r1 = 22, r2 = 22, text = "Vous tranchez la jambe de votre adversaire. La vitesse de votre ennemi est reduite à 0 et il ne peut rien faire d autre à part hurler d agonie pendant 1D4 rounds." },
		{ r1 = 23, r2 = 23, text = "Un coup violent sur le crane sonne votre adversaire pendant 1D4+1 rounds et reduit son Intelligence d 1D12 point de façon permanente. Profitez-en pour l attaquer à nouveau." },
		{ r1 = 24, r2 = 24, text = "Votre attaque sectionne le bras arme de votre adversaire. +2D12 points de degats. Vous êtes maintenant face à un manchot qui a une dent contre vous." },
		{ r1 = 25, r2 = 25, text = "Un coup devastateur au torse vide les intestins de votre adversaire et reduit ses organes internes en puree. Il perd 50% des points de vie qui lui reste ainsi que sa dignite." },
		{ r1 = 26, r2 = 26, text = "Votre coup broie la gorge de votre adversaire qui se noie dans son propre sang au bout d 1D4 rounds." },
		{ r1 = 27, r2 = 27, text = "Coup violent à la colonne vertebrale. +4D12 points de degats et votre adversaire est paralyse de façon permanente." },
		{ r1 = 28, r2 = 99, text = "Votre adversaire est decapite en un coup. Vous êtes la mort incarnee, continuez à attaquer tous les ennemis dans un rayon de 10  jusqu à ce qu une de vos attaques soit un echec." }
		},
	["U"] = {
		{ r1 = -99, r2 = 1, text = "Unnatural boils sprout spontaneously around the wound. These are extremely painful to the touch, and automatically in ict 1 point of damage in any round where the character exerts himself physically (such as running, jumping, and  ghting). The boils can only be healed with magical healing." },
		{ r1 = 2, r2 = 2, text = "The cold touch of un-death spreads across the wound. This attack inflicts +1d4 damage and the PC gets the chills, chattering his teeth noisily until magically healed." },
		{ r1 = 3, r2 = 3, text = "The numbness of death spreads around the wounded area. This attack inflicts +1d4 damage and the PC slowly loses sensation. On the next round, he must make a Fort save against DC 2. Failure means he is paralyzed. This  rst save is easy, but he must make another save against DC 3 on the next round, then against DC 4, then DC 5, and so on. If he makes every save to DC 20, he shakes off the numbness and is unaffected. If a single save is failed, the PC is paralyzed—he is insensitive to any sensation and completely numb and unable to move. The paralysis can be cured by any magical healing." },
		{ r1 = 4, r2 = 4, text = "The horrifying visage of life after death infects the PC s thoughts as the un-dead leers into his eyes with its attack. The PC must make a DC 15 Fort save or be shaken and unable to move or attack for the next 1d4 rounds" },
		{ r1 = 5, r2 = 5, text = "The character is cursed from beyond the grave! Depending on his actions and the intelligence of the un-dead creature, the curse may have speci c terms associated with the wishes of the un-dead (judge s discretion; see Appendix C). Alternately, the curse causes a -1 penalty to Luck and all dice rolls until lifted." },
		{ r1 = 6, r2 = 6, text = "The wound blackens immediately and a horrid infection from beyond the grave begins to spread. The character must make a DC 10 Fort save or temporarily lose 1d4 Stamina. The infection continues to attack each day, forcing another DC 10 Fort save each morning (failure results in the loss of another 1d4 Stamina) until the infection is magically expunged. The character does not heal while infected." },
		{ r1 = 7, r2 = 7, text = "Supernatural frost spreads out from the wound in a lacy web, causing an additional 1d8 damage and intense pain. The frost dissipates on the next round but until the next full moon, the PC takes an extra 1 point of damage from all cold-based attacks." },
		{ r1 = 8, r2 = 8, text = "Necrotic energies leap from the un-dead in a sizzling flash, enervating the character. The PC loses 2d4 Stamina temporarily." },
		{ r1 = 9, r2 = 9, text = "Faced with the very real prospect of unnatural un-death, the PC becomes unhinged. He immediately loses 1d4 Personality and goes temporarily insane, behaving erratically and strangely until the next new moon. The controlling player must make a percentile roll before any action, and on 01-10 the character makes an insane action (as determined by the judge) instead of what was intended. On 11-00 the intended action occurs." },
		{ r1 = 10, r2 = 10, text = "The visage of rotting un-death brings the horror of the grave to the character s thoughts. He must make a DC 16 Fort save or be shaken with fear, unable to attack or do anything except quake in fear for 1d4 rounds." },
		{ r1 = 11, r2 = 11, text = "Strange electrical sparks leap from the attacking un-dead, causing an additional 1d10 damage." },
		{ r1 = 12, r2 = 12, text = "The attack is imbued with some unnatural remnant of un-dead slumber. The character must make a DC 16 Fort save or fall asleep, instantly and deeply. He will not awaken for 1d7 hours or until shaken violently." },
		{ r1 = 13, r2 = 13, text = "The attack is infused with powerful necromantic energies which cause the character s skin to  ake and rot! His  esh begins to fall off in large chunks, exposing the muscle and bone below. This is extremely painful and debilitating. The character loses an extra 1d8 hit points and 1 point of Personality immediately and again every morning thereafter as his  esh slowly rots. He dies when his Personality reaches 0. The rot can be arrested only by powerful magical healing." },
		{ r1 = 14, r2 = 14, text = "The strike of un-death saps the PC s energy. The character temporarily loses 1d4 Str and must make a DC 12 Fort save or lose an additional 1d4 Str." },
		{ r1 = 15, r2 = 15, text = "Strange spectral energies arc to the PC s body, making him temporarily incorporeal for 1d4 rounds. The PC cannot grasp physical objects. He cannot speak, make noise, attack, or be seen in bright light. He can  y at his normal movement rate and can pass through solid objects at half speed. He is considered un-dead while incorporeal. There is a 1 percent chance the transition is permanent." },
		{ r1 = 16, r2 = 16, text = "A disgusting grave rot immediately spreads around the wound, causing an additional 2d6 damage and forcing a DC 16 Fort save. Failure on the save causes an additional temporary loss of 1d4 Stamina. The rot gets progressively worse until magically cured, forcing another save each morning against the loss of another 1d4 Stamina." },
		{ r1 = 17, r2 = 17, text = "The brief brush with death affects the PCs  memory. He loses all memory of the last 24 hours and must make a DC 16 Fort save or also lose memories of the past 1d7 days." },
		{ r1 = 18, r2 = 18, text = "The blow smashes against the PC s temple and gives him a glimpse of his own death sometime in the future. This brush with death paralyzes the PC with fear for 1d6 rounds." },
		{ r1 = 19, r2 = 19, text = "The wound immediately turns a deep yellow color and a dizzying madness infects the character. He temporarily loses 1d6 Intelligence and 1d6 Personality." },
		{ r1 = 20, r2 = 20, text = "The wound takes the shape of an unholy mark. The character takes an additional 1d6 damage and is marked. Un-dead creatures are attracted to the PC from miles around. He cannot hide from un-dead, and they relentlessly hound him. The mark can only be removed by a blessing, holy cleansing, exorcism, or the like." },
		{ r1 = 21, r2 = 21, text = "The character s soul is scarred by un-death. He permanently loses 1 point of Luck." },
		{ r1 = 22, r2 = 22, text = "The wound erupts in a disgusting infestation of maggots. They cause an additional 2d6 damage plus an ongoing 1d6 damage per round until the wound is healed via magical means." },
		{ r1 = 23, r2 = 23, text = "The un-dead s intensely concentrated aura of unholiness infects the PC with an unholy aura. Any magical blessings or similar effects are automatically cancelled, and the character takes 1d4 points of temporary Personality loss." },
		{ r1 = 24, r2 = 24, text = "Grave rot! The wound bubbles and festers like a thing not from this earth. The rot causes an additional 1d12 damage and 1d6 Strength loss immediately, and the wound will not heal naturally. The damage and Strength loss can only be recovered via magical healing." },
		{ r1 = 25, r2 = 25, text = "In a supernatural display,  esh melts away from the wound, revealing the bones beneath and causing an additional 1d6 damage and 1 point of Stamina loss. Each round thereafter, the radius of melted  esh expands, causing an additional 1d6 damage 1 point of Stamina loss. The melting  esh continues to expand until the PC dies. It can only be suspended via magical healing with a spell check of 20 or greater." },
		{ r1 = 26, r2 = 26, text = "Death rattle! The stench of un-death chokes the character, who collapses in a  t of gagging that slowly begins to suffocate him. He must make a DC 20 Fort save or lose 1d4 points of Stamina. If he fails the Fort save, he must make another save on the next round. If that fails, he takes additional Stamina damage and must make another save. The pattern continues until he makes a save or dies." },
		{ r1 = 27, r2 = 27, text = "The un-dead creature sucks life force from the character. The PC takes an additional 1d20 damage, and the un-dead creature heals that same amount (not to exceed its original total hit points)." },
		{ r1 = 28, r2 = 28, text = "The wizening. The character immediately ages 1d20 years. If the result is 15 or more, he permanently loses 1 point of Strength, Agility, and Stamina as his body weakens." },
		{ r1 = 29, r2 = 29, text = "The end is always dust: the wounded area crumbles to dust, in icting an extra 2d12 damage and permanently dis guring the character. He loses the use of that arm, leg, hand, or whatever area was struck. On the following round, the area adjacent to the wound in turn crumbles to dust, in icting an additional 1d6 damage. The radius of dust transformation continues to expand, in icting an additional 1d6 damage each round until the character is dead. The transformation to dust can only be stopped by very powerful magic" },
		{ r1 = 30, r2 = 99, text = "Un-death seeks un-death: in a  ash of thick black smoke, the un-dead creature expends some of the necromantic energies that sustain it to transform the PC into un-death. The un-dead attacker automatically loses 1d6 hit points and may be killed as a result. The PC collapses in a state of apparent death, only to arise 1d6 rounds later as an un-dead creature under the control of the judge. Roll 1d8 to determine the type of creature that arises: (1-4) zombie, (5-6) skeleton, (7) ghoul, (8) ghost." }
		},
	["M"] = {
		{ r1 = -99, r2 = 1, text = "Strike to chest, breaking ribs. This attack inflicts +1d6 damage." },
		{ r1 = 2, r2 = 2, text = "Stunning blow! The PC falls to the bottom of the initiative count for the remainder of the battle." },
		{ r1 = 3, r2 = 3, text = "Legs knocked out from beneath the character, knocking him prone." },
		{ r1 = 4, r2 = 4, text = "PC disarmed. Weapon lands 1d12+5 feet away." },
		{ r1 = 5, r2 = 5, text = "Blow to shield arm! If no shield, this attack inflicts +1d6 damage." },
		{ r1 = 6, r2 = 6, text = "Weapon lodged in PC s chest! This attack inflicts +2d6 damage and an additional 1d6 damage next round." },
		{ r1 = 7, r2 = 7, text = "Blow to jaw! The PC loses 1d8 hp and the same number of teeth." },
		{ r1 = 8, r2 = 8, text = "Blow shatters PC s forearm. This attack inflicts +1d6 damage, and the arm is useless until healed." },
		{ r1 = 9, r2 = 9, text = "Strike to helm! If no helmet, this attack inflicts +1d8 damage and forces a Fort save (DC 10 + HD). On a failed save, the PC falls unconscious." },
		{ r1 = 10, r2 = 10, text = "Stunning blow! The world spins as the fell monster makes a second attack!" },
		{ r1 = 11, r2 = 11, text = "Strike to throat! The PC can t speak until healed and spends the next round struggling to breathe." },
		{ r1 = 12, r2 = 12, text = "Blow smashes PC s kneecap. The character s movement is cut by half and this attack inflicts +1d10 damage." },
		{ r1 = 13, r2 = 13, text = "Crushing blow! This attack inflicts +1d12 damage." },
		{ r1 = 14, r2 = 14, text = "PC weapon sundered in the violent assault."},
		{ r1 = 15, r2 = 15, text = "Strike to torso crushes internal organs. This attack inflicts +1d12 damage, and force the PC to make Fort save (DC 15 + HD) to remain conscious through the pain." },
		{ r1 = 16, r2 = 16, text = "Devastating strike! This attack inflicts +1d16 damage." },
		{ r1 = 17, r2 = 17, text = "PC s Achilles tendon is torn, snapping back into his thigh. The character s movement drops to 5 feet and the screaming can be heard for leagues." },
		{ r1 = 18, r2 = 18, text = "Monster seizes PC by the neck. This attack inflicts +1d12 damage and the monster makes a second attack at +4 to hit." },
		{ r1 = 19, r2 = 19, text = "Blow to cranium! This attack inflicts +1d16 damage and the PC must make a Fort save (DC 15 + HD) or fall unconscious." },
		{ r1 = 20, r2 = 20, text = "Terrifying blow pierces several important organs. The PC spends the next 1d4 days dying a slow, painful death. Powerful magic (healing by a cleric of level 3 or higher) can arrest the dying." },
		{ r1 = 21, r2 = 21, text = "Strike crushes skull, destroying the optic nerve and resulting in instant, permanent blindness." },
		{ r1 = 22, r2 = 22, text = "PC s leg is shorn from his body. The character cannot move. This attack inflicts +2d12 damage." },
		{ r1 = 23, r2 = 23, text = "Both the PC s arms are torn from his body. This attack inflicts +3d12 damage. Exceptionally cruel monsters may proceed to use PC s arms as weapons." },
		{ r1 = 24, r2 = 24, text = "PC is disemboweled. Bloody guts spill to the ground. The PC spends the next 8 rounds dying as he futilely tries to feed the spooling intestines back into his body." },
		{ r1 = 25, r2 = 25, text = "Attack craters PC s skull. This attack inflicts 1d8 Intelligence and Personality damage and puts the PC into an instant coma." },
		{ r1 = 26, r2 = 26, text = "Strike crushes throat. The PC drowns in his own blood for 6 rounds." },
		{ r1 = 27, r2 = 27, text = "Attack snaps the PC s spinal column like a twig. The attack causes permanent paralysis, and the PC watches the remainder of the battle from the floor." },
		{ r1 = 28, r2 = 28, text = "Throat torn asunder. The panicked PC gargles wetly as blood gouts down his chest. He dies in 4 rounds." },
		{ r1 = 29, r2 = 29, text = "Terrible blow to the chest explodes the PC s heart. Immediate and instantaneous death." },
		{ r1 = 30, r2 = 99, text = "Attack rends PC s head from his torso. Blood gouts from the collapsing body, and the monster moves on to the next foe, making attacks until it misses." }
		},
	["G"] = {
		{ r1 = -99, r2 = 1, text = "Crushing blow. This attack in icts +1d8 damage, and the character s spine is compressed. The PC permanently loses 1d6” of height." },
		{ r1 = 2, r2 = 2, text = "Broken arm. This attack in icts +1d10 damage and one arm is crippled. The character suffers permanent loss of 1 Strength (arm never heals back to original position properly), and the arm cannot be used until healed." },
		{ r1 = 3, r2 = 3, text = "Broken leg. This attack in icts +1d10 damage and one leg is crippled. The PC suffers permanent loss of 5  of speed (leg never heals properly) and moves at half speed until healed." },
		{ r1 = 4, r2 = 4, text = "Crushed chest. This attack in icts +1d12 damage and chest is caved in. Until completely healed, any sort of exertion (including combat, running, swimming, jumping, etc.) requires DC 6 Fort save. Failure indicates permanent loss of 1 Stamina (due to several organ damage; e.g., heart attack, lung failure, etc.)." },
		{ r1 = 5, r2 = 5, text = "Flattened. The PC is literally  attened into the ground by the sheer force of the blow, with multiple broken bones and several shattered ribs. The character takes an additional 1d12 damage and permanently loses 1 Stamina." },
		{ r1 = 6, r2 = 6, text = "Ricochet blow. The giant s staggering attack sends the target hurling through the air up to 3d30  to collide with another victim (randomly determined). Both the original target and the secondary target take 1d10 damage from the collision (in addition to the giant s normal damage against the  rst target)." },
		{ r1 = 7, r2 = 7, text = "Colossal head strike. This attack in icts +2d6 damage and the PC permanently loses 1 point of Intelligence. In addition, there is a 25 percent chance the character forgets the last 24 hours of his life." },
		{ r1 = 8, r2 = 8, text = "Weapon smash. The giant s massive blow causes an additional 1d8 damage and splinters the character s weapons and equipment. The PC s weapons and equipment each have a 50 percent chance of being destroyed; roll for each item: armor is busted loose (straps broken and plates dented), shields are shattered, weapons splintered or cracked, etc. Magic items are destroyed only 10 percent of the time instead of 50 percent." },
		{ r1 = 9, r2 = 9, text = "Sweeping blow. The giant s strike bowls over the character, and he takes an extra 1d8 damage and is knocked prone (must spend his next activation to stand). In addition, the giant can make another attack as long as it is directed against a different target, who must be within melee range and adjacent to the  rst target. If this second attack hits, the giant can attack another target, up to  ve in total, as it sweeps through its opponents." },
		{ r1 = 10, r2 = 10, text = "Legs crushed into ground. The giant s blow hits the PC square on the head, driving him into the earth like a nail into a board. The character takes an additional 2d8 damage, and both his legs are broken as he is propelled 1d4 feet into the earth (reduced to 1d4 inches if surface is stone). The character suffers a permanent loss of 10  of speed and 1 Agility (legs never heal properly) and is temporarily reduced to a speed of 1  (yes, one foot per round) until his two broken legs are healed." },
		{ r1 = 11, r2 = 11, text = "Roll again twice." },
		{ r1 = 12, r2 = 99, text = "Roll again three times." }
		},
	["DN"] = {
		{ r1 = -99, r2 = 1, text = "Piercing blow. The character takes an additional 1d8 damage." },
		{ r1 = 2, r2 = 2, text = "Life burn. The character permanently loses an additional 2 hit points." },
		{ r1 = 3, r2 = 3, text = "Head strike. The character takes an additional 1d10 damage" },
		{ r1 = 4, r2 = 4, text = "Major life burn. The character permanently loses an additional 4 hit points." },
		{ r1 = 5, r2 = 5, text = "Corruption. Character takes on corruption, similar to a wizard casting spells. Roll 1d10 on a corruption table. If the demon has 5 HD or less, use the minor corruption table; if 6-10 HD, use the major corruption table; if 11+ HD, use the greater corruption table." },
		{ r1 = 6, r2 = 6, text = "Aging. The character ages 1d10 years instantly. If cumulative aging from this and other effects exceeds 20 years, the character suffers a -1 penalty to all physical ability scores." },
		{ r1 = 7, r2 = 7, text = "Infernal weakening I. The PC loses 1d4 points of ability score for one week. Determine randomly: (roll 1d5) (1) Strength, (2) Agility, (3) Stamina, (4) Intelligence, (5) Personality." },
		{ r1 = 8, r2 = 8, text = "Soul wound. The character loses 1 XP from the soul-burning touch of the demon." },
		{ r1 = 9, r2 = 9, text = "Soul trade. The character s soul is swapped with that of a soul already owned by the demon. The demon takes possession of the character s soul while his body is now controlled by another life force. The character s physical stats remain unchanged, but re-roll the character s new Intelligence, Personality, and Luck with 3d6. The character loses all his normal memories and takes on the memories of the soul now in his body, including its most recent memories of infernal brimstone. He retains his class abilities and other training, but his new mental statistics may change the skill with which he uses his abilities. The character can recover his stolen soul only by journeying to the demon s home plane and recovering it. The judge is encouraged to come up with a new history for the soul now in his body." },
		{ r1 = 10, r2 = 10, text = "Double corruption! The PC takes on corruption twice, similar to a wizard casting spells. Roll 1d10 twice on a corruption table. If the demon has 5 HD or less, use the minor corruption table; if 6-10 HD, use the major corruption table; if 11+ HD, use the greater corruption table." },
		{ r1 = 11, r2 = 11, text = "Infernal weakening II. The PC loses 1 point of one ability score permanently. Determine randomly: (roll 1d5) (1) Strength, (2) Agility, (3) Stamina, (4) Intelligence, (5) Personality." },
		{ r1 = 12, r2 = 12, text = "Luck burn. The touch of the demon brings bad luck upon the character! He loses 1 point of Luck. A halfling or thief can recover this loss through normal class means." },
		{ r1 = 13, r2 = 13, text = "Severe soul wound. The character loses 3 XP from the demon s soul-searing touch." },
		{ r1 = 14, r2 = 14, text = "Astral drift. The character s soul is sent adrift on the astral plane! The character drops to the ground, catatonic, and cannot be revived until his soul is located and returned to his body." },
		{ r1 = 15, r2 = 15, text = "Con nement. The demon s strike breaks the magic bonds holding it on this plane and con nes the character to the demon s current location. The character sees a burning circle of  ame appear around him, sputtering black with dark energy. The circle is approximately 5 feet in diameter and traps the character within. It is considered powerful magic (treat as spell check 25 to dispel). The character cannot pass through it by any means until it is dispelled or the character is freed or banished back to his native free state. The demon, on the other hand, is now freed from any con nement or banishment to this plane and can return to its home plane at will." },
		{ r1 = 16, r2 = 99, text = "Banishment. The demon s strike banishes the character to the demon s home plane! The character vanishes from sight as he is instantly transported back to the demon s home. For all intents and purposes, the character is out of the game unless his allies immediately follow to save him." },
		}
	};

function onInit()
	ActionsManager.registerModHandler("critical", modRoll);
	ActionsManager.registerResultHandler("critical", onRoll);
	Comm.registerSlashHandler("crit", slashCommandHandlerCritical);
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

function mysplit(inputstr, sep)
                        if sep == nil then sep = "%s" end
                                local t={}
                                for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                                table.insert(t, str)
                                end
                                return t
                        end

function slashCommandHandlerCritical(sCommand, sParams)

        -- parse params
        local args = mysplit( sParams );

        local aUsageMessage = { text = sCommand .. " 1,2,3,4,5,I,II,III,IV,V,U,M,G,DN check" , secret = true };

        -- we expect arg1 = table, arg2 = check 
        if (not args) or (#args ~= 2) then
                Comm.addChatMessage(aUsageMessage) ;
                return;
        end

        local table = args[1];
	if table == "1" then
		table = "I";
	elseif table == "2" then
		table = "II";
	elseif table == "3" then
		table = "III";
	elseif table == "4" then
		table = "IV";
	elseif table == "5" then
		table = "V";	
	end
			
        local check = tonumber( args[2] );
        if not check then
                Comm.addChatMessage(aUsageMessage) ;
                return;
        end

        local aMessage = { text = "Critical table " .. table .. ", roll is " .. check .. " => " .. getRollMessage(table,check) , secret = true };
        Comm.addChatMessage(aMessage) ;

end


