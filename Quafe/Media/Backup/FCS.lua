local Crux, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

--- ------------------------------------------------------------
--> API and Variable
--- ------------------------------------------------------------

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

-- exists = tContains(table, value)

--- ------------------------------------------------------------
--> ClassPower
--- ------------------------------------------------------------

local color_Ring = function(f, color)
	f.LR.Ring: SetVertexColor(F.Color(color))
	f.RR.Ring: SetVertexColor(F.Color(color))
end

local update_Ring = function(f, d)
	if f.LR then
		if not d then d = 1 end
		d = min(max(d, 0), 1)
		if d < 0.5 then
			f.LR.Ring:SetRotation(math.rad(f.LR.Base+0))
			f.RR.Ring:SetRotation(math.rad(f.RR.Base-180*d*2))
		else
			f.LR.Ring:SetRotation(math.rad(f.LR.Base-180*(d*2-1)))
			f.RR.Ring:SetRotation(math.rad(f.RR.Base+180))
		end
	end
end

local Ring_Artwork = function(f, size)
	f.C = CreateFrame("Frame", nil, f)
	f.C: SetSize(size, size)
	f: SetScrollChild(f.C)
	
	f.Ring = f.C:CreateTexture(nil, "BACKGROUND", nil, -2)
	f.Ring: SetTexture(F.Media.."Ring16_2")
	f.Ring: SetSize(sqrt(2)*size, sqrt(2)*size)
    f.Ring: SetPoint("CENTER")
    f.Ring: SetVertexColor(F.Color(C.Color.White2))
	f.Ring: SetAlpha(0.8)
	f.Ring: SetBlendMode("BLEND")
	f.Ring: SetRotation(math.rad(f.Base+180))
end

local Create_Ring = function(f, size1, size2)
	f.RingTimer = 0
	f.RingDuration = 0
	
	local level = f:GetFrameLevel() - 1
	
	f.LR = CreateFrame("ScrollFrame", nil, f)
	f.LR: SetFrameLevel(level)
	f.LR: SetSize((size2)/2, size2)
	f.LR: SetPoint("RIGHT", f, "CENTER", 0,0)
	f.LR.Base = -180
	Ring_Artwork(f.LR, size2)
	
	f.RR = CreateFrame("ScrollFrame", nil, f)
	f.RR: SetFrameLevel(level)
	f.RR: SetSize((size2)/2, size2)
	f.RR: SetPoint("LEFT", f, "CENTER", 0,0)
	f.RR: SetHorizontalScroll((size2)/2)
	f.RR.Base = 0
	Ring_Artwork(f.RR, size2)
	
	local Bg1 = f:CreateTexture(nil, "BACKGROUND", nil, -1)
	Bg1: SetTexture(F.Media.."Ring32_Bg")
	Bg1: SetSize(size1, size1)
	Bg1: SetPoint("CENTER", f ,"CENTER", 0,0)
	Bg1: SetVertexColor(F.Color(C.Color.Black))
	
	local Bg2 = f.LR:CreateTexture(nil, "BACKGROUND", nil, -3)
	Bg2: SetTexture(F.Media.."Ring32_Bg")
	Bg2: SetSize(size1+12, size1+12)
	Bg2: SetPoint("CENTER", f ,"CENTER", 0,0)
	Bg2: SetVertexColor(F.Color(C.Color.Black))
	Bg2: SetBlendMode("BLEND")
end

local function Point_Frame(f)
	f.Point = CreateFrame("Frame", nil, f)
	f.Point: SetSize(32,32)
	f.Point: SetPoint("CENTER", UIParent, "CENTER", 0,-140)
	f.Point.max = 0
	
	f.Point: Hide()
	
	for i = 1,6 do
		f["Point"..i] = CreateFrame("Frame", nil, f.Point)
		f["Point"..i]: SetSize(16,16)
		if i == 1 then
			f["Point"..i]: SetPoint("CENTER", f.Point, "CENTER", 0,0)
		else
			f["Point"..i]: SetPoint("CENTER", f["Point"..(i-1)], "CENTER", 28,0)
		end
		
		Create_Ring(f["Point"..i], 16, 32)
		
		f["Point"..i].Bar = f["Point"..i]:CreateTexture(nil, "ARTWORK")
		f["Point"..i].Bar: SetTexture(F.Media.."Ring16_Bg")
		f["Point"..i].Bar: SetVertexColor(F.Color(C.Color.B1))
		f["Point"..i].Bar: SetSize(32,32)
		f["Point"..i].Bar: SetPoint("CENTER", f["Point"..i], "CENTER",0,0)
		f["Point"..i].Bar: SetAlpha(1)
		
		f["Point"..i].BarEx = f["Point"..i]:CreateTexture(nil, "ARTWORK")
		f["Point"..i].BarEx: SetTexture(F.Media.."Ring16_Bg2")
		f["Point"..i].BarEx: SetVertexColor(F.Color(C.Color.B1))
		f["Point"..i].BarEx: SetSize(32,32)
		f["Point"..i].BarEx: SetPoint("CENTER", f["Point"..i], "CENTER",0,0)
		f["Point"..i].BarEx: SetAlpha(0)
		
		f["Point"..i].BarBg = f["Point"..i]:CreateTexture(nil, "BACKGROUND")
		f["Point"..i].BarBg: SetTexture(F.Media.."Ring16_Bg")
		f["Point"..i].BarBg: SetVertexColor(F.Color(C.Color.White))
		f["Point"..i].BarBg: SetSize(32,32)
		f["Point"..i].BarBg: SetPoint("CENTER", f["Point"..i], "CENTER",0,0)
		f["Point"..i].BarBg: SetAlpha(0.25)
	end
end

local Point_Init_Event = {
	"PLAYER_ENTERING_WORLD",
	"PLAYER_SPECIALIZATION_CHANGED",
	"PLAYER_TALENT_UPDATE",
	"UPDATE_SHAPESHIFT_FORM",
}

local function Point_Init(f, event)
	for k,v in ipairs(Point_Init_Event) do
		if v == event then
			for i = 1,6 do
				if i <= f.Point.pmax then
					f["Point"..i]: Show()
				else
					f["Point"..i]: Hide()
				end
			end
			f.Point1: ClearAllPoints()
			f.Point1: SetPoint("CENTER", f.Point, "CENTER", -14*(f.Point.pmax-1),0)
		end
	end
	if f.Point.p and f.Point.pmax > 0 then
		for i = 1,6 do
			if i <= f.Point.p then
				f["Point"..i].Bar: SetAlpha(1)
			else
				f["Point"..i].Bar: SetAlpha(0)
			end
		end
	end
end

--- ------------------------------------------------------------
--> ClassPower Druid
--- ------------------------------------------------------------

local function Druid_Init(f, event)
	if f.Point.class == 'DRUID' then
		if event == "PLAYER_LOGIN" then
			f.Point: RegisterEvent("UPDATE_SHAPESHIFT_FORM")
		end
		if f.Point.form == CAT_FORM then
			f.Point.p = GetComboPoints("player", "target")
			f.Point.pmax = MAX_COMBO_POINTS
		end
		if f.Point.p and f.Point.p > 0 then
			f.Point: Show()
		else
			f.Point: Hide()
		end
	end
end

--- ------------------------------------------------------------
--> ClassPower Warlock
--- ------------------------------------------------------------

local DemonicTable = {
    --Regular warlock pet codes
    ["1863"] = "Succubus",
    ["416"] = "Imp",
    ["58959"] = "Imp",
    ["1860"] = "Voidwalker",
    ["58960"] = "Voidwalker",
    ["417"] = "Felhunter",
    ["17252"] = "Felguard",
    ["11859"] = "Doomguard",
    ["89"] = "Infernal",
    ["58964"] = "Observer",
    ["58963"] = "Shivarra",
    ["58965"] = "Wrathguard",
	
    --Summoned pets
    ["55659"] = {icon = GetSpellTexture(205145)},	--"Wild Imp"
    ["98035"] = {icon = GetSpellTexture(104316)},	--"Dreadstalker",
    ["99737"] = {icon = GetSpellTexture(205145)},	--"Wild Imp" -- the ones on top of dreadstalkers
	["103673"] = {icon = GetSpellTexture(205180)},	-- Darkglare
    --Doomguard and infernal should be the same
}

local function Warlock_Init(f, event)
	if f.Point.class == 'WARLOCK' then
		if event == "PLAYER_LOGIN" then
			f.Point: RegisterEvent("SPELLS_CHANGED")
			f.Point: RegisterUnitEvent("UNIT_MAXPOWER", "player")
			f.Point: RegisterEvent("PLAYER_TOTEM_UPDATE")
		end
		
		if f.Point.specID == 3 then
			f.Point.p = UnitPower("player", SPELL_POWER_SOUL_SHARDS, true)/10
			f.Point.pmax = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS, true)/10
		else
			f.Point.p = UnitPower("player", SPELL_POWER_SOUL_SHARDS)
			f.Point.pmax = UnitPowerMax("player", SPELL_POWER_SOUL_SHARDS)
		end
		
		if f.Point.specID == 2 then -->Demonology
			f.Point.Demon = {}
			local priorities = STANDARD_TOTEM_PRIORITIES
			for i = 1, MAX_TOTEMS do
				f.Point.Demon[i] = {timer = 0, duration = 0, color = C.Color.White2}
				local slot = priorities[i]
				local haveTotem, name, startTime, duration, icon = GetTotemInfo(i)
				if haveTotem then
					f.Point.Demon[i].timer = max(GetTime() - startTime, 0)
					f.Point.Demon[i].duration = duration
					if icon == 1378282 then
						f.Point.Demon[i].color = C.Color.Green
					else
						f.Point.Demon[i].color = C.Color.Yellow
					end
				end
			end
			if f.Point.Demon[1] then
				table.sort(f.Point.Demon, function(v1,v2) return v1.timer > v2.timer end)
			end
		end
		if UnitAffectingCombat("player") or f.Point.p ~= 3 then
			f.Point: Show()
		else
			f.Point: Hide()
		end
	end
end

local function Warlock_Update(f, elapsed)
	if f.Point.class == 'WARLOCK' then
		if f.Point.specID == 2 then -->¶ñÄ§
			for i = 1, MAX_TOTEMS do
				if f.Point.Demon[i].timer > 0 then
					f.Point.Demon[i].timer = min(f.Point.Demon[i].timer + elapsed, f.Point.Demon[i].duration)
					update_Ring(f["Point"..i], (f.Point.Demon[i].duration-f.Point.Demon[i].timer)/f.Point.Demon[i].duration)
					color_Ring(f["Point"..i], f.Point.Demon[i].color)
				else
					update_Ring(f["Point"..i], 1)
					color_Ring(f["Point"..i], C.Color.White2)
				end
			end
		end
	end
end

--- ------------------------------------------------------------
--> ClassPower Deathknight
--- ------------------------------------------------------------

local function Deathknight_Init(f, event)
	if f.Point.class == 'DEATHKNIGHT' then
		if event == "PLAYER_LOGIN" then
			f.Point: RegisterEvent("RUNE_POWER_UPDATE")
			f.Point: RegisterEvent("RUNE_TYPE_UPDATE")
		end
		f.Point.Rune = {}
		for i = 1,6 do
			f.Point.Rune[i] = {start = 0, timer = 0, duration = 0, ready = 0}
		end
		local rune = 0
		for i = 1,6 do
			local start, duration, runeReady = GetRuneCooldown(i)
			if runeReady then
				rune = rune + 1
			end
			if f.Point.Rune then
				f.Point.Rune[i].start = start or 0
				f.Point.Rune[i].duration = duration
				f.Point.Rune[i].ready = runeReady
				if f.Point.Rune[i].ready then
					f.Point.Rune[i].timer = f.Point.Rune[i].duration
				else
					f.Point.Rune[i].timer = GetTime() - f.Point.Rune[i].start
				end
			end
		end
		f.Point.p = rune
		f.Point.pmax = 6
		table.sort(f.Point.Rune, function(v1,v2) return v1.timer > v2.timer end)
		if UnitAffectingCombat("player") or f.Point.p ~= 6 then
			f.Point: Show()
		else
			f.Point: Hide()
		end
	end
end

local function Deathknight_Update(f, elapsed)
	if f.Point.class == 'DEATHKNIGHT' then
		for i = 1, 6 do
			if f.Point.Rune[i].ready then
				update_Ring(f["Point"..i], 1)
				color_Ring(f["Point"..i], C.Color.White2)
			else
				f.Point.Rune[i].timer = min(f.Point.Rune[i].timer + elapsed, f.Point.Rune[i].duration)
				update_Ring(f["Point"..i], f.Point.Rune[i].timer/f.Point.Rune[i].duration)
				color_Ring(f["Point"..i], C.Color.B1)
			end
		end
	end
end

--- ------------------------------------------------------------
--> ClassPower Monk
--- ------------------------------------------------------------

local function MonkStagger_UpdateMaxValue(f)
	local maxHealth = UnitHealthMax("player");
	f.maxValue = maxHealth
end

local function MonkStagger_UpdateValue(f)
	local damage = UnitStagger("player")
	if (not damage) then
		return;
	end
	f.Value = damage
	MonkStagger_UpdateMaxValue(f)
	
	f.Percent = f.Value/f.maxValue
	f.Bar: SetSize(100*f.Percent+F.Debug, 16)
	f.Bar: SetTexCoord(14/128,(14+100*f.Percent)/128, 8/32,24/32)
	f.Text: SetText(F.FormatNum(f.Value))
	
	if (f.Percent > STAGGER_YELLOW_TRANSITION and f.Percent < STAGGER_RED_TRANSITION) then
		
	elseif (f.Percent > STAGGER_RED_TRANSITION) then
		
	else
		
	end
	
	if (f.Value and f.Value > 0) then
		f: Show()
	else
		f: Hide()
	end
end

local function MonkStagger_OnUpdate(f)
	MonkStagger_UpdateValue(f)
	if f.pauseUpdate == false then
		C_Timer.After(0.05, function(self) MonkStagger_OnUpdate(f) end)
	end
end

local function MonkStagger_UpdatePowerType(f)
	if (f.class == 'MONK') and (f.specID == SPEC_MONK_BREWMASTER) and (not UnitHasVehiclePlayerFrameUI("player")) then
		if f.Stagger.pauseUpdate == true then
			f.Stagger.pauseUpdate = false
			MonkStagger_OnUpdate(f.Stagger)
		end
	else
		f.Stagger.pauseUpdate = true
		f.Stagger: Hide()
	end
end

local function MonkStagger_Event(f, event, arg1)
	if ( event == "UNIT_DISPLAYPOWER" or event == "UPDATE_VEHICLE_ACTIONBAR" or event == "UNIT_EXITED_VEHICLE" ) then
		MonkStagger_UpdatePowerType(f)
	elseif ( event == "PLAYER_SPECIALIZATION_CHANGED" ) then
		if ( arg1 == nil or arg1 == "player") then
			MonkStagger_UpdatePowerType(f)
		end
	elseif ( event == "PLAYER_ENTERING_WORLD" ) then
		MonkStagger_UpdatePowerType(f)
	end
end

local function MonkStagger_OnEvent(f)
	f.Stagger: RegisterEvent("PLAYER_ENTERING_WORLD")
	f.Stagger: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	f.Stagger: RegisterEvent("UNIT_DISPLAYPOWER")
	f.Stagger: RegisterEvent("UPDATE_VEHICLE_ACTIONBAR")
	f.Stagger: RegisterEvent("UNIT_EXITED_VEHICLE")
	f.Stagger: SetScript("OnEvent", function(self, event, arg1)
		MonkStagger_Event(f, event, arg1)
	end)
end

local function MonkStagger_Artwork(f)
	f.Bar = F.create_Texture(f, "ARTWORK", "Stagger_Bar1", C.Color.G1)
	f.Bar: SetSize(100,16)
	f.Bar: SetTexCoord(14/128,114/128, 8/32,24/32)
	f.Bar: SetPoint("LEFT", f, "LEFT", 0,0)
	
	f.Border = F.create_Texture(f, "ARTWORK", "Stagger_Border1", C.Color.B1)
	f.Border: SetSize(110,26)
	f.Border: SetTexCoord(9/128,119/128, 3/32,29/32)
	f.Border: SetPoint("CENTER", f, "CENTER", 0,0)
	
	f.Bg = F.create_Texture(f, "BACKGROUND", "Stagger_Bg1", C.Color.W1, 0.75)
	f.Bg: SetSize(110,26)
	f.Bg: SetTexCoord(9/128,119/128, 3/32,29/32)
	f.Bg: SetPoint("CENTER", f, "CENTER", 0,0)
	
	f.Text = F.create_Font(f, C.Font.Num, 12, nil, 1, "CENTER", "CENTER")
	f.Text: SetPoint("CENTER", f, "CENTER", 0,0)
end

local function MonkStagger_Init(f)
	f.Stagger = CreateFrame("Frame", nil, f)
	f.Stagger: SetSize(100,16)
	f.Stagger: SetPoint("CENTER", f, "CENTER", 0,0)
	f.Stagger.pauseUpdate = true
	f.Stagger: Hide()
	
	MonkStagger_Artwork(f.Stagger)
	MonkStagger_OnEvent(f)
end

local function Monk_Init(f, event)
	if (f.Point.class == 'MONK') then
		if event == "PLAYER_LOGIN" then
			f.Point: RegisterUnitEvent("UNIT_MAXPOWER", "player")	
			table.insert(Point_Init_Event, "UNIT_MAXPOWER")		
			MonkStagger_Init(f.Point)
		end
		if (f.Point.specID == SPEC_MONK_WINDWALKER) then 
			f.Point.p = UnitPower("player", SPELL_POWER_CHI)
			f.Point.pmax = UnitPowerMax("player", SPELL_POWER_CHI)
			if UnitAffectingCombat("player") or f.Point.p ~= 0 then
				f.Point: Show()
			else
				f.Point: Hide()
			end
		end
		if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" or event == "UNIT_ENTERED_VEHICLE" or event == "UNIT_EXITED_VEHICLE" then
			if (f.Point.specID == SPEC_MONK_BREWMASTER) then
				if not f.Point:IsShown() then
					f.Point: Show()
				end
			end
		end
	end
end

local function Monk_Update(f, elapsed)
	if f.Point.class == 'Monk' then
		
	end
end

----------------------------------------------------------------
-- ClassPower Update
----------------------------------------------------------------

local function Point_Event(f, event)
	f.Point.class = select(2, UnitClass("player"))
	f.Point.specID = GetSpecialization()
	f.Point.form = GetShapeshiftFormID()
	f.Point.pmax = 0
	f.Point.p = nil
	
	if UnitInVehicle("player") then
		f.Point.p = GetComboPoints("vehicle", "target")
		f.Point.pmax = MAX_COMBO_POINTS
	else
		Warlock_Init(f, event)
		Druid_Init(f, event)
		Deathknight_Init(f, event)
		Monk_Init(f, event)
	end
	Point_Init(f, event)
end

local function Point_OnEvent(f)
	local event = {
		"PLAYER_LOGIN",
		"PLAYER_ENTERING_WORLD",
		
		"PLAYER_SPECIALIZATION_CHANGED",
		"PLAYER_TALENT_UPDATE",
		
		"UPDATE_VEHICLE_ACTIONBAR",
		"UNIT_ENTERED_VEHICLE",
		"UNIT_EXITED_VEHICLE",
		
		"UNIT_COMBO_POINTS",
		
		"PLAYER_TARGET_CHANGED",
		"UNIT_POWER",
		
		"PLAYER_REGEN_DISABLED",
		"PLAYER_REGEN_ENABLED",
	}
	F.rEvent(f.Point, event)
	f.Point: SetScript("OnEvent", function(self, event)
		Point_Event(f, event)
	end)
end

local function Point_OuUpdate(f)
	f.Point: SetScript("OnUpdate", function(self, elapsed)
		Warlock_Update(f, elapsed)
		Deathknight_Update(f, elapsed)
	end)
end

--- ------------------------------------------------------------
--> End
--- ------------------------------------------------------------







--- ------------------------------------------------------------
--> Watcher
--- ------------------------------------------------------------

local GCD = select(2,GetSpellCooldown(61304))
local UnitList = {}
local AuraFilter = {}
local WatcherNum = {
	["Bar"] = 5,
	["Count"] = 3,
	["Icon"] = 4,
	["BarNum"] = 0,
	["CountNum"] = 0,
	["IconNum"] = 0,
}

local function Pita_Bar1(f, p, angle)
	f: SetPoint("CENTER", p, "CENTER", 275*cos(rad(angle)), 275*sin(rad(angle)))
	
	f.Bg = f:CreateTexture(nil, "BACKGROUND")
	f.Bg: SetTexture(F.Media.."Pita_Bar\\Pita_Bar_72")
	f.Bg: SetVertexColor(F.Color(C.Color.B1))
	f.Bg: SetAlpha(0.2)
	f.Bg: SetSize(128,128)
	f.Bg: SetPoint("CENTER", f, "CENTER", 0,0)
	F.RotateTexture(f.Bg, angle)
	
	f.Bar = f:CreateTexture(nil, "ARTWORK")
	f.Bar: SetTexture(F.Media.."Pita_Bar\\Pita_Bar_72")
	f.Bar: SetVertexColor(F.Color(C.Color.B1))
	f.Bar: SetAlpha(0)
	f.Bar: SetSize(128,128)
	f.Bar: SetPoint("CENTER", f, "CENTER", 0,0)
	F.RotateTexture(f.Bar, angle)
	
	f.Num = {}
	for i = 1,3 do
		f.Num[i] = f:CreateTexture(nil, "OVERLAY")
		f.Num[i]: SetTexture(F.Media.."N12\\N".."9")
		f.Num[i]: SetVertexColor(F.Color(C.Color.B1))
		f.Num[i]: SetAlpha(0)
		f.Num[i]: SetSize(32,32)
		F.RotateTexture(f.Num[i], angle)
	end
	
	f.Count = {}
	for i = 1,2 do
		f.Count[i] = f:CreateTexture(nil, "OVERLAY")
		f.Count[i]: SetTexture(F.Media.."N12\\N".."9")
		f.Count[i]: SetVertexColor(F.Color(C.Color.B1))
		f.Count[i]: SetAlpha(0)
		f.Count[i]: SetSize(32,32)
		F.RotateTexture(f.Count[i], angle)
	end
end

local function Ring_Bar1(f, p, angle)
	f: SetPoint("CENTER", p, "CENTER", 255*cos(rad(angle)), 255*sin(rad(angle)))
	
	f.Bg = f:CreateTexture(nil, "BACKGROUND")
	f.Bg: SetTexture(F.Media.."HUD_Ring_BarBg")
	f.Bg: SetVertexColor(F.Color(C.Color.W1))
	f.Bg: SetAlpha(0.2)
	f.Bg: SetSize(64,64)
	f.Bg: SetPoint("CENTER", f, "CENTER", 0,0)
	F.RotateTexture(f.Bg, angle)
	
	f.BarBg = f:CreateTexture(nil, "BACKGROUND")
	f.BarBg: SetTexture(F.Media.."Ring_Bar\\Ring_Bar_36")
	f.BarBg: SetVertexColor(F.Color(C.Color.W1))
	f.BarBg: SetAlpha(0.2)
	f.BarBg: SetSize(64,64)
	f.BarBg: SetPoint("CENTER", p, "CENTER", 278*cos(rad(angle)), 278*sin(rad(angle)))
	F.RotateTexture(f.BarBg, angle)
	
	f.Bar = f:CreateTexture(nil, "ARTWORK")
	f.Bar: SetTexture(F.Media.."Ring_Bar\\Ring_Bar_36")
	f.Bar: SetVertexColor(F.Color(C.Color.B1))
	f.Bar: SetAlpha(0.9)
	f.Bar: SetSize(64,64)
	f.Bar: SetPoint("CENTER", p, "CENTER", 278*cos(rad(angle)), 278*sin(rad(angle)))
	F.RotateTexture(f.Bar, angle)
	
	f.Count = {}
	for i = 1,3 do
		f.Count[i] = f:CreateTexture(nil, "OVERLAY")
		f.Count[i]: SetTexture(F.Media.."N16\\N".."9")
		f.Count[i]: SetVertexColor(F.Color(C.Color.B1))
		f.Count[i]: SetAlpha(0)
		f.Count[i]: SetSize(32,32)
		F.RotateTexture(f.Count[i], angle)
	end
end

local function Icon_Bar1(f, p, i)
	f.Icon = F.create_Texture(f, "BACKGROUND", nil, nil, 1)
	f.Icon: SetDesaturated(true)
	f.Icon: SetSize(36,30)
	f.Icon: SetPoint("CENTER", f, "CENTER", 0,0)
	
	f.IconBg = F.create_Texture(f, "BORDER", "White", C.Color.B1, 0.6)
	f.IconBg: SetSize(36,30)
	f.IconBg: SetPoint("CENTER", f, "CENTER", 0,0)
	
	f.Mana = F.create_Texture(f, "OVERLAY", "Icons\\Mana16", C.Color.Y1, 1)
	f.Mana: SetSize(16,16)
	f.Mana: SetPoint("CENTER", f, "CENTER", -1,0)
	f.Mana: Hide()
	
	f.ManaBg = F.create_Texture(f, "ARTWORK", "Icons\\Mana16", C.Color.W1, 1)
	f.ManaBg: SetSize(16,16)
	f.ManaBg: SetPoint("CENTER", f.Mana, "CENTER", 1.5,-1)
	f.ManaBg: Hide()
	
	f.Forbid = F.create_Texture(f, "OVERLAY", "Icons\\Forbid16", C.Color.Y1, 1)
	f.Forbid: SetSize(16,16)
	f.Forbid: SetPoint("CENTER", f, "CENTER", -1,0)
	f.Forbid: Hide()
	
	f.ForbidBg = F.create_Texture(f, "ARTWORK", "Icons\\Forbid16", C.Color.W1, 1)
	f.ForbidBg: SetSize(16,16)
	f.ForbidBg: SetPoint("CENTER", f.Forbid, "CENTER", 1.5,-1)
	f.ForbidBg: Hide()
	
	local Bar = CreateFrame("StatusBar", nil, f)
	Bar: SetStatusBarTexture(F.Media.."StatusBar\\Flat") 
	--Bar: SetStatusBarColor(r, g, b[, alpha])
	Bar: SetOrientation("HORIZONTAL")
	--Bar: SetRotatesTexture(true)
	Bar: SetSize(36,4)
	Bar: SetPoint("BOTTOM", f.IconBg, "TOP", 0, 2)
	Bar: SetMinMaxValues(0, 1)
	Bar: SetValue(1)
	f.Bar = Bar
	
	f.BarBg = F.create_Texture(f, "BACKGROUND", "StatusBar\\Flat", C.Color.W1, 0.6)
	f.BarBg: SetSize(36,4)
	f.BarBg: SetPoint("BOTTOM", f.IconBg, "TOP", 0, 2)
	
	f.Cooldown = F.create_Font(f, C.Font.NumSmall, 14, nil, 1, "CENTER", "CENTER")
	f.Cooldown: SetPoint("CENTER", f, "CENTER", 0,0)
	f.Cooldown: SetTextColor(F.Color(C.Color.Y1))
	
	f.Count = F.create_Font(f, C.Font.Num, 14, nil, 1, "CENTER", "CENTER")
	f.Count: SetPoint("TOP", f.Icon, "BOTTOM", 0,-1)
	f.Count: SetTextColor(F.Color(C.Color.Y1))
end

local function Num12_Rotate(f, p, angle, numrotate)
	for i = 1, #f.Num do
		if numrotate then
			F.RotateTexture(f.Num[i], 180+angle)
			f.Num[i]: SetPoint("CENTER", p, "CENTER", (313+8*i)*cos(rad(angle)), (313+8*i)*sin(rad(angle)))
		else
			F.RotateTexture(f.Num[i], angle)
			f.Num[i]: SetPoint("CENTER", p, "CENTER", (313+8*i)*cos(rad(angle)), (313+8*i)*sin(rad(angle)))
		end
	end
	for i = 1, #f.Count do
		if numrotate then
			F.RotateTexture(f.Count[i], 180+angle)
			f.Count[i]: SetPoint("CENTER", p, "CENTER", (239-8*i)*cos(rad(angle)), (239-8*i)*sin(rad(angle)))
		else
			F.RotateTexture(f.Count[i], angle)
			f.Count[i]: SetPoint("CENTER", p, "CENTER", (239-8*i)*cos(rad(angle)), (239-8*i)*sin(rad(angle)))
		end
	end
end

local function Num16_Rotate(f, p, angle, radius, numrotate)
	for i = 1, #f.Count do
		if numrotate then
			F.RotateTexture(f.Count[i], 180+angle)
			f.Count[i]: SetPoint("CENTER", p, "CENTER", (radius+10*(2-i))*cos(rad(angle)), (radius+10*(2-i))*sin(rad(angle)))
		else
			F.RotateTexture(f.Count[i], angle)
			f.Count[i]: SetPoint("CENTER", p, "CENTER", (radius+10*(i-1))*cos(rad(angle)), (radius+10*(i-1))*sin(rad(angle)))
		end
	end
	if f.Count[3] then
		if numrotate then
			F.RotateTexture(f.Count[3], 180+angle)
			f.Count[3]: SetPoint("CENTER", p, "CENTER", (radius+5)*cos(rad(angle+0.2)), (radius+5)*sin(rad(angle+0.2)))
		else
			F.RotateTexture(f.Count[3], angle)
			f.Count[3]: SetPoint("CENTER", p, "CENTER", (radius+5)*cos(rad(angle)), (radius+5)*sin(rad(angle)))
		end
	end
end

local function Watcher_Bar_Create(f, i)
	local button = CreateFrame("Frame", "Watcher.Bar.Button"..i, f)
	button: SetSize(12, 12)
	Pita_Bar1(button, f, (-20-4.5*i))
	Num12_Rotate(button, f, (-20-4.5*i), false)
	return button
end

local function Watcher_Count_Create(f, i)
	local button = CreateFrame("Frame", "Watcher.Count.Button"..i, f)
	button: SetSize(12, 12)
	Ring_Bar1(button, f, (-160+8.5*(i)))
	Num16_Rotate(button, f, (-160+8.5*(i)), 250, true)
	return button
end

local function Watcher_Icon_Create(f, i)
	local button = CreateFrame("Frame", "Watcher.Icon.Button"..i, f)
	button: SetSize(12, 12)
	Icon_Bar1(button, f, i)
	if i <= 2 then
		button: SetPoint("CENTER", f, "CENTER", -164+(i-1)*40, -100)
	elseif i <= 4 then
		button: SetPoint("CENTER", f, "CENTER", 124+(i-3)*40, -100)
	end
	return button
end

local function Watcher_ColorButton(f, style, color)
	if style == "Bar" then
		f.Bar: SetVertexColor(F.Color(color))
	elseif style == "Count" then
		f.Bar: SetVertexColor(F.Color(color))
	elseif style == "Icon" then
		f.Bar: SetStatusBarColor(F.Color(color))
	end
end

local function Watcher_RenewButton(f, All)
	if All then
		--> Aura
		f.AuraID = nil
		f.AuraName = nil
		f.Unit = nil
		--> Spell
		f.SpellID = nil
		--> Button
		f:SetAlpha(0)
	end
	--> Aura
	f.Exist = nil
	f.AuraCount = 0
	f.AuraNum = 0
	f.Expires = 0
	f.Duration = 0
	f.AuraRemain = 0
	--> Spell
	f.Usable = false
	f.SpellCharge = 0
	f.MaxCharge = 0
	f.Start = 0
	f.CD = 0
	f.SpellRemain = 0
	-->
	f.SpecCount = 0
end

local function Watcher_NewButton(f, style, i)
	if i > #f[style] and (not f[style][i]) then
		if style == "Bar" then
			f[style][i] = Watcher_Bar_Create(f, i)
		elseif style == "Count" then
			f[style][i] = Watcher_Count_Create(f, i)
		elseif style == "Icon" then
			f[style][i] = Watcher_Icon_Create(f, i)
		end
		f[style][i].Style = style
	end
end

local function Watcher_ResetButton(f, filter)
	local num = {
		["Bar"] = 1,
		["Count"] = 1,
		["Icon"] = 1,
	}
	wipe(UnitList)
	for i = 1, 6 do
		if f.Bar[i] then
			Watcher_RenewButton(f.Bar[i], true)
		end
		if f.Count[i] then
			Watcher_RenewButton(f.Count[i], true)
		end
		if f.Icon[i] then
			Watcher_RenewButton(f.Icon[i], true)
		end
	end
	
	for k, v in pairs(filter) do
		if v and v.Show and num[v.Style] <= WatcherNum[v.Style] then
			if v.Type == "Spell" then
				local name, rank, fileID, castTime, minRange, maxRange, spellID = GetSpellInfo(v.Spell)
				if GetSpellInfo(name) then
					Watcher_NewButton(f, v.Style, num[v.Style])
					--Watcher_RenewButton(f[v.Style][num[v.Style]], true)
					f[v.Style][num[v.Style]].Type = v.Type
					--if spellID then
						--f[v.Style][num[v.Style]].SpellID = spellID
					--else
						f[v.Style][num[v.Style]].SpellID = name
					--end
					f[v.Style][num[v.Style]]: SetAlpha(1)
					if v.Color then
						Watcher_ColorButton(f[v.Style][num[v.Style]], v.Style, v.Color)
					end
					if v.Style == "Icon" then
						f[v.Style][num[v.Style]].Icon: SetTexture(fileID)
					end
					num[v.Style] = num[v.Style] + 1
				end
			elseif v.Type == "Aura" then
				Watcher_NewButton(f, v.Style, num[v.Style])
				--Watcher_RenewButton(f[v.Style][num[v.Style]], true)
				f[v.Style][num[v.Style]].Type = v.Type
				if tonumber(v.Aura) then
					f[v.Style][num[v.Style]].AuraID = v.Aura
					if Crux_DB.AuraList then
						if Crux_DB.AuraList[v.Aura] then
							if Crux_DB.AuraList[v.Aura].Name then
								f[v.Style][num[v.Style]].AuraName = Crux_DB.AuraList[v.Aura].Name
							else
								F.Watcher_AddFindAura(f, v.Unit)
							end
						else
							Crux_DB.AuraList[v.Aura] = {["Name"] = false}
							F.Watcher_AddFindAura(f, v.Unit)
						end
					end
				else
					f[v.Style][num[v.Style]].AuraName = v.Aura
				end
				f[v.Style][num[v.Style]].Unit = v.Unit
				if not tContains(UnitList, v.Unit) then
					tinsert(UnitList, v.Unit)
				end
				if v.Filter == "Buff" then
					f[v.Style][num[v.Style]].AuraFilter = "HELPFUL"
				elseif v.Filter == "Debuff" then
					f[v.Style][num[v.Style]].AuraFilter = "HARMFUL"
				end
				f[v.Style][num[v.Style]]: SetAlpha(1)
				if v.Color then
					Watcher_ColorButton(f[v.Style][num[v.Style]], v.Style, v.Color)
				end
				num[v.Style] = num[v.Style] + 1
			end
		end
	end
end

local function Watcher_Reset(f)
	AuraFilter = C.WatcherFilter
	local classFileName = select(2, UnitClass("player"))
	local specID = GetSpecialization()
	
	if classFileName and specID then
		if AuraFilter[classFileName] and AuraFilter[classFileName][specID] then
			Watcher_ResetButton(f, AuraFilter[classFileName][specID])
			WatcherNum.BarNum = #f.Bar or 0
			WatcherNum.CountNum = #f.Count or 0
			WatcherNum.IconNum = #f.Icon or 0
		end
	end
end

local function Watcher_AddResetButton(f, filter)
	local num = {
		["Bar"] = 1,
		["Count"] = 1,
		["Icon"] = 1,
	}
	
	for k, v in pairs(filter) do
		if v and v.Show and num[v.Style] <= WatcherNum[v.Style] then
			if v.Type == "Spell" then
				local name, rank, fileID, castTime, minRange, maxRange, spellID = GetSpellInfo(v.Spell)
				if GetSpellInfo(name) then
					num[v.Style] = num[v.Style] + 1
				end
			elseif v.Type == "Aura" then
				if tonumber(v.Aura) then
					if Crux_DB.AuraList then
						if Crux_DB.AuraList[v.Aura] then
							if Crux_DB.AuraList[v.Aura].Name then
								f[v.Style][num[v.Style]].AuraName = Crux_DB.AuraList[v.Aura].Name
							end
						end
					end
				end
				num[v.Style] = num[v.Style] + 1
			end
		end
	end
end

local function Watcher_AddReset(f)
	local classFileName = select(2, UnitClass("player"))
	local specID = GetSpecialization()
	if classFileName and specID then
		if AuraFilter[classFileName] and AuraFilter[classFileName][specID] then
			Watcher_AddResetButton(f, AuraFilter[classFileName][specID])
		end
	end
end

local function Watcher_BarUpdate(f, d, show)
	if (not d) or d < 0 then d = 0 end
	if d > 1 then d = 1 end
	if f.Style == "Bar" then
		if d > 0 then
			f.Bar: SetAlpha(1)
			f.Bg: SetAlpha(0.6)
		else
			f.Bar: SetAlpha(0)
			f.Bg: SetAlpha(0.2)
		end
		d = floor(31*d + 0.5) * 2
		f.Bar: SetTexture(F.Media.."Pita_Bar\\Pita_Bar_"..d)
	elseif f.Style == "Count" then
		if d > 0 or show then
			f.Bar: SetAlpha(1)
			f.BarBg: SetAlpha(0.6)
			f.Bg: SetAlpha(0.6)
		else
			f.Bar: SetAlpha(0)
			f.BarBg: SetAlpha(0.2)
			f.Bg: SetAlpha(0)
		end
		d = floor(36*d + 0.5)
		f.Bar: SetTexture(F.Media.."Ring_Bar\\Ring_Bar_"..d)
	elseif f.Style == "Icon" then
		if d > 0 then
			f.Icon: SetAlpha(0.5)
			f.IconBg: SetAlpha(0.3)
			--f.Icon: SetDesaturated(true)
			f.Bar: SetAlpha(1)
			f.BarBg: SetAlpha(0.6)
		else
			f.Icon: SetAlpha(1)
			f.IconBg: SetAlpha(0.6)
			--f.Icon: SetDesaturated(false)
			f.Bar: SetAlpha(0)
			f.BarBg: SetAlpha(0)
		end
		f.Bar: SetValue(d)
	end
end

local function Watcher_NumUpdate(f, value)
	if f.Style == "Bar" then
		local v1, v2, v3 = 0, 0, 0
		if not value then
			value = 0
		elseif value > 999 then
			value = 999
		end
		
		v1 = max(floor(value/100), 0)
		v2 = max(floor(value/10) - floor(value/100)*10, 0)
		v3 = max(floor(value) - floor(value/10)*10, 0)
		
		if v1 == 0 and v2 == 0 then
			v1 = v3
			v2 = "p"
			v3 = max(floor(value*10) - floor(value)*10, 0)
		end
		if v1 == 0 and v2 == "p" and v3 == 0 then
			f.Num[1]: SetAlpha(0)
			f.Num[2]: SetAlpha(0)
			f.Num[3]: SetAlpha(0)
		elseif v1 == 0 and v2 ~= "p" then
			f.Num[1]: SetTexture(F.Media.."N12\\N"..v2)
			f.Num[2]: SetTexture(F.Media.."N12\\N"..v3)
			f.Num[1]: SetAlpha(1)
			f.Num[2]: SetAlpha(1)
			f.Num[3]: SetAlpha(0)
		else
			f.Num[1]: SetTexture(F.Media.."N12\\N"..v1)
			f.Num[2]: SetTexture(F.Media.."N12\\N"..v2)
			f.Num[3]: SetTexture(F.Media.."N12\\N"..v3)
			f.Num[1]: SetAlpha(1)
			f.Num[2]: SetAlpha(1)
			f.Num[3]: SetAlpha(1)
		end
	elseif f.Style == "Icon" then
		if value and value > 0 then
			f.Cooldown: SetText(F.FormatTime(value))
		else
			f.Cooldown: SetText("")
		end
	end
end

local function Watcher_CountUpdate(f, value, zero)
	if f.Style == "Bar" then
		local v1, v2 = 0, 0
		if not value then
			value = 0
		elseif value > 99 then
			value = 99
		end
		v1 = floor(value/10) - floor(value/100)*10
		v2 = floor(value) - floor(value/10)*10
		if v1 == 0 and v2 == 0 then
			f.Count[1]: SetAlpha(0)
			f.Count[2]: SetAlpha(0)
		elseif v1 == 0 then
			f.Count[1]: SetTexture(F.Media.."N12\\N"..v2)
			f.Count[1]: SetAlpha(1)
			f.Count[2]: SetAlpha(0)
		else
			f.Count[1]: SetTexture(F.Media.."N12\\N"..v2)
			f.Count[2]: SetTexture(F.Media.."N12\\N"..v1)
			f.Count[1]: SetAlpha(1)
			f.Count[2]: SetAlpha(1)
		end
	elseif f.Style == "Count" then
		local v1, v2 = 0, 0
		if not value then
			value = 0
		elseif value > 99 then
			value = 99
		end
		v1 = floor(value/10) - floor(value/100)*10
		v2 = floor(value) - floor(value/10)*10
		if v1 == 0 and v2 == 0 and (not zero) then
			f.Count[1]: SetAlpha(0)
			f.Count[2]: SetAlpha(0)
			f.Count[3]: SetAlpha(0)
		elseif v1 == 0 then
			f.Count[3]: SetTexture(F.Media.."N16\\N"..v2)
			f.Count[1]: SetAlpha(0)
			f.Count[2]: SetAlpha(0)
			f.Count[3]: SetAlpha(1)
		else
			f.Count[1]: SetTexture(F.Media.."N16\\N"..v1)
			f.Count[2]: SetTexture(F.Media.."N16\\N"..v2)
			f.Count[1]: SetAlpha(1)
			f.Count[2]: SetAlpha(1)
			f.Count[3]: SetAlpha(0)
		end
	elseif f.Style == "Icon" then
		if value and value > 0 then
			f.Count: SetText(value)
		else
			f.Count: SetText("")
		end
	end
end

local function Watcher_AuraUpdate(f)
	if f.Type == "Aura" then
		if UnitExists(f.Unit) and f.AuraName then
			local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID, canApplyAura, isBossDebuff, _, nameplateShowAll, timeMod, value1, value2, value3 = UnitAura(f.Unit, f.AuraName, nil, f.AuraFilter)
			if name and ((f.Caster == caster) or ((not f.Caster) and (caster == "player"))) then
				f.Exist = true
				local id = tostring(spellID)
				if not Crux_DB.AuraList[id] then
					Crux_DB.AuraList[id] = {}
					Crux_DB.AuraList[id].Name = name
					Crux_DB.AuraList[id].Icon = icon
				end
				f.AuraRemain = expires - GetTime()
				f.AuraCount = count
				Watcher_BarUpdate(f, ((f.AuraRemain)/(duration+F.Debug)), true)
			else
				Watcher_BarUpdate(f, 0, true)
			end
		else
			Watcher_BarUpdate(f, 0, true)
		end
		Watcher_NumUpdate(f, f.AuraRemain)
		Watcher_CountUpdate(f, f.AuraCount, true)
	end
end

local function Watcher_AuraUpdate_CountStyle(f)
	local button = f[style][i]
	local ValidCount = 0
	if (button.SpecCount >= 1) then
		ValidCount = button.SpecCount
	elseif (button.AuraCount > 1) then
		ValidCount = button.AuraCount
	elseif (button.AuraNum > 1) then
		ValidCount = button.AuraNum
	end
	Watcher_NumUpdate(button, button.AuraRemain)
	Watcher_CountUpdate(button, ValidCount, true)
end

local function Watcher_AuraUpdate_Count(f)
	for i = 1, WatcherNum.BarNum do
		Watcher_AuraUpdate_Style(f, "Bar", i, name, icon, count, duration, expires, caster, spellID)
	end
	for i = 1, WatcherNum.CountNum do
		Watcher_AuraUpdate_Style(f, "Count", i, name, icon, count, duration, expires, caster, spellID)
	end
	for i = 1, WatcherNum.IconNum do
		Watcher_AuraUpdate_Style(f, "Icon", i, name, icon, count, duration, expires, caster, spellID)
	end
end

local function Watcher_AuraUpdate_NumStyle(f, style, i, name, icon, count, duration, expires, caster, spellID)
	local button = f[style][i]
	if (button.Caster == caster) and (button.AuraID == name) or (button.AuraID == id) then
		button.Exist = true
		button.AuraRemain = expires - GetTime()
		button.AuraCount = Count
		button.AuraNum = button.AuraNum + 1
		Watcher_BarUpdate(button, ((f.AuraRemain)/(duration+F.Debug)), true)
	else
		Watcher_BarUpdate(f, 0, true)
	end
end

local function Watcher_AuraUpdate_Num(f, name, icon, count, duration, expires, caster, spellID)
	for i = 1, WatcherNum.BarNum do
		Watcher_AuraUpdate_NumStyle(f, "Bar", i, name, icon, count, duration, expires, caster, spellID)
	end
	for i = 1, WatcherNum.CountNum do
		Watcher_AuraUpdate_NumStyle(f, "Count", i, name, icon, count, duration, expires, caster, spellID)
	end
	for i = 1, WatcherNum.IconNum do
		Watcher_AuraUpdate_NumStyle(f, "Icon", i, name, icon, count, duration, expires, caster, spellID)
	end
end

local function Watcher_AuraUpdate_Index(f, unit)
	local iBuff = 1
	local b
	while (iBuff == 1) or b do
		b = false
		local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID = UnitBuff(unit, iBuff)
		if name then b = true end
		Watcher_AuraUpdate_Num(f, name, icon, count, duration, expires, caster, spellID)
		iBuff = iBuff + 1
	end

	local iDebuff = 1
	local d
	while (iDebuff == 1) or d do
		d = false
		local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID = UnitDebuff(unit, iDebuff)
		if name then d = true end
		Watcher_AuraUpdate_Num(f, name, icon, count, duration, expires, caster, spellID)
		iDebuff = iDebuff + 1
	end
end

local function Watcher_AuraUpdate_Unit(f)
	for k,v ipairs(UnitList) do
		Watcher_AuraUpdate_Index(f, v)
	end
end

local function Watcher_SpellUpdate(f)
	if f.Type == "Spell" then
		if f.SpellID then
			local isUsable, notEnoughMana = IsUsableSpell(f.SpellID)
			local start, duration, enabled = GetSpellCooldown(f.SpellID)
			local charges, maxCharges, chargeStart, chargeDuration = GetSpellCharges(f.SpellID)
			if maxCharges and maxCharges <= 1 then charges = 0 end
			if charges and charges >= 1 then
				f.Start = chargeStart or 0
				f.CD = chargeDuration or 0
			else
				f.Start = start or 0
				f.CD = duration or 0
			end
			if f.Start ~= 0 then
				f.SpellRemain = max(f.CD + f.Start - GetTime(), 0)
			end
			f.SpellCharge = charges
			if f.Style == "Icon" then
				f.Mana: Hide()
				f.ManaBg: Hide()
				f.Forbid: Hide()
				f.ForbidBg: Hide()
			end
			if (f.CD > GCD) and (f.SpellRemain >= 0) and ((f.CD - f.SpellRemain) >= 0) then
				Watcher_BarUpdate(f, (f.CD-f.SpellRemain)/(f.CD+F.Debug), true)
				Watcher_NumUpdate(f, f.SpellRemain)
			elseif (f.Style == "Icon") and (f.SpellRemain >= 0) and ((f.CD - f.SpellRemain) >= 0) then
				Watcher_BarUpdate(f, (f.CD-f.SpellRemain)/(f.CD+F.Debug), true)
				Watcher_NumUpdate(f, 0)
			else
				Watcher_BarUpdate(f, 0, true)
				Watcher_NumUpdate(f, 0)
				if f.Style == "Icon" then
					if notEnoughMana then
						f.Mana: Show()
						f.ManaBg: Show()
					else
						if IsSpellInRange(f.SpellID, "target") == 0 then
							f.Forbid: Show()
							f.ForbidBg: Show()
						end
					end
				end
			end
			Watcher_CountUpdate(f, f.SpellCharge, true)
		end
	end
end

local function Watcher_Update(f)
	GCD = select(2,GetSpellCooldown(61304))
	local num = 0
	if WatcherNum.BarNum > 0 then
		for i = 1, WatcherNum.BarNum do
			Watcher_RenewButton(f["Bar"][i])
			Watcher_AuraUpdate(f["Bar"][i])
			Watcher_SpellUpdate(f["Bar"][i])
			if f.Bar[i].Exist or ((f.Bar[i].CD > GCD) and (f.Bar[i].CD - f.Bar[i].SpellRemain >= 0)) then
				num = num + 1
			end
		end
	end
	if WatcherNum.CountNum > 0 then
		for i = 1, WatcherNum.CountNum do
			Watcher_RenewButton(f.Count[i])
			Watcher_AuraUpdate(f.Count[i])
			Watcher_SpellUpdate(f.Count[i])
			if f.Count[i].Exist or ((f.Count[i].CD > GCD) and (f.Count[i].CD - f.Count[i].SpellRemain >= 0)) then
				num = num + 1
			end
		end
	end
	if WatcherNum.IconNum > 0 then
		for i = 1, WatcherNum.IconNum do
			Watcher_RenewButton(f.Icon[i])
			Watcher_AuraUpdate(f.Icon[i])
			Watcher_SpellUpdate(f.Icon[i])
			if f.Icon[i].Exist or ((f.Icon[i].CD > GCD) and (f.Icon[i].CD - f.Icon[i].SpellRemain >= 0)) then
				num = num + 1
			end
		end
	end
	if num > 0 then
		f:Show()
	else
		f:Hide()
	end
	C_Timer.After(0.1, function(self) Watcher_Update(f) end)
end

local function Watcher_Register(f)
	f: RegisterEvent("PLAYER_LOGIN")
	f: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	f: SetScript("OnEvent", function(self, event, ...)
		Watcher_Reset(self)
		if event == "PLAYER_LOGIN" then
			Watcher_Update(self)
		end
	end)
end

local function Watcher_Frame(f)
	f.Watcher = CreateFrame("Frame", nil, f)
	f.Watcher: SetSize(12, 12)
	f.Watcher: SetPoint("CENTER", f, "CENTER", 0,0)
	
	f.Watcher["Bar"] = {}
	f.Watcher["Count"] = {}
	f.Watcher["Icon"] = {}
	
	--Watcher_Bar(f.Watcher)
	Watcher_Register(f.Watcher)
end

--- ------------------------------------------------------------
--> AuraList
--- ------------------------------------------------------------

local function AuraList_Init()
	if not Crux_DB then 
		Crux_DB = {}
	end
	if not Crux_DB.AuraList then
		Crux_DB.AuraList = {}
	end
	if not Crux_DB.AuraToGet then
		Crux_DB.AuraToGet = 0
	end
	local toget = 0
	for k, v in pairs(Crux_DB.AuraList) do
		if not v.Name then
			toget = toget + 1
		end
	end
	Crux_DB.AuraToGet = toget
end

local function GetAura(f, unit)
	local index = 1
	local n
	while (index == 1) or n do
		n = false
		local name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID
		
		name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID = UnitBuff(unit, index)
		if name then 
			n = true
		end
		local id = tostring(spellID)
		if Crux_DB.AuraList[id] then
			if not Crux_DB.AuraList[id].Name then
				Crux_DB.AuraList[id].Name = name
				Crux_DB.AuraList[id].Icon = icon
				Crux_DB.AuraToGet = Crux_DB.AuraToGet - 1
				Watcher_AddReset(f)
				if Crux_DB.AuraToGet <= 0 then
					--return
				end
			end
		end
		
		name, rank, icon, count, dispelType, duration, expires, caster, isStealable, nameplateShowPersonal, spellID = UnitDebuff(unit, index)
		if name then 
			n = true
		end
		local id = tostring(spellID)
		if Crux_DB.AuraList[id] then
			if not Crux_DB.AuraList[id].Name then
				Crux_DB.AuraList[id].Name = name
				Crux_DB.AuraList[id].Icon = icon
				Crux_DB.AuraToGet = Crux_DB.AuraToGet - 1
				Watcher_AddReset(f)
				if Crux_DB.AuraToGet <= 0 then
					--return
				end
			end
		end
		
		index = index + 1
	end
	
	if Crux_DB.AuraToGet > 0 then
		C_Timer.After(1, function(self) GetAura(f, unit) end)
	end
end

local function AddFindAura(f, unit)
	AuraList_Init()
	GetAura(f, unit)
end
F.Watcher_AddFindAura = AddFindAura

----------------------------------------------------------------
-- FCS
----------------------------------------------------------------

function F.FCS_Load(f)
	f.FCS = CreateFrame("Frame", nil, f)
	f.FCS: SetSize(12,12)
	f.FCS: SetPoint("CENTER", UIParent, "CENTER", 0,0)
	
	Point_Frame(f.FCS)
	Point_OnEvent(f.FCS)
	Point_OuUpdate(f.FCS)
	
	Watcher_Frame(f.FCS)
	AuraList_Init()
end

--"UNIT_MAXPOWER"
--"UNIT_DISPLAYPOWER",
--"UPDATE_SHAPESHIFT_FORM",
--"UNIT_AURA",
--"ACTIVE_TALENT_GROUP_CHANGED",
--"SPELLS_CHANGED",
--"GROUP_ROSTER_UPDATE",
--"CHARACTER_POINTS_CHANGED",

