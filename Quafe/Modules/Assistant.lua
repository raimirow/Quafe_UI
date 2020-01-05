local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

--- ------------------------------------------------------------
--> API Localization
--- ------------------------------------------------------------

local _G = getfenv(0)
local format = string.format
local find = string.find

local min = math.min
local max = math.max
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local rad = math.rad
local acos = math.acos
local atan = math.atan
local rad = math.rad
local modf = math.modf

local insert = table.insert
local remove = table.remove
local wipe = table.wipe

local GetTime = GetTime

----------------------------------------------------------------
--> SoulStone
----------------------------------------------------------------

--UNIT_SPELLCAST_START
--arg1 Unit casting the spell
--arg2 Spell lineID counter
--arg3 Spell ID (added in 4.0)

--"UNIT_SPELLCAST_SENT"
--arg1 Unit casting the spell
--arg2 <no longer produced>
--arg3 Complex string similar to a GUID. For Flare this appeared: Cast-3-3783-1-7-1543-000197DD84. 1543 is the SpellID. Identification of the rest of that string is needed.
--arg4 Varies. Occasionally the Spell ID, but not always. Occasionally the target, but not always.

--local name, text, texture, startTimeMS, endTimeMS, isTradeSkill, castID, notInterruptible, spellId = UnitCastingInfo("unit")

local SoulStone_List = {
	20707, --灵魂石
	20484, --复生
	61999, --复活盟友
}

local function SoulStoneNotification_StyleName(name)
	if UnitIsPlayer(name) then
		local eClass = select(2, UnitClass(name))
		local eColor = C.Color.Class[eClass] or C.Color.White
		return string.format("\124Hunit:%s:%s\124h%s[%s]\124r\124h", UnitGUID(name), name, F.Hex(eColor), name)
	else
		return "["..name.."]"
	end
end

local function SoulStoneNotification_Event(self, event, ...)
	local arg1, arg2, arg3, arg4 = ...
	if event == "UNIT_SPELLCAST_SENT" then
		if arg1 == "player" and tContains(SoulStone_List, arg4) then
			self.TargetName = arg2
		end
	end
	if event == "UNIT_SPELLCAST_START" then
		if arg1 == "player" and tContains(SoulStone_List, arg3) then
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone then
				if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone == "player" then
					DEFAULT_CHAT_FRAME:AddMessage(GetSpellLink(arg3).." >>> "..SoulStoneNotification_StyleName(self.TargetName))
				elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone == "instance" then
					if self.TargetName == F.PlayerName then
						DEFAULT_CHAT_FRAME:AddMessage(GetSpellLink(arg3).." >>> "..SoulStoneNotification_StyleName(self.TargetName))
					else
						SendChatMessage(GetSpellLink(arg3).." >>> "..SoulStoneNotification_StyleName(self.TargetName), IsInGroup(2) and "INSTANCE_CHAT" or IsInRaid() and "RAID" or IsInGroup(1) and "PARTY")
					end
				end
			end
		end
	end
end

local function SoulStoneNotification_OnEvent(frame)
	frame:RegisterEvent("UNIT_SPELLCAST_SENT")
	frame:RegisterEvent("UNIT_SPELLCAST_START")
	frame:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
	frame: SetScript("OnEvent", function(self, event, ...)
		SoulStoneNotification_Event(self, event, ...)
	end)
end

local function Quafe_SSN_Toggle(arg)
	if arg == "ON" then
		if not Quafe_Assistant.SSN.Init then
			SoulStoneNotification_OnEvent(Quafe_Assistant.SSN)
			Quafe_Assistant.SSN.Init = true
			Quafe_Assistant.SSN.RE = true
		elseif not Quafe_Assistant.SSN.RE then
			Quafe_Assistant.SSN:RegisterEvent("UNIT_SPELLCAST_SENT")
			Quafe_Assistant.SSN:RegisterEvent("UNIT_SPELLCAST_START")
			Quafe_Assistant.SSN.RE = true
		end
	elseif arg == "OFF" then
		if Quafe_Assistant.SSN.RE then
			Quafe_Assistant.SSN:UnregisterEvent("UNIT_SPELLCAST_SENT")
			Quafe_Assistant.SSN:UnregisterEvent("UNIT_SPELLCAST_START")
			Quafe_Assistant.SSN.RE = false
		end
	end
end

local function SoulStoneNotification_Create(frame)
	local SSN = CreateFrame("Frame", nil, frame)
	SSN.Init = false
	SSN.RE = false
	frame.SSN = SSN

	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone then
		Quafe_SSN_Toggle("ON")
	end
end

----------------------------------------------------------------
--> 职业大厅信息栏
----------------------------------------------------------------

local Quafe_SkinOrderHall = CreateFrame("Frame", nil, E)
Quafe_SkinOrderHall.Info = {}
Quafe_SkinOrderHall.Init = false

local function SkinOrderHall_New()
	OrderHallCommandBar.Background: SetAlpha(0.5)
	OrderHallCommandBar.Background: SetTexture(F.Path("StatusBar\\Raid"))
	OrderHallCommandBar.Background: SetVertexColor(F.Color(C.Color.W1))
end

local function SkinOrderHall_Old()
	OrderHallCommandBar.Background: SetAlpha(Quafe_SkinOrderHall.Info.Alpha)
	OrderHallCommandBar.Background: SetTexture(Quafe_SkinOrderHall.Info.Texture)
	OrderHallCommandBar.Background: SetVertexColor(Quafe_SkinOrderHall.Info.Color)
end

local function SkinOrderHall_Load()
	if F.IsClassic then return end
	if (not IsAddOnLoaded("Blizzard_OrderHallUI")) then
		LoadAddOn("Blizzard_OrderHallUI")
	end
	Quafe_SkinOrderHall.Info.Alpha = OrderHallCommandBar.Background:GetAlpha()
	Quafe_SkinOrderHall.Info.Texture = OrderHallCommandBar.Background:GetTexture()
	Quafe_SkinOrderHall.Info.Color = OrderHallCommandBar.Background:GetVertexColor()
	SkinOrderHall_New()
	Quafe_SkinOrderHall.Init = true
end

local function Quafe_SOH_Toggle(arg)
	if arg == "ON" then
		if not Quafe_SkinOrderHall.Init then
			SkinOrderHall_Load()
		else
			SkinOrderHall_New()
		end
	elseif arg == "OFF" then
		SkinOrderHall_Old()
	end
end

---——------------------------------------------------------------
--> Character Frame
---——------------------------------------------------------------
-- itemLevel = LibItemUpgradeInfo:GetUpgradedItemLevel(itemString)
-- "itemLink" = GetInventoryItemLink("unit", slotId)
-- current, maximum = GetInventoryItemDurability(slotID)
-- itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, iconFileDataID, itemSellPrice = GetItemInfo(itemID or "itemString" or "itemName" or "itemLink")

local PosSlot = {[0] = "Top", [1] = "Right", [2] = "Right", [3] = "Right", [4] = "Right", [5] = "Right", [6] = "Left", [7] = "Left", [8] = "Left", [9] = "Right", [10] = "Left", [11] = "Left", [12] = "Left", [13] = "Left", [14] = "Left", [15] = "Right", [16] = "Top", [17] = "Top", [18] = "Top"}

local function Get_ItemGem(itemLink)
	if not itemLink then return end
	local num = 0
	local gems = {}
	local stats = GetItemStats(itemLink)
	if stats then
		for k, v in pairs(stats) do
			if find(k, "EMPTY_SOCKET_") then
				num = num + v
			end
		end
	end
	if num > 0 then
		for i = 1, num do
			local name, link = GetItemGem(itemLink, i)
			insert(gems, {Name = name, Link = link})
		end
	end
	return num, gems
end

local function Create_GemButton(f)
	local frame = CreateFrame("Button", nil, f)
	frame: SetSize(12,12)
	frame.Bg = F.create_Texture(frame, "BACKGROUND", "Addition_Gem1")
	frame.Bg: SetSize(12,12)
	frame.Bg: SetPoint("CENTER", frame, "CENTER", 0,0)
	
	frame.Icon = F.create_Texture(frame, "BORDER")
	frame.Icon: SetSize(10,10)
	frame.Icon: SetPoint("CENTER", frame, "CENTER", 0,0)
	
	frame.Bd = F.create_Texture(frame, "OVERLAY", "Addition_Gem2")
	frame.Bd: SetSize(12,12)
	frame.Bd: SetPoint("CENTER", frame, "CENTER", 0,0)
	frame: SetScript("OnEnter", function(self)
		if self.ItemLink then
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetHyperlink(self.ItemLink)
			GameTooltip:Show()
		end
	end)
	frame: SetScript("OnLeave", function(self)
		GameTooltip: Hide()
	end)
	return frame
end

local function Create_ItemGem(f, itemLink, slotID)
	local num, gems = Get_ItemGem(itemLink)
	if num and num > 0 then
		for i = 1, num do
			if not f["Gem"..i] then
				f["Gem"..i] =Create_GemButton(f)
			end
			if gems[i]["Link"] then
				f["Gem"..i].ItemLink = gems[i]["Link"]
				local itemType, itemSubType, _,_, itemTexture = select(6, GetItemInfo(gems[i]["Link"]))
				f["Gem"..i].Icon: SetTexture(itemTexture)
			else
				f["Gem"..i].ItemLink = nil
				f["Gem"..i].Icon: SetTexture("")
				--f["Gem"..i].Icon: SetTexture("Interface\\ItemSocketingFrame\\UI-EmptySocket")
			end
			if PosSlot[slotID] == "Right" then
				if i == 1 then
					f["Gem"..i]: SetPoint("TOPLEFT", f, "TOPRIGHT", 10, 0)
				else
					f["Gem"..i]: SetPoint("TOP", f["Gem"..(i-1)], "BOTTOM", 0, 0)
				end
			elseif PosSlot[slotID] == "Left" then
				if i == 1 then
					f["Gem"..i]: SetPoint("TOPRIGHT", f, "TOPLEFT", -10, 0)
				else
					f["Gem"..i]: SetPoint("TOP", f["Gem"..(i-1)], "BOTTOM", 0, 0)
				end
			elseif PosSlot[slotID] == "Top" then
				if i == 1 then
					f["Gem"..i]: SetPoint("BOTTOMLEFT", f, "TOPLEFT", 0, 8)
				else
					f["Gem"..i]: SetPoint("LEFT", f["Gem"..(i-1)], "RIGHT", 0, 0)
				end
			end
			f["Gem"..i]:Show()
		end
		for i = num+1, 4 do
			if f["Gem"..i] then
				f["Gem"..i]:Hide()
			end
		end
	else
		for i = 1, 4 do
			if f["Gem"..i] then
				f["Gem"..i]:Hide()
			end
		end
	end
end

local function Hook_PaperDollSlotButton(self, unit)
	local slotID = self:GetID()
	local ItemLevel, ItemLink, ItemQuality, CurDura, MaxDura
	
	ItemLink = GetInventoryItemLink(unit, slotID)
	if ItemLink then
		TextureName = GetInventoryItemTexture(unit, slotID)
		ItemQuality = GetInventoryItemQuality(unit, slotID)
		CurDura, MaxDura = GetInventoryItemDurability(slotID)
		ItemLevel = GetDetailedItemLevelInfo(ItemLink)
	end
	--[[
	if unit and textureName then
		--itemLevel, _, itemLink, quality = select(2, LibItemInfo:GetUnitItemInfo(unit, slotID))

		local EffectiveItemLevel,IsPreview, ItemLevel = GetDetailedItemLevelInfo(itemLink)
		if (slotID == 16) or (slotID == 17) then
			local _, mlevel, _, _, mquality = LibItemInfo:GetUnitItemInfo(unit, 16)
			local _, olevel, _, _, oquality = LibItemInfo:GetUnitItemInfo(unit, 17)
			if (mlevel > 0 and olevel > 0 and (mquality == 6 or oquality == 6)) then
				itemLevel = max(mlevel,olevel)
			end
		end
	else
		itemLevel = 0
	end
	--]]
	
	if not self.ItemFrame then
		local ItemFrame = CreateFrame("Frame", nil, self)
		ItemFrame: SetFrameLevel(self:GetFrameLevel()+1)
		ItemFrame: SetAllPoints(self)
		
		self.ItemFrame = ItemFrame
		self.ItemFrame.Level = F.create_Font(self.ItemFrame, C.Font.NumSmall, 12, "OUTLINE", 0, "CENTER", "CENTER")
		self.ItemFrame.Level: SetTextColor(F.Color(C.Color.W4))
		self.ItemFrame.Level: SetAlpha(0.9)
		self.ItemFrame.Level: SetPoint("CENTER", self.ItemFrame, "CENTER", 1,0)
		
		local DuraBar = CreateFrame("StatusBar", nil, self.ItemFrame)
		DuraBar: SetStatusBarTexture(F.Path("StatusBar\\Flat"))
		DuraBar: SetStatusBarColor(F.Color(C.Color.Y2))
		DuraBar: SetRotatesTexture(true)
		if PosSlot[slotID] == "Right" then
			DuraBar: SetOrientation("VERTICAL")
			DuraBar: SetPoint("BOTTOMLEFT", self.ItemFrame, "BOTTOMRIGHT", 1,1)
			DuraBar: SetPoint("TOPRIGHT", self.ItemFrame, "TOPRIGHT", 5,-1)
		elseif PosSlot[slotID] == "Left" then
			DuraBar: SetOrientation("VERTICAL")
			DuraBar: SetPoint("BOTTOMLEFT", self.ItemFrame, "BOTTOMLEFT", -5,1)
			DuraBar: SetPoint("TOPRIGHT", self.ItemFrame, "TOPLEFT", -1,-1)
		elseif PosSlot[slotID] == "Top" then
			DuraBar: SetOrientation("HORIZONTAL")
			DuraBar: SetPoint("BOTTOMLEFT", self.ItemFrame, "TOPLEFT", 1,1)
			DuraBar: SetPoint("TOPRIGHT", self.ItemFrame, "TOPRIGHT", -1,5)
		end
		DuraBar: SetMinMaxValues(0, 1)
		DuraBar: SetValue(0)
		self.ItemFrame.DuraBar = DuraBar
		
		self.ItemFrame.DuraBarBg = F.create_Texture(self.ItemFrame, "BACKGROUND", "White", C.Color.W1, 0.9)
		self.ItemFrame.DuraBarBg: SetAllPoints(self.ItemFrame.DuraBar)
	end
	if ItemLevel and (ItemLevel > 0) then
		self.ItemFrame.Level: SetText(ItemLevel)
	else
		self.ItemFrame.Level: SetText("")
	end
	if MaxDura then
		self.ItemFrame.DuraBar: SetValue(CurDura/(MaxDura+F.Debug))
		self.ItemFrame.DuraBar: Show()
	else
		self.ItemFrame.DuraBar: Hide()
	end
	Create_ItemGem(self.ItemFrame, ItemLink, slotID)
end

local function Hook_EquipmentFlyout_DisplayButton(button, paperDollItemSlot)
	local location = button.location;
	if ( not location ) then
		return;
	end
	local player, bank, bags, voidStorage, slotID, bagID, tab, voidSlot = EquipmentManager_UnpackLocation(location)
	if (not (player or bank or bags)) then 
		return;
	end
	local itemLink
	if bags then
		itemLink = GetContainerItemLink(bagID, slotID)
	else
		itemLink = GetInventoryItemLink("player", slotID)
	end
	local itemLevel = GetDetailedItemLevelInfo(itemLink)
	
	if not button.ItemFrame then
		local ItemFrame = CreateFrame("Frame", nil, button)
		ItemFrame: SetFrameLevel(button:GetFrameLevel()+1)
		ItemFrame: SetAllPoints(button)
		
		button.ItemFrame = ItemFrame
		button.ItemFrame.Level = F.create_Font(button.ItemFrame, C.Font.NumSmall, 12, "OUTLINE", 0, "CENTER", "CENTER")
		button.ItemFrame.Level: SetTextColor(F.Color(C.Color.W4))
		button.ItemFrame.Level: SetAlpha(0.9)
		button.ItemFrame.Level: SetPoint("CENTER", button.ItemFrame, "CENTER", 1,0)
	end
	if itemLevel  and (itemLevel > 0) then
		button.ItemFrame.Level: SetText(itemLevel)
	else
		button.ItemFrame.Level: SetText("")
	end
end

local Quafe_CharacterFrame = CreateFrame("Frame", nil, E)
Quafe_CharacterFrame.Init = false

local function Quafe_CharacterFrame_Load()
	hooksecurefunc("PaperDollItemSlotButton_Update", function(self)
		Hook_PaperDollSlotButton(self, "player")
	end)
	if F.IsClassic then
		
	else
		hooksecurefunc("EquipmentFlyout_DisplayButton", function(button, paperDollItemSlot)
			Hook_EquipmentFlyout_DisplayButton(button, paperDollItemSlot)
		end)
	end
	Quafe_CharacterFrame.Init = true
end

local function Quafe_CharacterFrame_Toggle(arg)
	if arg == "ON" then
		if not Quafe_CharacterFrame.Init then
			Quafe_CharacterFrame_Load()
		end
	elseif arg == "OFF" then
		Quafe_NoticeReload()
	end
end

----------------------------------------------------------------
--> Assistants
----------------------------------------------------------------

local Quafe_Assistant = CreateFrame("Frame", "Quafe_Assistant", E)

local function Quafe_Assistant_Load()
	SoulStoneNotification_Create(Quafe_Assistant)
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SkinOrderHall then
		SkinOrderHall_Load()
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.CharacterFrame then
		Quafe_CharacterFrame_Load()
	end
end

local Quafe_Assistant_Config = {
	Database = {
		["Quafe_Assistant"] = {
			SoulStone = false,
			SkinOrderHall = true,
			CharacterFrame = false,
		},
	},

	Config = {
		Name = L['ASSISTANT'],
		Type = "Blank", --Switch, Trigger, Blank, Dropdown
		Sub = {
			[1] = {
				Name = L['AUTO_SCALE'],
				Text = L['START'],
				Type = "Trigger",
				Click = function(self, button)
					F.AutoScale()
				end,
				Show = function(self)

				end,
			},
			[2] = {
				Name = L['RESURRECTION_NOTIFICATION'],
				Text = L["OFF"],
				Type = "Dropdown",
				Click = function(self, button)

				end,
				Load = function(self)

				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone then
						if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone == "player" then
							self.Text:SetText(L['PLAYER'])
						elseif Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone == "instance" then
							self.Text:SetText(INSTANCE)
						end
					else
						self.Text:SetText(L["OFF"])
					end
				end,
				DropMenu = {
					[1] = {
						Text = L['OFF'],
						Click = function(self, button) 
							Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone = false
							Quafe_SSN_Toggle("OFF")
						end,
					},
					[2] = {
						Text = L['PLAYER'],
						Click = function(self, button) 
							Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone = "player"
							Quafe_SSN_Toggle("ON")
						end,
					},
					[3] = {
						Text = INSTANCE,
						Click = function(self, button) 
							Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SoulStone = "instance"
							Quafe_SSN_Toggle("ON")
						end,
					},
				},
			},
			[3] = {
				Name = L['SKIN_ORDERHALL'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SkinOrderHall then
						Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SkinOrderHall = false
						self.Text:SetText(L["OFF"])
						Quafe_SOH_Toggle("OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SkinOrderHall = true
						self.Text:SetText(L["ON"])
						Quafe_SOH_Toggle("ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.SkinOrderHall then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[4] = {
				Name = L['SKIN_CHARACTER'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.CharacterFrame then
						Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.CharacterFrame = false
						self.Text:SetText(L["OFF"])
						Quafe_CharacterFrame_Toggle("OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.CharacterFrame = true
						self.Text:SetText(L["ON"])
						Quafe_CharacterFrame_Toggle("ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Assistant.CharacterFrame then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
		},
	},
}

Quafe_Assistant.Load = Quafe_Assistant_Load
Quafe_Assistant.Config = Quafe_Assistant_Config
tinsert(E.Module, Quafe_Assistant)