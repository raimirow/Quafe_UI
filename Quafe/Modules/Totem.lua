local P, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

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

--- ------------------------------------------------------------
--> Totem
--- ------------------------------------------------------------

local ICON_TEXTURE = {
	--萨满
	["511726"] = C.Color.G1, --图腾掌握
	["136013"] = C.Color.G1, --闪电奔涌图腾
	["135790"] = C.Color.R3, --火元素
	--死亡骑士
	["298674"] = C.Color.Bar["F5512C"], --黑暗冲裁者
	--牧师
	["136214"] = C.Color.Bar["F5512C"], --摧心魔
}

local function TotemButton_Sign(frame)
	local Sign = CreateFrame("Frame", nil, frame)
	Sign: SetSize(12,12)

	local Bg1 = frame:CreateTexture(nil, "BACKGROUND")
	Bg1: SetTexture(F.Path("FCS\\FCS1_Bg3"))
	Bg1: SetVertexColor(F.Color(C.Color.W1))
	Bg1: SetAlpha(0.6)
	Bg1: SetSize(64,64)
	Bg1: SetPoint("CENTER", Sign, "CENTER", 0,0)

	local Bg1_Glow = frame:CreateTexture(nil, "BORDER")
	Bg1_Glow: SetTexture(F.Path("FCS\\FCS1_Bg3"))
	Bg1_Glow: SetVertexColor(F.Color(C.Color.W3))
	Bg1_Glow: SetAlpha(0.1)
	Bg1_Glow: SetSize(64,64)
	Bg1_Glow: SetPoint("CENTER", Sign, "CENTER", 0,0)

	local Bd1 = frame:CreateTexture(nil, "ARTWORK")
	Bd1: SetTexture(F.Path("FCS\\FCS1_Bd3"))
	Bd1: SetVertexColor(F.Color(C.Color.W3))
	Bd1: SetAlpha(0.6)
	Bd1: SetSize(64,64)
	Bd1: SetPoint("CENTER", Sign, "CENTER", 0,0)

	frame.Sign = Sign
	frame.SignBg1 = Bg1
	frame.SignBg1Glow = Bg1_Glow
	frame.SignBd1 = Bd1

	frame.Num = {}
	frame.NumHold = CreateFrame("Frame", nil, Sign)
	frame.NumHold: SetSize(64,64)
	
	for i = 1,3 do
		frame.Num[i] = frame.NumHold:CreateTexture(nil, "OVERLAY")
		frame.Num[i]: SetTexture(F.Path("N12\\N".."9"))
		frame.Num[i]: SetVertexColor(F.Color(C.Color.W3))
		frame.Num[i]: SetAlpha(0.9)
		frame.Num[i]: SetSize(32,32)
	end
end

local function TotemButton_Main(frame)
	local Main = CreateFrame("Frame", nil, frame)
	Main: SetSize(12,12)
	Main: SetPoint("CENTER", frame, "CENTER", 0,0)

	local Bg1 = Main:CreateTexture(nil, "BACKGROUND")
	Bg1: SetTexture(F.Path("FCS\\FCS1_Background1"))
	Bg1: SetVertexColor(F.Color(C.Color.W1))
	Bg1: SetAlpha(0.6)
	Bg1: SetSize(128,128)
	Bg1: SetPoint("CENTER", Main, "CENTER", 0,0)

	local Bg1_Glow = Main:CreateTexture(nil, "BORDER")
	Bg1_Glow: SetTexture(F.Path("FCS\\FCS1_Background1"))
	Bg1_Glow: SetVertexColor(F.Color(C.Color.W3))
	Bg1_Glow: SetAlpha(0.1)
	Bg1_Glow: SetSize(128,128)
	Bg1_Glow: SetPoint("CENTER", Main, "CENTER", 0,0)

	local Bd1 = Main:CreateTexture(nil, "ARTWORK")
	Bd1: SetTexture(F.Path("FCS\\FCS1_Border1"))
	Bd1: SetVertexColor(F.Color(C.Color.W3))
	Bd1: SetAlpha(0.6)
	Bd1: SetSize(128,128)
	Bd1: SetPoint("CENTER", Main, "CENTER", 0,0)

	local Bd2 = Main:CreateTexture(nil, "ARTWORK")
	Bd2: SetTexture(F.Path("FCS\\FCS1_Border2"))
	Bd2: SetVertexColor(F.Color(C.Color.W3))
	Bd2: SetAlpha(0)
	Bd2: SetSize(128,128)
	Bd2: SetPoint("CENTER", Main, "CENTER", 0,0)

	local Bar = Main:CreateTexture(nil, "ARTWORK")
	Bar: SetTexture(F.Path("FCS\\FCS1_Bar35"))
	Bar: SetVertexColor(F.Color(C.Color.W3))
	Bar: SetAlpha(0.9)
	Bar: SetSize(128,128)
	Bar: SetPoint("CENTER", Main, "CENTER", 0,0)

	local BarBg = Main:CreateTexture(nil, "BACKGROUND")
	BarBg: SetTexture(F.Path("FCS\\FCS1_Bar50"))
	BarBg: SetVertexColor(F.Color(C.Color.W1))
	BarBg: SetAlpha(0.6)
	BarBg: SetSize(128,128)
	BarBg: SetPoint("CENTER", Main, "CENTER", 0,0)

	local BarBg_Glow = Main:CreateTexture(nil, "BORDER")
	BarBg_Glow: SetTexture(F.Path("FCS\\FCS1_Bar50"))
	BarBg_Glow: SetVertexColor(F.Color(C.Color.W3))
	BarBg_Glow: SetAlpha(0.1)
	BarBg_Glow: SetSize(128,128)
	BarBg_Glow: SetPoint("CENTER", Main, "CENTER", 0,0)

	frame.Main = Main
	frame.MainBg1 = Bg1
	frame.MainBg1Glow = Bg1_Glow
	frame.MainBd1 = Bd1
	frame.MainBd2 = Bd2
	frame.MainBar = Bar
	frame.MainBarBg = BarBg
	frame.MainBarBgGlow = BarBg_Glow
end

local function TotemButton_Rotate(f, p)
	f: SetPoint("CENTER", p, "CENTER", 335*cos(rad(f.Info.Angle)), 335*sin(rad(f.Info.Angle)))
	f.Sign: SetPoint("CENTER", p, "CENTER", 297*cos(rad(f.Info.Angle)), 297*sin(rad(f.Info.Angle)))
	F.RotateTexture(f.SignBg1, f.Info.Angle)
	F.RotateTexture(f.SignBg1Glow, f.Info.Angle)
	F.RotateTexture(f.SignBd1, f.Info.Angle)
	F.RotateTexture(f.MainBg1, f.Info.Angle)
	F.RotateTexture(f.MainBg1Glow, f.Info.Angle)
	F.RotateTexture(f.MainBd1, f.Info.Angle)
	F.RotateTexture(f.MainBd2, f.Info.Angle)
	F.RotateTexture(f.MainBar, f.Info.Angle)
	F.RotateTexture(f.MainBarBg, f.Info.Angle)
	F.RotateTexture(f.MainBarBgGlow, f.Info.Angle)
	for i = 1,3 do
		F.RotateTexture(f.Num[i], f.Info.Angle-90+(i-2)*0.8)
		f.Num[i]: SetPoint("CENTER", p, "CENTER", 295*cos(rad(f.Info.Angle-0.04+(i-2)*0.8)), 295*sin(rad(f.Info.Angle-0.04+(i-2)*0.8)))
	end
end

local function Totem_Create(frame)
	for i = 1,MAX_TOTEMS do
		local Button = CreateFrame("Frame", nil, frame)
		Button:SetSize(32,32)
		TotemButton_Main(Button)
		TotemButton_Sign(Button)
		Button.Info = {}
		Button.Info.Angle = 170-6*i
		TotemButton_Rotate(Button, P)
		Button:Hide()

		frame.Totem[i] = Button
	end
end

local function TotemButton_BarUpdate(button)
	local d = button.Info.Remain/(button.Info.Duration+F.Debug)
	if d > 1 then d = 1 end
	if d < 0 then d = 0 end
	d = floor(50*d + 0.5)
	button.MainBar:SetTexture(F.Path("FCS\\FCS1_Bar"..d))
end

local function TotemButton_NumUpdate(button)
	local d1,d2,n1,n2,n3 = 0,0,0,0,0
	local d = button.Info.Remain
	if d then
		if d < 0 then d = 0 end
		if d > 540 then d = 540 end
		if d > 99 then
			d1 = "m"
			d2 = floor(d/60)
		else
			d2 = floor(d/10)
			d1 = max(floor(d - d2*10), 0)
		end
		if d2 >= 1 then
			n1 = d2
			n2 = "b"
			n3 = d1
		else
			n1 = "b"
			n2 = d1
			n3 = "b"
		end
		button.Num[1]: SetTexture(F.Path("N12\\N"..n3))
		button.Num[2]: SetTexture(F.Path("N12\\N"..n2))
		button.Num[3]: SetTexture(F.Path("N12\\N"..n1))
		button.NumHold:Show()
	else
		button.NumHold:Hide()
	end
end

local function TotemButton_Update(button, startTime, duration, icon)
	if ( duration > 0 ) then
		button.Info.Duration = duration
		button.Info.Remain = max(duration + startTime - GetTime(), 0)
		button:SetScript("OnUpdate", function(self, elapsed)
			if F.Last25H == 0 then
				TotemButton_BarUpdate(button)
				TotemButton_NumUpdate(button)
			end
			button.Info.Remain = button.Info.Remain - elapsed
		end)
		button:Show()
	else
		button.Info.Duration = 0
		button.Info.Remain = 0
		button:SetScript("OnUpdate", nil)
		button:Hide()
	end
end

local function Totem_Update(self, event, ...)
	local _, class = UnitClass("player");
	local priorities = STANDARD_TOTEM_PRIORITIES;
	if (class == "SHAMAN") then
		priorities = SHAMAN_TOTEM_PRIORITIES;
	end
	local haveTotem, name, startTime, duration, icon
	local slot
	local button
	local buttonIndex = 1
	for i = 1, MAX_TOTEMS do
		slot = priorities[i]
		haveTotem, name, startTime, duration, icon = GetTotemInfo(slot)
		if ( haveTotem ) then
			local tex = tostring(icon)
			if ICON_TEXTURE[tex] then
				self.Totem[buttonIndex].MainBar:SetVertexColor(F.Color(ICON_TEXTURE[tex]))
			else
				self.Totem[buttonIndex].MainBar:SetVertexColor(F.Color(C.Color.W3))
			end
			self.Totem[buttonIndex].Slot = slot
			TotemButton_Update(self.Totem[buttonIndex], startTime, duration, icon)
			buttonIndex = buttonIndex + 1
		else
			self.Totem[buttonIndex].Slot = 0
			self.Totem[buttonIndex]:Hide()
		end
	end
end

local function Totem_OnEvent(frame)
	frame:RegisterEvent("PLAYER_TOTEM_UPDATE");
	frame:RegisterEvent("PLAYER_ENTERING_WORLD");
	frame:RegisterEvent("UPDATE_SHAPESHIFT_FORM");
	frame:RegisterEvent("PLAYER_TALENT_UPDATE");
	frame:SetScript("OnEvent", function(self, event, ...)
		if ( event == "PLAYER_TOTEM_UPDATE" ) then
			local slot = ...;
			if ( slot <= MAX_TOTEMS ) then
				local haveTotem, name, startTime, duration, icon = GetTotemInfo(slot);
			end
		end
		Totem_Update(self, event, ...)
	end)
end

--- ------------------------------------------------------------
--> Load
--- ------------------------------------------------------------

local Totems = CreateFrame("Frame", "Quafe_TIE_Totem", P)
local function Load()
	Totems.Totem = {}
	Totems.Info = {}
	Totem_Create(Totems)
	Totem_OnEvent(Totems)
end
Totems.Load = Load
insert(P.Module, Totems)