ES_Travel = LibStub("AceAddon-3.0"):NewAddon("ES_Travel", "AceEvent-3.0")
local _, addon = ...
_G["BINDING_CATEGORY_ES Travel"] = "ES_Travel"
_G["BINDING_NAME_ES_TRAVEL_GLOBAL_TOGGLE"] = "Toggle panel"
local ES_Travel_Frame = CreateFrame("Frame","ES_Travel_Frame", UIParent, "TooltipBorderedFrameTemplate")
addon.panel = CreateFrame("Frame", "ES_TravelPanel", UIParent);
ES_Travel_Frame:SetPoint("CENTER",UIParent,"CENTER",0,0)
ES_Travel_Frame:SetFrameStrata("DIALOG")
ES_Travel_Frame:Hide()
ES_Travel_Frame.dng = CreateFrame("Button", nil, ES_Travel_Frame, "SquareIconButtonTemplate")
ES_Travel_Frame.dng:SetSize(42,42)
ES_Travel_Frame.dng:SetPoint("CENTER",ES_Travel_Frame,"TOPRIGHT",-8,-8)
ES_Travel_Frame.dng:SetNormalTexture(1121272)
ES_Travel_Frame.dng:GetNormalTexture():SetTexCoord(0.133117, 0.196484, 0.258406, 0.324141)
ES_Travel_Frame.dng:SetPushedTexture(1121272)
ES_Travel_Frame.dng:GetPushedTexture():SetTexCoord(0.133117, 0.196484, 0.258406, 0.324141)

local ES_Travel_Dungeon = CreateFrame("Frame","ES_Travel_Dungeon", UIParent, "TooltipBorderedFrameTemplate")
ES_Travel_Dungeon:SetPoint("CENTER",UIParent,"CENTER",0,0)
ES_Travel_Dungeon:SetFrameStrata("DIALOG")
ES_Travel_Dungeon:Hide()
ES_Travel_Dungeon.ret = CreateFrame("Button", nil, ES_Travel_Dungeon, "SquareIconButtonTemplate")
ES_Travel_Dungeon.ret:SetSize(42,42)
ES_Travel_Dungeon.ret:SetPoint("CENTER",ES_Travel_Dungeon,"TOPRIGHT",-8,-8)
ES_Travel_Dungeon.ret:SetNormalTexture(1121272)
ES_Travel_Dungeon.ret:GetNormalTexture():SetTexCoord(0.262124, 0.3, 0.295, 0.334141)
ES_Travel_Dungeon.ret:SetPushedTexture(1121272)
ES_Travel_Dungeon.ret:GetPushedTexture():SetTexCoord(0.262124, 0.3, 0.295, 0.334141)

--
local GetItemInfoInstant = C_Item.GetItemInfoInstant
--

local count = 1
local count2 = 1
local generated = false
local playerfeedback = false
local width,height = 80, 80
local padding = 16
local validIDs = {}
local fullname

local function createNewButton(txt,left,type,right,icon,xPos,yPos,dungeon)
	local path = "Interface\\EncounterJournal\\UI-EncounterJournalTextures"
	local btn
	if dungeon then
		btn = CreateFrame("Button", "ES_Travel_Dungeon.button" .. count2, ES_Travel_Dungeon, "SecureActionButtonTemplate")
		btn:SetPoint("TOP", ES_Travel_Dungeon, "TOP", xPos, yPos)
	else
		btn = CreateFrame("Button", "ES_Travel_Frame.button" .. count, ES_Travel_Frame, "SecureActionButtonTemplate")
		btn:SetPoint("TOP", ES_Travel_Frame, "TOP", xPos, yPos)
	end
    btn:SetSize(width, height)
	btn:RegisterForClicks("AnyUp", "AnyDown")
	btn.cd = CreateFrame("Cooldown", nil, btn, "CooldownFrameTemplate")
	btn.cd:SetDrawEdge(false)
	btn.cd:SetDrawBling(false)
	btn.cd:SetAllPoints()
	local bg = btn:CreateTexture(nil, "BACKGROUND")
	bg:SetPoint("TOPLEFT", 2, -2)
	bg:SetPoint("BOTTOMRIGHT", -2, 2)
	bg:SetTexture(icon)
	local tf = CreateFrame("Frame", nil, btn)
	tf:SetAllPoints()
	tf:SetFrameStrata("TOOLTIP")
	local t = tf:CreateFontString(nil, "OVERLAY")
	t:SetPoint("TOP",0,0)
	t:SetFont("Fonts\\ARIALN.TTF", 18, "OUTLINE")
	t:SetText(txt)
    btn:SetNormalTexture(path)
    btn:GetNormalTexture():SetTexCoord(0.00195313, 0.34179688, 0.42871094, 0.52246094)
    btn:SetHighlightTexture(path)
    btn:GetHighlightTexture():SetTexCoord(0.34570313, 0.68554688, 0.33300781, 0.42675781)
	if not right then
		btn:SetAttribute("type", type)
		btn:SetAttribute(type, left)
	else
		btn:SetAttribute("type1", type)
		btn:SetAttribute(type.."1", left)
		btn:SetAttribute("type2", type)
		btn:SetAttribute(type.."2", right)
	end
	return btn
end

local function generateButtons(tbl)
	local titleSize = 26
	local xPos = 0
	local yPos = (-1 * padding) - titleSize
	local mfMax = 0
	for i=1,3 do
		if #tbl[i] > 0 then
			if yPos ~= (-1 * padding) - titleSize then
				yPos = yPos - (padding*3)
			end
			--
			local t = ES_Travel_Frame:CreateFontString(nil, "OVERLAY")
			t:SetPoint("BOTTOM", ES_Travel_Frame, "TOP", 0, yPos + 2)
			t:SetFont("Fonts\\MORPHEUS.TTF", titleSize, "")
			t:SetTextColor(1, 0.8, 0)
			t:SetText(addon.mainTitle[i])
			--
			local mRw = math.ceil(#tbl[i]/6)
			local bTBL = {}
			local max = math.ceil(#tbl[i]/mRw)
			if max > mfMax then mfMax = max end
			local rCtn = 1
			local cCtn = 1
			for j=1,#tbl[i] do
				if cCtn > max then
					rCtn = rCtn + 1
					cCtn = 1
				end
				if not bTBL[rCtn] then bTBL[rCtn] = {} end
				bTBL[rCtn][cCtn] = tbl[i][j]
				cCtn = cCtn + 1
			end
			for y=1,#bTBL do
				xPos = ((padding + width) / 2) - ((#bTBL[y]/2) * (width + padding))
				for l=1,#bTBL[y] do
					local b = bTBL[y][l]
					if b then
						local btn = createNewButton(b.name,b.left,b.type,b.right,b.icon,xPos,yPos)
						btn.type = b.type
						btn.id = b.id
						count = count + 1
						xPos = xPos + width + padding
					end
				end
				yPos = yPos - height - padding
			end
		end
	end
	mfMax = (mfMax == 0) and 0 or (mfMax >= 2) and mfMax or 2 -- Ensure the frame is wide enough to fit text if less than 2 wide
	ES_Travel_Frame:SetSize(((width+padding)*mfMax)+padding,yPos*-1)
	
	xPos = 0
	yPos = (-1 * padding) - titleSize
	mfMax = 0
	tbl = tbl[4]
	for i=1,7 do
		if #tbl[i] > 0 then
			if yPos ~= (-1 * padding) - titleSize then
				yPos = yPos - (padding*3)
			end
			local t = ES_Travel_Dungeon:CreateFontString(nil, "OVERLAY")
			t:SetPoint("BOTTOM", ES_Travel_Dungeon, "TOP", 0, yPos + 2)
			t:SetFont("Fonts\\MORPHEUS.TTF", titleSize, "")
			t:SetTextColor(1, 0.8, 0)
			t:SetText(addon.dungeonTitle[i])
			local bTBL = {}
			if #tbl[i] > mfMax then mfMax = #tbl[i] end
			local cCtn = 1
			for j=1,#tbl[i] do
				if not bTBL[1] then bTBL[1] = {} end
				bTBL[1][cCtn] = tbl[i][j]
				cCtn = cCtn + 1
			end
			for y=1,#bTBL do
				xPos = ((padding + width) / 2) - ((#bTBL[y]/2) * (width + padding))
				for l=1,#bTBL[y] do
					local b = bTBL[y][l]
					if b then
						local btn = createNewButton(b.name,b.left,b.type,b.right,b.icon,xPos,yPos,true)
						btn.type = b.type
						btn.id = b.id
						count2 = count2 + 1
						xPos = xPos + width + padding
					end
				end
				yPos = yPos - height - padding
			end
		end
	end
	mfMax = (mfMax == 0) and 0 or (mfMax >= 3) and mfMax or 3 -- Ensure the frame is wide enough to fit text if less than 3 wide
	if mfMax == 0 then -- If no dungeon ports are unlocked, give it a size of 1 button and create infotext
		mfMax = 1
		yPos = yPos - height - padding
		local tf = CreateFrame("Frame", "ES_Travel_Dungeon.button0", ES_Travel_Dungeon)
		tf:SetAllPoints()
		local t = tf:CreateFontString(nil, "OVERLAY")
		t:SetPoint("CENTER",0,0)
		t:SetFont("Fonts\\ARIALN.TTF", 18, "OUTLINE")
		t:SetText('No\ndungeon\nteleports\nunlocked')
	end
	ES_Travel_Dungeon:SetSize(((width+padding)*mfMax)+padding,yPos*-1)
end

local function customOverride()
	local toyid = false
	if ESTravel_DB[fullname] and ESTravel_DB[fullname].id then
		toyid = ESTravel_DB[fullname].id
	elseif ESTravel_DB["global"] and ESTravel_DB["global"].id then
		toyid = ESTravel_DB["global"].id
	end
	if toyid then
		validIDs[addon.spellLookup[toyid]] = true
	end
	return toyid
end

local tblInit = {}
function ES_Travel_DelayedInit()
	if generated then return end
	
	if not tblInit["loadstart"] then
		tblInit["loadstart"] = GetTime()
	end
	if not tblInit["tTBL"] then
		tblInit["tTBL"] = {[1]={},[2]={},[3]={},[4]={}}
	end
	C_ToyBox.ForceToyRefilter()
	local h = addon.general
	local idx = 1
	for i=1,#h do
		if not tblInit["addH"..i] then
			local custID = customOverride()
			if h[i].type == "spell" and C_SpellBook.IsSpellKnown(h[i].id) then
				local spInfo = C_Spell.GetSpellInfo(h[i].id)
				local spNm, icon = spInfo.name, spInfo.iconID
				tblInit["tTBL"][1][idx] = {
					name = h[i].name,
					left = spNm,
					right = false,
					type = "spell",
					id = h[i].id,
					icon = icon
				}
				tblInit["addH"..i] = true
				idx = idx + 1
			elseif h[i].type == "override" and custID and PlayerHasToy(custID) then
				local usable = C_ToyBox.IsToyUsable(custID)
				if usable == nil or usable == "" then
					C_Timer.After(0.1, ES_Travel_DelayedInit)
					return
				elseif usable then
					local _, _, icon = C_ToyBox.GetToyInfo(custID)
					tblInit["tTBL"][1][idx] = {
						name = "Hearthstone",
						left = custID,
						right = false,
						type = "toy",
						id = custID,
						icon = icon
					}
					idx = idx + 1
					tblInit["addH"..i] = true
					tblInit["override"] = true
				end
			elseif h[i].type == "toy" and PlayerHasToy(h[i].id) then
				local usable = C_ToyBox.IsToyUsable(h[i].id)
				if usable == nil or usable == "" then
					C_Timer.After(0.1, ES_Travel_DelayedInit)
					return
				elseif usable then
					local valid = true
					if h[i].quest then
						if not addon.checkQuest(h[i].id) then
							valid = false
						end
					end
					if valid then
						local _, _, icon = C_ToyBox.GetToyInfo(h[i].id)
						tblInit["tTBL"][1][idx] = {
							name = h[i].name,
							left = h[i].id,
							right = false,
							type = "toy",
							id = h[i].id,
							icon = icon
						}
						idx = idx + 1
						tblInit["addH"..i] = true
					end
				end
			elseif not (tblInit["override"] and h[i].id == 6948) then
				for bag = 0, NUM_BAG_SLOTS do
					local bSlots = C_Container.GetContainerNumSlots(bag)
					if not bSlots then break end
					for slot = 1, bSlots do
						local item =  C_Container.GetContainerItemInfo(bag, slot)
						if item and item.itemID == h[i].id then
							local icon = select(5,GetItemInfoInstant(h[i].id))
							tblInit["tTBL"][1][idx] = {
								name = h[i].short or h[i].name,
								left = h[i].name,
								right = false,
								type = "item",
								id = h[i].id,
								icon = icon
							}
							idx = idx + 1
							tblInit["addH"..i] = true
						end
					end
				end
			end
		else
			idx = idx + 1
		end
	end
	local w = addon.wormholes
	idx = 1
	for i=1,#w do
		if not tblInit["addW"..i] then
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
							tblInit["tTBL"][2][idx] = {
								name = "Legion",
								left = bot[item.itemID],
								right = false,
								type = "item",
								id = item.itemID,
								icon = icon
							}
							idx = idx + 1
							tblInit["addW"..i] = true
						end
					end
				end
			elseif w[i].id and PlayerHasToy(w[i].id) then
				local usable = C_ToyBox.IsToyUsable(w[i].id)
				if usable == nil or usable == "" then
					C_Timer.After(0.1, ES_Travel_DelayedInit)
					return
				elseif usable then
					local _, _, icon = C_ToyBox.GetToyInfo(w[i].id)
					tblInit["tTBL"][2][idx] = {
						name = w[i].name,
						left = w[i].id,
						right = false,
						type = "toy",
						id = w[i].id,
						icon = icon
					}
					idx = idx + 1
					tblInit["addW"..i] = true
				end
			end
		else
			idx = idx + 1
		end
	end
	if (select(3,UnitClass("player")) == 8) then
		idx = 1
		local p = addon.ports
		for i=1,#p do
			if p[i].tele and C_SpellBook.IsSpellKnown(p[i].tele) then
				local right
				if p[i].port and C_SpellBook.IsSpellKnown(p[i].port) then
					local spNm2 = C_Spell.GetSpellInfo(p[i].port).name
					right = spNm2
				end
				local spInfo = C_Spell.GetSpellInfo(p[i].tele)
				local spNm, icon = spInfo.name, spInfo.iconID
				tblInit["tTBL"][3][idx] = {
					name = p[i].name,
					left = spNm,
					right = right or false,
					type = "spell",
					id = p[i].id,
					icon = icon
				}
				idx = idx + 1
			end
		end
	end
	local d = addon.dungeon
	for i=1,#d do
		idx = 1
		tblInit["tTBL"][4][i] = {}
		for k,v in pairs(d[i]) do
			if C_SpellBook.IsSpellKnown(k) then
				local spInfo = C_Spell.GetSpellInfo(k)
				local spNm, icon = spInfo.name, spInfo.iconID
				tblInit["tTBL"][4][i][idx] = {
					name = v,
					left = spNm,
					right = false,
					type = "spell",
					id = k,
					icon = icon
				}
				idx = idx + 1
			end
		end
	end
	generateButtons(tblInit["tTBL"])
	if playerfeedback then
		playerfeedback = false
		PlaySound(15273, "Master", true)
	end
	local strTime = ""
	local seconds = GetTime() - tblInit["loadstart"]
	if seconds > 0 then
		local hours = math.floor(seconds/3600)
		if hours > 0 then strTime = strTime .. hours .. ' hr, ' end
		local mins = math.floor(seconds/60 - (hours*60))
		if mins > 0 then strTime = strTime .. mins .. ' min, ' end
		local secs = string.format("%.1f", seconds - hours*3600 - mins *60)
		strTime = '(' .. strTime .. secs .. ' sec)'
	else
		strTime = '(0 sec)'
	end
	print('|cff00b4ffES_Travel: |r|cff00ff00Load completed|r |cffb2b2b2'..strTime..'|r')
	addon.initToys()
	generated = true
	ES_Travel:RegisterEvent("UNIT_SPELLCAST_START", "Handler1")
	ES_Travel:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "Handler1")
	ES_Travel:RegisterEvent("PLAYER_REGEN_DISABLED", "Handler2")
	wipe(tblInit)
end

local function toggleShow(arg,dungeon)
	if arg == "show" then
		if not (UnitAffectingCombat("player") or InCombatLockdown()) then
			if dungeon then
				ES_Travel_Frame:Hide()
				ES_Travel_Dungeon:Show()
			else
				C_ToyBox.ForceToyRefilter()
				ES_Travel_Dungeon:Hide()
				ES_Travel_Frame:Show()
			end
		end
	else
		ES_Travel_Dungeon:Hide()
		ES_Travel_Frame:Hide()
	end
end

ES_Travel_Frame.dng:SetScript("OnClick", function()
	toggleShow("show",true)
end)

ES_Travel_Dungeon.ret:SetScript("OnClick", function()
	toggleShow("show")
end)

function ES_Travel_Toggle()
	if not generated then
		print('|cff00b4ffES_Travel: |r|cffff0000Issue fetching data from API. Load pending!')
		playerfeedback = true
		return
	end
	if ES_Travel_Frame:IsVisible() then
		toggleShow("hide")
	else
		toggleShow("show")
	end
end

function ES_Travel:Handler1(event, unit, cast, spellID)
	if not (ES_Travel_Frame:IsVisible() or ES_Travel_Dungeon:IsVisible()) then return end
	if not unit or not (unit == "player") then return end
	if not spellID or not validIDs[spellID] then return end	
	toggleShow("hide")
	if spellID == 163830 then
		print('|cff00b4ff### Wormhole Centrifuge ###|r')
		print("A jagged landscape " .. '|cffffc700(Spires of Arak)|r')
		print("A reddush-orange forest " .. '|cffffc700(Talador)|r')
		print("Shadows... " .. '|cffffc700(Shadowmoon Valley)|r')
		print("Grassy plains " .. '|cffffc700(Nagrand)|r')
		print("Primal forest " .. '|cffffc700(Gorgrond)|r')
		print("Lava and snow " .. '|cffffc700(Frostfire Ridge)|r')
	end
end

function ES_Travel:Handler2(event, ...)
	if ES_Travel_Frame:IsVisible() or ES_Travel_Dungeon:IsVisible() then
		toggleShow("hide")
	end
end

ES_Travel_Frame:SetScript("OnShow", function()
	for i=1,count do
		local f = _G["ES_Travel_Frame.button"..i]
		if f then
			f.cd:Clear()
			if f.type == "spell" and f.id then
				local cdLP = C_Spell.GetSpellCooldown(f.id)
				local start, dur = cdLP.startTime, cdLP.duration
				if start and start > 0 then
					f.cd:SetCooldown(start, dur)
				end
			elseif f.type == "item" then
				local start, dur, _ = C_Container.GetItemCooldown(f.id)
				if start and start > 0 then
					f.cd:SetCooldown(start, dur)
				end
			elseif f.type == "toy" then
				local start, dur, _ = C_Container.GetItemCooldown(f.id)
				if start and start > 0 then
					f.cd:SetCooldown(start, dur)
				end
			end
		end
	end
end)
ES_Travel_Dungeon:SetScript("OnShow", function()
	for i=1,count2 do
		local f = _G["ES_Travel_Dungeon.button"..i]
		if f and f.type == "spell" and f.id then
			f.cd:Clear()
			local cdLP = C_Spell.GetSpellCooldown(f.id)
			local start, dur = cdLP.startTime, cdLP.duration
			if start and start > 0 then
				f.cd:SetCooldown(start, dur)
			end
		end
	end
end)
-- /

--## Interface Options ##
addon.panel.name = "ES_Travel";
local category, layout = Settings.RegisterCanvasLayoutCategory(addon.panel, addon.panel.name);
Settings.RegisterAddOnCategory(category);


local opTitle = addon.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
opTitle:SetText('|cffFFd200ES_Travel|r')
opTitle:SetPoint("TOPLEFT", 15, -15)
opTitle:SetTextScale(1.5)

local opDD1 = CreateFrame("DropdownButton", "ES_Travel_GlobalOverride", addon.panel, "WowStyle1DropdownTemplate")
opDD1:SetPoint("TOPLEFT", 15, -140)
opDD1:SetWidth(300)
opDD1:SetScript("OnShow", function(self)
	self:SetDefaultText(ESTravel_DB["global"] and ESTravel_DB["global"].name or "Disabled")
end)
opDD1:SetupMenu(function(dropdown, rootDescription)
	local string = '|cff00b4ffES_Travel: |rReload interface to update the travel frame.'
    rootDescription:CreateButton("Disable", function()
		dropdown:SetDefaultText("Disabled")
		ESTravel_DB["global"] = false
		print(string)
	end)
	if addon.knownToys then
		for _,name in ipairs(addon.knownToys) do
			local id = addon.knownReversed[name]
			rootDescription:CreateButton(name, function()
				dropdown:SetDefaultText(name)
				ESTravel_DB["global"] = {
					["id"] = id,
					["name"] = name
					};
				print(string);
			end)
		end
	end
end)
opDD1.title = opDD1:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
opDD1.title:SetPoint("BOTTOMLEFT", opDD1, "TOPLEFT", 0, 2)
opDD1.title:SetText('|cffffffffHearthstone override for all characters.|r')

local opDD2 = CreateFrame("DropdownButton", "ES_Travel_CharacterOverride", addon.panel, "WowStyle1DropdownTemplate")
opDD2:SetPoint("TOPLEFT", 15, -80)
opDD2:SetWidth(300)
opDD2:SetScript("OnShow", function(self)
	self:SetDefaultText(ESTravel_DB[fullname] and ESTravel_DB[fullname].name or "Disabled")
end)
opDD2:SetupMenu(function(dropdown, rootDescription)
	local string = '|cff00b4ffES_Travel: |rReload interface to update the travel frame.'
    rootDescription:CreateButton("Disable", function()
		dropdown:SetDefaultText("Disabled")
		ESTravel_DB[fullname] = false
		print(string)
	end)
	if addon.knownToys then
		for _,name in ipairs(addon.knownToys) do
			local id = addon.knownReversed[name]
			rootDescription:CreateButton(name, function()
				dropdown:SetDefaultText(name)
				ESTravel_DB[fullname] = {
					["id"] = id,
					["name"] = name
					};
				print(string);
			end)
		end
	end
end)
opDD2.title = opDD2:CreateFontString(nil, 'ARTWORK', 'GameFontNormal')
opDD2.title:SetPoint("BOTTOMLEFT", opDD2, "TOPLEFT", 0, 2)
opDD2.title:SetText('|cffffffffHearthstone override for this character. (Takes priority)|r')

local opInfo = addon.panel:CreateFontString(nil, "OVERLAY", "GameFontNormal")
opInfo:SetText('|cffFFd200To ensure that any changed setting will be loaded correctly, you have to\nreload your interface after making alterations.\n\n\nTo set a keybind to toggle the travel-frame, you can\nfind it in the keybinding menu in interface options.\n\n\n\nSet windowscale through chat command:\n\n/es_t scale 1\n\n0.5 - 2|r')
opInfo:SetPoint("TOPLEFT", 15, -220)
opInfo:SetJustifyH("LEFT")
-- /

local function ES_Travel_SetScale(scale)
	scale = scale or ESTravel_DB["scale"] or 1
	
	ES_Travel_Frame:SetScale(scale)
	ES_Travel_Dungeon:SetScale(scale)
	
	ESTravel_DB["scale"] = scale
end

function ES_Travel:OnInitialize()
	fullname = UnitName("player") .. '-' .. GetRealmName()
	ESTravel_DB = ESTravel_DB or {
		["scale"] = 1,
		["global"] = false,
		[fullname] = false
	}
	for i=1,#addon.general do
		local id = addon.general[i].id
		if id then
			local e = addon.spellLookup[id]
			if type(e) == "table" then
				for _,idx in ipairs(e) do
					validIDs[idx] = true
				end
			else
				validIDs[e] = true
			end
		end
	end
	for i=1,#addon.wormholes do
		local id = addon.wormholes[i].id
		if id then
			validIDs[addon.spellLookup[id]] = true
		end
	end
	for i=1,#addon.ports do
		if addon.ports[i].port then
			validIDs[addon.ports[i].port] = true
		end
		if addon.ports[i].tele then
			validIDs[addon.ports[i].tele] = true
		end
	end
	for i=1,7 do
		for k,v in pairs(addon.dungeon[i]) do
			if k then
				validIDs[k] = true
			end
		end
	end
	C_Timer.After(3, function()
		ES_Travel_DelayedInit()
	end)
	ES_Travel_SetScale()
end

SLASH_ESTRAVEL1 = "/es_t";
SlashCmdList["ESTRAVEL"] = function(msg)
	local s1, sT = strsplit(" ", msg, 2)
	local s2 = tonumber(sT)
	if s1 == "scale" then
		if s2 and (s2 >= 0.5) and (s2 <= 2) then
			ES_Travel_SetScale(s2)
		else
			print('|cff00b4ffES_Travel: |rInvalid numbervalue. Accepting 0.5 up to 2')
		end
	else
		print('|cff00b4ffES_Travel: |rValid commands: \n|cfffff400/es_t scale 1 |r(to set frame size for your account [0.5 - 2])')
	end
end