local _, addon = ...
local fact, _ = UnitFactionGroup("player")
local _, _, classId = UnitClass("player")

local factionlookup = {
	["Alliance"] = {
		[1] = {port = 33691, tele = 33690, name = "Shattrath"},
		[2] = {port = 88345, tele = 88342, name = "Tol Barad"},
		[3] = {port = 132620, tele = 132621, name = "Vale of\nEternal\nBlossoms"},
		[4] = {port = 176246, tele = 176248, name = "Ashran"}
	},
	["Horde"] = {
		[1] = {port = 35717, tele = 35715, name = "Shattrath"},
		[2] = {port = 88346, tele = 88344, name = "Tol Barad"},
		[3] = {port = 132626, tele = 132627, name = "Vale of\nEternal\nBlossoms"},
		[4] = {port = 176244, tele = 176242, name = "Ashran"}
	}
}

addon.ports = { -- Mage Teleports/Portals
	[1] = {port = 446534, tele = 446540, name = "Dornogal"},
	[2] = {port = 395289, tele = 395277, name = "Valdrakken"},
	[3] = {port = 344597, tele = 344587, name = "Oribos"},
	[4] = {port = 281400, tele = 281403, name = "Boralus"},
	[5] = {port = 281402, tele = 281404, name = "Dazar'alor"},
	[6] = {port = false, tele = 193759, name = "Hall of the\nGuardian"},
	[7] = {port = 224871, tele = 224869, name = "Dalaran\nLegion"},
	[8] = factionlookup[fact][4], -- Ashran
	[9] = factionlookup[fact][3], -- Vale of Eternal Blossoms
	[10] = {port = 120146, tele = 120145, name = "Dalaran\nAncient"},
	[11] = factionlookup[fact][2], -- Tol Barad
	[12] = {port = 53142, tele = 53140, name = "Dalaran\nNorthrend"},
	[13] = factionlookup[fact][1], -- Shattrath
	[14] = {port = 49360, tele = 49359, name = "Theramore"},
	[15] = {port = 49361, tele = 49358, name = "Stonard"},
	[16] = {port = 32266, tele = 32271, name = "Exodar"},
	[17] = {port = 32267, tele = 32272, name = "Silvermoon"},
	[18] = {port = 11419, tele = 3565, name = "Darnassus"},
	[19] = {port = 11420, tele = 3566, name = "Thunder Bluff"},
	[20] = {port = 11416, tele = 3562, name = "Ironforge"},
	[21] = {port = 11418, tele = 3563, name = "Undercity"},
	[22] = {port = 10059, tele = 3561, name = "Stormwind"},
	[23] = {port = 11417, tele = 3567, name = "Orgrimmar"},	
}

addon.mainTitle = {
	[1] = "General",
	[2] = "Engineering",
	[3] = "Mage",
}

addon.dungeonTitle = {
	[1] = "Current Season",
	[2] = "The War Within",
	[3] = "Dragonflight",
	[4] = "Shadowlands",
	[5] = "Battle for Azeroth",
	[6] = "Legion",
	[7] = "Other",
}

addon.dungeon = {
	[1] ={ -- Current Season
		[445417] = "Ara-Kara",
		[445414] = "Dawnbreaker",
		[1216786] = "Operation:\nFloodgate",
		[445444] = "Priory of the\nSacred Flame",
		[354465] = "Halls of\nAtonement",
		[367416] = "Tazavesh",
		[1237215] = "Eco-Dome\nAl'dani",
	},
	[2] = { -- The War Within
		[445269] = "Stonevault",
		--[445414] = "Dawnbreaker",
		--[445417] = "Ara-Kara",
		[445416] = "City of\nThreads",
		[445443] = "The Rookery",
		[445440] = "Cinderbrew\nMeadery",
		--[445444] = "Priory of the\nSacred Flame",
		[445441] = "Darkflame\nCleft",
		--[1216786] = "Operation:\nFloodgate",
		--[1237215] = "Eco-Dome\nAl'dani",
	},
	[3] = { -- Dragonflight
		[393273] = "Algeth'ar\nAcademy",
		[393267] = "Brackenhide\nHollow",
		[393283] = "Halls of\nInfusion",
		[393276] = "Neltharus",
		[393256] = "Ruby\nLife Pools",
		[393279] = "Azure Vault",
		[393262] = "Nokhud\nOffensive",
		[393222] = "Uldaman:LoT",
		[424197] = "Dawn of\nthe Infinite",
	},
	[4] = { -- Shadowlands
		[354463] = "Plaguefall",
		[354468] = "De Other\nSide",
		--[354465] = "Halls of\nAtonement",
		[354464] = "Mists of\nTirna Scithe",
		[354462] = "Necrotic\nWake",
		[354469] = "Sanguine\nDepths",
		[354466] = "Spires of\nAscension",
		[354467] = "Theater\nof Pain",
		--[367416] = "Tazavesh",
	},
	[5] = { -- Battle for Azeroth
		[424187] = "Atal Dazar",
		[410071] = "Freehold",
		[373274] = "Operation:\nMechagon",
		[445418] = "Siege of\nBoralus", --Alliance
		[464256] = "Siege of\nBoralus", --Horde
		[410074] = "Underrot",
		[424167] = "Waycrest\nManor",
		[467555] = "The\nMOTHERLODE!!",
	},
	[6] = { -- Legion
		[424153] = "Black Rook\nHold",
		[393766] = "Court of\nStars",
		[424163] = "Darkheart\nThicket",
		[393764] = "Halls of\nValor",
		[410078] = "Neltharion's\nLair",
		[373262] = "Karazhan",
	},
	[7] = { -- Other
		[445424] = "Grim Batol",
		[159899] = "Shadowmoon\nBurial Grounds",
		[159900] = "Grimrail\nDepot",
		[159896] = "Iron Docks",
		[131204] = "Temple of the\nJade Serpent",
		[424142] = "Throne of\nthe Tides",
		[159901] = "The\nEverbloom",
		[410080] = "Vortex\nPinnacle",
	}
}

addon.wormholes = {
	[1] = {id = 221966, name = "Khaz Algar"},
	[2] = {id = 198156, name = "Dragon Isles"},
	[3] = {id = 172924, name = "Shadowlands"},
	[4] = {id = 168808, name = "Zandalar"},
	[5] = {id = 168807, name = "Kul Tiras"},
	[6] = {id = 144341, type = "reaves"},
	[7] = {id = 151652, name = "Argus"},
	[8] = {id = 112059, name = "Draenor"},
	[9] = {id = 87215, name = "Pandaria"},
	[10] = {id = 48933, name = "Northrend"},
	[11] = {id = 30542, name = "Area 52"},
	[12] = {id = 30544, name = "Toshley's Station"},
	[13] = {id = 18984, name = "Everlook"},
	[14] = {id = 18986, name = "Gadgetzan"},
}

addon.quest = {
	[140192] = {44663, 44184}, -- Dalaran
	[110560] = {34378, 34586} -- Garrrison  
}

addon.checkQuest = function(questId)
	local valid = false
	for _,id in ipairs(addon.quest[questId]) do
		if C_QuestLog.IsQuestFlaggedCompleted(id) then
			valid = true
			break
		end
	end
	return valid
end

addon.general = {
	[1] = {id = false, type = "override", name = "Hearthstone"},
	[2] = {id = 6948, type = "item", name = "Hearthstone"},
	[3] = {id = 556, type = "spell", name = "Astral Recall"},
	[4] = {id = 140192, type = "toy", name = "Dalaran", quest = true},
	[5] = {id = 110560, type = "toy", name = "Garrison", quest = true},
	[6] = {id = 243056, type = "toy", name = "Dornogal"},
	[7] = {id = 193753, type = "spell", name = "Dreamwalk"},
	[8] = {id = 18960, type = "spell", name = "Moonglade"},
	[9] = {id = 50977, type = "spell", name = "Death Gate"},
	[10] = {id = 126892, type = "spell", name = "Zen\nPilgrimage"},
}

addon.spellLookup = { -- The spell cast by the items
	-- Toys:
	[166747] = 286353, -- Brewfest Reveler's Hearthstone
	[190237] = 367013, -- Broker Translocation Matrix
	[246565] = 1242509, -- Cosmic Hearthstone
	[93672] = 136508, -- Dark Portal
	[208704] = 420418, -- Deepdweller's Earthen Hearthstone
	[188952] = 363799, -- Dominated Hearthstone
	[190196] = 366945, -- Enlightened Hearthstone
	[172179] = 308742, -- Eternal Traveler's Hearthstone
	[54452] = 75136, -- Ethereal Portal
	[236687] = 1220729, -- Explosive Hearthstone
	[166746] = 286331, -- Fire Eater's Hearthstone
	[162973] = 278244, -- Greatfather Winter's Hearthstone
	[163045] = 278559, -- Headless Horseman's Hearthstone
	[209035] = 422284, -- Hearthstone of the Flame
	[168907] = 298068, -- Holographic Digitalization Hearthstone
	[184353] = 345393, -- Kyrian Hearthstone
	[165669] = 285362, -- Lunar Elder's Hearthstone
	[182773] = 340200, -- Necrolord Hearthstone
	[180290] = 326064, -- Night Fae Hearthstone
	[165802] = 286031, -- Noble Gardener's Hearthstone
	[228940] = 463481, -- Notorious Thread's Hearthstone
	[200630] = 391042, -- Ohn'ir Windsage's Hearthstone
	[245970] = 1240219, -- P.O.S.T. Master's Express Hearthstone
	[206195] = 412555, -- Path of the Naaru
	[165670] = 285424, -- Peddlefeet's Lovely Hearthstone
	[235016] = 1217281, -- Redeployment Module
	[212337] = 401802, -- Stone of the Hearth
	[64488] = 94719, -- The Innkeeper's Daughter
	[193588] = 375357, -- Timewalker's Hearthstone
	[142542] = 231504, -- Tome of Town Portal
	[183716] = 342122, -- Venthyr Hearthstone
	--/
	[6948] = 8690, -- Hearthstone
	[556] = 556, -- Astral Recall
	[50977] = 50977, -- Death Gate
	[18960] = 18960, -- Moonglade
	[193753] = 193753, -- Dreamwalk
	[126892] = { -- Zen Pilgrimage
		126892,
		293866 -- Returnspell
	},
	[140192] = 222695, -- Dalaran Hearthstone
	[110560] = 171253, -- Garrison Hearthstone
	[243056] = 1234526, -- Dornogal Toy (Delve reward)
	[221966] = 448126, -- Khaz Algar
	[198156] = 386379, -- Dragon Isles
	[172924] = 324031, -- Shadowlands
	[168808] = 299084, -- Zandalar
	[168807] = 299083, -- Kul Tiras
	[151652] = 250796, -- Argus
	[144341] = 200061, -- Reaves - Legion
	[112059] = 163830, -- Draenor
	[87215] = 126755, -- Pandaria
	[48933] = 67833, -- Northrend
	[30542] = 36890, -- Area 52
	[30544] = 36941, -- Toshley's Station
	[18984] = 23442, -- Everlook
	[18986] = 23453, -- Gadgetzan
}

addon.knownToys = {}
addon.knownReversed = {}
addon.missing = {}
addon.missingSorted = {}

local list = {
	[166747] = "Brewfest Reveler's Hearthstone",
	[190237] = "Broker Translocation Matrix",
	[246565] = "Cosmic Hearthstone",
	[93672] = "Dark Portal",
	[208704] = "Deepdweller's Earthen Hearthstone",
	[188952] = "Dominated Hearthstone",
	[190196] = "Enlightened Hearthstone",
	[172179] = "Eternal Traveler's Hearthstone",
	[54452] = "Ethereal Portal",
	[236687] = "Explosive Hearthstone",
	[166746] = "Fire Eater's Hearthstone",
	[162973] = "Greatfather Winter's Hearthstone",
	[163045] = "Headless Horseman's Hearthstone",
	[209035] = "Hearthstone of the Flame",
	[168907] = "Holographic Digitalization Hearthstone",
	[184353] = "Kyrian Hearthstone",
	[165669] = "Lunar Elder's Hearthstone",
	[182773] = "Necrolord Hearthstone",
	[180290] = "Night Fae Hearthstone",
	[165802] = "Noble Gardener's Hearthstone",
	[228940] = "Notorious Thread's Hearthstone",
	[200630] = "Ohn'ir Windsage's Hearthstone",
	[245970] = "P.O.S.T. Master's Express Hearthstone",
	[206195] = "Path of the Naaru",
	[165670] = "Peddlefeet's Lovely Hearthstone",
	[235016] = "Redeployment Module",
	[212337] = "Stone of the Hearth",
	[64488] = "The Innkeeper's Daughter",
	[193588] = "Timewalker's Hearthstone",
	[142542] = "Tome of Town Portal",
	[183716] = "Venthyr Hearthstone",
}
addon.initToys = function()
	table.wipe(addon.knownToys)
	table.wipe(addon.knownReversed)
	table.wipe(addon.missing)
	table.wipe(addon.missingSorted)
	for k,v in pairs(list) do
		local usable = C_ToyBox.IsToyUsable(k)
		if usable == nil or usable == "" then
			C_Timer.After(0.1, addon.initToys)
			return
		elseif usable and PlayerHasToy(k) then
			addon.knownToys[k] = v
		else
			addon.missing[k] = v
		end
	end
	local sorted = {}
	local missing = {}
	for k,v in pairs(addon.knownToys) do
		addon.knownReversed[v] = k
		table.insert(sorted, v)
	end
	for k,v in pairs(addon.missing) do
		addon.missingSorted[v] = k
		table.insert(missing, v)
	end
	table.sort(sorted)
	table.sort(missing)
	addon.knownToys = sorted
	addon.missingSorted = missing
end

