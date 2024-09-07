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

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local band = bit.band
local numMirrorTimerTypes = 3;

----------------------------------------------------------------
--> Create Player CastBar
----------------------------------------------------------------

local function PlayerCastBar_ColorRing(frame, color)
	frame.LR.Ring: SetVertexColor(F.Color(color))
	frame.RR.Ring: SetVertexColor(F.Color(color))
end

local function PlayerCastBar_UpdateRing(frame, d)
	if not d then d = 1 end
	d = min(max(d, 0), 1)
	if frame.LR then
		frame.LR.Ring:SetRotation(math.rad(frame.LR.Base-frame.LR.Range*d))
	end
	if frame.RR then
		frame.RR.Ring:SetRotation(math.rad(frame.RR.Base+frame.RR.Range*d))
	end
end

local function Ring_Artwork(frame, size, texture, bgangle)
	local SC = CreateFrame("Frame", nil, frame)
	SC: SetSize(size, size)
	frame: SetScrollChild(SC)
	
	local Ring = SC:CreateTexture(nil, "ARTWORK")
	Ring: SetTexture(MEKA.Path(texture))
	Ring: SetSize(size, size)
    Ring: SetPoint("CENTER")
    Ring: SetVertexColor(F.Color(C.Color.Main1))
	Ring: SetAlpha(1)
	--Ring: SetBlendMode("BLEND")
	Ring: SetRotation(math.rad(frame.Base))

	local RingBg = SC:CreateTexture(nil, "BACKGROUND")
	RingBg: SetTexture(MEKA.Path(texture.."_Sd"))
	RingBg: SetSize(size, size)
    RingBg: SetPoint("CENTER")
    RingBg: SetVertexColor(F.Color(C.Color.Main0))
	RingBg: SetAlpha(0.25)
	RingBg: SetRotation(math.rad(frame.Base+bgangle))

	frame.Ring = Ring
	frame.RingBg = RingBg
end

local function Create_Ring(frame, size, texture)
	frame.LR = CreateFrame("ScrollFrame", nil, frame)
	frame.LR: SetSize((size)/2, size)
	frame.LR: SetPoint("RIGHT", frame, "CENTER", 0,0)
	frame.LR.Base = 0
	frame.LR.Range = 30
	Ring_Artwork(frame.LR, size, texture, -30)
	
	frame.RR = CreateFrame("ScrollFrame", nil, frame)
	frame.RR: SetSize((size)/2, size)
	frame.RR: SetPoint("LEFT", frame, "CENTER", 0,0)
	frame.RR: SetHorizontalScroll((size)/2)
	frame.RR.Base = -180
	frame.RR.Range = 30
	Ring_Artwork(frame.RR, size, texture, 30)
end

local function PlayerCastBar_Artwork(frame)
	local LeftBD = frame:CreateTexture(nil, "ARTWORK")
	LeftBD: SetTexture(MEKA.Path("RingBar\\Castbar1_Bd1"))
	LeftBD: SetVertexColor(F.Color(C.Color.Warn1))
	LeftBD: SetAlpha(0.9)
	LeftBD: SetSize(32,32)
	LeftBD: SetPoint("CENTER", frame, "CENTER", 175*cos(rad(-122)), 175*sin(rad(-122)))
	F.RotateTexture(LeftBD, -32)

	local RightBD = frame:CreateTexture(nil, "ARTWORK")
	RightBD: SetTexture(MEKA.Path("RingBar\\Castbar1_Bd1"))
	RightBD: SetVertexColor(F.Color(C.Color.Warn1))
	RightBD: SetAlpha(0.9)
	RightBD: SetSize(32,32)
	RightBD: SetPoint("CENTER", frame, "CENTER", 175*cos(rad(-58)), 175*sin(rad(-58)))
	F.RotateTexture(RightBD, 32)

	local Text = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 14, nil, C.Color.Warn1,1, C.Color.Main0,1, {1,-1}, "CENTER", "CENTER")
	Text: SetPoint("CENTER", frame, "CENTER", 0,-210)
	Text: SetSize(100,8)

	local Num = {}
	for i = 1,7 do
		Num[i] = frame:CreateTexture(nil, "ARTWORK")
		Num[i]: SetTexture(MEKA.Path("N12\\N0"))
		Num[i]: SetVertexColor(F.Color(C.Color.Warn1))
		Num[i]: SetAlpha(1)
		Num[i]: SetSize(32,32)
		Num[i]: SetPoint("CENTER", frame, "CENTER", 190*cos(rad(-90-12+3*i)), 190*sin(rad(-90-12+3*i)))
		F.RotateTexture(Num[i], -12+3*i)
	end

	local StageNum = F.Create.Texture(frame, {
		texture = MEKA.Path("N16\\NN"),
		color = C.Color.Blue,
		alpha = 1,
		size = {32,32},
	})
	StageNum: SetPoint("CENTER", frame, "CENTER", 0,-150)

	frame.Num = Num
	frame.Text = Text
	frame.StageNum = StageNum
end

local function PlayerCastBar_ColorNum(frame, color)
	if frame.Text then
		frame.Text: SetTextColor(F.Color(color))
	end
	for i = 1,7 do
		frame.Num[i]: SetVertexColor(F.Color(color))
	end
end

local function Conversion_Time(time)
	local v1,v2,v3
	if time then
		time = F.Clamp(time, 0,99)
	else
		time = 0 
	end
	if time < 10 then
		time = time * 10
		v2 = "p"
	else
		v2 = "b"
	end
	v1 = floor(time/10)
	v3 = floor(time) - v1*10
	return v1,v2,v3
end

local function PlayerCastBar_UnpdateNum(frame, blank)
	if blank then
		for i = 1,7 do
			frame.Num[i]: SetTexture(MEKA.Path("N12\\Nb"))
		end
	else
		frame.Num[4]: SetTexture(MEKA.Path("N12\\Nslash"))
		local v1,v2,v3,v4,v5,v6
		if frame.Channeling then
			v1,v2,v3 = Conversion_Time(frame.Value)
		else
			v1,v2,v3 = Conversion_Time(frame.MaxValue-frame.Value)
		end

		v4,v5,v6 = Conversion_Time(frame.MaxValue)
		if v2 == "p" then
			frame.Num[1]: SetTexture(MEKA.Path("N12\\N"..v1))
			frame.Num[2]: SetTexture(MEKA.Path("N12\\N"..v2))
			frame.Num[3]: SetTexture(MEKA.Path("N12\\N"..v3))
		elseif v2 == "b" then
			frame.Num[1]: SetTexture(MEKA.Path("N12\\N"..v2))
			frame.Num[2]: SetTexture(MEKA.Path("N12\\N"..v1))
			frame.Num[3]: SetTexture(MEKA.Path("N12\\N"..v3))
		end
		if v5 == "p" then
			frame.Num[5]: SetTexture(MEKA.Path("N12\\N"..v4))
			frame.Num[6]: SetTexture(MEKA.Path("N12\\N"..v5))
			frame.Num[7]: SetTexture(MEKA.Path("N12\\N"..v6))
		elseif v5 == "b" then
			frame.Num[5]: SetTexture(MEKA.Path("N12\\N"..v4))
			frame.Num[6]: SetTexture(MEKA.Path("N12\\N"..v6))
			frame.Num[7]: SetTexture(MEKA.Path("N12\\N"..v5))
		end
	end
end

local function PlayerCastBar_UnpdateStageNum(self, blank)
	if self.StageNum then
		if (not blank) and self.CurrSpellStage and (self.CurrSpellStage > 0) then
			self.StageNum: SetTexture(MEKA.Path("N16\\N"..self.CurrSpellStage))
			if self.CurrSpellStage == 3 then
				self.StageNum: SetVertexColor(F.Color(C.Color.Red))
			elseif self.CurrSpellStage == 2 then
				self.StageNum: SetVertexColor(F.Color(C.Color.Yellow))
			else
				self.StageNum: SetVertexColor(F.Color(C.Color.Blue))
			end
		else
			self.StageNum: SetTexture(MEKA.Path("N16\\NN"))
		end
	end
end

local function PlayerCastBar_ApplyUpdate(frame, value)
	if value then
		PlayerCastBar_UpdateRing(frame, value)
	end
	PlayerCastBar_UpdateRing(frame, frame.Value/frame.MaxValue)
	PlayerCastBar_UnpdateNum(frame, value)
	PlayerCastBar_UnpdateStageNum(frame)
end

local function PlayerCastBar_ApplyAlpha(frame, alpha)
	frame: SetAlpha(alpha)
end

local CAST_COLOR = {
	Cast = C.Color.Blue,
	Shield = C.Color.Yellow,
	Stop = C.Color.Green,
	Fail = C.Color.Red,
}

local function PlayerCastBar_ApplyColor(frame, state, notInterruptible)
	if state == "Start" then
		if notInterruptible then
			PlayerCastBar_ColorRing(frame, CAST_COLOR.Shield)
			PlayerCastBar_ColorNum(frame, CAST_COLOR.Shield)
		else
			PlayerCastBar_ColorRing(frame, CAST_COLOR.Cast)
			PlayerCastBar_ColorNum(frame, CAST_COLOR.Cast)
		end
	elseif state == "Finished" then
		PlayerCastBar_ColorRing(frame, CAST_COLOR.Stop)
		PlayerCastBar_ColorNum(frame, CAST_COLOR.Stop)
	elseif state == "Failed" then
		PlayerCastBar_ColorRing(frame, CAST_COLOR.Fail)
		PlayerCastBar_ColorNum(frame, CAST_COLOR.Fail)
	end
end

local function PlayerCastBar_Create(frame)
	local PlayerCastBar = CreateFrame("frame", "MEKA_PlayerCastBar", frame)
	PlayerCastBar: SetSize(16, 16)
	PlayerCastBar: SetPoint("CENTER", UIParent, "CENTER", 0,0)
	PlayerCastBar.RingSize = 512

	Create_Ring(PlayerCastBar, PlayerCastBar.RingSize, "RingBar\\Castbar1")
	PlayerCastBar_Artwork(PlayerCastBar)

	PlayerCastBar.Unit = "player"
	PlayerCastBar.EnableCastbar = true
	PlayerCastBar.ShowCastbar = true
	PlayerCastBar.ShowTradeSkills = true
	PlayerCastBar.ApplyUpdate = PlayerCastBar_ApplyUpdate
	PlayerCastBar.ApplyAlpha = PlayerCastBar_ApplyAlpha
	PlayerCastBar.ApplyColor = PlayerCastBar_ApplyColor
	F.CastBar_Create(PlayerCastBar)

	frame.PlayerCastBar = PlayerCastBar
end

local function PlayerCastBar_Load(frame)
	if not frame.PlayerCastBar then
		PlayerCastBar_Create(frame)
		F.HideFrame(CastingBarFrame, true, true)
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.PlayerSpellName then
		frame.PlayerCastBar.Text: Show()
	else
		frame.PlayerCastBar.Text: Hide()
	end
end

--- ------------------------------------------------------------
--> Create Pet CastBar
--- ------------------------------------------------------------

local function PetCastBar_Artwork(frame)
	local LeftBD = frame:CreateTexture(nil, "ARTWORK")
	LeftBD: SetTexture(MEKA.Path("RingBar\\Castbar1_Bd1"))
	LeftBD: SetVertexColor(F.Color(C.Color.Warn1))
	LeftBD: SetAlpha(0.9)
	LeftBD: SetSize(32,32)
	LeftBD: SetPoint("CENTER", frame, "CENTER", 150*cos(rad(-122)), 150*sin(rad(-122)))
	F.RotateTexture(LeftBD, -32)

	local RightBD = frame:CreateTexture(nil, "ARTWORK")
	RightBD: SetTexture(MEKA.Path("RingBar\\Castbar1_Bd1"))
	RightBD: SetVertexColor(F.Color(C.Color.Warn1))
	RightBD: SetAlpha(0.9)
	RightBD: SetSize(32,32)
	RightBD: SetPoint("CENTER", frame, "CENTER", 150*cos(rad(-58)), 150*sin(rad(-58)))
	F.RotateTexture(RightBD, 32)

	local Num = {}
	for i = 1,7 do
		Num[i] = frame:CreateTexture(nil, "ARTWORK")
		Num[i]: SetTexture(MEKA.Path("N12\\N0"))
		Num[i]: SetVertexColor(F.Color(C.Color.Warn1))
		Num[i]: SetAlpha(1)
		Num[i]: SetSize(32,32)
		Num[i]: SetPoint("CENTER", frame, "CENTER", 135*cos(rad(-90-16+4*i)), 135*sin(rad(-90-16+4*i)))
		F.RotateTexture(Num[i], -16+4*i)
	end

	frame.Num = Num
end

local function PetCastBar_OnEvent(frame, event, ...)
	local arg1 = ...;
	if ( event == "UNIT_PET" ) then
		if ( arg1 == "player" ) then
			if (frame.EnableCastbar == false) and Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Player then
				frame.ShowCastbar = UnitIsPossessed("pet");
			end
			if not frame.ShowCastbar then
				frame: Hide();
			elseif ( frame.Casting or frame.Channeling ) then
				frame: Show();
			end
		end
		return
	end
end

local function PetCastBar_Create(frame)
	local PetCastBar = CreateFrame("frame", "MEKA_PetCastBar", frame)
	PetCastBar: SetSize(16, 16)
	PetCastBar: SetPoint("CENTER", UIParent, "CENTER", 0,0)
	PetCastBar.RingSize = 512

	Create_Ring(PetCastBar, PetCastBar.RingSize, "RingBar\\Castbar2")
	PetCastBar_Artwork(PetCastBar)

	PetCastBar: RegisterEvent("UNIT_PET")

	PetCastBar.Unit = "pet"
	PetCastBar.EnableCastbar = true
	PetCastBar.ShowCastbar = true
	PetCastBar.ShowTradeSkills = false
	PetCastBar.ApplyUpdate = PlayerCastBar_ApplyUpdate
	PetCastBar.ApplyAlpha = PlayerCastBar_ApplyAlpha
	PetCastBar.ApplyColor = PlayerCastBar_ApplyColor
	PetCastBar.ApplyEvent = PetCastBar_OnEvent
	F.CastBar_Create(PetCastBar)

	frame.PetCastBar = PetCastBar
end

local function PetCastBar_Load(frame)
	if not frame.PetCastBar then
		PetCastBar_Create(frame)
		F.HideFrame(PetCastingBarFrame, true, true)
	end
end

----------------------------------------------------------------
--> GCD
----------------------------------------------------------------

local function GCD_Artwork(frame)
	local Bg1 = frame: CreateTexture(nil, "BACKGROUND")
	Bg1: SetTexture(MEKA.Path("RingBar\\Bar5_Bar"))
	Bg1: SetVertexColor(F.Color(C.Color.Main0))
	Bg1: SetAlpha(0.65)
	Bg1: SetSize(55,32)
	Bg1: SetTexCoord(0/4096,110/4096, 0,1)
	Bg1: SetPoint("BOTTOMLEFT", frame, "BOTTOM", 0,0)

	local BgGlow1 = frame: CreateTexture(nil, "BORDER")
	BgGlow1: SetTexture(MEKA.Path("RingBar\\Bar5_Bar"))
	BgGlow1: SetVertexColor(F.Color(C.Color.Main1))
	BgGlow1: SetAlpha(0.15)
	BgGlow1: SetSize(55,32)
	BgGlow1: SetTexCoord(0/4096,110/4096, 0,1)
	BgGlow1: SetPoint("BOTTOMLEFT", frame, "BOTTOM", 0,0)

	local Bg2 = frame: CreateTexture(nil, "BACKGROUND")
	Bg2: SetTexture(MEKA.Path("RingBar\\Bar5_Bar"))
	Bg2: SetVertexColor(F.Color(C.Color.Main0))
	Bg2: SetAlpha(0.65)
	Bg2: SetSize(55,32)
	Bg2: SetTexCoord(110/4096,0/4096, 0,1)
	Bg2: SetPoint("BOTTOMRIGHT", frame, "BOTTOM", 0,0)

	local BgGlow2 = frame: CreateTexture(nil, "BORDER")
	BgGlow2: SetTexture(MEKA.Path("RingBar\\Bar5_Bar"))
	BgGlow2: SetVertexColor(F.Color(C.Color.Main1))
	BgGlow2: SetAlpha(0.15)
	BgGlow2: SetSize(55,32)
	BgGlow2: SetTexCoord(110/4096,0/4096, 0,1)
	BgGlow2: SetPoint("BOTTOMRIGHT", frame, "BOTTOM", 0,0)

	local Gloss = frame: CreateTexture(nil, "BACKGROUND")
	Gloss: SetTexture(MEKA.Path("RingBar\\Bar5_Bar"))
	Gloss: SetVertexColor(F.Color(C.Color.Main1))
	Gloss: SetAlpha(0.25)
	Gloss: SetSize(114,32)
	Gloss: SetTexCoord(3868/4096,4096/4096, 0,1)
	Gloss: SetPoint("BOTTOM", frame, "BOTTOM", 0,0)

	local BarR = frame: CreateTexture(nil, "ARTWORK")
	BarR: SetTexture(MEKA.Path("RingBar\\Bar5_Bar"))
	BarR: SetVertexColor(F.Color(C.Color.Main1))
	BarR: SetAlpha(1)
	BarR: SetSize(55,32)
	BarR: SetTexCoord(0/4096,110/4096, 0,1)
	BarR: SetPoint("BOTTOMLEFT", frame, "BOTTOM", 0,0)

	local BarL = frame: CreateTexture(nil, "ARTWORK")
	BarL: SetTexture(MEKA.Path("RingBar\\Bar5_Bar"))
	BarL: SetVertexColor(F.Color(C.Color.Main1))
	BarL: SetAlpha(1)
	BarL: SetSize(55,32)
	BarL: SetTexCoord(110/4096,0/2048, 0,1)
	BarL: SetPoint("BOTTOMRIGHT", frame, "BOTTOM", 0,0)

	frame.BarL = BarL
	frame.BarR = BarR
	frame.Gloss = Gloss
end

local function GCD_Update(frame, d, remain)
	if not d then d = 0 end
	d = F.Clamp(d,0,1)

	--f.Bar: SetSize(154, 34*d+F.Debug)
	--f.Bar: SetTexCoord(51/256,205/256, (15+34*abs(1-d))/64,49/64)
	--f.Text: SetText(format("%.1f", remain))

	d = floor(d*22+0.5)
	frame.BarR: SetTexCoord((110*abs(22-d))/4096,(110*abs(23-d))/4096, 0,1)
	frame.BarL: SetTexCoord((110*abs(23-d))/4096,(110*abs(22-d))/4096, 0,1)

	if remain <= frame.SQW then
		frame.BarL: SetVertexColor(F.Color(C.Color.Main2))
		frame.BarR: SetVertexColor(F.Color(C.Color.Main2))
		frame.Gloss: SetVertexColor(F.Color(C.Color.Main2))
	else
		frame.BarL: SetVertexColor(F.Color(C.Color.Main1))
		frame.BarR: SetVertexColor(F.Color(C.Color.Main1))
		frame.Gloss: SetVertexColor(F.Color(C.Color.Main1))
	end
end

local function Get_GCD()
	local SpellInfo = C_Spell.GetSpellCooldown(61304)
	local remain = max((GetTime() - SpellInfo.startTime), 0)
	return remain, SpellInfo.duration
end

local function Get_GCD_Classic(unit, guid, spell)
	local start, duration, remain = 0,0,0
	if unit and unit == "player" then
		local SpellInfo = C_Spell.GetSpellCooldown(spell)
		start = SpellInfo.startTime
		duration = SpellInfo.duration
		if duration and duration > 0 and duration <= 1.5 then
			remain = max((GetTime() - start), 0)
		else
			duration = 0
		end
	end
	return remain, duration
end

local function GCD_RgEvent(frame)
	frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterEvent("CVAR_UPDATE")
	if F.IsClassic then
		frame: RegisterUnitEvent("UNIT_SPELLCAST_START", "player")
		frame: RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")
	else
		frame: RegisterEvent("SPELL_UPDATE_COOLDOWN")
	end
end

local function GCD_OnEvent(frame, event, arg1, arg2, arg3)
	if event == "ALL" or event == "SPELL_UPDATE_COOLDOWN" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_SUCCEEDED" then
		if F.IsClassic then
			frame.Remain, frame.CD = Get_GCD_Classic(arg1, arg2, arg3)
		else
			frame.Remain, frame.CD = Get_GCD()
		end
		if (frame.Remain > 0 and frame.CD > frame.Remain) then
			frame: SetAlpha(1)
			frame: SetScript("OnUpdate", function(self, elapsed)
				if frame.Remain > 0 and frame.CD > frame.Remain then
					GCD_Update(self, frame.Remain/frame.CD, frame.CD-frame.Remain)
					frame.Remain = frame.Remain + elapsed
				else
					GCD_Update(self, 0, 0)
					frame: SetAlpha(0)
					frame: SetScript("OnUpdate", nil)
				end
			end)
		end
	end
	if event == "ALL" or event == "PLAYER_ENTERING_WORLD" or event == "CVAR_UPDATE" then
		frame.SQW = GetCVar("SpellQueueWindow")/1000
	end
end

local function GCD_Init(frame)
	frame: SetAlpha(0)
	GCD_RgEvent(frame)

	frame: SetScript("OnHide", function(self)
		self: UnregisterAllEvents()
		self: SetScript("OnUpdate", nil)
	end)
	frame: SetScript("OnShow", function(self)
		GCD_RgEvent(self)
		GCD_OnEvent(self, "ALL")
	end)
end

local function GCD_Frame(frame)
	frame.GCD = CreateFrame("Frame", nil, frame)
	frame.GCD: SetSize(112,82)
	frame.GCD: SetPoint("TOP", frame, "CENTER", 0,0)
	frame.GCD.SQW = 0.4
	GCD_Artwork(frame.GCD)
	GCD_Init(frame.GCD)

	frame.GCD: SetScript("OnEvent", function(self, event, arg1, arg2, arg3)
		if event == "SPELL_UPDATE_COOLDOWN" or event == "UNIT_SPELLCAST_START" or event == "UNIT_SPELLCAST_SUCCEEDED" then
			if F.IsClassic then
				frame.GCD.Remain, frame.GCD.CD = Get_GCD_Classic(arg1, arg2, arg3)
			else
				frame.GCD.Remain, frame.GCD.CD = Get_GCD()
			end
			if (frame.GCD.Remain > 0 and frame.GCD.CD > frame.GCD.Remain) then
				frame.GCD: SetAlpha(1)
				frame.GCD: SetScript("OnUpdate", function(self, elapsed)
					if frame.GCD.Remain > 0 and frame.GCD.CD > frame.GCD.Remain then
						GCD_Update(self, frame.GCD.Remain/frame.GCD.CD, frame.GCD.CD-frame.GCD.Remain)
						frame.GCD.Remain = frame.GCD.Remain + elapsed
					else
						GCD_Update(self, 0, 0)
						frame.GCD: SetAlpha(0)
						frame.GCD: SetScript("OnUpdate", nil)
					end
				end)
			end
		end
		if event == "PLAYER_ENTERING_WORLD" or event == "CVAR_UPDATE" then
			self.SQW = GetCVar("SpellQueueWindow")/1000
		end
	end)
end

local function GCD_Load(frame)
	if not frame.GCD then
		GCD_Frame(frame)
	end
end

local function GCD_Toggle(frame, arg1)
	if arg1 == "ON" then
		GCD_Load(frame)
		frame.GCD: Show()
	elseif arg1 == "OFF" then
		if frame.GCD then
			frame.GCD: Hide()
		end
	end
end

----------------------------------------------------------------
--> Mirror
----------------------------------------------------------------

local function Mirror_Artwork(f, p)
	local Bg = f: CreateTexture(nil, "BACKGROUND")
	Bg: SetTexture(F.Path("TieBar4\\Bar1"))
	Bg: SetVertexColor(F.Color(C.Color.W1))
	Bg: SetAlpha(0.6)
	Bg: SetSize(8, 42)
	Bg: SetTexCoord(4/16,12/16, 11/64,53/64)
	Bg: SetPoint("CENTER", f, "CENTER", 0,0)

	local Bg_Glow = f: CreateTexture(nil, "BORDER")
	Bg_Glow: SetTexture(F.Path("TieBar4\\Bar1"))
	Bg_Glow: SetVertexColor(F.Color(C.Color.W3))
	Bg_Glow: SetAlpha(0.1)
	Bg_Glow: SetSize(8, 42)
	Bg_Glow: SetTexCoord(4/16,12/16, 11/64,53/64)
	Bg_Glow: SetPoint("CENTER", f, "CENTER", 0,0)

	local Bar = f: CreateTexture(nil, "ARTWORK")
	Bar: SetTexture(F.Path("TieBar4\\Bar1"))
	Bar: SetVertexColor(F.Color(C.Color.B3))
	Bar: SetAlpha(0.8)
	Bar: SetSize(8, 42)
	Bar: SetTexCoord(4/16,12/16, 11/64,53/64)
	Bar: SetPoint("BOTTOM", Bg, "BOTTOM", 0,0)

	local nonius = f: CreateTexture(nil, "OVERLAY")
	nonius: SetTexture(F.Path("TieBar4\\Border1"))
	nonius: SetVertexColor(F.Color(C.Color.W3))
	nonius: SetAlpha(0.8)
	nonius: SetSize(32,32)
	nonius: SetPoint("CENTER", p, "CENTER", 118*cos(rad(10)), 118*sin(rad(10)))
	F.RotateTexture(nonius, 10)

	local Bd = CreateFrame("Frame", nil, f)
	for i = 1,3 do
		Bd[i] = Bd: CreateTexture(nil, "BACKGROUND")
		Bd[i]: SetTexture(F.Path("TieBar4\\Border2"))
		Bd[i]: SetVertexColor(F.Color(C.Color.W3))
		Bd[i]: SetAlpha(0.8)
		Bd[i]: SetSize(8,8)
		Bd[i]: SetPoint("CENTER", p, "CENTER", 121*cos(rad(-10+10*(i-1))), 121*sin(rad(-10+10*(i-1))))
		F.RotateTexture(Bd[i], -10+10*(i-1))
	end

	--f.Text = F.create_Font(f, C.Font.Num, 12, nil, 0.8, "LEFT", "CENTER")
	f.Text = F.Create.Font(f, "ARTWORK", C.Font.Num, 12, nil, nil, 0.8, nil, 1, nil, "LEFT", "MIDDLE")
	if F.IsClassic then
		f.Text: SetPoint("RIGHT", Bg, "LEFT", -10,0)
	else
		f.Text: SetPoint("LEFT", Bg, "RIGHT", 20,0)
	end

	f.Bar = Bar
	f.Nonius = nonius
end

local function Mirror_Refresh(f)
	f.Mode = "UNKNOWN"
	f.Duration = 0
	f.Text: SetText(" ")
end

local function TieBar4_Update(f, d, p)
	if not d then d = 0 end
	if d > 1 then d = 1 end
	if d < 0 then d = 0 end
	local r = d * 20

	f.Bar: SetSize(8, 42*d+F.Debug)
	f.Bar: SetTexCoord(4/16,12/16, (11+42*abs(1-d))/64,53/64)
	f.Nonius: SetPoint("CENTER", p, "CENTER", 118*cos(rad(-10+r)), 118*sin(rad(-10+r)))
	F.RotateTexture(f.Nonius, -10+r)
end

local function Mirror_Update(f, elapsed, p)
	if f.Mode ~= "UNKNOWN" then
		f: SetAlpha(1)
		local value = GetMirrorTimerProgress(f.Mode)
		value = F.Clamp(value, 0,f.Duration)
		TieBar4_Update(f, value/f.Duration, p)
		f.Text: SetText(F.FormatTime(value/1000))
	else
		for i = 1, MIRRORTIMER_NUMTIMERS or numMirrorTimerTypes do
			if i == 2 then
				local timer, initial, maxvalue, scale, paused, label = GetMirrorTimerInfo(i)
				if timer ~= "UNKNOWN" then
					f.Mode = timer
					f.Duration = maxvalue
				end
			end
		end
		if f.Mode == "UNKNOWN" then
			f: SetAlpha(0)
			f: SetScript("OnUpdate", nil)
		end
	end
end

local function Mirror_SetUpdate(frame, parent)
	local last = 0
	frame: SetScript("OnUpdate", function(self, elapsed)
		if last >= 7*elapsed then
			Mirror_Update(self, last, parent)
			last = 0
		else
			last = last + elapsed
		end
	end)
end

local function Mirror_DesUpdate(frame, parent)
	frame: SetAlpha(0)
	frame: SetScript("OnUpdate", nil)
end

local function Mirror_Event(f, event, parent)
	if event == "ALL" or event == "PLAYER_ENTERING_WORLD" or event == "MIRROR_TIMER_START" or event == "MIRROR_TIMER_PAUSE" then
		local currentTime = GetTime()
		Mirror_Refresh(f)
		for i = 1, numMirrorTimerTypes do
			--1 = Fatigue, 2 = Breath, 3 = Feign Death.
			if i == 2 then
				local timer, initial, maxvalue, scale, paused, label = GetMirrorTimerInfo(i)
				--timer: "EXHAUSTION", "BREATH", and "FEIGNDEATH", or "UNKNOWN"
				if timer ~= "UNKNOWN" then
					f.Mode = timer
					f.Duration = maxvalue
				end
			end
		end
		if event == "ALL" or event == "PLAYER_ENTERING_WORLD" then
			if f.Mode == "UNKNOWN" then
				--f: Hide()
				Mirror_DesUpdate(f, parent)
			else
				--f: Show()
				Mirror_SetUpdate(f, parent)
			end
		end
	end

	if event == "MIRROR_TIMER_START" then
		--f: Show()
		Mirror_SetUpdate(f, parent)
	elseif event == "MIRROR_TIMER_STOP" then
		--f: Hide()
		Mirror_DesUpdate(f, parent)
	end
end

local function Mirror_RgEvent(f)
	f: RegisterEvent("PLAYER_ENTERING_WORLD")
	f: RegisterEvent("MIRROR_TIMER_PAUSE")
	f: RegisterEvent("MIRROR_TIMER_START")
	f: RegisterEvent("MIRROR_TIMER_STOP")
	f: RegisterEvent("READY_CHECK")
	f: RegisterEvent("READY_CHECK_FINISHED")
	if not F.IsClassic then
		f: RegisterEvent("LFG_PROPOSAL_FAILED")
		f: RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
	end
end

local function Mirror_Frame(frame)
	local Mirror = CreateFrame("Frame", nil, frame)
	Mirror: SetSize(8, 42)
	Mirror: SetPoint("CENTER", frame, "CENTER", 113,0)
	Mirror: SetAlpha(0)

	Mirror_Artwork(Mirror, frame)
	Mirror_Refresh(Mirror)
	Mirror_RgEvent(Mirror)
	Mirror_SetUpdate(Mirror, frame)

	Mirror: SetScript("OnEvent", function(self, event)
		Mirror_Event(self, event, frame)
	end)
	Mirror: SetScript("OnHide", function(self)
		self: UnregisterAllEvents()
		self: SetScript("OnUpdate", nil)
	end)
	Mirror: SetScript("OnShow", function(self)
		Mirror_RgEvent(self)
		--Mirror_SetUpdate(self, frame)
		Mirror_Event(self, "ALL", frame)
	end)

	frame.Mirror = Mirror
end

local function Mirror_Load(frame)
	if not frame.Mirror then
		Mirror_Frame(frame)
		--F.HideFrame(MirrorTimer1, true, true)
		--F.HideFrame(MirrorTimer2, true, true)
		--F.HideFrame(MirrorTimer3, true, true)
	end
end

local function Mirror_Toggle(frame, arg1)
	if arg1 == "ON" then
		Mirror_Load(frame)
		frame.Mirror: Show()
	elseif arg1 == "OFF" then
		if frame.Mirror then
			frame.Mirror: Hide()
			Quafe_NoticeReload()
		end
	end
end

----------------------------------------------------------------
--> Ammo amount
----------------------------------------------------------------

local function AmmoCount_Artwork(frame)
	frame.Text = F.create_Font(frame, C.Font.Num, 12, nil, 0.8, "LEFT", "CENTER")
	frame.Text: SetPoint("TOP", frame, "BOTTOM", 0,-20)
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
		if ammo and (ammo > 0) then
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
	AmmoCount: SetPoint("CENTER", frame, "CENTER", 0,0)
	AmmoCount: Hide()
	AmmoCount.State = "Hide"

	AmmoCount_Artwork(AmmoCount)
	AmmoCount_RgEvent(AmmoCount)
	AmmoCount_OnEvent(AmmoCount)

	frame.AmmoCount = AmmoCount
end

----------------------------------------------------------------
--> Swing
----------------------------------------------------------------
--['自动射击'] = 75
--frame:RegisterEvent("START_AUTOREPEAT_SPELL")
--frame:RegisterEvent("STOP_AUTOREPEAT_SPELL")

local Swing_CombatLog = {
	LogON = false,
	LogEvent = nil,
}

local function Swing_Artwork(frame, pos)
	local Bg = frame: CreateTexture(nil, "BACKGROUND")
	Bg: SetTexture(F.Path("TieBar4\\Bar1"))
	Bg: SetVertexColor(F.Color(C.Color.W1))
	Bg: SetAlpha(0.6)
	Bg: SetSize(8, 42)
	Bg: SetTexCoord(12/16,4/16, 11/64,53/64)
	Bg: SetPoint("CENTER", frame, "CENTER", 0,0)

	local Bg_Glow = frame: CreateTexture(nil, "BORDER")
	Bg_Glow: SetTexture(F.Path("TieBar4\\Bar1"))
	Bg_Glow: SetVertexColor(F.Color(C.Color.W3))
	Bg_Glow: SetAlpha(0.1)
	Bg_Glow: SetSize(8, 42)
	Bg_Glow: SetTexCoord(12/16,4/16, 11/64,53/64)
	Bg_Glow: SetPoint("CENTER", frame, "CENTER", 0,0)

	local Bar = frame: CreateTexture(nil, "ARTWORK")
	Bar: SetTexture(F.Path("TieBar4\\Bar1"))
	Bar: SetVertexColor(F.Color(C.Color.B3))
	Bar: SetAlpha(1)
	Bar: SetSize(8, 42)
	Bar: SetTexCoord(12/16,4/16, 11/64,53/64)
	Bar: SetPoint("BOTTOM", Bg, "BOTTOM", 0,0)

	local nonius = frame: CreateTexture(nil, "OVERLAY")
	nonius: SetTexture(F.Path("TieBar4\\Border1"))
	nonius: SetVertexColor(F.Color(C.Color.W3))
	nonius: SetAlpha(1)
	nonius: SetSize(32,32)
	nonius: SetPoint("CENTER", pos, "CENTER", 118*cos(rad(170)), 118*sin(rad(170)))
	F.RotateTexture(nonius, -10)

	local Bd = CreateFrame("Frame", nil, frame)
	for i = 1,3 do
		Bd[i] = Bd: CreateTexture(nil, "BACKGROUND")
		Bd[i]: SetTexture(F.Path("TieBar4\\Border2"))
		Bd[i]: SetVertexColor(F.Color(C.Color.W3))
		Bd[i]: SetAlpha(0.8)
		Bd[i]: SetSize(8,8)
		Bd[i]: SetPoint("CENTER", p, "CENTER", 121*cos(rad(190-10*(i-1))), 121*sin(rad(190-10*(i-1))))
		F.RotateTexture(Bd[i], 190-10*(i-1))
	end

	frame.Text = F.create_Font(frame, C.Font.Num, 12, nil, 0.8, "LEFT", "CENTER")
	frame.Text: SetPoint("LEFT", Bg, "RIGHT", 20,0)

	frame.Bar = Bar
	frame.Nonius = nonius
end

local function Swing_BarUpdate(frame, d, pos)
	d = F.Clamp(d,0,1)
	local r = d * 20

	frame.Bar: SetSize(8, 42*d+F.Debug)
	frame.Bar: SetTexCoord(12/16,4/16, (11+42*abs(1-d))/64,53/64)
	frame.Nonius: SetPoint("CENTER", pos, "CENTER", 118*cos(rad(190-r)), 118*sin(rad(190-r)))
	F.RotateTexture(frame.Nonius, 10-r)
end

local function Swing_SetUpdate(frame, d, pos)
	if not d then return end
	local normal = true
	frame: SetAlpha(1)
	frame.Bar: SetVertexColor(F.Color(C.Color.B3))
	local duration = d
	local last = 0
	frame: SetScript("OnUpdate", function(self, elapsed)
		if last >= 5*elapsed then
			last = last or 0
			Swing_BarUpdate(frame, (1-d/duration), pos)
			frame.Text:SetFormattedText("%.1f", d)
			if d < 0.5 and normal then
				frame.Bar: SetVertexColor(F.Color(C.Color.R3))
				normal = false
			end
			d = d - last
			if d < 0 then
				self: SetScript("OnUpdate", nil)
				self: SetAlpha(0)
			end
			last = 0
		else
			last = last + elapsed
		end
	end)
end

local function Swing_Melee_Update(frame, pos, per)
	local speed = UnitAttackSpeed("player")
	if per then
		speed = speed * per
	end
	Swing_SetUpdate(frame, speed, pos)
end

local function Swing_Shoot_Update(frame, pos)
	local speed = UnitRangedDamage("player")
	Swing_SetUpdate(frame, speed, pos)
end

local function Swing_CombatLog_Event(frame, pos)
	Swing_CombatLog.LogON = true
	Swing_CombatLog.LogEvent = function(timestamp, eventParam, hideCaster, sourceGUID, sourceName, sourceFlags, sourceRaidFlags, destGUID, destName, destFlags, destRaidFlags, Param12, Param13, Param14, Param15, Param16, Param17, Param18, Param19, Param20, Param21, Param22, Param23, Param24)
		if (band(sourceFlags, COMBATLOG_FILTER_ME) == COMBATLOG_FILTER_ME) then
			if (eventParam == "SWING_DAMAGE") then
				if not Param21 then
					Swing_Melee_Update(frame, pos)
				end
			elseif (eventParam == "SWING_MISSED") then
				if not Param13 then
					if Param12 == "PARRY" then
						Swing_Melee_Update(frame, pos, 0.6)
					else
						Swing_Melee_Update(frame, pos)
					end
				end
			elseif (eventParam == "RANGE_DAMAGE") then
				Swing_Shoot_Update(frame, pos)
			end
		end
	end
	tinsert(E.CombatLogList, Swing_CombatLog)
	F.BGCL_Toggle()
end

local function Swing_Frame(frame)
	local Swing = CreateFrame("Frame", nil, frame)
	Swing: SetSize(8, 42)
	Swing: SetPoint("CENTER", frame, "CENTER", -113,0)
	Swing: SetAlpha(0)

	Swing_Artwork(Swing, frame)
	Swing_CombatLog_Event(Swing, frame)
	if F.IsClassic then
		AmmoCount_Frame(Swing)
	end

	Swing: SetScript("OnHide", function(self)
		self:SetScript("OnUpdate", nil)
	end)

	frame.Swing = Swing
end

local function Swing_Load(frame)
	if not frame.Swing then
		Swing_Frame(frame)
	end
end

local function Swing_Toggle(frame,arg1,arg2)
	if arg1 == "ON" then
		Swing_Load(frame)
		frame.Swing: Show()
	elseif arg1 == "OFF" then
		if frame.Swing then
			frame.Swing: Hide()
		end
	end
end

----------------------------------------------------------------
--> MEKA CastBar
----------------------------------------------------------------

local MEKA_CastBar = CreateFrame("frame", nil, E)
MEKA_CastBar: SetSize(16, 16)
MEKA_CastBar: SetPoint("CENTER", UIParent, "CENTER", 0,0)
MEKA_CastBar.Init = false

local function MEKA_CastBar_Load()
	if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Enable then
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Player then
			PlayerCastBar_Load(MEKA_CastBar)
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Pet then
			PetCastBar_Load(MEKA_CastBar)
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Target then
			F.IFF_Castbar_Toggle("ON")
		else
			F.IFF_Castbar_Toggle("OFF")
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.GCD then
			GCD_Load(MEKA_CastBar)
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Mirror then
			Mirror_Load(MEKA_CastBar)
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Swing then
			Swing_Load(MEKA_CastBar)
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.Scale then
			MEKA_CastBar: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.Scale)
		end

		MEKA_CastBar.Init = true
	end
end

local function MEKA_CastBar_Toggle(arg1, arg2)
	if arg1 == "ON" then
		MEKA_CastBar: Show()
		if not MEKA_CastBar.Init then
			MEKA_CastBar_Load()
		end
	elseif arg1 == "OFF" then
		MEKA_CastBar: Hide()
	elseif arg1 == "PLAYER" then
		if arg2 == "ON" then
			PlayerCastBar_Load(MEKA_CastBar)
			MEKA_CastBar.PlayerCastBar.EnableCastbar = true
		elseif arg2 == "OFF" then
			MEKA_CastBar.PlayerCastBar.EnableCastbar = false
			Quafe_NoticeReload()
		end
	elseif arg1 == "PLAYERNAME" then
		if arg2 == "ON" then
			if MEKA_CastBar.PlayerCastBar then
				MEKA_CastBar.PlayerCastBar.Text: Show()
			end
		elseif arg2 == "OFF" then
			if MEKA_CastBar.PlayerCastBar then
				MEKA_CastBar.PlayerCastBar.Text: Hide()
			end
		end
	elseif arg1 == "PET" then
		if arg2 == "ON" then
			PetCastBar_Load(MEKA_CastBar)
			MEKA_CastBar.PetCastBar.EnableCastbar = true
		elseif arg2 == "OFF" then
			MEKA_CastBar.PetCastBar.EnableCastbar = false
			Quafe_NoticeReload()
		end
	elseif arg1 == "TARGET" then
		F.IFF_Castbar_Toggle(arg2)
	elseif arg1 == "GCD" then
		GCD_Toggle(MEKA_CastBar, arg2)
	elseif arg1 == "MIRROR" then
		Mirror_Toggle(MEKA_CastBar, arg2)
	elseif arg1 == "SWING" then
		Swing_Toggle(MEKA_CastBar, arg2)
	elseif arg1 == "SCALE" then
		MEKA_CastBar: SetScale(arg2)
	end
end

local MEKA_CastBar_Config = {
	Database = {
		["MEKA_CastBar"] = {
			Enable = true,
			Player = true,
			PlayerSpellName = false,
			Pet = true,
			Target = true,
			GCD = true,
			Mirror = true,
			Swing = false,
		},
	},

	Config = {
		Name = "MEKA "..L['CAST_BAR'],
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_CastBar"].Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_CastBar"].Enable = false
				self.Text:SetText(L["OFF"])
				MEKA_CastBar_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_CastBar"].Enable = true
				self.Text:SetText(L["ON"])
				MEKA_CastBar_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile]["MEKA_CastBar"].Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = {
			[1] = {
				Name = L['PLAYER'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Player then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Player = false
						self.Text:SetText(L["OFF"])
						MEKA_CastBar_Toggle("PLAYER","OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Player = true
						self.Text:SetText(L["ON"])
						MEKA_CastBar_Toggle("PLAYER","ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Player then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[2] = {
				Name = L['PLAYER_SPELLNAME'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.PlayerSpellName then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.PlayerSpellName = false
						self.Text:SetText(L["OFF"])
						MEKA_CastBar_Toggle("PLAYERNAME","OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.PlayerSpellName = true
						self.Text:SetText(L["ON"])
						MEKA_CastBar_Toggle("PLAYERNAME","ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.PlayerSpellName then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[3] = {
				Name = L['PET'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Pet then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Pet = false
						self.Text:SetText(L["OFF"])
						MEKA_CastBar_Toggle("PET","OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Pet = true
						self.Text:SetText(L["ON"])
						MEKA_CastBar_Toggle("PET","ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Pet then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[4] = {
				Name = L['TARGET'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Target then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Target = false
						self.Text:SetText(L["OFF"])
						MEKA_CastBar_Toggle("TARGET","OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Target = true
						self.Text:SetText(L["ON"])
						MEKA_CastBar_Toggle("TARGET","ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Target then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[5] = {
				Name = L['GCD'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.GCD then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.GCD = false
						self.Text:SetText(L["OFF"])
						MEKA_CastBar_Toggle("GCD","OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.GCD = true
						self.Text:SetText(L["ON"])
						MEKA_CastBar_Toggle("GCD","ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.GCD then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[6] = {
				Name = L['MIRROR_BAR'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Mirror then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Mirror = false
						self.Text:SetText(L["OFF"])
						MEKA_CastBar_Toggle("MIRROR","OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Mirror = true
						self.Text:SetText(L["ON"])
						MEKA_CastBar_Toggle("MIRROR","ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Mirror then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[7] = {
				Name = L['SWING_BAR'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Swing then
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Swing = false
						self.Text:SetText(L["OFF"])
						MEKA_CastBar_Toggle("SWING","OFF")
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Swing = true
						self.Text:SetText(L["ON"])
						MEKA_CastBar_Toggle("SWING","ON")
					end
				end,
				Show = function(self)
					if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_CastBar.Swing then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
		},
	},
}

MEKA_CastBar.Load = MEKA_CastBar_Load
MEKA_CastBar.Config = MEKA_CastBar_Config
F.MEKA_CastBar_Toggle = MEKA_CastBar_Toggle
insert(E.Module, MEKA_CastBar)