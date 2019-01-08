local P, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Local

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

--- ------------------------------------------------------------
--> 
--- ------------------------------------------------------------

local function PartyPortrait_Update(self, unit)
	local isAvailable
	if unit then
		isAvailable = UnitIsConnected(unit) and UnitIsVisible(unit)
	end
	if(not isAvailable) then
		self.Portrait:SetCamDistanceScale(0.25)
		self.Portrait:SetPortraitZoom(0)
		self.Portrait:SetPosition(0, 0, 0.25)
		self.Portrait:ClearModel()
		self.Portrait:SetModel([[Interface\Buttons\TalkToMeQuestionMark.m2]])
	else
		self.Portrait:SetCamDistanceScale(0.9)
		self.Portrait:SetPortraitZoom(1)
		self.Portrait:SetPosition(0, 0, 0)
		self.Portrait:ClearModel()
		self.Portrait:SetUnit(unit)
	end
end

local function PartyHealth_Update(self, unit)
	if unit then
		local minHealth,maxHealth = UnitHealth(unit),UnitHealthMax(unit)
		local h1,h2 = 0,0
		if maxHealth == 0 or minHealth == 0 then
			h1 = 0
			h2 = 0
		else
			h1 = floor(minHealth/maxHealth*1e4)/1e4
			h2 = floor(minHealth/maxHealth*1e2)
		end
		self.ArtFrame.HealthBar: SetSize(100*h1+F.Debug,10)
		self.ArtFrame.HealthBar: SetTexCoord(14/128,(14+100*h1)/128, 3/16,13/16)
		self.ArtFrame.Percent: SetText(format("%d%s", h2,"%"))
	end
end

local function PartyName_Update(self, unit)
	if unit then
		local name = UnitName(unit) or "???"
		self.ArtFrame.Name: SetText(name)
	end
end

function PartyButton_OnLoad(self)
	self: RegisterForClicks("AnyDown")
	self: SetAttribute("*type1", "target")
	self: SetAttribute("*type2", "togglemenu")
	self: SetAttribute("shift-type1", "focus")
	self: SetAttribute("ctrl-type1", "focus")
	self: SetAttribute("toggleForVehicle", true)
	
	self: SetScript("OnEnter", function(self)
		local unit = self:GetAttribute("unit")
		if unit then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			if ( GameTooltip:SetUnit(unit, self.hideStatusOnTooltip) ) then
				self.UpdateTooltip = F.UnitFrame_UpdateTooltip;
			else
				self.UpdateTooltip = nil;
			end
			local r, g, b = GameTooltip_UnitColor(unit);
			GameTooltipTextLeft1:SetTextColor(r, g, b);
			GameTooltip: Show()
		end
	end)
	self: SetScript("OnLeave", F.UnitFrame_OnLeave)

	local help = CreateFrame("Frame", nil, self.Portrait)
	help: SetPoint("TOPLEFT", -2,2)
	help: SetPoint("BOTTOMRIGHT", 2,-2)
	help: SetBackdrop({
		bgFile = F.Path("StatusBar\\Raid"), 
		edgeFile = F.Path("StatusBar\\Flat"), 
		tile = false, tileSize = 1, edgeSize = 2, 
		insets = { left = 0, right = 0, top = 0, bottom = 0 }
	})
	help: SetBackdropColor(F.Color(C.Color.W1, 0))
	help: SetBackdropBorderColor(F.Color(C.Color.W3, 0.9))
	self.Portrait.Border = help

	self.ArtFrame.HealthBarBg: SetVertexColor(F.Color(C.Color.W2))
	self.ArtFrame.HealthBarBg: SetAlpha(0.6)
	self.ArtFrame.HealthBar: SetVertexColor(F.Color(C.Color.W3))
	self.ArtFrame.HealthBar: SetAlpha(0.9)
	self.ArtFrame.HealthBar: ClearAllPoints()
	self.ArtFrame.HealthBar: SetPoint("LEFT", self.ArtFrame.HealthBarBg, "LEFT", 0,0)
	self.ArtFrame.HealthBar: SetSize(100,10)
	self.ArtFrame.HealthBar: SetTexCoord(14/128,114/128, 3/16,13/16)

	self.ArtFrame.Bg: SetVertexColor(F.Color(C.Color.W1))
	self.ArtFrame.Bg_Glow: SetVertexColor(F.Color(C.Color.W3))

	self.ArtFrame.Name: SetFont(C.Font.Txt, 12, nil)
	self.ArtFrame.Percent: SetFont(C.Font.NumSmall, 14, nil)

	self: RegisterEvent('PLAYER_ENTERING_WORLD')
	self: RegisterEvent('GROUP_ROSTER_UPDATE')
	self: RegisterEvent('VARIABLES_LOADED')
	self: RegisterEvent('UNIT_ENTERED_VEHICLE')
	self: RegisterEvent('UNIT_EXITED_VEHICLE')
	self: RegisterEvent('PARTY_MEMBER_ENABLE')
	self: RegisterEvent('PARTY_MEMBER_DISABLE')
	self: RegisterEvent('UNIT_OTHER_PARTY_CHANGED')
	self: RegisterEvent('UNIT_CONNECTION')
	self: RegisterEvent('UNIT_MODEL_CHANGED')
	self: RegisterEvent('UNIT_PORTRAIT_UPDATE')
	self: RegisterEvent("UNIT_HEALTH")
	self: RegisterEvent("UNIT_MAXHEALTH")
	self: RegisterEvent("UNIT_NAME_UPDATE")
end

function PartyButton_OnShow(self)
	local unit = self:GetAttribute("unit")
	PartyPortrait_Update(self, unit)
	PartyName_Update(self, unit)
	PartyHealth_Update(self, unit)
end

function PartyButton_OnEvent(self, event, ...)
	local unit = self:GetAttribute("unit")
	--local guid = UnitGUID(unit)
	if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_CONNECTION" or event == "UNIT_MODEL_CHANGED" or event == "UNIT_PORTRAIT_UPDATE" then
		PartyPortrait_Update(self, unit)
	end
	--if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_CONNECTION" then
	if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" or event == "UNIT_NAME_UPDATE" then
		PartyName_Update(self, unit)
	end
	if event == "PLAYER_ENTERING_WORLD" or event == "GROUP_ROSTER_UPDATE" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_CONNECTION" or event == "UNIT_HEALTH" or event == "UNIT_MAXHEALTH" then
		PartyHealth_Update(self, unit)
	end
end

local function PartyHeader_Frame(f)
	do
		local header = CreateFrame("Frame", "Quafe_PartyGroup", f, "SecurePartyHeaderTemplate")
		header: SetSize(100, 60)
		header: SetPoint("LEFT", f, "LEFT", 0,0)
		header: SetClampedToScreen(true)

		header: SetAttribute("point", "LEFT")
		header: SetAttribute("xOffset", 10)
		header: SetAttribute("yOffset", 0)
		header: SetAttribute("sortMethod", "INDEX")
		header: SetAttribute("sortDir", "ASC")
		header: SetAttribute("minWidth", 100)
		header: SetAttribute("minHeight", 60)
		--header: SetAttribute("showPlayer", "true")
		--header: SetAttribute("showSolo", "true")
		header: SetAttribute("template", "Quafe_PartyFrameTemplate")
		--header: SetAttribute("templateType", "Frame")
		header: SetMovable(true)

		f.Header = header
	end
end

local Quafe_Party = CreateFrame("Frame", "Quafe_Party", P)
Quafe_Party: SetPoint("TOPLEFT", UIParent, "TOPLEFT", 60,-32)

function Quafe_Party.Load()
	Quafe_Party: SetSize(540, 60)
	Quafe_Party: SetClampedToScreen(true)
	PartyHeader_Frame(Quafe_Party)

	Quafe_Party.Header: Show()
end
insert(P.Module, Quafe_Party)