local P, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

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
--> API and Variable
----------------------------------------------------------------

local PlayerName = GetUnitName("player")

local Num_14 = {
	[0] = {12,14,   0/256, 12/256, 9/32,23/32},
	[1] = {12,14,  12/256, 24/256, 9/32,23/32},
	[2] = {12,14,  24/256, 36/256, 9/32,23/32},
	[3] = {12,14,  36/256, 48/256, 9/32,23/32},
	[4] = {12,14,  48/256, 60/256, 9/32,23/32},
	[5] = {12,14,  60/256, 72/256, 9/32,23/32},
	[6] = {12,14,  72/256, 84/256, 9/32,23/32},
	[7] = {12,14,  84/256, 96/256, 9/32,23/32},
	[8] = {12,14,  96/256,108/256, 9/32,23/32},
	[9] = {12,14, 108/256,120/256, 9/32,23/32},
	["."] = {12,14, 120/256,132/256, 9/32,23/32},
	["k"] = {12,14, 132/256,144/256, 9/32,23/32},
	["m"] = {12,14, 144/256,156/256, 9/32,23/32},
	["g"] = {12,14, 156/256,168/256, 9/32,23/32},
	["t"] = {12,14, 168/256,180/256, 9/32,23/32},
	["w"] = {12,14, 180/256,192/256, 9/32,23/32},
	["y"] = {12,14, 192/256,204/256, 9/32,23/32},
	["n"] = {12,14, 255/256,256/256, 9/32,23/32},
}

local Details = _G["Details"]
local Recount = _G["Recount"]
local Skada = _G["Skada"]
local EAST_ASIA = true

----------------------------------------------------------------
--> General
----------------------------------------------------------------

local function Num_Format(v)
	local v1, v2, v3, v4, v5
	v = min(v, 1e15-2)
	if EAST_ASIA then
		if v >= 1e12 then
			v = v/1e12
			v5 = "t"
		elseif v >= 1e8 then
			v = v/1e8
			v5 = "y"
		elseif v >= 1e4 then
			v = v/1e4
			v5 = "w"
		else
			v5 = "n"
		end
	else
		if v >= 1e12 then
			v = v/1e12
			v5 = "t"
		elseif v >= 1e9 then
			v = v/1e9
			v5 = "g"
		elseif v >= 1e6 then
			v = v/1e6
			v5 = "m"
		elseif v >= 1e3 then
			v = v/1e3
			v5 = "k"
		else
			v5 = "n"
		end
	end
	
	if v < 10 then
		v1 = floor(v)
		v2 = "."
		v3 = floor(v*10) - floor(v)*10
		v4 = max(floor(v*100) - floor(v*10)*10, 0)
	elseif v < 100 then
		v1 = floor(v/10)
		v2 = floor(v) - floor(v/10)*10
		v3 = "."
		v4 = max(floor(v*10) - floor(v)*10, 0)
	else
		v1 = floor(v/1e3) - floor(v/1e4)*10
		v2 = floor(v/1e2) - floor(v/1e3)*10
		v3 = floor(v/10) - floor(v/1e2)*10
		v4 = max(floor(v) - floor(v/10)*10, 0)
	end
	return v1, v2, v3, v4, v5
end

local function Num_Update(f, v1, v2, v3)
	if not v1 then v1 = 0 end
	if not v2 then v2 = 0 end
	if not v3 then v3 = 0 end
	
	local n1 = floor(v1/10)
	local n2 = floor(v1) - floor(v1/10)*10
	
	if n1 == 0 then
		f.Num[1]: SetAlpha(0.4)
	else
		f.Num[1]: SetAlpha(1)
	end
	f.Num[1]: SetSize(Num_14[n1][1], Num_14[n1][2])
	f.Num[1]: SetTexCoord(Num_14[n1][3],Num_14[n1][4], Num_14[n1][5],Num_14[n1][6])
	f.Num[2]: SetSize(Num_14[n2][1], Num_14[n2][2])
	f.Num[2]: SetTexCoord(Num_14[n2][3],Num_14[n2][4], Num_14[n2][5],Num_14[n2][6])
	
	local n3,n4,n5,n6,n7 = Num_Format(v2)
	f.Num[3]: SetSize(Num_14[n3][1], Num_14[n3][2])
	f.Num[3]: SetTexCoord(Num_14[n3][3],Num_14[n3][4], Num_14[n3][5],Num_14[n3][6])
	f.Num[4]: SetSize(Num_14[n4][1], Num_14[n4][2])
	f.Num[4]: SetTexCoord(Num_14[n4][3],Num_14[n4][4], Num_14[n4][5],Num_14[n4][6])
	f.Num[5]: SetSize(Num_14[n5][1], Num_14[n5][2])
	f.Num[5]: SetTexCoord(Num_14[n5][3],Num_14[n5][4], Num_14[n5][5],Num_14[n5][6])
	f.Num[6]: SetSize(Num_14[n6][1], Num_14[n6][2])
	f.Num[6]: SetTexCoord(Num_14[n6][3],Num_14[n6][4], Num_14[n6][5],Num_14[n6][6])
	f.Num[7]: SetSize(Num_14[n7][1], Num_14[n7][2])
	f.Num[7]: SetTexCoord(Num_14[n7][3],Num_14[n7][4], Num_14[n7][5],Num_14[n7][6])
	if n3 == 0 then
		f.Num[3]: SetAlpha(0.4)
		if n4 == 0 then
			f.Num[4]: SetAlpha(0.4)
			if n5 == 0 then
				f.Num[5]: SetAlpha(0.4)
				if n6 == 0 then
					f.Num[6]: SetAlpha(0.4)
				else
					f.Num[6]: SetAlpha(1)
				end
			else
				f.Num[5]: SetAlpha(1)
			end
		else
			f.Num[4]: SetAlpha(1)
		end
	else
		f.Num[3]: SetAlpha(1)
	end
	
	local n8,n9,n10,n11,n12 = Num_Format(v3)
	f.Num[8]: SetSize(Num_14[n8][1], Num_14[n8][2])
	f.Num[8]: SetTexCoord(Num_14[n8][3],Num_14[n8][4], Num_14[n8][5],Num_14[n8][6])
	f.Num[9]: SetSize(Num_14[n9][1], Num_14[n9][2])
	f.Num[9]: SetTexCoord(Num_14[n9][3],Num_14[n9][4], Num_14[n9][5],Num_14[n9][6])
	f.Num[10]: SetSize(Num_14[n10][1], Num_14[n10][2])
	f.Num[10]: SetTexCoord(Num_14[n10][3],Num_14[n10][4], Num_14[n10][5],Num_14[n10][6])
	f.Num[11]: SetSize(Num_14[n11][1], Num_14[n11][2])
	f.Num[11]: SetTexCoord(Num_14[n11][3],Num_14[n11][4], Num_14[n11][5],Num_14[n11][6])
	f.Num[12]: SetSize(Num_14[n12][1], Num_14[n12][2])
	f.Num[12]: SetTexCoord(Num_14[n12][3],Num_14[n12][4], Num_14[n12][5],Num_14[n12][6])
	if n8 == 0 then
		f.Num[8]: SetAlpha(0.4)
		if n9 == 0 then
			f.Num[9]: SetAlpha(0.4)
			if n10 == 0 then
				f.Num[10]: SetAlpha(0.4)
				if n11 == 0 then
					f.Num[11]: SetAlpha(0.4)
				else
					f.Num[11]: SetAlpha(1)
				end
			else
				f.Num[10]: SetAlpha(1)
			end
		else
			f.Num[9]: SetAlpha(1)
		end
	else
		f.Num[8]: SetAlpha(1)
	end
end

----------------------------------------------------------------
--> Details
----------------------------------------------------------------

local function DetailsGetOverall()
	local OverallCombat = Details: GetCombat(-1)
	local OverallTime = OverallCombat: GetCombatTime()

	local OverallDamageActor = OverallCombat: GetActor(DETAILS_ATTRIBUTE_DAMAGE, PlayerName)
	local OverallHealingActor = OverallCombat: GetActor(DETAILS_ATTRIBUTE_HEAL, PlayerName)
	
	local OverallDamage,OverallHealing = 0,0
	if OverallDamage then
		OverallDamage = OverallDamageActor.total
	end
	if OverallHealing then
		OverallHealing = OverallHealingActor.total
	end

	local OverallDPS = OverallDamage / OverallTime
	local OverallHPS = OverallHealing / OverallTime
	
	return OverallDamage, OverallDPS, OverallHealing, OverallHPS, OverallTime
end

local function DetailsGetCurrent()
	local CurrentCombat = Details: GetCombat(0)
	local CurrentTime = CurrentCombat: GetCombatTime() or 1
	
	local CurrentDamageActor = CurrentCombat: GetActor(DETAILS_ATTRIBUTE_DAMAGE, PlayerName)
	local CurrentHealingActor = CurrentCombat: GetActor(DETAILS_ATTRIBUTE_HEAL, PlayerName)
	
	local CurrentDamage, CurrentHealing = 0,0
	if CurrentDamageActor then
		CurrentDamage = CurrentDamageActor.total
	end
	if CurrentHealingActor then
		CurrentHealing = CurrentHealingActor.total
	end
	
	local CurrentDPS = CurrentDamage / CurrentTime
	local CurrentHPS = CurrentHealing / CurrentTime
	
	return CurrentDamage, CurrentDPS, CurrentHealing, CurrentHPS, CurrentTime
end

local function DetailsGetCurrentList()
	local CurrentCombat = Details: GetCombat(0)
	--local CurrentTime = CurrentCombat: GetCombatTime() or 1
	
	local CurrentDamageContainer = CurrentCombat: GetContainer(DETAILS_ATTRIBUTE_DAMAGE)
	local CurrentHealingContainer = CurrentCombat: GetContainer(DETAILS_ATTRIBUTE_HEAL)
	
	--CurrentDamageContainer: SortByKey ("totalover")
	--CurrentHealingContainer: SortByKey ("totalover")
	
	local Damage = {}
	local Healing = {}
	for i, Actor in CurrentDamageContainer:ListActors() do
		if (Actor:IsGroupPlayer()) then
			table.insert(Damage, {Actor:name(), Actor.total})
		end
	end
	for i, Actor in CurrentHealingContainer:ListActors() do
		if (Actor:IsGroupPlayer()) then
			table.insert(Healing, {Actor:name(), Actor.total})
		end
	end
	table.sort(Damage, function(v1,v2) return v1[2] > v2[2] end)
	table.sort(Healing, function(v1,v2) return v1[2] > v2[2] end)
	
	local DamageNum = 1
	for i = 1, #Damage do
		if Damage[i][1] == PlayerName then
			DamageNum = i
		end
	end
	local HealingNum = 1
	for i = 1, #Healing do
		if Healing[i][1] == PlayerName then
			HealingNum = i
		end
	end
	
	return DamageNum, HealingNum
end

local function Details_Update(f)
	local CurrentDamageValue, CurrentDPS, CurrentHealingValue, CurrentHPS = DetailsGetCurrent()
	local CurrentDamageList, CurrentHealingList = DetailsGetCurrentList()
	Num_Update(f.CurrentDamage, CurrentDamageList, CurrentDPS, CurrentDamageValue)
	Num_Update(f.CurrentHealing, CurrentHealingList, CurrentHPS, CurrentHealingValue)
end

local function Details_OnUpdate(f)
	f:SetScript("OnUpdate", function(self)
		if F.Last5 == 0 then
			Details_Update(self)
		end
	end)
end

local function Details_Event(f, event, ...)
	if not Details then return end
	if event == "PLAYER_ENTERING_WORLD" then
		Details_Update(f)
	end
	if event == "PLAYER_REGEN_DISABLED" then
		Details_OnUpdate(f)
	end
	if event == "PLAYER_REGEN_ENABLED" then
		f:SetScript("OnUpdate", nil)
	end
end

--- ------------------------------------------------------------
--> Recount
--- ------------------------------------------------------------



----------------------------------------------------------------
--> Skada
----------------------------------------------------------------
--print(Skada, Skada.db, Skada.total.damage, Skada.char.total.damage, Skada.char.sets, Skada.current)
--print(Skada.char.total.damage, Skada.char.sets[1].damage)
--print("C"..Skada.current.damage)
--print("L"..Skada.last.damage)

local function Skada_GetTime(set)
	if set.time > 0 then
		return max(1, set.time)
	else
		local endtime = set.endtime
		if not endtime then
			endtime = time()
		end
		return max(1, endtime-set.starttime)
	end
end

local function Skada_GetActiveTime(set, player)
	local maxtime = 0

	-- Add recorded time (for total set)
	if player.time > 0 then
		maxtime = player.time
	end

	-- Add in-progress time if set is not ended.
	if (not set.endtime or set.stopped) and player.first then
		maxtime = maxtime + player.last - player.first
	end
	return max(1, maxtime)
end

local function Skada_CurrentDamage()
	local set = {}
	if Skada.current then
		set = Skada.current
	elseif Skada.last then
		set = Skada.last
	elseif Skada.char.sets then
		set = Skada.char.sets[1]
	end
	
	if set and set.players then
		table.sort(set.players, function(v1,v2) return v1.damage > v2.damage end)
		for i, v in ipairs(set.players) do
			if v.name == PlayerName then
				return i, v.damage, v.damage/Skada_GetActiveTime(set, v)
			end
		end
	end
end

local function Skada_CurrentHealing()
	local set = {}
	if Skada.current then
		set = Skada.current
	elseif Skada.last then
		set = Skada.last
	elseif Skada.char.sets then
		set = Skada.char.sets[1]
	end
	
	if set and set.players then
		table.sort(set.players, function(v1,v2) return v1.healing > v2.healing end)
		for i, v in ipairs(set.players) do
			if v.name == PlayerName then
				return i, v.healing, v.healing/Skada_GetActiveTime(set, v)
			end
		end
	end
end

local function Skada_Update(f)
	local CurrentDamageNum, CurrentDamageValue, CurrentDPS = Skada_CurrentDamage()
	local CurrentHealingNum, CurrentHealingValue, CurrentHPS = Skada_CurrentHealing()
	Num_Update(f.CurrentDamage, CurrentDamageNum, CurrentDPS, CurrentDamageValue)
	Num_Update(f.CurrentHealing, CurrentHealingNum, CurrentHPS, CurrentHealingValue)
end

local function Skada_OnUpdate(f)
	f:SetScript("OnUpdate", function(self)
		if F.Last5 == 0 then
			Skada_Update(self)
		end
	end)
end

local function Skada_Event(f, event, ...)
	if not Skada then return end
	if event == "PLAYER_ENTERING_WORLD" then
		Skada_Update(f)
	end
	if event == "PLAYER_REGEN_DISABLED" then
		Skada_OnUpdate(f)
	end
	if event == "PLAYER_REGEN_ENABLED" then
		f:SetScript("OnUpdate", nil)
	end
end

----------------------------------------------------------------
--> Tactics Data Recording System
----------------------------------------------------------------

local function Num_Artwork(f, color)
	f.Num = {}
	for i = 1, 12 do
		f.Num[i] = f:CreateTexture(nil, "ARTWORK")
		f.Num[i]: SetTexture(F.Media.."Num_Right14")
		f.Num[i]: SetVertexColor(F.Color(color))
		f.Num[i]: SetAlpha(1)
		f.Num[i]: SetSize(Num_14[0][1], Num_14[0][2])
		f.Num[i]: SetTexCoord(Num_14[0][3],Num_14[0][4], Num_14[0][5],Num_14[0][6])
		
		if i == 1 then
			f.Num[i]: SetPoint("TOPLEFT", f, "TOPLEFT", 0,0)
		elseif i == 3 then
			f.Num[i]: SetPoint("TOPLEFT", f.Num[i-1], "TOPLEFT", 9*3,-1*3)
		elseif i == 8 then
			f.Num[i]: SetPoint("TOPLEFT", f.Num[i-1], "TOPLEFT", 18,-2)
		else
			f.Num[i]: SetPoint("TOPLEFT", f.Num[i-1], "TOPLEFT", 9,-1)
		end
	end
end

local function CurrentDamage_Frame(f)
	f.CurrentDamage = CreateFrame("Frame", nil, f)
	f.CurrentDamage: SetSize(160,20)
	f.CurrentDamage: SetPoint("CENTER", f, "CENTER", -4,10)
	
	Num_Artwork(f.CurrentDamage, C.Color.R1)
end

local function CurrentHealing_Frame(f)
	local healing = CreateFrame("Frame", nil, f)
	healing: SetSize(160,20)
	healing: SetPoint("CENTER", f, "CENTER", 4,-10)
	Num_Artwork(healing, C.Color.Y2)
	
	f.CurrentHealing = healing
end

local function TDR_RegEvent(frame)
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterEvent("PLAYER_REGEN_DISABLED")
	frame: RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function TDR_OnEvent(frame)
	frame: SetScript("OnEvent", function(self, event, ...)
		Skada_Event(self, event, ...)
		Details_Event(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			if not (Details or Skada) then
				if self:IsShown() then
					self:Hide()
				end
			end
		end
	end)
end

local TacticsDataRecord = CreateFrame("Frame", "Quafe_TacticsDataRecord", P)
TacticsDataRecord: SetSize(160,20)
TacticsDataRecord: SetPoint("CENTER", UIParent, "BOTTOMRIGHT", -400, 160)
local function TDR_Load()
	CurrentDamage_Frame(TacticsDataRecord)
	CurrentHealing_Frame(TacticsDataRecord)
	TDR_RegEvent(TacticsDataRecord)
	TDR_OnEvent(TacticsDataRecord)
end
TacticsDataRecord.Load = TDR_Load
tinsert(P.Module, TacticsDataRecord)









--[[

local function TDR_Frame(f)
	f.TDR = CreateFrame("Frame", nil, f)
	f.TDR: SetSize(160,20)
	f.TDR: SetPoint("CENTER", UIParent, "BOTTOMRIGHT", -360, 160)
	
	CurrentDamage_Frame(f.TDR)
	CurrentHealing_Frame(f.TDR)
	
	local CurrentDamageList, CurrentDamageValue, CurrentDPS = 1, 0, 0
	local CurrentHealingList, CurrentHealingValue, CurrentHPS = 1, 0, 0
	
	f.TDR: RegisterEvent("PLAYER_ENTERING_WORLD")
	f.TDR: RegisterEvent("PLAYER_REGEN_DISABLED")
	f.TDR: RegisterEvent("PLAYER_REGEN_ENABLED")
	f.TDR: SetScript("OnEvent", function(self, event, ...)
		Skada_Event(self, event, ...)
		Details_Event(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			if not (Details or Skada) then
				if self:IsShown() then
					self:Hide()
				end
			end
		end
	end)
end

]]--