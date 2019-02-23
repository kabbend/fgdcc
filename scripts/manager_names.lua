
local names = {

  Homme={ 
'Aseir', 'Haseid', 'Kheed', 'Zasheir', 'Fodel', 'Glar', 'Grigor', 'Igan', 'Ivor', 'Kosef', 'Mival', 'Pavel', 'Sergor', 'Darvin', 'Dorn', 'Evendir',
'Gorstag', 'Helm', 'Morn', 'Randal', 'Stedd', 'Ander', 'Blath', 'Bran', 'Frath', 'Geth', 'Lander', 'Luth', 'Malcer', 'Stor', 'Taman', 'Bareris', 'Kethoth', 'Mumed', 
'Urhur', 'Borivik', 'Faurgar', 'Jandar', 'Kanithar', 'Madislak', 'Ralmevik', 'Shaumar', 'Vladislak', 'Chen', 'Chi', 'Fai', 'Lian', 'Long', 'Wen', 'Anton', 
'Adran', 'Aelar', 'Aramil', 'Aranis', 'Aust', 'Berrian', 'Carric' , 'Enialis', 'Erdan', 'Erevan', 'Galinndan', 'Hadarai', 'Himo', 'Immeral', 'Laucian', 'Mindartis', 
'Paelias', 'Peren', 'Quarion', 'Riardon', 'Rolen', 'Soveliss', 'Thamior', 'Tharivol', 'Theren', 'Varis', 'Alton', 'Ander', 'Cade', 'Corrin', 'Eldon', 'Errich' , 
'Finnan', 'Garret', 'Lindal', 'Lyle', 'Merric', 'Milo', 'Perrin', 'Reed', 'Roscoe', 'Wellby', 'Agermus', 'Davic', 'Hudis', 'Anvam', 'Egar', 'Dolich', 'Itur',
'Maglor', 'Brattin', 'Hebert', 'Mochor', 'Tudon' , 'Melyn', 'Ambert', 'Horne', 'Saber', 'Hygrid', 'Gayle', 'Nairial', 'Jengrid', 'Orcan', 'Eglain', 'Leisman',
'Pelreth', 'Severn', 'Doyle', 'Lemar', 'Peris', 'Tigit', 'Mablain', 'Tronnk', 'Malez', 'Ropire', 'Adech', 'Heran', 'Aluset', 'Darian', 'Kage', 'Shard', 'Aluvin',
'Deorhael', 'Kagi', 'Sland', 'Artina', 'Dresrin', 'Keanan', 'Artine', 'Ebert', 'Thornelm','Artink', 'Elich', 'Mudarne', 'Tibba', 'Athen','Ogemtown', 
'Cybill', 'Keven', 'Priva', 'Anbog', 'Lito', 'Pultaren', 'Angroc', 'Lear', 'Ronke','Besoth', 'Leat', 'Sengar', 'Bloodvine','Flama', 'Lexis', 'Snorg', 'Meter',
'Tigan', 'Duan', 'Alwis (All Wise)','Asabiarn (Divine Bear)','Bard (Battle Axe)',
'Biarn (Bear)','Bondi (Peasant Farmer)','Booth (Shelter)','Brand (Flaming Torch)','Brander (Fiery Sword)','Dag (Day)',
'Delling (Shining One)','Einar (Lone Warrior)','Eric (Honorable Ruler)',
'Erland (Stranger)','Farman (Traveller)','Gus (Staff )','Gustaw (Lord’s Rod)','Hakon (Of Noble Birth)',
'Hallam (dweller at the Rocks)','Halstein (Rock)', 'Halward (Defender of the Rock)','Hamar (Hammer)',
'Harald (High-Old)','Holgeir (Spear-Like)','Ingemar (Famous Son)','Ingar (Son’s Army)','Iwar (Battle Archer)','Kell (From the Well or Spring)',
'Knut (Knot)','Lif (Beloved)','Lunt (From the Sacred Wood)','Odell (Wealthy)','Olaf (Ancestor)',
'Ranulf (Wolf-Like Advice)','Ric (Honourable Ruler)', 'Roald (Famous Ruler)','Rutland (From the Stump Land)',
'Sigurd (Victorious Guardian)','Skip (Ship)','Stig (Wanderer)','Storr (Great Man)'
	},

 
  Femme={ 
'Atala', 'Ceidil', 'Hama', 'Jasmal', 'Meilil', 'Yasheira', 'Zasheida', 'Arveene', 'Esvele', 'Jhessail', 'Kerri', 'Lureene', 'Miri', 'Rowan',
'Tessele', 'Alethra', 'Kara', 'Katernin', 'Mara', 'Olma', 'Tana', 'Betha', 'Cefrey', 'Kethra', 'Mara', 'Olga', 'Silifrey', 'Westra', 'Arizima',
'Chathi', 'Nehis', 'Nulara', 'Murithi', 'Sefris', 'Thola', 'Umara', 'Hulmarra', 'Immith', 'Imzel', 'Navarra', 'Shevarra', 'Tammith. Yuldra', 'Bai',
'Chao', 'Jia', 'Lei', 'Mei', 'Qiao', 'Shui', 'Tai', 'Balama', 'Dona', 'Faila', 'Jalana', 'Luisa', 'Marta', 'Quara', 'Selise', 'Vonda',  'Adrie', 'Althaea',
'Anastrianna', 'Andraste', 'Antinua', 'Bethrynna', 'Birel', 'Caelynn', 'Drusilia', 'Enna', 'Felosial', 'Ielenia', 'Jelenneth', 'Keyleth', 'Leshanna', 'Lia',
'Meriele', 'Mialee', 'Naivara', 'Quelenna', 'Quillathe', 'Sariel', 'Shanairra', 'Silaqui', 'Theirastra', 'Thia', 'Vadania', 'Valanthe', 'Andry', 'Bree', 'Callie',
'Cora', 'Euphemia', 'Jillian', 'Kithri', 'Lavinia', 'Lidda', 'Merla', 'Nedda', 'Paela', 'Portia', 'Seraphina', 'Shaena', 'Trym', 'Vani', 'Verna',
'Adaldrida','Adamanta','Amaranth','Angelica','Asphodel', 'Belba','Bell','Belladonna','Berylla','Camellia','Celandine',
'Donnamira','Eglantine', 'Elanor','Esmerelda','Gilly','Hanna','Hilda','Lily', 'Linda','Lobelia','Malva','Melilot','Menegild',
'Mentha','Mimosa','Mirabella','Myrtle','Pansy','Peony','Pervinca','Primrose','Primula', 'Prisca','Rosamund','Rosa','Rose','Ruby','Salvia' 
	},

  Nain ={ 
'Adrik', 'Alberich', 'Baern', 'Barendd', 'Brottor', 'Bruenor', 'Dain', 'Darrak', 'Delg', 'Eberk', 'Einkil', 'Fargrim', 'Flint', 'Gardain',
'Harbek', 'Kildrak', 'Morgran', 'Orsik', 'Oskar', 'Rangrim', 'Rurik', 'Taklinn', 'Thoradin', 'Thorin', 'Tordek', 'Travok', 'Ulfgar', 'Veit', 'Vondal',
'Anar','Balin','Beli','Bifur','Blain','Bofur','Bombur','Borin', 'Burin','Dain','Dori','Durin','Dwalin','Farin','Fili','Floi','Frar',
'Frerin','Fror','Fundin','Gimli','Ginar','Gloin','Groin','Gror', 'Hanar','Kili','Lofar','Loni','Nain','Nali','Nar','Noi','Nori','Oin',
'Onar','Ori','Pori','Regin','Thrin','Thain','Thor','Vidar' 
	},

  Naine={ 
'Amber', 'Artin', 'Audhild', 'Bardryn', 'Diesa', 'Eldeth', 'Falkrunn', 'Finellen', 'Gunnloda', 'Gurdis', 'Helja', 'Hlin', 'Kathra',
'Kristryd', 'Ilde', 'Liftrasa', 'Mardred', 'Riswynn', 'Sannl', 'Torbera', 'Torgga', 'Vistra' 
	},

  Clan={  
'Marteau De Guerre', 'Nuqueroide', 'Coeursang', 'Forgefeu', 'Barberaide', 'Oeil D’aigle','Poing de Fer', 'Broidemon',
'Lamefine','Foudrelame', 'Coupefer', 'Barbemine', 'Fondor', 'Fondargent', 'Coupedragon', 'Bonneforge', 'Saintechasse',
'Clairargent', 'Brisemarbre', 'Forgenclume', 'Bronzenoir', 'Grandeforge', 'Barbeglaive', 'Chasseur d Orcs', 'Sapepierre',
'Richeterre', 'Terre d argent'
	},

  Orc= { 
'Dench', 'Feng', 'Gell', 'Henk', 'Holg', 'Imsh', 'Keth', 'Krusk', 'Mhurren', 'Ront', 'Shump', 'Thokk', 'Azog','Bolg','Burz','Gazbag','Gazduf','Gazdush','Gazhur',
'Gazgash','Gazbug','Gazhorn','Gazmog','Gazmuz','Gazrad','Gazrat','Gazthak','Gazlag','Gazluk','Gazlun','Gazlur','Gaznag','Gazuf','Gazug','Gazul','Ghash','Golfimbul',
'Gorbag','Gorbug','Gorduf','Gordush','Gorgash','Gorgaz', 'Gorhur','Gorluk','Gorlun','Gornag','Gorshag','Gorthak',
'Gorul','Gorzag','Grishnákh','Lagbug','Lagduf','Lagdush', 'Laghur','Laguf','Laglug','Laglun','Lagrad','Lagrat','Lagthak',
'Lug','Lugbag','Lugduf','Lugdush','Lughorn','Lughur','Lugluk', 'Luglun','Lugnag','Lugthak','Lugul','Lugzag','Lunbag','Lunbug','Lunduf','Lundush',
'Lungash','Lungaz','Lungor','Lunhur', 'Lunlag','Lunluk','Lunmaz','Lunrad','Lunrat','Lunshag','Lunthak','Lunuf','Lunug','Lunul','Lunzag','Maubag','Maubug',
'Mauduf','Maudush','Maugash','Maugaz','Maugor','Mauhur', 'Mauluk','Maulur','Maunag','Mauthak','Mauzag','Muzbag',
'Muzbug','Muzduf','Muzdush','Muzgash','Muzgaz','Muzgor', 'Muzhur','Muzlag','Muzlug','Muzluk','Muzlun','Muzlur',
'Muznag','Muzrad','Muzrat','Muzthak','Muzug','Muzul', 'Nagbug','Nagduf','Nagdush','Naghur','Naglug','Nagluk','Naglur','Nagmuz',
'Nagug','Nagrad','Nagrat','Nagthak','Nagzag', 'Nuzu','Radbag','Radbug','Radgash','Radgaz','Radhur','Radlag','Radluk','Radmuz','Radnag','Radrat','Radthak','Radug',
'Radzag','Shagbug','Shagduf','Shagdush','Shagluk','Shaglur', 'Shagrad','Shagrat','Shagthak','Shaguf','Shagug','Shagul',
'Snaga','Ufgaz','Uflug','Ufluk','Ufthak','Ufzag','Ugbag','Ugduf', 'Ugdush','Ughur','Uglag','Ugluk','Uglur','Ugmuz','Ugnag',
'Ugrad','Ugrat','Ugthak','Ugzag','Yagaz','Yagbug','Yagduf', 'Yagdush','Yaghur','Yaglug','Yaglun','Yagluk','Yagmuz','Yagor',
'Yagrad','Yagrat','Yagthak','Yaguf','Yagug','Yagul','Zagbug','Zagduf','Zagdush','Zaghur','Zaglag','Zaglug','Zaglun','Zagluk',
'Zagmuz','Zagrad','Zagrat','Zagthak','Zaguf','Zagug'
	},

  Ville= { 
'Amar', 'Bremere', 'Lostrain', 'Lindell', 'Stinglad', 'Restan', 'Lingle', 'Palos', 'Brig', 'Courgenay', 'Laferie',
'Planchemouton', 'Loucet', 'Dambron', 'Camphin', 'Nolats', 'Trapont', 'Froidos', 'Argin', 'Puilacher', 'Cublaise', 'Bluech',
'Evermeu', 'Erbigot', 'Vaire', 'Hodent', 'Lolon', 'Sermaize', 'Cornoyer', 'Saurm', 'Bytham', 'Ruthin', 'Edmore', 'Rogat', 'Devizes',
'Ottery', 'Caleon', 'Norham', 'Farham', 'Rhuddlan', 'Bullion', 'Visker', 'Maureville', 'Thalar', 'Noironte', 'Valades', 'Puits', 'Mifaget',
'Bleury', 'Hautevelle', 'Longefont', 'Nonville', 'Dieudet', 'Crochte', 'Bertry', 'Banson', 'Burgaronne', 'Augeville', 'Ombre', 'Azolette',
'Gaubert', 'Melleroy', 'Angle', 'Dallon', 'Saulnot', 'Goos', 'Arinthod', 'Ybourgues', 'Venarsal', 'Bignay', 'Lureuil', 'Caves',
'Honville', 'Arcelot', 'Rocheblonde', 'Stuckange', 'Fervaches', 'Treizanches', 'Fontrin', 'Charnod', 'Ottange', 'Fontvive',
'Fourche', 'Fribuge', 'Utiac', 'Frace', 'Arthenas', 'Barbonval', 'Valseme', 'Andron', 'Grandvals', 'Dagret', 'Chapelle',
'Gardefort', 'Logrian', 'Languenan', 'Thivars', 'Arbin', 'Champsecret', 'Mottier', 'Nirolle', 'Wycombe', 'Criccieth',
'Fierville', 'Arundel', 'Manorbier', 'Bramber', 'Aust', 'Raglan', 'Pebmar', 'Anberis', 'Gravise', 'Lacrique',
	},

  Taverne={ 
'Du Fou', 'La Licorne Enivree', 'Le Barbare et le Marteau', 'Le Serpent Moqueur', 'Au Crabe Sauvage', 'Le Grand Golem', 'Le Duche', 'La Fiere Statue',
'La Chauve Sourist', 'Au Poisson Enivre', 'Le Fier Cochon', 'La Barrique en Bois', 'Au Trefonds du Seau', 
'La maison de la Sirene', 'Le Cheval et le Blaireau', 'Le Sage Volant', 'Chez Lagar', 'Le lit fondu', 'Chez Pirath', 'Le repaire du voyageur',
'Chez Nambion', 'Le relais de Tradus', 'A l ours farceur', 'De l hermine', 'Le heron et le poulet', 'A la fourchette de rubis',
'Aux cents chemins', 'Le moustique et le poulet', 'A la grenouille hurlante', 'L ours et la mouche', 'A la mesange enragee', 'Des remparts',
'Le lit et la cuillere', 'Le luth du voisin', 'La marmotte jaune', 'Le chene et la bougie', 'L araignee qui louche', 'Au poulet rouge', 'A la marmotte malchanceuse',
'Le crapaud et la pieuvre', 'Chez Brasan', 'L enclume et la flute', 'A l araignee souriante ', 'Chez Tomel', 'Le loup braise', 'Le crapaud et la mouette',
'Le toit de l oreille pointue', 'Au renard blanc', 'Aux quatre vents', 'La poelle et l enclume', 'La chope et le chiffon', 'La mouche farcie', 'La plume et le chiffon',
'La belette et le moustique', 'A l auberge des cents chemins', 'Au chien fringant', 'La poelle brulante', 'Le marteau et la bouteille', 'A la table des trois sous',
'La biere et l enclume', 'Au moustique d argent', 'Le tonneau et la fleur', 'L hydre et l hermine', 'A la broche du voyageur', 'Chez Enos', 'Le refuge de Runden',
'La maison du combattant', 'A la fleur blanche', 'La bouteille fumante', 'Le marteau et la chopine', 'Au gobelet chantant', 'Chez Vascar', 'La mouche rouge',
'Au gobelet des quatre chemins', 'Le coin des trois croix', 'Le lit d argent', 'Au bar de la longue barbe', 'Le relais de Rilan', 'La mouche et la grenouille',
'Le dortoir du forgeron', 'La barbe et la table', 'Chez Madal', 'Le lapin enrage', 'Le toit de Thodar', 'A l aigle rieur', 'L abeille malade',
'Le lit et la chope', 'Au chien rieur', 'Au blaireau chantant', 'La hutte d Hadigan', 'Le poulet et le corbeau', 'A la grenouille fatiguee',
'Les douze morts', 'Le godet et le bol', 'La mouche et le moustique', 'Chez Petam', 'Le vin et la fleur', 'Le herisson farci', 'Le faucon affame',
'Le chien sifflant', 'L araignee fumee', 'Le refuge du rodeur', 'Le blaireau et le lapin', 'A l arbre copieux', 'A la taverne des trois chopes',
'Le mouton brule', 'A la mesange rouge', 'Le luth et la fleur',
	},

};


function onInit()
        Comm.registerSlashHandler("name", slashCommandHandlerNames);
        Comm.registerSlashHandler("names", slashCommandHandlerNames);
end

function mysplit(inputstr, sep)
                        if sep == nil then sep = "%s" end
                        local t={}
                        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                        table.insert(t, str)
                        end
                        return t
                        end

function slashCommandHandlerNames(sCommand, sParams)

        -- parse params
        local args = mysplit( sParams );

        local aUsageMessage = { text = sCommand, secret = true };
        local aMessage = { text = "", secret = true };

	-- pick one name in each category
	for k,v in pairs(names) do
		aMessage.text = aMessage.text .. k .. " : " .. names[k][ math.random(#names[k]) ] .. "\n" ;
	end	
        Comm.addChatMessage(aMessage) ;

end




