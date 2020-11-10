local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> API Localization
----------------------------------------------------------------

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

----------------------------------------------------------------
--> 
----------------------------------------------------------------

local function UpdateValue(frame, unit, type, value)
	frame._OldValue = value
	for k,v in ipairs(E.UBU[unit][type]) do
		v("Update", value/(frame._MaxValue), value, frame._MaxValue)
	end
end

local function UpdateNumValue(frame, unit, type, value)
	for k,v in ipairs(E.UBU[unit][type]) do
		v("Event", value/(frame._MaxValue), value, frame._MaxValue, frame._PowerType)
	end
end

local function UpdateMaxValue(frame, min_value, max_value)
	frame._MinValue = min_value
	frame._MaxValue = max(max_value,1)
end

local function BGU_UpdateHealth(frame, parent, unit, type)
	local value = UnitHealth(parent.Unit) or 0
	frame.UpdateValue(frame, value)
	UpdateNumValue(frame, unit, type, value)
end

local function BGU_UpdateHealthMax(frame, parent)
	local value = UnitHealthMax(parent.Unit) or 1
	if E.Value[parent.Unit] then
		E.Value[parent.Unit].Health.Max = value
	end
	frame.UpdateMaxValue(frame, 0, value)
end

local function BGU_UpdatePower(frame, parent, unit, type)
	local value = UnitPower(parent.Unit) or 0
	frame.UpdateValue(frame, value)
	UpdateNumValue(frame, unit, type, value)
end

local function BGU_UpdatePowerMax(frame, parent)
	local value = UnitPowerMax(parent.Unit) or 1
	frame.UpdateMaxValue(frame, 0, value)
end

local function BGU_UpdatePowerType(frame, power_type)
	frame._PowerType = power_type
end

local function BGU_UpdateMana(frame, parent, unit, type)
	local value = UnitPower(parent.Unit,0) or 0
	frame.UpdateValue(frame, value)
	UpdateNumValue(frame, unit, type, value)
end

local function BGU_UpdateManaMax(frame, parent)
	local value = UnitPowerMax(parent.Unit,0) or 1
	frame.UpdateMaxValue(frame, 0, value)
end

local function BGU_UpdateAbsorb(frame, parent, unit, type)
	local value = (F.IsClassic and 0) or UnitGetTotalAbsorbs(parent.Unit) or 0
	frame.UpdateValue(frame, value)
	UpdateNumValue(frame, unit, type, value)
end

local function DummyBar_Template(frame)
	local DummyBar = CreateFrame("Frame", nil, frame)

	return DummyBar
end

----------------------------------------------------------------
--> Player
----------------------------------------------------------------

local function BGU_Player_Event(frame, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_DISPLAYPOWER" then
		if not F.IsClassic then
			if UnitHasVehiclePlayerFrameUI("player") then
				frame.Unit = "vehicle"
			else
				frame.Unit = "player"
			end
		end
		
		local powerType = UnitPowerType(frame.Unit)
		frame.ShowMana = "Hide"
		if powerType ~= 0 then
			local maxmana = UnitPowerMax(frame.Unit, 0)
			if maxmana ~= 0 then
				frame.ShowMana = "Show"
			end
		end

		BGU_UpdateHealthMax(frame.Health, frame)
		BGU_UpdateHealth(frame.Health, frame, "Player", "HP")
		BGU_UpdatePowerType(frame.Power, powerType)
		BGU_UpdatePowerMax(frame.Power, frame)
		BGU_UpdatePower(frame.Power, frame, "Player", "PP")
		BGU_UpdateHealthMax(frame.Absorb, frame)
		BGU_UpdateAbsorb(frame.Absorb, frame, "Player", "AS")
		if frame.ShowMana == "Show" then
			BGU_UpdateManaMax(frame.Mana, frame)
			BGU_UpdateMana(frame.Mana, frame, "Player", "MN")
		end
	elseif event == "UNIT_HEALTH" then
		BGU_UpdateHealth(frame.Health, frame, "Player", "HP")
	elseif event == "UNIT_MAXHEALTH" then
		BGU_UpdateHealthMax(frame.Health, frame)
		BGU_UpdateHealth(frame.Health, frame, "Player", "HP")
		BGU_UpdateHealthMax(frame.Absorb, frame)
		BGU_UpdateAbsorb(frame.Absorb, frame, "Player", "AS")
	elseif event == "UNIT_POWER_UPDATE" then
		BGU_UpdatePower(frame.Power, frame, "Player", "PP")
		if frame.ShowMana == "Show" then
			BGU_UpdateMana(frame.Mana, frame, "Player", "MN")
		end
	elseif event == "UNIT_MAXPOWER" then
		BGU_UpdatePowerMax(frame.Power, frame)
		BGU_UpdatePower(frame.Power, frame, "Player", "PP")
		if frame.ShowMana == "Show" then
			BGU_UpdateManaMax(frame.Mana, frame)
			BGU_UpdateMana(frame.Mana, frame, "Player", "MN")
		end
	elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
		BGU_UpdateAbsorb(frame.Absorb, frame, "Player", "AS")
	end
end

local function BGU_Player_RegEvent(frame)
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterUnitEvent("UNIT_HEALTH", "player", "vehicle")
	frame: RegisterUnitEvent("UNIT_MAXHEALTH", "player", "vehicle")
	frame: RegisterUnitEvent("UNIT_POWER_UPDATE", "player", "vehicle")
	frame: RegisterUnitEvent("UNIT_MAXPOWER", "player", "vehicle")
	if not F.IsClassic then
		frame: RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "player", "vehicle")
		frame: RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
		frame: RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	end
	--frame: RegisterUnitEvent("UNIT_PET", "player")
	--frame: RegisterEvent("PET_UI_UPDATE")
	frame: RegisterEvent("UNIT_DISPLAYPOWER")
end

local function Player_HealthUpdate(frame, value)
	UpdateValue(frame, "Player", "HP", value)
end

local function Player_PowerUpdate(frame, value)
	UpdateValue(frame, "Player", "PP", value)
end

local function Player_AbsorbUpdate(frame, value)
	UpdateValue(frame, "Player", "AS", value)
end

local function Player_ManaUpdate(frame, value)
	UpdateValue(frame, "Player", "MN", value)
end

local function BGU_PlayerFrame(frame)
	local BGU_Player = CreateFrame("Frame", nil, frame)
	BGU_Player.Unit = "player"
	BGU_Player.Health = DummyBar_Template(BGU_Player)
	BGU_Player.Health.UpdateValue = Player_HealthUpdate
	BGU_Player.Health.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Player.Health, true)

	BGU_Player.Power = DummyBar_Template(BGU_Player)
	BGU_Player.Power.UpdateValue = Player_PowerUpdate
	BGU_Player.Power.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Player.Power, true)

	BGU_Player.Mana = DummyBar_Template(BGU_Player)
	BGU_Player.Mana.UpdateValue = Player_ManaUpdate
	BGU_Player.Mana.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Player.Mana, true)

	BGU_Player.Absorb = DummyBar_Template(BGU_Player)
	BGU_Player.Absorb.UpdateValue = Player_AbsorbUpdate
	BGU_Player.Absorb.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Player.Absorb, true)

	BGU_Player.ShowMana = "Hide"
	BGU_Player: SetScript("OnEvent", function(self, event, ...)
		BGU_Player_Event(self, event, ...)
	end)

	frame.BGU_Player = BGU_Player
end

----------------------------------------------------------------
--> Pet
----------------------------------------------------------------

local function BGU_Pet_Event(frame, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_PET" or event == "PET_UI_UPDATE" then
		--if UnitInVehicle("player") or UnitExists("pet") then
		if F.IsClassic then
			if UnitExists("pet") then
				frame.ShowPet = "Show"
			else
				frame.ShowPet = "Hide"
			end
		else
			if UnitHasVehiclePlayerFrameUI("player") then
				frame.ShowPet = "Show"
				frame.Unit = "player"
			elseif UnitExists("pet") then
				frame.ShowPet = "Show"
				frame.Unit = "pet"
			else
				frame.ShowPet = "Hide"
				frame.Unit = "pet"
			end
		end
		BGU_UpdateHealthMax(frame.Health, frame)
		BGU_UpdateHealth(frame.Health, frame, "Pet", "HP")
		BGU_UpdatePowerMax(frame.Power, frame)
		BGU_UpdatePower(frame.Power, frame, "Pet", "PP")
	end
	if frame.ShowPet == "Show" then
		if event == "UNIT_HEALTH" or event == "UNIT_HEALTH_FREQUENT" then
			BGU_UpdateHealth(frame.Health, frame, "Pet", "HP")
		elseif event == "UNIT_MAXHEALTH" then
			BGU_UpdateHealthMax(frame.Health, frame)
			BGU_UpdateHealth(frame.Health, frame, "Pet", "HP")
		elseif event == "UNIT_POWER_UPDATE" or event == "UNIT_POWER_FREQUENT"then
			BGU_UpdatePower(frame.Power, frame, "Pet", "PP")
		elseif event == "UNIT_MAXPOWER" then
			BGU_UpdatePowerMax(frame.Power, frame)
			BGU_UpdatePower(frame.Power, frame, "Pet", "PP")
		end
	end
end

local function BGU_Pet_RegEvent(frame)
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterUnitEvent("UNIT_HEALTH", "pet", "player")
	frame: RegisterUnitEvent("UNIT_MAXHEALTH", "pet", "player")
	frame: RegisterUnitEvent("UNIT_POWER_UPDATE", "pet", "player")
	frame: RegisterUnitEvent("UNIT_MAXPOWER", "pet", "player")
	frame: RegisterUnitEvent("UNIT_PET", "player")
	frame: RegisterEvent("PET_UI_UPDATE")
	if not F.IsClassic then
		frame: RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
		frame: RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	end
	--frame: RegisterEvent("UNIT_DISPLAYPOWER")
end

local function Pet_HealthUpdate(frame, value)
	UpdateValue(frame, "Pet", "HP", value)
end

local function Pet_PowerUpdate(frame, value)
	UpdateValue(frame, "Pet", "PP", value)
end

local function BGU_PetFrame(frame)
	local BGU_Pet = CreateFrame("Frame", nil, frame)
	BGU_Pet.Unit = "pet"
	BGU_Pet.Health = DummyBar_Template(BGU_Pet)
	BGU_Pet.Health.UpdateValue = Pet_HealthUpdate
	BGU_Pet.Health.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Pet.Health, true)

	BGU_Pet.Power = DummyBar_Template(BGU_Pet)
	BGU_Pet.Power.UpdateValue = Pet_PowerUpdate
	BGU_Pet.Power.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Pet.Power, true)

	BGU_Pet.ShowPet = "Hide"
	BGU_Pet: SetScript("OnEvent", function(self, event, ...)
		BGU_Pet_Event(self, event, ...)
	end)

	frame.BGU_Pet = BGU_Pet
end

----------------------------------------------------------------
--> Target
----------------------------------------------------------------

local function BGU_Target_Event(frame, event, ...)
	if not UnitExists(frame.Unit) then return end
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_TARGET_CHANGED" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_DISPLAYPOWER" then
		local powerType = UnitPowerType(frame.Unit)
		frame.ShowMana = "Hide"
		if powerType ~= 0 then
			local maxmana = UnitPowerMax(frame.Unit, 0)
			if maxmana ~= 0 then
				frame.ShowMana = "Show"
			end
		end

		BGU_UpdateHealthMax(frame.Health, frame)
		BGU_UpdateHealth(frame.Health, frame, "Target", "HP")
		BGU_UpdatePowerType(frame.Power, powerType)
		BGU_UpdatePowerMax(frame.Power, frame)
		BGU_UpdatePower(frame.Power, frame, "Target", "PP")
		BGU_UpdateHealthMax(frame.Absorb, frame)
		BGU_UpdateAbsorb(frame.Absorb, frame, "Target", "AS")
		if frame.ShowMana == "Show" then
			--BGU_UpdateManaMax(frame.Mana, frame)
			--BGU_UpdateMana(frame.Mana, frame, "Target", "MN")
		end
	elseif event == "UNIT_HEALTH" then
		BGU_UpdateHealth(frame.Health, frame, "Target", "HP")
	elseif event == "UNIT_MAXHEALTH" then
		BGU_UpdateHealthMax(frame.Health, frame)
		BGU_UpdateHealth(frame.Health, frame, "Target", "HP")
		BGU_UpdateHealthMax(frame.Absorb, frame)
		BGU_UpdateAbsorb(frame.Absorb, frame, "Target", "AS")
	elseif event == "UNIT_POWER_UPDATE" then
		BGU_UpdatePower(frame.Power, frame, "Target", "PP")
		if frame.ShowMana == "Show" then
			--BGU_UpdateMana(frame.Mana, frame, "Target", "MN")
		end
	elseif event == "UNIT_MAXPOWER" then
		BGU_UpdatePowerMax(frame.Power, frame)
		BGU_UpdatePower(frame.Power, frame, "Target", "PP")
		if frame.ShowMana == "Show" then
			--BGU_UpdateManaMax(frame.Mana, frame)
			--BGU_UpdateMana(frame.Mana, frame, "Target", "MN")
		end
	elseif event == "UNIT_ABSORB_AMOUNT_CHANGED" then
		BGU_UpdateAbsorb(frame.Absorb, frame, "Target", "AS")
	end
end

local function BGU_Target_RegEvent(frame)
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterEvent("PLAYER_TARGET_CHANGED")
	frame: RegisterUnitEvent("UNIT_HEALTH", "target")
	frame: RegisterUnitEvent("UNIT_MAXHEALTH", "target")
	frame: RegisterUnitEvent("UNIT_POWER_UPDATE", "target")
	frame: RegisterUnitEvent("UNIT_MAXPOWER", "target")
	if not F.IsClassic then
		frame: RegisterUnitEvent("UNIT_ABSORB_AMOUNT_CHANGED", "target")
		frame: RegisterUnitEvent("UNIT_EXITED_VEHICLE", "target")
		frame: RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "target")
	end
end

local function Target_HealthUpdate(frame, value)
	UpdateValue(frame, "Target", "HP", value)
end

local function Target_PowerUpdate(frame, value)
	UpdateValue(frame, "Target", "PP", value)
end

local function Target_AbsorbUpdate(frame, value)
	UpdateValue(frame, "Target", "AS", value)
end

local function Target_ManaUpdate(frame, value)
	UpdateValue(frame, "Target", "MN", value)
end

local function BGU_TargetFrame(frame)
	local BGU_Target = CreateFrame("Frame", nil, frame)
	BGU_Target.Unit = "target"
	BGU_Target.Health = DummyBar_Template(BGU_Target)
	BGU_Target.Health.UpdateValue = Target_HealthUpdate
	BGU_Target.Health.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Target.Health, true)

	BGU_Target.Power = DummyBar_Template(BGU_Target)
	BGU_Target.Power.UpdateValue = Target_PowerUpdate
	BGU_Target.Power.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Target.Power, true)

	--BGU_Target.Mana = DummyBar_Template(BGU_Target)
	--BGU_Target.Mana.UpdateValue = Target_ManaUpdate
	--BGU_Target.Mana.UpdateMaxValue = UpdateMaxValue
	--F.SetSmooth(BGU_Target.Mana, true)

	BGU_Target.Absorb = DummyBar_Template(BGU_Target)
	BGU_Target.Absorb.UpdateValue = Target_AbsorbUpdate
	BGU_Target.Absorb.UpdateMaxValue = UpdateMaxValue
	F.SetSmooth(BGU_Target.Absorb, true)

	BGU_Target.ShowMana = "Hide"
	BGU_Target: SetScript("OnEvent", function(self, event, ...)
		BGU_Target_Event(self, event, ...)
	end)

	frame.BGU_Target = BGU_Target
end

local UnitFrame_BackgroundUpdate = CreateFrame("Frame", nil, E)
UnitFrame_BackgroundUpdate.Init = false

F.UBGU_ForceUpdate = function()
	BGU_Player_Event(UnitFrame_BackgroundUpdate.BGU_Player, "PLAYER_ENTERING_WORLD")
	BGU_Pet_Event(UnitFrame_BackgroundUpdate.BGU_Pet, "PLAYER_ENTERING_WORLD")
	BGU_Target_Event(UnitFrame_BackgroundUpdate.BGU_Target, "PLAYER_ENTERING_WORLD")
end

local function BGU_Load()
	if not UnitFrame_BackgroundUpdate.Init then
		BGU_PlayerFrame(UnitFrame_BackgroundUpdate)
		BGU_Player_RegEvent(UnitFrame_BackgroundUpdate.BGU_Player)

		BGU_PetFrame(UnitFrame_BackgroundUpdate)
		BGU_Pet_RegEvent(UnitFrame_BackgroundUpdate.BGU_Pet)

		BGU_TargetFrame(UnitFrame_BackgroundUpdate)
		BGU_Target_RegEvent(UnitFrame_BackgroundUpdate.BGU_Target)

		UnitFrame_BackgroundUpdate.Init = true
	end
end

local BGU_Config = {}

UnitFrame_BackgroundUpdate.Load = BGU_Load
tinsert(E.Module, UnitFrame_BackgroundUpdate)