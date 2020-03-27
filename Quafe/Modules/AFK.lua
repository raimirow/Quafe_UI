local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale
if F.IsClassic then return end

--- ------------------------------------------------------------
--> API Localization
--- ------------------------------------------------------------

local _G = getfenv(0)
local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local rad = math.rad

local insert = table.insert
local remove = table.remove
local wipe = table.wipe

local find = string.find

--- ------------------------------------------------------------
--> AFK
--- ------------------------------------------------------------

local prevAFKState = false
local camSpeed = 0.05

local function ToggleAwayMode(afk)
	if afk then
		SaveView(5)
		MoveViewLeftStart(camSpeed)
	end
	if not afk then
		MoveViewLeftStop()
		SetView(5)
	end
end

local function UpdateAwayMode()
	local isAFK = UnitIsAFK("player")
	if isAFK and not prevAFKState then
		prevAFKState = true
		ToggleAwayMode(true)
	elseif not isAFK and prevAFKState then
		prevAFKState = false
		ToggleAwayMode(false)
	end
end

local function AwayMode_OnUpdate(frame)
	local Dummy = frame:CreateAnimationGroup()
    Dummy: SetLooping("REPEAT") --[NONE, REPEAT, or BOUNCE].

	local DummyAmin = Dummy:CreateAnimation()
    DummyAmin: SetDuration(1)
    DummyAmin: SetOrder(1)
    
	Dummy:SetScript("OnLoop", function(self)
		if not InCombatLockdown() then
       		UpdateAwayMode()
			self:Stop()
		end
	end)
	--Dummy:Play()
	--Dummy:Stop()
	frame.Timer = Dummy
end

local function AwayMode_Event(frame, event)
	if InCombatLockdown() then
		if prevAFKState then
			frame.Timer:Play()
		end
	else
		UpdateAwayMode()
		frame.Timer:Stop()
	end
end

local function AwayMode_OnEvent(frame)
	frame: SetScript("OnEvent", AwayMode_Event)
end

local function AwayMode_RgEvent(frame)
	--SetCVar("AutoClearAFK", 1)
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:RegisterEvent("PLAYER_REGEN_DISABLED")
	frame:RegisterEvent("PLAYER_FLAGS_CHANGED")
	frame:RegisterEvent("UPDATE_BATTLEFIELD_STATUS")
	frame:RegisterEvent("LFG_PROPOSAL_SHOW")
	frame:RegisterEvent("TAXIMAP_OPENED")
	frame:RegisterEvent("TAXIMAP_CLOSED")
end

--- ------------------------------------------------------------
--> Load
--- ------------------------------------------------------------

local AwayMode = CreateFrame("Frame", nil, E)
local function Load()
	AwayMode_RgEvent(AwayMode)
	AwayMode_OnEvent(AwayMode)
	AwayMode_OnUpdate(AwayMode)
end
AwayMode.Load = Load
insert(E.Module, AwayMode)


