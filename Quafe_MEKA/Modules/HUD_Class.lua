local MEKA = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

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

local BurstHaste = {
	"146555", --暴怒之鼓
	"178207", --狂怒战鼓
	"230935", --高山战鼓
	"2825", --嗜血
	"32182", --英勇
	"80353", --时间扭曲
	"90355", --远古狂乱
	"160452", --虚空之风
}

--灵魂碎片 ItemID:6265
--count = GetItemCount(6265)

--- ------------------------------------------------------------
--> Ammo amount
--- ------------------------------------------------------------

--[[
PLAYER_EQUIPMENT_CHANGED
UNIT_INVENTORY_CHANGED
BAG_UPDATE
--]]
--local ammoCount = GetInventoryItemCount("player", ammoSlot);

local function AmmoCount_Artwork(frame)
	frame.Text = F.create_Font(frame, C.Font.Num, 12, nil, 0.8, "LEFT", "CENTER")
	frame.Text: SetPoint("LEFT", frame, "RIGHT", 10,0)
end

local function AmmoCount_RgEvent(frame)
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
	frame: RegisterUnitEvent("UNIT_INVENTORY_CHANGED", "player")
	frame: RegisterEvent("BAG_UPDATE")
end

local function AmmoCount_OnEvent(frame)
	frame: SetScript("OnEvent", function(self, event)
		local ammo = GetInventoryItemCount("player", 0);
		if ammo > 0 then
			if frame.State == "Hide" then
				frame: Show()
				frame.State = "Show"
			end
			self.Text: SetText(F.FormatNum(ammo, 1, false))
		end
	end)
end

local function AmmoCount_Frame(frame)
	local AmmoCount = CreateFrame("Frame", nil, frame)
	AmmoCount: SetSize(8, 42)
	--AmmoCount: SetPoint("CENTER", frame, "CENTER", -113,0)
	AmmoCount: SetPoint("CENTER", frame, "CENTER", 0,0)
	AmmoCount: Hide()
	AmmoCount.State = "Hide"

	AmmoCount_Artwork(AmmoCount)
	AmmoCount_RgEvent(AmmoCount)
	AmmoCount_OnEvent(AmmoCount)

	frame.AmmoCount = AmmoCount
end

----------------------------------------------------------------
--> Class Points
----------------------------------------------------------------

local NUM_COORD = {
	[0] =   {  0/256, 15/256, 4/32,27/32},
	[1] =   { 15/256, 30/256, 4/32,27/32},
	[2] =   { 30/256, 45/256, 4/32,27/32},
	[3] =   { 45/256, 60/256, 4/32,27/32},
	[4] =   { 60/256, 75/256, 4/32,27/32},
	[5] =   { 75/256, 90/256, 4/32,27/32},
	[6] =   { 90/256,105/256, 4/32,27/32},
	[7] =   {105/256,120/256, 4/32,27/32},
	[8] =   {120/256,135/256, 4/32,27/32},
	[9] =   {135/256,150/256, 4/32,27/32},
	["X"] = {150/256,165/256, 4/32,27/32},
	["B"] = {255/256,256/256, 4/32,27/32},
}

local function update_Ring(frame, d)
	if frame.RR then
		if not d then d = 1 end
		d = min(max(d, 0), 1)
		frame.RR.Bar:SetRotation(math.rad(frame.RR.Base+180*d))
	end
end

local function Ring_Artwork(frame, size, texture)
	local SC = CreateFrame("Frame", nil, frame)
	SC: SetSize(size, size)
	SC: SetPoint("CENTER")
	frame: SetScrollChild(SC)
	
	local Ring = SC:CreateTexture(nil, "ARTWORK")
	Ring: SetTexture(F.Path(texture))
	Ring: SetSize(size, size)
    Ring: SetPoint("CENTER")
    Ring: SetVertexColor(F.Color(C.Color.Main1))
	Ring: SetAlpha(1)
	--Ring: SetBlendMode("BLEND")
	Ring: SetRotation(math.rad(frame.Base+180))
	frame.Bar = Ring
end

local function Create_Ring(frame, size, texture)
	frame.RingTimer = 0
	frame.RingDuration = 0

	frame.RR = CreateFrame("ScrollFrame", nil, frame)
	--f.RR: SetFrameLevel(level)
	frame.RR: SetSize((size)/2, size)
	frame.RR: SetPoint("LEFT", frame, "CENTER", 0,0)
	frame.RR: SetHorizontalScroll((size)/2)
	frame.RR.Base = -180
	Ring_Artwork(frame.RR, size, texture)
end

local function ClassPoints_Artwork(frame)
	local Ring1 = CreateFrame("Frame", nil, frame)
	Ring1: SetSize(54,54)
	Ring1: SetPoint("CENTER", frame, "CENTER", 0,0)
	Create_Ring(Ring1, 64, "Points\\Bar")

	local Ring1_Bg = frame: CreateTexture(nil, "BACKGROUND")
	Ring1_Bg: SetTexture(F.Path("Points\\BarBg"))
	Ring1_Bg: SetVertexColor(F.Color(C.Color.W1))
	Ring1_Bg: SetAlpha(0.9)
	Ring1_Bg: SetSize(64,64)
	Ring1_Bg: SetPoint("CENTER", frame, "CENTER", 0,0)

	local Ring1_Bg_Glow = frame: CreateTexture(nil, "BORDER")
	Ring1_Bg_Glow: SetTexture(F.Path("Points\\BarBg"))
	Ring1_Bg_Glow: SetVertexColor(F.Color(C.Color.Main1))
	Ring1_Bg_Glow: SetAlpha(0.2)
	Ring1_Bg_Glow: SetSize(64,64)
	Ring1_Bg_Glow: SetPoint("CENTER", frame, "CENTER", 0,0)

	frame.Num = {}
	frame.NumHold = CreateFrame("Frame", nil, frame)
	frame.NumHold: SetSize(12,12)
	frame.NumHold: SetPoint("CENTER", frame, "CENTER", 0,0)
	for i = 1,2 do
		frame.Num[i] = frame.NumHold: CreateTexture(nil, "OVERLAY")
		frame.Num[i]: SetTexture(F.Path("Points\\Num26"))
		frame.Num[i]: SetVertexColor(F.Color(C.Color.Main1))
		frame.Num[i]: SetAlpha(1)
		frame.Num[i]: SetSize(15,23)
		frame.Num[i]: SetTexCoord(NUM_COORD[0][1],NUM_COORD[0][2], NUM_COORD[0][3],NUM_COORD[0][4])
		frame.Num[i]: SetPoint("CENTER", frame.NumHold, "CENTER", -10*(i-1),0)
	end
	frame.Num.Unit = frame.NumHold: CreateTexture(nil, "OVERLAY")
	frame.Num.Unit: SetTexture(F.Path("Points\\Num26"))
	frame.Num.Unit: SetVertexColor(F.Color(C.Color.Main1))
	frame.Num.Unit: SetAlpha(0.9)
	frame.Num.Unit: SetSize(15,23)
	frame.Num.Unit: SetTexCoord(NUM_COORD["X"][1],NUM_COORD["X"][2], NUM_COORD["X"][3],NUM_COORD["X"][4])
	frame.Num.Unit: SetPoint("CENTER", frame.NumHold, "CENTER", 9,0)

	frame.Ring = Ring1
	frame.Ring.Bg = Ring1_Bg
end

local function Points_Event(frame)
	local d1, d2
	if frame.Info.CP > 0 then
		if not frame.Info.OldValue or frame.Info.OldValue ~= frame.Info.CP then
			d1,d2 = F.BreakNums(frame.Info.CP, 2)
			if d2 < 1 then
				d2 = "B"
			end
			frame.Num[1]: SetTexCoord(NUM_COORD[d1][1],NUM_COORD[d1][2], NUM_COORD[d1][3],NUM_COORD[d1][4])
			frame.Num[2]: SetTexCoord(NUM_COORD[d2][1],NUM_COORD[d2][2], NUM_COORD[d2][3],NUM_COORD[d2][4])
			if frame.Info.CMP and frame.Info.CMP == frame.Info.CP then
				frame.Num[1]: SetVertexColor(F.Color(C.Color.Warn1))
				frame.Num[2]: SetVertexColor(F.Color(C.Color.Warn1))
			else
				frame.Num[1]: SetVertexColor(F.Color(C.Color.Main1))
				frame.Num[2]: SetVertexColor(F.Color(C.Color.Main1))
			end
			frame.Info.OldValue = frame.Info.CP
		end
	elseif frame.Info.E then
		if not frame.Info.OldValue or frame.Info.OldValue ~= frame.Info.E then
			d1,d2 = F.BreakNums(frame.Info.E, 2)
			if d2 < 1 then
				d2 = "B"
			end
			frame.Num[1]: SetTexCoord(NUM_COORD[d1][1],NUM_COORD[d1][2], NUM_COORD[d1][3],NUM_COORD[d1][4])
			frame.Num[2]: SetTexCoord(NUM_COORD[d2][1],NUM_COORD[d2][2], NUM_COORD[d2][3],NUM_COORD[d2][4])
			if frame.Info.MP and frame.Info.MP == frame.Info.E then
				frame.Num[1]: SetVertexColor(F.Color(C.Color.Warn1))
				frame.Num[2]: SetVertexColor(F.Color(C.Color.Warn1))
			else
				frame.Num[1]: SetVertexColor(F.Color(C.Color.Main1))
				frame.Num[2]: SetVertexColor(F.Color(C.Color.Main1))
			end
			frame.Info.OldValue = frame.Info.E
		end
	end

	if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.State == "RING" and Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.RingTopLeftTrack == "COMBO" then
		if C.RTL then
			frame: SetAlpha(0)
		else
			frame: SetAlpha(frame.Info.Alpha)
		end
	else
		if frame.Info.CP > 0 then
			frame: SetAlpha(1)
		else
			frame: SetAlpha(frame.Info.Alpha)
		end
	end
end
--[[
local function Point_CTA(frame)
	if frame.Info.E and frame.Info.MP > 0 then
		local d, d1, d2
		d = frame.Info.E
		d2 = floor(d/10)
		d1 = max(floor(d - d2*10), 0)
		if d2 < 1 then
			d2 = "B"
		end
		frame.Num[1]: SetTexCoord(NUM_COORD[d1][1],NUM_COORD[d1][2], NUM_COORD[d1][3],NUM_COORD[d1][4])
		frame.Num[2]: SetTexCoord(NUM_COORD[d2][1],NUM_COORD[d2][2], NUM_COORD[d2][3],NUM_COORD[d2][4])
	end
	C_Timer.After(0.1, function(self) Point_CTA(frame) end)
end

local function Monk_Mistweaver_CTA(frame)
	if frame.Info.MistweaverUpdate then
		if (frame.Info.SpecID == SPEC_MONK_MISTWEAVER) then
			local count = GetSpellCount("205406")
			frame.Info.E = count
			frame.Info.MP = 12
			update_Ring(frame.Ring, 1, true)
			if frame.Info.E ~= 0 then
				frame: SetAlpha(1)
				if not frame:IsShown() then
					frame.SlideIn: Play()
				end
			else
				if frame:IsShown() then
					frame.SlideOut: Play()
				end
			end
		end
		C_Timer.After(0.1, function(self) Monk_Mistweaver_CTA(frame) end)
	end
end
]]--
--> ComboPoints
local function ComboPoints_Event(frame, event, ...)
	if F.IsClassic then
		frame.Info.CP = GetComboPoints("player", "target")
		frame.Info.CMP = 5
	else
		frame.Info.CP = UnitPower("player", 4)
		frame.Info.CMP = UnitPowerMax("player", 4)
	end
end

--> DeathKnight
local function DeathKnight_Event(frame, event, ...)
	if F.IsClassic then return end
	if (frame.Info.Class == "DEATHKNIGHT") then
		if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
			if (frame.Info.SpecID == 1) then
				if (not E.AuraUpdate["player"].Buff["195181"]) then
					E.AuraUpdate["player"].Buff["195181"] = {
						Aura = "195181",
						Caster = "player",
					}
					F.ABGU_Toggle("player")
				end
			elseif (frame.Info.SpecID == 2) then
				if (not E.AuraUpdate["player"].Buff["281209"]) then
					E.AuraUpdate["player"].Buff["281209"] = {
						Aura = "281209",
						Caster = "player",
					}
					F.ABGU_Toggle("player")
				end
			elseif (frame.Info.SpecID == 3) then
				if (not E.AuraUpdate["target"].Debuff["194310"]) then
					E.AuraUpdate["target"].Debuff["194310"] = {
						Aura = "194310",
						Caster = "player",
					}
					F.ABGU_Toggle("target")
				end
			end
		end
		if (frame.Info.SpecID == 1) then
			frame.Info.MP = 10
		elseif (frame.Info.SpecID == 2) then

		elseif (frame.Info.SpecID == 3) then
			frame.Info.MP = 6
		end
	end
end

local function DeathKnight_Update(frame, elapsed)
	if F.IsClassic then return end
	if (frame.Info.Class == "DEATHKNIGHT") then
		if (frame.Info.SpecID == 1) then
			frame.Info.E = E.AuraUpdate["player"].Buff["195181"].Count or 0
			frame.Info.Remain = E.AuraUpdate["player"].Buff["195181"].Remain or 0
			frame.Info.Duration = E.AuraUpdate["player"].Buff["195181"].Duration
			if E.AuraUpdate["player"].Buff["195181"].Remain and (E.AuraUpdate["player"].Buff["195181"].Remain > 0) then
				E.AuraUpdate["player"].Buff["195181"].Remain = E.AuraUpdate["player"].Buff["195181"].Remain - elapsed
			end
		elseif (frame.Info.SpecID == 2) then
			frame.Info.E = E.AuraUpdate["player"].Buff["281209"].Count or 0
			frame.Info.Remain = E.AuraUpdate["player"].Buff["281209"].Remain or 0
			frame.Info.Duration = E.AuraUpdate["player"].Buff["281209"].Duration
			if E.AuraUpdate["player"].Buff["281209"].Remain and (E.AuraUpdate["player"].Buff["281209"].Remain > 0) then
				E.AuraUpdate["player"].Buff["281209"].Remain = E.AuraUpdate["player"].Buff["281209"].Remain - elapsed
			end
		elseif (frame.Info.SpecID == 3) then
			frame.Info.E = E.AuraUpdate["target"].Debuff["194310"].Count or 0
			frame.Info.Remain = E.AuraUpdate["target"].Debuff["194310"].Remain or 0
			frame.Info.Duration = E.AuraUpdate["target"].Debuff["194310"].Duration
			if E.AuraUpdate["target"].Debuff["194310"].Remain and (E.AuraUpdate["target"].Debuff["194310"].Remain > 0) then
				E.AuraUpdate["target"].Debuff["194310"].Remain = E.AuraUpdate["target"].Debuff["194310"].Remain - elapsed
			end
		end
		if (frame.Info.SpecID == 1) or (frame.Info.SpecID == 2) or (frame.Info.SpecID == 3) then
			if frame.Info.Remain and (frame.Info.Remain > 0) then
				update_Ring(frame.Ring, frame.Info.Remain/(frame.Info.Duration+F.Debug))
			else
				update_Ring(frame.Ring, 1)
			end
			if frame.Info.E == 0 then
				frame.Info.Alpha = 0
			elseif UnitAffectingCombat("player") then
				frame.Info.Alpha = 1
			else
				frame.Info.Alpha = 0.4
			end
		end
	end
end

--> Druid
local function Druid_Event(frame, event, ...)
	if F.IsClassic then return end
	if (frame.Info.Class == "DRUID") then
		if event == "PLAYER_ENTERING_WORLD" then
			frame: RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		end
		if event == "PLAYER_ENTERING_WORLD" or "UPDATE_SHAPESHIFT_FORM" then
			frame.Info.Form = GetShapeshiftFormID()
		end
		--CAT_FORM
	end
end

--> Mage
local function Mage_Event(frame, event, ...)
	if F.IsClassic then return end
	if (frame.Info.Class == "MAGE") then
		if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
			if (frame.Info.SpecID == 1) then
				frame: UnregisterEvent("SPELL_UPDATE_COOLDOWN")
				C.RTL = true
			elseif (frame.Info.SpecID == 2) then
				frame: RegisterEvent("SPELL_UPDATE_COOLDOWN")
			elseif (frame.Info.SpecID == 3) then
				C.RTL = true
				frame: UnregisterEvent("SPELL_UPDATE_COOLDOWN")
			end
		end
		if (frame.Info.SpecID == 1) then
			frame.Info.E = UnitPower("player", 16)
			frame.Info.MP = UnitPowerMax("player", 16)
			update_Ring(frame.Ring, 1, true)
			if frame.Info.E == 0 then
				frame.Info.Alpha = 0
			elseif UnitAffectingCombat("player") then
				frame.Info.Alpha = 1
			else
				frame.Info.Alpha = 0.4
			end
		elseif (frame.Info.SpecID == 2) then
			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" then
				local count, maxcount, expiration, duration = GetSpellCharges("108853") -->火焰冲击
				frame.Info.E = count
				frame.Info.MP = maxcount or 3
				frame.Info.Remain = GetTime() - (expiration or 0)
				frame.Info.Duration = duration
				update_Ring(frame.Ring, frame.Info.Remain/(frame.Info.Duration+F.Debug))
			end
		elseif (frame.Info.SpecID == 3) then
				frame.Info.MP = 5
			if (not E.AuraUpdate["player"].Buff["205473"]) then
				E.AuraUpdate["player"].Buff["205473"] = { --刺骨冰寒
					Aura = "205473",
					Unit = "player",
					Caster = "player",
				}
				F.ABGU_Toggle("player")
			end
		end
	end
end

local function Mage_Update(frame, elapsed)
	if F.IsClassic or (not (F.PlayerClass == "MAGE")) then return end
	if (frame.Info.SpecID == 2) then
		if frame.Info.Remain and (frame.Info.Remain >= 0) and (frame.Info.Remain <= frame.Info.Duration) then
			update_Ring(frame.Ring, frame.Info.Remain/(frame.Info.Duration+F.Debug))
			frame.Info.Remain = frame.Info.Remain + elapsed
		else
			update_Ring(frame.Ring, 1)
		end
		if frame.Info.E == frame.Info.MP then
			frame.Info.Alpha = 0
		else
			frame.Info.Alpha = 1
		end
	elseif (frame.Info.SpecID == 3) then
		if E.AuraUpdate["player"].Buff["205473"].Exist then
			frame.Info.E = E.AuraUpdate["player"].Buff["205473"].Count or 0
			frame.Info.Remain = E.AuraUpdate["player"].Buff["205473"].Remain or 0
			frame.Info.Duration = E.AuraUpdate["player"].Buff["205473"].Duration
		else
			frame.Info.E = 0
			frame.Info.Remain = 0
			frame.Info.Duration = 0
		end
		if E.AuraUpdate["player"].Buff["205473"].Remain and (E.AuraUpdate["player"].Buff["205473"].Remain > 0) then
			E.AuraUpdate["player"].Buff["205473"].Remain = E.AuraUpdate["player"].Buff["205473"].Remain - elapsed
		end
	end
	if (frame.Info.SpecID == 3) then
		if frame.Info.Remain and (frame.Info.Remain > 0) then
			update_Ring(frame.Ring, frame.Info.Remain/(frame.Info.Duration+F.Debug))
		else
			update_Ring(frame.Ring, 1)
		end
		if frame.Info.E == 0 then
			frame.Info.Alpha = 0
		elseif UnitAffectingCombat("player") then
			frame.Info.Alpha = 1
		else
			frame.Info.Alpha = 0.4
		end
	end
end

--> 武僧
local function Monk_Event(frame, event, ...)
	if F.IsClassic then return end
	if (frame.Info.Class == "MONK") then
		if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
			frame.Ring.RR.Bar: SetVertexColor(F.Color(C.Color.Main1))
			frame.Ring.Bg: SetVertexColor(F.Color(C.Color.W1))

			if (frame.Info.SpecID == SPEC_MONK_BREWMASTER) then
				frame: UnregisterEvent("UNIT_MAXPOWER")
				frame: RegisterEvent("SPELL_UPDATE_COOLDOWN")
				C.RTL = true
			elseif (frame.Info.SpecID == SPEC_MONK_MISTWEAVER) then
				frame: UnregisterEvent("UNIT_MAXPOWER")
				frame: RegisterEvent("SPELL_UPDATE_COOLDOWN")
			elseif (frame.Info.SpecID == SPEC_MONK_WINDWALKER) then
				frame: RegisterUnitEvent("UNIT_MAXPOWER", "player")
				frame: UnregisterEvent("SPELL_UPDATE_COOLDOWN")
				C.RTL = true
			end
		end
		--> 酒仙
		if (frame.Info.SpecID == SPEC_MONK_BREWMASTER) then
			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" then
				local count, maxcount = GetSpellCharges("119582") --活血酒
				frame.Info.E = count
				frame.Info.MP = maxcount
			end
		--> 织雾
		elseif (frame.Info.SpecID == SPEC_MONK_MISTWEAVER) then
			--local count = GetSpellCount("115151") --复苏之雾
			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "SPELL_UPDATE_COOLDOWN" then
				local count, maxcount, expiration, duration = GetSpellCharges("115151") --复苏之雾
				frame.Info.E = count
				frame.Info.MP = maxcount or 2
				frame.Info.Remain = GetTime() - (expiration or 0)
				frame.Info.Duration = duration
				update_Ring(frame.Ring, frame.Info.Remain/(frame.Info.Duration+F.Debug))
			end
			--update_Ring(frame.Ring, 1, true)
			if frame.Info.E == frame.Info.MP then
				frame.Info.Alpha = 0
			else
				frame.Info.Alpha = 1
			end
			
		--> 踏风
		elseif (frame.Info.SpecID == SPEC_MONK_WINDWALKER) then 
			frame.Info.E = UnitPower("player", 12)
			frame.Info.MP = UnitPowerMax("player", 12)
			update_Ring(frame.Ring, 1, true)
			if frame.Info.E == 0 then
				frame.Info.Alpha = 0
			elseif UnitAffectingCombat("player") then
				frame.Info.Alpha = 1
			else
				frame.Info.Alpha = 0.5
			end
		end
	end
end

local function Monk_Update(frame, elapsed)
	if F.IsClassic then return end
	if (frame.Info.Class == "MONK") then
		--> 酒仙
		if (frame.Info.SpecID == SPEC_MONK_BREWMASTER) then
			local currstagger = UnitStagger("player") or 0
			local maxstagger = UnitHealthMax("player") or 1
			local percent = currstagger/maxstagger;

			if UnitAffectingCombat("player") then
				frame.Info.Alpha = 1
			elseif (percent == 0) and (frame.Info.E == frame.Info.MP) then
				frame.Info.Alpha = 0
			else
				frame.Info.Alpha = 0.5
			end

			if (percent > 1) then
				percent = percent - 1
				frame.Ring.RR.Bar: SetVertexColor(F.Color(C.Color.R3))
				frame.Ring.Bg: SetVertexColor(F.Color(C.Color.Y3))
			elseif (percent >= 0.5) then
				frame.Ring.RR.Bar: SetVertexColor(F.Color(C.Color.Y3))
				frame.Ring.Bg: SetVertexColor(F.Color(C.Color.W1))
			else
				frame.Ring.RR.Bar: SetVertexColor(F.Color(C.Color.W3))
				frame.Ring.Bg: SetVertexColor(F.Color(C.Color.W1))
			end
			update_Ring(frame.Ring, percent)
		--> 织雾
		elseif (frame.Info.SpecID == SPEC_MONK_MISTWEAVER) then
			if frame.Info.Remain and (frame.Info.Remain >= 0) and (frame.Info.Remain <= frame.Info.Duration) then
				update_Ring(frame.Ring, frame.Info.Remain/(frame.Info.Duration+F.Debug))
				frame.Info.Remain = frame.Info.Remain + elapsed
			else
				update_Ring(frame.Ring, 1)
			end
		end
	end
end

--> Paladin
local function Paladin_Event(frame, event, ...)
	if F.IsClassic then return end
	if (frame.Info.Class == "PALADIN") then
		--if (frame.Info.SpecID == SPEC_PALADIN_RETRIBUTION) then
			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
				C.RTL = true
			end
			frame.Info.E = UnitPower("player", 9)
			frame.Info.MP = UnitPowerMax("player", 9)
			update_Ring(frame.Ring, 1, true)
			if frame.Info.E == 0 then
				frame.Info.Alpha = 0
			elseif UnitAffectingCombat("player") then
				frame.Info.Alpha = 1
			else
				frame.Info.Alpha = 0.5
			end
		--end
	end
end

--> Warlock
local function Warlock_Event(frame, event, ...)
	if (frame.Info.Class == "WARLOCK") then
		if F.IsClassic then
			if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_Class.SoulShard then
				if event == "PLAYER_ENTERING_WORLD" then
					frame: RegisterEvent("BAG_UPDATE")
					frame: UnregisterEvent("UNIT_MAXPOWER")
					frame: UnregisterEvent("UNIT_POWER_UPDATE")
				end
				frame.Info.E = GetItemCount(6265)
				if frame.Info.E == 0 then
					frame.Info.Alpha = 0
				elseif UnitAffectingCombat("player") then
					frame.Info.Alpha = 1
				else
					frame.Info.Alpha = 0.5
				end
			end
		else
			if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
				C.RTL = true
			end
			frame.Info.E = UnitPower("player", 7)
			frame.Info.MP = UnitPowerMax("player", 7)
			if (frame.Info.SpecID == SPEC_WARLOCK_DESTRUCTION) then
				local HighPower = UnitPower("player", 7, true)
				local HighPowerMax = UnitPowerMax("player", 7, true)
				local PerShareMax = HighPowerMax/frame.Info.MP
				local PerShare = HighPower - PerShareMax*frame.Info.E
				frame.Info.PP = PerShare/PerShareMax
				update_Ring(frame.Ring, frame.Info.PP, true)
			else
				update_Ring(frame.Ring, 1, true)
			end
			if UnitAffectingCombat("player") then
				frame.Info.Alpha = 1
			else
				if frame.Info.E ~= 3 then
					frame.Info.Alpha = 0.5
				else
					frame.Info.Alpha = 0
				end
			end
		end
	end
end

--> 牧师
local function Priest_Event(frame, event, ...)
	if F.IsClassic or (not (F.PlayerClass == "PRIEST")) then return end
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
		if (frame.Info.SpecID == 3) then
			if (not E.AuraUpdate["player"].Buff["194249"]) then --虚空形态
				E.AuraUpdate["player"].Buff["194249"] = {
					Aura = "194249",
					Unit = "player",
				}
				F.ABGU_Toggle("player")
			end
			if (not E.AuraUpdate["player"].Buff["197937"]) then --延宕狂乱
				E.AuraUpdate["player"].Buff["197937"] = {
					Aura = "197937",
					Unit = "player",
				}
				F.ABGU_Toggle("player")
			end
		end
	end
end

local function Priest_Update(frame, elapsed)
	if F.IsClassic or (not (F.PlayerClass == "PRIEST")) then return end
	if (frame.Info.SpecID == 3) then
		if E.AuraUpdate["player"].Buff["194249"].Exist then
			frame.Info.E = E.AuraUpdate["player"].Buff["194249"].Count or 0
			frame.Info.Remain = E.AuraUpdate["player"].Buff["194249"].Remain or 0
			frame.Info.Duration = E.AuraUpdate["player"].Buff["194249"].Duration
		elseif E.AuraUpdate["player"].Buff["197937"].Exist then
			frame.Info.E = E.AuraUpdate["player"].Buff["197937"].Count or 0
			frame.Info.Remain = E.AuraUpdate["player"].Buff["197937"].Remain or 0
			frame.Info.Duration = E.AuraUpdate["player"].Buff["197937"].Duration
		else
			frame.Info.E = 0
			frame.Info.Remain = 0
			frame.Info.Duration = 0
		end
		if E.AuraUpdate["player"].Buff["194249"].Remain and (E.AuraUpdate["player"].Buff["194249"].Remain > 0) then
			E.AuraUpdate["player"].Buff["194249"].Remain = E.AuraUpdate["player"].Buff["194249"].Remain - elapsed
		end
		if E.AuraUpdate["player"].Buff["197937"].Remain and (E.AuraUpdate["player"].Buff["197937"].Remain > 0) then
			E.AuraUpdate["player"].Buff["197937"].Remain = E.AuraUpdate["player"].Buff["197937"].Remain - elapsed
		end
	end
	if (frame.Info.SpecID == 3) then
		if frame.Info.Remain and (frame.Info.Remain > 0) then
			update_Ring(frame.Ring, frame.Info.Remain/(frame.Info.Duration+F.Debug))
		else
			update_Ring(frame.Ring, 1)
		end
		if frame.Info.E == 0 then
			frame.Info.Alpha = 0
		elseif UnitAffectingCombat("player") then
			frame.Info.Alpha = 1
		else
			frame.Info.Alpha = 0.5
		end
	end
end

--> 龙希尔 Evoker
local function Evoker_Event(frame, event, ...)
	if F.IsClassic or frame.Info.Class ~= "EVOKER" then return end
	frame.Info.E = UnitPower("player", Enum.PowerType.Essence)	--19
	frame.Info.EP = UnitPowerMax("player", Enum.PowerType.Essence)	--19
	if frame.Info.E == frame.Info.EP then
		frame.Info.Alpha = 0
	elseif UnitAffectingCombat("player") then
		frame.Info.Alpha = 1
	else
		frame.Info.Alpha = 0.5
	end
end

local function Evoker_Update(frame, elapsed)
	if F.IsClassic or frame.Info.Class ~= "EVOKER" then return end
	if frame.Info.E ~= frame.Info.EP then
		local partialPoint = UnitPartialPower("player", Enum.PowerType.Essence)
		local elapsedPortion = (partialPoint / 1000.0)
		update_Ring(frame.Ring, elapsedPortion, true)
		frame.Info.Update = true
	elseif frame.Info.Update == true then
		update_Ring(frame.Ring, 1)
		frame.Info.Update = false
	end
end

local function ClassPoints_RgEvent(frame)
	frame: RegisterEvent("PLAYER_LOGIN")
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	if not F.IsClassic then
		frame: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		frame: RegisterEvent("PLAYER_TALENT_UPDATE")
		frame: RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
		frame: RegisterUnitEvent("UNIT_EXITED_VEHICLE", "player")
		frame: RegisterUnitEvent("UNIT_ENTERED_VEHICLE", "player")
	end
	--frame: RegisterEvent("UNIT_COMBO_POINTS")
	frame: RegisterEvent("PLAYER_TARGET_CHANGED")
	frame: RegisterUnitEvent("UNIT_POWER_UPDATE", "player")
	frame: RegisterUnitEvent("UNIT_MAXPOWER", "player")
	frame: RegisterEvent("PLAYER_REGEN_DISABLED")
	frame: RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function ClassPoints_OnEvent(frame, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "UPDATE_SHAPESHIFT_FORM" or event == "UNIT_EXITED_VEHICLE" or event == "UNIT_ENTERED_VEHICLE" then
		frame.Info.SpecID = (F.IsClassic and 1) or GetSpecialization()
		update_Ring(frame.Ring, 1)
		frame.Info.E = 0
		frame.Info.MP = 0
		frame.Info.CP = 0
		frame.Info.CMP = 0
		frame.Info.Value = 0
		frame.Info.Alpha = 0
		C.RTL = false
	end
	ComboPoints_Event(frame, event, ...)
	DeathKnight_Event(frame, event, ...)
	Druid_Event(frame, event, ...)
	Mage_Event(frame, event, ...)
	Monk_Event(frame, event, ...)
	Paladin_Event(frame, event, ...)
	Warlock_Event(frame, event, ...)
	Priest_Event(frame, event, ...)
	Evoker_Event(frame, event, ...)
	--Points_Event(frame)
	if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.State == "RING" and Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.RingTopLeftTrack == "COMBO" then
		F.MEKA_RINGHUD_ClassPoints_Update(frame, event, ...)
	end
end

local function Points_OnUpdate(frame)
	local Elapsed_Help = 100
	frame: SetScript("OnUpdate", function(self, elapsed)
		if Elapsed_Help >= 5*elapsed then
			DeathKnight_Update(self, Elapsed_Help)
			Priest_Update(self, Elapsed_Help)
			Mage_Update(self, Elapsed_Help)
			Monk_Update(self, Elapsed_Help)
			Points_Event(self, Elapsed_Help)
			Evoker_Update(self, Elapsed_Help)
			Elapsed_Help = 0
		else
			Elapsed_Help = Elapsed_Help + elapsed
		end
	end)
end

local function ClassPoints_Frame(frame)
	local Points = CreateFrame("Frame", nil, frame)
	Points: SetSize(12, 12)
	Points: SetPoint("CENTER", f, "CENTER", -200,0)
	Points: SetAlpha(0)
	Points.Info = {}
	--Points.Info.CTA_Pruse = true
	Points.Info.E = 0
	Points.Info.MP = 0
	Points.Info.CP = 0
	Points.Info.CMP = 0
	Points.Info.Value = 0
	Points.Info.Class = select(2, UnitClass("player"))
	Points.Info.Alpha = 0

	Points.Info.Remain = 0
	Points.Info.Duration = 1
	
	ClassPoints_Artwork(Points)
	ClassPoints_RgEvent(Points)
	Points: SetScript("OnEvent", function(self, event, ...)
		ClassPoints_OnEvent(self, event, ...)
		if F.IsClassic then
			Points_Event(self)
		end
	end)
	if not F.IsClassic then
		Points_OnUpdate(Points)
	end
	ClassPoints_OnEvent(Points, "PLAYER_ENTERING_WORLD")

	frame.Points = Points
end

local function MEKA_ClassPoints_Toggle(frame, arg1)
	if not frame.Points then return end
	if arg1 == "ON" then
		frame.Points: Show()
		ClassPoints_RgEvent(frame.Points)
		if not F.IsClassic then
			Points_OnUpdate(Points)
		end
		ClassPoints_OnEvent(frame.Points, "PLAYER_ENTERING_WORLD")
	elseif arg1 == "OFF" then
		frame.Points: Hide()
		frame.Points: UnregisterAllEvents()
		frame.Points: SetScript("OnUpdate", nil)
	elseif arg1 == "Refresh" then
		ClassPoints_OnEvent(frame.Points, "PLAYER_ENTERING_WORLD")
	end
end

----------------------------------------------------------------
--> Rune Power
----------------------------------------------------------------

local function Rune_Ring_Color(frame, color)
	frame.LR.Ring: SetVertexColor(F.Color(color))
	frame.RR.Ring: SetVertexColor(F.Color(color))
end

local function Rune_Ring_Update(frame, value)
	if frame.LR then
		if not value then value = 1 end
		value = min(max(value, 0),1)
		if value < 0.5 then
			frame.LR.Ring:SetRotation(math.rad(frame.LR.Base+0))
			frame.RR.Ring:SetRotation(math.rad(frame.RR.Base-180*value*2))
		else
			frame.LR.Ring:SetRotation(math.rad(frame.LR.Base-180*(value*2-1)))
			frame.RR.Ring:SetRotation(math.rad(frame.RR.Base+180))
		end
	end
end

local function Rune_Ring_Artwork(frame, size)
	frame.C = CreateFrame("Frame", nil, frame)
	frame.C: SetSize(size, size)
	frame: SetScrollChild(frame.C)
	
	frame.Ring = frame.C:CreateTexture(nil, "BACKGROUND", nil, -2)
	frame.Ring: SetTexture(F.Path("Ring16_2"))
	frame.Ring: SetSize(size, size)
    frame.Ring: SetPoint("CENTER")
	frame.Ring: SetAlpha(1)
	frame.Ring: SetBlendMode("BLEND")
	frame.Ring: SetRotation(math.rad(frame.Base+180))
end

local function Rune_Ring_Create(f, size1, size2)
	f.RingTimer = 0
	f.RingDuration = 0
	
	local level = f:GetFrameLevel() - 1
	
	f.LR = CreateFrame("ScrollFrame", nil, f)
	f.LR: SetFrameLevel(level)
	f.LR: SetSize((size2)/2, size2)
	f.LR: SetPoint("RIGHT", f, "CENTER", 0,0)
	f.LR.Base = -180
	Rune_Ring_Artwork(f.LR, size2)
	
	f.RR = CreateFrame("ScrollFrame", nil, f)
	f.RR: SetFrameLevel(level)
	f.RR: SetSize((size2)/2, size2)
	f.RR: SetPoint("LEFT", f, "CENTER", 0,0)
	f.RR: SetHorizontalScroll((size2)/2)
	f.RR.Base = 0
	Rune_Ring_Artwork(f.RR, size2)

	local Bg1 = f:CreateTexture(nil, "BACKGROUND", nil, -1)
	Bg1: SetTexture(F.Path("Ring32_Bg"))
	Bg1: SetSize(size1, size1)
	Bg1: SetPoint("CENTER", f ,"CENTER", 0,0)
	Bg1: SetVertexColor(F.Color(C.Color.Black))
	
	local Bg2 = f.LR:CreateTexture(nil, "BACKGROUND", nil, -3)
	Bg2: SetTexture(F.Path("Ring32_Bg"))
	Bg2: SetSize(size1+12, size1+12)
	Bg2: SetPoint("CENTER", f ,"CENTER", 0,0)
	Bg2: SetVertexColor(F.Color(C.Color.Black))
	Bg2: SetBlendMode("BLEND")
end

local function Rune_RgEvent(frame)
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	frame: RegisterEvent("RUNE_POWER_UPDATE")
	--frame: RegisterEvent("RUNE_TYPE_UPDATE")
	frame: RegisterEvent("PLAYER_REGEN_DISABLED")
	frame: RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function Rune_OnEvent(frame, event, ...)
	--if event == "PLAYER_ENTERING_WORLD" then
	--	frame.Info.Class = select(2, UnitClass("player"))
	--	if frame.Info.Class == 'DEATHKNIGHT' then
	--		frame: Show()
	--	end
	--end
	if (event == "PLAYER_ENTERING_WORLD") or (event == "PLAYER_SPECIALIZATION_CHANGED") then
		frame.Info.SpecID = GetSpecialization() or 1
		for i = 1,3 do
			frame.Point[i].Bar: SetVertexColor(F.Color(C.Color.Rune[frame.Info.SpecID]))
		end
	end
	frame.Info.E = 0
	for i = 1,6 do
		frame.Rune[i] = {start = 0, timer = 0, duration = 0, ready = 0}
		local start, duration, runeReady = GetRuneCooldown(i)
		if runeReady then
			frame.Info.E = frame.Info.E + 1
		end
		frame.Rune[i].start = start or 0
		frame.Rune[i].duration = duration or 10
		frame.Rune[i].ready = runeReady
		if frame.Rune[i].ready then
			frame.Rune[i].timer = frame.Rune[i].duration
		else
			frame.Rune[i].timer = GetTime() - frame.Rune[i].start
		end
	end
	table.sort(frame.Rune, function(v1,v2) return v1.timer > v2.timer end)
	for i = 1,3 do
		if frame.Rune[i].ready and frame.Rune[i+3].ready then
			Rune_Ring_Color(frame.Point[i], C.Color.Rune[frame.Info.SpecID])
		else
			Rune_Ring_Color(frame.Point[i], C.Color.W4)
		end
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.State == "RING" and Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.RingTopLeftTrack == "COMBO" then
		frame: SetAlpha(0)
	else
		if UnitAffectingCombat("player") then
			frame: SetAlpha(1)
		elseif frame.Info.E ~= 6 then
			frame: SetAlpha(0.4)
		else
			frame: SetAlpha(0)
		end
	end
end

local function Rune_OnUpdate(frame)
	local Elapsed_Help = 0
	frame: SetScript("OnUpdate", function(self, elapsed)
		Elapsed_Help = Elapsed_Help + elapsed
		if (F.Last25H == 0) then
			for i = 1,3 do
				if self.Rune[i].ready then
					self.Point[i].Bar:Show()
					Rune_Ring_Update(self.Point[i], self.Rune[i+3].timer/self.Rune[i+3].duration)
				else
					self.Point[i].Bar:Hide()
					Rune_Ring_Update(self.Point[i], self.Rune[i].timer/self.Rune[i].duration)
				end
			end
			F.MEKA_RINGHUD_ClassPoints_RuneUpdate(self)
			for i = 1,6 do
				if not self.Rune[i].ready then
					self.Rune[i].timer = min(self.Rune[i].timer + Elapsed_Help, self.Rune[i].duration)
				end
			end
			Elapsed_Help = 0
		end
	end)
end

local function Rune_Frame(frame)
	local class = select(2, UnitClass("player"))
	if class ~= 'DEATHKNIGHT' then return end

	local Runes = CreateFrame("Frame", nil, frame)
	Runes: SetSize(32,32)
	Runes: SetPoint("CENTER", frame, "CENTER", 0,-120)

	Runes.Info = {}
	Runes.Info.Max = 0
	Runes.Info.SpecID = 3
	Runes.Point = {}
	Runes.Rune = {}
	for i = 1,6 do
		Runes.Rune[i] = {start = 0, timer = 0, duration = 0, ready = 0}
	end
	for i = 1,3 do
		local Point = CreateFrame("Frame", nil, Runes)
		Point: SetSize(16,16)
		Point: SetPoint("CENTER", Runes, "CENTER", 28*(i-2), 0)

		local Bar = Point: CreateTexture(nil, "ARTWORK")
		Bar: SetTexture(F.Path("Ring16_Bg"))
		Bar: SetSize(32,32)
		Bar: SetPoint("CENTER", Point, "CENTER", 0,0)
		Bar: SetAlpha(1)

		local BarBg = Point: CreateTexture(nil, "BACKGROUND")
		BarBg: SetTexture(F.Path("Ring16_Bg"))
		BarBg: SetVertexColor(F.Color(C.Color.White))
		BarBg: SetSize(32,32)
		BarBg: SetPoint("CENTER", Point, "CENTER", 0,0)
		BarBg: SetAlpha(0.25)

		Rune_Ring_Create(Point, 16, 32)

		Runes.Point[i] = Point
		Runes.Point[i].Bar = Bar
	end

	Rune_RgEvent(Runes)
	Runes: SetScript("OnEvent", function(self, event, ...)
		Rune_OnEvent(self, event, ...)
	end)
	Rune_OnUpdate(Runes)

	Rune_OnEvent(Runes, "PLAYER_ENTERING_WORLD")

	frame.Runes = Runes
end

local function MEKA_Class_Runes_Toggle(frame, arg1)
	if not frame.Runes then return end
	if arg1 == "ON" then
		frame.Runes: Show()
		Rune_RgEvent(frame.Runes)
		Rune_OnUpdate(frame.Runes)
		Rune_OnEvent(frame.Runes, "PLAYER_ENTERING_WORLD")
	elseif arg1 == "OFF" then
		frame.Runes: Hide()
		frame.Runes: UnregisterAllEvents()
		frame.Runes: SetScript("OnUpdate", nil)
	end
end

--- ------------------------------------------------------------
--> Load
--- ------------------------------------------------------------

local MEKA_Class = CreateFrame("Frame", "MEKA_ClassBar", E)
MEKA_Class: SetSize(202,54)
MEKA_Class: SetPoint("CENTER", UIParent, "CENTER", 0,0)
MEKA_Class.Init = false
MEKA_Class.Info = {}

local function MEKA_Class_Load()
	if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable then
		ClassPoints_Frame(MEKA_Class)
		if not F.IsClassic then
			Rune_Frame(MEKA_Class)
		end
		MEKA_Class.Init = true

		if not Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint then
			MEKA_ClassPoints_Toggle(MEKA_Class, "OFF")
		end

		if not Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Rune then
			MEKA_Class_Runes_Toggle(MEKA_Class, "ON")
		end

		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.Scale then
			MEKA_Class: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.Scale)
		end
	end
end

local function MEKA_Class_Toggle(arg1, arg2)
	if not arg2 then
		if arg1 == "ON" then
			MEKA_Class: Show()
			if not MEKA_Class.Init then
				MEKA_Class_Load()
			end
		elseif arg1 == "OFF" then
			MEKA_Class: Hide()
		elseif arg1 == "Refresh" then
			MEKA_ClassPoints_Toggle(MEKA_Class, arg1)
		elseif type(arg1) == "number" then
			MEKA_Class: SetScale(arg1)
		end
		--MEKA_Class_Point_Toggle(MEKA_Class, arg1)
		--MEKA_Class_Runes_Toggle(MEKA_Class, arg1)
	elseif arg2 == "ClassPoint" then
		MEKA_ClassPoints_Toggle(MEKA_Class, arg1)
	elseif arg2 == "Rune" then
		MEKA_Class_Runes_Toggle(MEKA_Class, arg1)
	end
end

local MEKA_Class_Config = {
	Database = {
		["MEKA_Class"] = {
			Enable = true,
			ClassPoint = true,
			Rune = true,
		},
	},

	Config = {
		Name = "MEKA "..L['CLASS'],
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable = false
				self.Text:SetText(L["OFF"])
				MEKA_Class_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable = true
				self.Text:SetText(L["ON"])
				MEKA_Class_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = {
			[1] = {
				Name = L['CLASS_POINT'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint then
						Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint = false
						self.Text:SetText(L["OFF"])
						MEKA_Class_Toggle("OFF", "ClassPoint")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint = true
						self.Text:SetText(L["ON"])
						MEKA_Class_Toggle("ON", "ClassPoint")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[2] = {
				Name = COMBAT_TEXT_RUNE_DEATH,
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Rune then
						Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Rune = false
						self.Text:SetText(L["OFF"])
						MEKA_Class_Toggle("OFF", "Rune")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Rune = true
						self.Text:SetText(L["ON"])
						MEKA_Class_Toggle("ON", "Rune")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Rune then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
		},
	},
}

local MEKA_Class_Config_Classic = {
	Database = {
		["MEKA_Class"] = {
			Enable = true,
			ClassPoint = true,
			Rune = true,
			SoulShard = true,
		},
	},

	Config = {
		Name = "MEKA "..L['CLASS'],
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable = false
				self.Text:SetText(L["OFF"])
				MEKA_Class_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable = true
				self.Text:SetText(L["ON"])
				MEKA_Class_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = {
			[1] = {
				Name = L['CLASS_POINT'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint then
						Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint = false
						self.Text:SetText(L["OFF"])
						MEKA_Class_Toggle("OFF", "ClassPoint")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint = true
						self.Text:SetText(L["ON"])
						MEKA_Class_Toggle("ON", "ClassPoint")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_Class"].ClassPoint then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[2] = {
				Name = L['SOUL_SHARD'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_Class.SoulShard then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_Class.SoulShard = false
						self.Text:SetText(L["OFF"])
						MEKA_Class_Toggle("Refresh")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_Class.SoulShard = true
						self.Text:SetText(L["ON"])
						MEKA_Class_Toggle("Refresh")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_Class.SoulShard then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
		},
	},
}

MEKA_Class.Load = MEKA_Class_Load
if F.IsClassic then
	MEKA_Class.Config = MEKA_Class_Config_Classic
else
	MEKA_Class.Config = MEKA_Class_Config
end
F.MEKA_Class_Toggle = MEKA_Class_Toggle
insert(E.Module, MEKA_Class)