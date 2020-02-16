local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Local

--- ------------------------------------------------------------
--> API and Variable
--- ------------------------------------------------------------

local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local asin = math.asin
local cos = math.cos
local acos = math.acos
local atan = math.atan
local rad = math.rad
local modf = math.modf

local insert = table.insert

if F.IsClassic then return end
--- ------------------------------------------------------------
--> 
--- ------------------------------------------------------------
--[[
local function PlayerPowerBarAlt_Frame(frame)
	frame.isPlayerBar = true;
	frame.unit = "player"

	for i, child in ipairs({PlayerPowerBarAlt:GetChildren()}) do
		--child:SetParent(frame)
		child: ClearAllPoints()
		child: SetPoint("CENTER", frame, "CENTER", 0,0)
	end

	--local CounterBar = PlayerPowerBarAltCounterBar
	--CounterBar: SetParent(frame)
	--CounterBar: ClearAllPoints()
	--CounterBar: SetPoint("CENTER", frame, "CENTER", 0,0)

	--local StatusFrame = PlayerPowerBarAltStatusFrame
	--StatusFrame: SetParent(frame)
	--StatusFrame: ClearAllPoints()
	--StatusFrame: SetPoint("CENTER", frame, "CENTER", 0,0)

	local Artwork = PlayerPowerBarAlt.frame
	Artwork:SetParent(frame)
	Artwork: ClearAllPoints()
	Artwork: SetAllPoints(frame)
	local Background = PlayerPowerBarAlt.background
	Background:SetParent(frame)
	Background: ClearAllPoints()
	Background: SetAllPoints(frame)
	local Fill = PlayerPowerBarAlt.fill
	Fill:SetParent(frame)
	Fill: ClearAllPoints()
	Fill: SetAllPoints(frame)
	local Flash = PlayerPowerBarAlt.flash
	Flash:SetParent(frame)
	Flash: ClearAllPoints()
	Flash: SetAllPoints(frame)
	local Spark = PlayerPowerBarAlt.spark
	Spark:SetParent(frame)

	PlayerPowerBarAlt:HookScript("OnShow", function(self)
		frame: Show()
	end)
	PlayerPowerBarAlt:HookScript("OnHide", function(self)
		frame: Hide()
	end)
	PlayerPowerBarAlt:HookScript("OnEvent", function(self)
	
	end)

	frame: SetScript("OnEnter", function(self)
		local statusFrame = PlayerPowerBarAltStatusFrame
		if ( statusFrame.enabled ) then
			statusFrame:Show();
			UnitPowerBarAltStatus_UpdateText(statusFrame);
			--GameTooltip:SetText(PlayerPowerBarAlt.powerName, 1, 1, 1);
			--GameTooltip:AddLine(PlayerPowerBarAlt.powerTooltip, nil, nil, nil, true);
			--GameTooltip:Show();
		end
	end)
	frame: SetScript("OnLeave", function(self)
		local statusFrame = PlayerPowerBarAltStatusFrame
		UnitPowerBarAltStatus_ToggleFrame(statusFrame)
		GameTooltip:Hide();
	end)
end
--]]
local function PlayerPowerBarAlt_Init(frame)
	frame.isPlayerBar = true;
	UnitPowerBarAlt_Initialize(frame, "player", 1);

	F.HideFrame(PlayerPowerBarAlt)
end

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

--local Quafe_PlayerPowerBarAlt = CreateFrame("Frame", "Quafe.PlayerPowerBarAlt", E)
local Quafe_PlayerPowerBarAlt = CreateFrame("Frame", "Quafe.PlayerPowerBarAlt", E, "UnitPowerBarAltTemplate")
Quafe_PlayerPowerBarAlt: SetSize(256, 64)
Quafe_PlayerPowerBarAlt.Init = false

local function Joystick_Update(self, elapsed)
	local x2 = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.PosX
	local y2 = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.PosY
	local x0,y0 = Quafe_PlayerPowerBarAlt: GetCenter()
	local x1,y1 = self: GetCenter()
	local step = floor(1/(GetFramerate())*1e3)/1e3
	if x0 ~= x1 then
		x2 = x2 + (x1-x0)*step/2
	end
	if y0 ~= y1 then
		y2 = y2 + (y1-y0)*step/2
	end
	Quafe_PlayerPowerBarAlt: SetPoint("CENTER", UIParent, "BOTTOM",x2, y2)
	Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.PosX = x2
	Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.PosY = y2
end

local function Quafe_PlayerPowerBarAlt_Load()
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.Enable then
		Quafe_PlayerPowerBarAlt: SetPoint("CENTER", UIParent, "BOTTOM", Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.PosX, Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.PosY)
		F.CreateJoystick(Quafe_PlayerPowerBarAlt, 256,64, "Quafe "..L['PLAYER_POWER_BAR_ALTER'])
		Quafe_PlayerPowerBarAlt.Joystick.postUpdate = Joystick_Update
		
		--PlayerPowerBarAlt_Frame(Quafe_PlayerPowerBarAlt)
		PlayerPowerBarAlt_Init(Quafe_PlayerPowerBarAlt)

		Quafe_PlayerPowerBarAlt.Init = true
	end
end

local function Quafe_PlayerPowerBarAlt_Toggle(arg)
	if arg == "ON" then
		--if not Quafe_PlayerPowerBarAlt.Init then
		--	Quafe_PlayerPowerBarAlt_Load()
		--end
		Quafe_NoticeReload()
	elseif arg == "OFF" then
		Quafe_NoticeReload()
	end
end

local Quafe_PlayerPowerBarAlt_Config = {
	Database = {
		Quafe_PlayerPowerBarAlt = {
			Enable = true,
			PosX = 0,
			PosY = 200,
		},
	},
	Config = {
		Name = "Quafe "..L['PLAYER_POWER_BAR_ALTER'],
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.Enable = false
				self.Text:SetText(L["OFF"])
				Quafe_PlayerPowerBarAlt_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.Enable = true
				self.Text:SetText(L["ON"])
				Quafe_PlayerPowerBarAlt_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_PlayerPowerBarAlt.Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = nil,
	},
}

Quafe_PlayerPowerBarAlt.Load = Quafe_PlayerPowerBarAlt_Load
Quafe_PlayerPowerBarAlt.Config = Quafe_PlayerPowerBarAlt_Config
insert(E.Module, Quafe_PlayerPowerBarAlt)
