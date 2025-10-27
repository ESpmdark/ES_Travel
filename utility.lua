local _, addon = ...
local GetItemInfoInstant = C_Item.GetItemInfoInstant

local function customOverride()
	local toyid = false
	if ESTravel_DB[addon.fullname] and ESTravel_DB[addon.fullname].id then
		toyid = ESTravel_DB[addon.fullname].id
	elseif ESTravel_DB["global"] and ESTravel_DB["global"].id then
		toyid = ESTravel_DB["global"].id
	end
	if toyid then
		addon.validIDs[addon.spellLookup[toyid]] = true
	end
	return toyid
end

local tblInit = {[1]={},[2]={},[3]={},[4]={}}

local toyCheckButton
local function isActuallyUsable(toyID)
    toyCheckButton:SetAttribute("toy", toyID)
    if C_ToyBox.IsToyUsable(toyID) then
		return true
    end
	return false
end

local function checkEngineering()
	local w = addon.wormholes
	local count = 1
    for i=1,#w do
	    if w[i].type then -- Reaves
		    local bot = {
			    [132523] = "Reaves Battery",
			    [144341] = "Rechargeable Reaves Battery"
		    }
		    for bag = 0, NUM_BAG_SLOTS do
				local bSlots = C_Container.GetContainerNumSlots(bag)
   				if not bSlots then break end
    			for slot = 1, bSlots do
	    			local item =  C_Container.GetContainerItemInfo(bag, slot)
		    		if item and item.itemID and bot[item.itemID] and C_QuestLog.IsQuestFlaggedCompleted(40738) then
			    		local icon = select(5,GetItemInfoInstant(item.itemID))
				    	tblInit[2][count] = {
							name = "Legion",
   							left = bot[item.itemID],
    						right = false,
	    					type = "item",
		    				id = item.itemID,
			    			icon = icon
						}
                        count = count + 1
	    			end
		    	end
			end
   		elseif PlayerHasToy(w[i].id) and isActuallyUsable(w[i].id) then
			local icon, _ = select(5,GetItemInfoInstant(w[i].id))
   	    	tblInit[2][count] = {
       			name = w[i].name,
	    		left = w[i].id,
		    	right = false,
			    type = "toy",
		    	id = w[i].id,
	    		icon = icon
       		}
            count = count + 1
   		end
    end
end

local function checkEntryGeneral()
    local custID = customOverride()
    local h = addon.general
    local count = 1
    if custID and PlayerHasToy(custID) then
        local icon, _ = select(5,GetItemInfoInstant(custID))
        tblInit[1][count] = {
			name = "Hearthstone",
			left = custID,
			right = false,
			type = "toy",
			id = custID,
			icon = icon
		}
        count = 2
    else
        custID = false
    end
	for i=1,#h do
		if h[i].type == "spell" and C_SpellBook.IsSpellKnown(h[i].id) then
			local spInfo = C_Spell.GetSpellInfo(h[i].id)
			local spNm, icon = spInfo.name, spInfo.iconID
			tblInit[1][count] = {
				name = h[i].name,
				left = spNm,
				right = false,
				type = "spell",
				id = h[i].id,
				icon = icon
			}
            count = count + 1
		elseif h[i].type == "toy" and PlayerHasToy(h[i].id) then
			local valid = true
			if h[i].quest then
				if not addon.checkQuest(h[i].id) then
					valid = false
				end
			end
			if valid then
                local icon, _ = select(5,GetItemInfoInstant(h[i].id))
				tblInit[1][count] = {
					name = h[i].name,
					left = h[i].id,
					right = false,
					type = "toy",
					id = h[i].id,
					icon = icon
				}
                count = count + 1
			end
		elseif not custID and h[i].id == 6948 then
			for bag = 0, NUM_BAG_SLOTS do
				local bSlots = C_Container.GetContainerNumSlots(bag)
				if not bSlots then break end
				for slot = 1, bSlots do
					local item =  C_Container.GetContainerItemInfo(bag, slot)
					if item and item.itemID == h[i].id then
						local icon, _ = select(5,GetItemInfoInstant(h[i].id))
						tblInit[1][count] = {
							name = h[i].short or h[i].name,
							left = h[i].name,
							right = false,
							type = "item",
							id = h[i].id,
							icon = icon
						}
                        count = count + 1
					end
				end
			end
		end
	end
end

addon.loadEntries = function()
    checkEntryGeneral()
	local prof1, prof2, _ = GetProfessions()
	local isEngineer = (prof1 and select(7,GetProfessionInfo(prof1)) == 202) or (prof2 and select(7,GetProfessionInfo(prof2)) == 202) or false
	if isEngineer then
		toyCheckButton = CreateFrame("Button", "ES_Travel_Secure", UIParent, "SecureActionButtonTemplate")
		toyCheckButton:SetAttribute("type", "toy")
		toyCheckButton:Hide()
		checkEngineering()
	end
    if (select(3,UnitClass("player")) == 8) then
		local p = addon.ports
        local count = 1
		for i=1,#p do
			if p[i].tele and C_SpellBook.IsSpellKnown(p[i].tele) then
				local right
				if p[i].port and C_SpellBook.IsSpellKnown(p[i].port) then
					local spNm2 = C_Spell.GetSpellInfo(p[i].port).name
					right = spNm2
				end
				local spInfo = C_Spell.GetSpellInfo(p[i].tele)
				local spNm, icon = spInfo.name, spInfo.iconID
				tblInit[3][count] = {
					name = p[i].name,
					left = spNm,
					right = right or false,
					type = "spell",
					id = p[i].id,
					icon = icon
				}
                count = count + 1
			end
		end
	end
	local d = addon.dungeon
	for i=1,#d do
		tblInit[4][i] = {}
        local count = 1
		for k,v in pairs(d[i]) do
			if C_SpellBook.IsSpellKnown(k) then
				local spInfo = C_Spell.GetSpellInfo(k)
				local spNm, icon = spInfo.name, spInfo.iconID
				tblInit[4][i][count] = {
					name = v,
					left = spNm,
					right = false,
					type = "spell",
					id = k,
					icon = icon
				}
                count = count + 1
			end
		end
	end
    addon.generateButtons(tblInit)
	addon.initToys()
    addon.registerEvents()
	wipe(tblInit)
    addon.generated = true
    print('|cff00b4ffES_Travel: |r|cff00ff00Load completed|r')
end