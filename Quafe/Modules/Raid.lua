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

--- ------------------------------------------------------------
--> API and Variable
--- ------------------------------------------------------------

local Icon_Class = {
	["WARRIOR"]			= {  0/128, 32/128,   0/128, 32/128},
	["MAGE"]			= { 32/128, 64/128,   0/128, 32/128},
	["ROGUE"]			= { 64/128, 96/128,   0/128, 32/128},
	["DRUID"]			= { 96/128,128/128,   0/128, 32/128},
	["HUNTER"]			= {  0/128, 32/128,  32/128, 64/128},
	["DEATHKNIGHT"]		= { 32/128, 64/128,  32/128, 64/128},
	["PRIEST"]			= { 64/128, 96/128,  32/128, 64/128},
	["WARLOCK"]			= { 96/128,128/128,  32/128, 64/128},
	["PALADIN"]			= {  0/128, 32/128,  64/128, 96/128},
	["SHAMAN"]			= { 32/128, 64/128,  64/128, 96/128},
	["MONK"]			= { 64/128, 96/128,  64/128, 96/128},
	["DEMONHUNTER"]		= { 96/128,128/128,  64/128, 96/128},
}

local function Name_Color_Update(f)
	local eColor = {}
	if UnitIsPlayer(f.Unit) then
		local eClass = select(2, UnitClass(f.Unit))
		eColor = C.Color.Class[eClass] or C.Color.White
	else
		local red, green, blue, alpha = UnitSelectionColor(f.Unit)
		eColor.r = red or 1
		eColor.g = green or 1
		eColor.b = blue or 1
	end
	local name, realm = UnitName(f.Unit)
	return F.Hex(eColor)..name.."|r"
end

--- ------------------------------------------------------------
--> 
--- ------------------------------------------------------------

function RaidButton_OnLoad(self)
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


end

local function RaidHeader_Frame(f)
	do
		local header = CreateFrame("Frame", "Quafe_RaidHealGroup", f, "SecureRaidGroupHeaderTemplate")
		header: SetSize(72, 36)
		header: SetPoint("LEFT", f, "LEFT", 0,0)
		header: SetClampedToScreen(true)

		header: SetAttribute("point", "LEFT")
		header: SetAttribute("xOffset", 4)
		header: SetAttribute("yOffset", -4)
		header: SetAttribute("sortMethod", "INDEX")
		header: SetAttribute("sortDir", "ASC")
		header: SetAttribute("minWidth", 100)
		header: SetAttribute("minHeight", 60)
		header: SetAttribute("showParty", "true")
		header: SetAttribute("showSolo", "true")
		header: SetAttribute("template", "Quafe_RaidFrameTemplate")
		--header: SetAttribute("templateType", "Frame")
		header: SetMovable(true)

		f.Heal = header
	end

	do
		local header = CreateFrame("Frame", "Quafe_RaidSlimGroup", f, "SecureRaidGroupHeaderTemplate")
		header: SetSize(72, 36)
		header: SetPoint("LEFT", f, "LEFT", 0,0)
		header: SetClampedToScreen(true)

		header: SetAttribute("point", "LEFT")
		header: SetAttribute("xOffset", 4)
		header: SetAttribute("yOffset", -4)
		header: SetAttribute("sortMethod", "INDEX")
		header: SetAttribute("sortDir", "ASC")
		header: SetAttribute("minWidth", 100)
		header: SetAttribute("minHeight", 60)
		header: SetAttribute("showParty", "true")
		header: SetAttribute("showSolo", "true")
		header: SetAttribute("template", "Quafe_RaidFrameTemplate")
		--header: SetAttribute("templateType", "Frame")
		header: SetMovable(true)
		
		f.Slim = header
	end
end

local Quafe_Raid = CreateFrame("Frame", "Quafe_Raid", E)


--[[

local heal = UnitGetIncomingHeals(unit[, healer]);

Parameters

    unit 
        UnitId - Unit to query healing for
    healer (Optional) 
        UnitId - Filter heals done by unit

Returns

    heal 
        Integer - Predicted health from incoming heal



]]--