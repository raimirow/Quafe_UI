local E, C, F, L = unpack(Quafe) -->Engine, Config, Function, Loca

--- ------------------------------------------------------------
--> API and Variable
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
local modf = math.modf

local Lerp = Lerp

----------------------------------------------------------------
--> Function
----------------------------------------------------------------

F.Debug = 0.000001

F.Void = function() end

F.PlayerClass = select(2, UnitClass("player"))
F.PlayerName = GetUnitName("player")
F.PlayerGUID = UnitGUID("player")
F.Build = select(2, GetBuildInfo())

local function CheckClassic()
	local version, build, date, tocversion = GetBuildInfo()
	--> version = "2.4.2", build = "8278", date = "May 1 2008", tocversion = 20400
	if tocversion then
		if tocversion < 20000 then
			return true
		else
			return false
		end
	end
end

--- WOW PROJECT ID
--- 1	WOW_PROJECT_MAINLINE					Retail
--- 2	WOW_PROJECT_CLASSIC						Classic Era
--- 3	WOW_PROJECT_WOWLABS						Plunderstorm
--- 5	WOW_PROJECT_BURNING_CRUSADE_CLASSIC		Burning Crusade Classic
--- 11	WOW_PROJECT_WRATH_CLASSIC				Wrath Classic
--- 14	WOW_PROJECT_CATACLYSM_CLASSIC			Cataclysm Classic

F.IsRetail = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
F.IsClassic = (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC)
F.IsCata = (WOW_PROJECT_ID == WOW_PROJECT_CATACLYSM_CLASSIC)

local function Get_WoW_Project()
	if (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE) then
		return 1 --> Retail
	elseif (WOW_PROJECT_ID == WOW_PROJECT_CLASSIC) then
		return 2 --> Classic
	else
		return 0 --> Other
	end
end
F.Project = Get_WoW_Project()
--> WOW_PROJECT_ID == WOW_PROJECT_MAINLINE == 1 -- for main line / retail
--> WOW_PROJECT_ID == WOW_PROJECT_CLASSIC == 2 -- for WoW Classic

----------------------------------------------------------------

F.rEvent = function(f, event)
    for i = 1,#event do
        f:RegisterEvent(event[i])
    end
end

F.CheckEvent = function(f,event,unit1,unit2)
	local registered = f:IsEventRegistered(event)
	if not registered then
		if unit2 then
			f:RegisterUnitEvent(event, unit1, unit2)
		elseif unit1 then
			f:RegisterUnitEvent(event, unit1)
		else
			f:RegisterEvent(event)
		end
	end
end

----------------------------------------------------------------

F.Round = function(value, idp)
	if(idp and idp > 0) then
		local mult = 10 ^ idp
		return floor(value * mult + 0.5) / mult
	end
	return floor(value + 0.5)
end

F.Clamp = function(value, min_value, max_value)
	if value > max_value then
		return max_value
	elseif value < min_value then
		return min_value
	end

	return value
end

 --[[
string.sub()
for w in gmatch(tostring(count), "(%d)") do
	insert(d, w)
end
--]]

F.BreakNums = function(value, idp)
	local nums = {}
	value = value/10^idp+F.Debug
	for i = idp,1,-1 do
		if i == 1 then
			nums[i] = modf(value*10)
		else
			nums[i],value = modf(value*10)
		end
	end
	return unpack(nums)
end

F.ShortValue = function(value)
	if value >= 1e6 then
		return ("%.2fm"):format(value / 1e6):gsub("%.?0+([km])$", "%1")
	elseif value >= 1e3 or value <= -1e3 then
		return ("%.1fk"):format(value / 1e3):gsub("%.?+([km])$", "%1")
	else
		return value
	end
end

F.FormatTime = function(s, n)
	local day, hour, minute = 86400, 3600, 60
	if s >= day then
		return format("%dd", floor(s/day + 0.5)), s % day
	elseif s >= hour then
		return format("%dh", floor(s/hour + 0.5)), s % hour
	elseif s >= minute then
		return format("%dm", floor(s/minute + 0.5)), s % minute
	elseif s >= minute / 12 then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	end
	
	if not n then
		return floor(s + 0.5), (s * 100 - floor(s * 100))/100
	else
		return format("%."..n.."f", s), (s * 100 - floor(s * 100))/100
	end
end

F.FormatNum = function(v, n, wan)
	if not n then n = 0 end
	if v < 1e4 then
		return format("%.0f", v)  
	elseif v < 1e6 then
		return format("%."..n.."fK", v/1e3)
	elseif v < 1e9 then
		return format("%."..n.."fM", v/1e6)
	elseif v < 1e12 then
		return format("%."..n.."fG", v/1e9)
	end
end
--local currencyText = BreakUpLargeNumbers(count);
--if strlenutf8(currencyText) > 5 then
--	currencyText = AbbreviateNumbers(count);
--end

function F.FormatPercent(value)
	if not value then value = 0 end
	value = value * 100
	if value >= 10 then
		return format("%d", value)
	else
		return format("%.1f", value)
	end
end

----------------------------------------------------------------

F.Color = function(color, alpha)
	local c = color
	if not (c and c.r) then return end 
	if (c.r > 1) or (c.g > 1) or (c.b > 1) then
		c.r = c.r/255
		c.g = c.g/255
		c.b = c.b/255
	end
	if alpha then
		return c.r, c.g, c.b, alpha
	else
		return c.r, c.g, c.b
	end
end

F.Hex = function(rgb)
	if rgb.r then
		if (rgb.r > 1) or (rgb.g > 1) or (rgb.b > 1) then
			return format("|cff%02x%02x%02x",rgb.r,rgb.g,rgb.b)
		else
			return format("|cff%02x%02x%02x",rgb.r*255,rgb.g*255,rgb.b*255)
		end
	else
		local r,g,b = rgb[1],rgb[2],rgb[3]
		return format("|cff%02x%02x%02x",r*255,g*255,b*255)
	end
end

F.Gradient = function(perc,a,b)
	perc = perc > 1 and 1 or perc < 0 and 0 or perc -- Stay between 0-1
	local r1,g1,b1,r2,g2,b2 = a[1],a[2],a[3],b[1],b[2],b[3]
	local r = r1+(r2-r1)*perc
	local g = g1+(g2-g1)*perc
	local b = b1+(b2-b1)*perc
	return r,g,b
end

function F.Round_XY(x,y)
	x = floor(x+0.5)
	y = floor(y+0.5)
	return x,y
end

----------------------------------------------------------------

local function CalculateCorner(angle)
	local radian = rad(angle);
	return 0.5 + cos(radian) / sqrt(2), 0.5 + sin(radian) / sqrt(2);
end
F.RotateTexture = function(texture, angle, cx, cy)
	--[[
	local LRx, LRy = CalculateCorner(angle + 45);
	local LLx, LLy = CalculateCorner(angle + 135);
	local ULx, ULy = CalculateCorner(angle + 225);
	local URx, URy = CalculateCorner(angle - 45);

	texture: SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
	--]]
	texture:SetRotation(rad(angle), cx, cy)
end

----------------------------------------------------------------

--> 同步闪烁
F.Alpha1 = 0
F.Alpha2 = 0
F.Alpha4 = 0
F.Last1 = 0
F.Last2 = 0
F.Last5 = 0
F.Last10 = 0
F.Last10H = 0.05
F.Last25 = 0
F.Last25H = 0.02

local Transfer1 = 0
local Transfer2 = 0
local Transfer4 = 0
local flash = CreateFrame("Frame", nil, UIParent)
flash:SetScript("OnUpdate",function(self, elapsed)
	--> Flash1
	local step1 = elapsed
	if Transfer1 == 0 then
		F.Alpha1 = F.Alpha1 + step1
	elseif Transfer1 == 1 then
		F.Alpha1 = F.Alpha1 - step1
	else
		F.Alpha1 = 0
		Transfer1 = 0
	end
	if F.Alpha1 <= 0 then
		F.Alpha1 = 0
		Transfer1 = 0
	elseif F.Alpha1 >= 1 then
		F.Alpha1 = 1
		Transfer1 = 1
	end

	--> Flash2
	local step2 = 2*elapsed
	if Transfer2 == 0 then
		F.Alpha2 = F.Alpha2 + step2
	elseif Transfer2 == 1 then
		F.Alpha2 = F.Alpha2 - step2
	else
		F.Alpha2 = 0
		Transfer2 = 0
	end
	if F.Alpha2 <= 0 then
		F.Alpha2 = 0
		Transfer2 = 0
	elseif F.Alpha2 >= 1 then
		F.Alpha2 = 1
		Transfer2 = 1
	end
	
	--> Flash4
	local step4 = 4*elapsed
	if Transfer4 == 0 then
		F.Alpha4 = F.Alpha4 + step4
	elseif Transfer4 == 1 then
		F.Alpha4 = F.Alpha4 - step4
	else
		F.Alpha4 = 0
		Transfer4 = 0
	end
	if F.Alpha4 <= 0 then
		F.Alpha4 = 0
		Transfer4 = 0
	elseif F.Alpha4 >= 1 then
		F.Alpha4 = 1
		Transfer4 = 1
	end
	
	if F.Last1 >= 1 then
		F.Last1 = 0
	else
		F.Last1 = F.Last1 + elapsed
	end
	
	if F.Last2 >= 0.5 then
		F.Last2 = 0
	else
		F.Last2 = F.Last2 + elapsed
	end
	
	if F.Last5 >= 0.2 then
		F.Last5 = 0
	else
		F.Last5 = F.Last5 + elapsed
	end
	
	if F.Last10 >= 0.1 then
		F.Last10 = 0
	else
		F.Last10 = F.Last10 + elapsed
	end

	if F.Last10H >= 0.1 then
		F.Last10H = 0
	else
		F.Last10H = F.Last10H + elapsed
	end
	
	if F.Last25 >= 0.04 then
		F.Last25 = 0
	else
		F.Last25 = F.Last25 + elapsed
	end

	if F.Last25H >= 0.04 then
		F.Last25H = 0
	else
		F.Last25H = F.Last25H + elapsed
	end
end)

F.FadeIn = function(f, t, a1, a2)
	if f:GetAlpha() == a1 then
		UIFrameFadeIn(f, t, a1, a2)
	end
end

F.FadeOut = function(f, t, a1, a2)
	if f:GetAlpha() == a1 then
		UIFrameFadeOut(f, t, a1, a2)
	end
end

--> 获取帧数
F.FrameRate = function()
	if GetFramerate() >= 60 then
		return 60 
	else 
		return GetFramerate()
	end
end

----------------------------------------------------------------
--> Function
----------------------------------------------------------------

F.init_Smooth = function(self)
	self.Per = 0
	self.Cur = 0
	self.Min = 0
	self.Max = 100
	self.PowerType = nil
end

if F.IsClassic then
	F.Smooth_Health = function(unit)
		local u
		--UnitInVehicleHidesPetFrame("player")
		--if (unit == "player") and UnitHasVehiclePlayerFrameUI("player") then
		--	u = "vehicle"
		--elseif (unit == "pet") and UnitHasVehiclePlayerFrameUI("player") then
		--	u = "player"
		--else
			u = unit
		--end
		local minHealth,maxHealth = UnitHealth(u),UnitHealthMax(u)
		
		local h,hv = 0,0
		if maxHealth == 0 or minHealth == 0 then
			h = 0
		else
			h = floor(minHealth/maxHealth*1e4)/1e4
		end
		if not E.Value[unit].Health then
			E.Value[unit].Health = {}
		end
		E.Value[unit].Health.Per = h
		E.Value[unit].Health.Min = minHealth
		E.Value[unit].Health.Max = maxHealth
	end

	F.Smooth_Power = function(unit)
		local u
		--if (unit == "player") and UnitHasVehiclePlayerFrameUI("player") then
		--	u = "vehicle"
		--elseif (unit == "pet") and UnitHasVehiclePlayerFrameUI("player") then
		--	u = "player"
		--else
			u = unit
		--end
		local minPower,maxPower = UnitPower(u),UnitPowerMax(u)
		local powerType = UnitPowerType(u)
		local p,pv = 0,0
		if maxPower == 0 or minPower == 0 then
			p = 0
		else
			p = floor(minPower/maxPower*1e4)/1e4
		end
		if not E.Value[unit].Power then
			E.Value[unit].Power = {}
		end
		E.Value[unit].Power.Per = p
		E.Value[unit].Power.Min = minPower
		E.Value[unit].Power.Max = maxPower
		E.Value[unit].Power.Type = powerType
	end

	F.Smooth_Absorb = function(unit)
		
	end
else
	F.Smooth_Health = function(unit)
		local u
		--UnitInVehicleHidesPetFrame("player")
		if (unit == "player") and UnitHasVehiclePlayerFrameUI("player") then
			u = "vehicle"
		elseif (unit == "pet") and UnitHasVehiclePlayerFrameUI("player") then
			u = "player"
		else
			u = unit
		end
		local minHealth,maxHealth = UnitHealth(u),UnitHealthMax(u)
		
		local h,hv = 0,0
		if maxHealth == 0 or minHealth == 0 then
			h = 0
		else
			h = floor(minHealth/maxHealth*1e4)/1e4
		end
		if not E.Value[unit].Health then
			E.Value[unit].Health = {}
		end
		E.Value[unit].Health.Per = h
		E.Value[unit].Health.Min = minHealth
		E.Value[unit].Health.Max = maxHealth
	end

	F.Smooth_Power = function(unit)
		local u
		if (unit == "player") and UnitHasVehiclePlayerFrameUI("player") then
			u = "vehicle"
		elseif (unit == "pet") and UnitHasVehiclePlayerFrameUI("player") then
			u = "player"
		else
			u = unit
		end
		local minPower,maxPower = UnitPower(u),UnitPowerMax(u)
		local powerType = UnitPowerType(u)
		local p,pv = 0,0
		if maxPower == 0 or minPower == 0 then
			p = 0
		else
			p = floor(minPower/maxPower*1e4)/1e4
		end
		if not E.Value[unit].Power then
			E.Value[unit].Power = {}
		end
		E.Value[unit].Power.Per = p
		E.Value[unit].Power.Min = minPower
		E.Value[unit].Power.Max = maxPower
		E.Value[unit].Power.Type = powerType
	end

	F.Smooth_Absorb = function(unit)
		local u
		if (unit == "player") and UnitHasVehiclePlayerFrameUI("player") then
			u = "vehicle"
		elseif (unit == "pet") and UnitHasVehiclePlayerFrameUI("player") then
			u = "player"
		else
			u = unit
		end
		local TotalAbsorb = UnitGetTotalAbsorbs(u)

		local h = 0
		if E.Value[unit].Health.Max == 0 then
			h = 0
		else
			h = floor(TotalAbsorb/E.Value[unit].Health.Max*1e4)/1e4
		end

		E.Value[unit].Absorb.Min = TotalAbsorb
		E.Value[unit].Absorb.Per = h
	end
end

function F.Smooth_Mana(unit)
	local minMana = UnitPower(unit, 0)
	local maxMana = UnitPowerMax(unit, 0)
	local per = 0
	if maxMana == 0 or minMana == 0 then
		per = 0
	else
		per = floor(minMana/maxMana*1e4)/1e4
	end
	if not E.Value[unit].Mana then
		E.Value[unit].Mana = {}
	end
	E.Value[unit].Mana.Per = per
	E.Value[unit].Mana.Min = minMana
	E.Value[unit].Mana.Max = maxMana
end

F.update_Health = function(self, unit)
	local minHealth,maxHealth = UnitHealth(unit),UnitHealthMax(unit)
	local h,hv = 0,0
	if maxHealth == 0 or minHealth == 0 then
		h = 0
	else
		h = floor(minHealth/maxHealth*1e4)/1e4
	end
	self.Health.Per = h
	self.Health.Min = minHealth
	self.Health.Max = maxHealth
end

F.update_Power = function(self, unit)
	local minPower,maxPower = UnitPower(unit),UnitPowerMax(unit)
	local powerType = UnitPowerType(unit)
	local p,pv = 0,0
	if maxPower == 0 or minPower == 0 then
		p = 0
	else
		p = floor(minPower/maxPower*1e4)/1e4
	end
	self.Power.Per = p
	self.Power.Min = minPower
	self.Power.Max = maxPower
	self.Power.PowerType = powerType
end

--[[
F.Smooth_Update = function(f)
	--local limit = 30/GetFramerate()
	local limit = 1
	local per = f.Per or 0
	local cur = f.Cur or 0
	if per ~= cur then
		local new = cur + min((per-cur)/6, max(per-cur, limit))
		if new ~= new then
			new = per
		end
		cur = floor(new*1e6+0.5)/1e6
		if abs(cur) < 1e-5 then 
			new = 0
			cur = 0 
		end
		if abs(cur - per) <= 1e-4 then
			cur = per
		end
		f.Cur = cur
	end
end
--]]

local function clamp(v, min, max)
	min = min or 0
	max = max or 1

	if v > max then
		return max
	elseif v < min then
		return min
	end

	return v
end

local function isCloseEnough(new, target, range)
	if range > 0 then
		return abs((new - target) / range) <= 0.001
	end

	return true
end

local function SmoothNumUpdate(Per, Cur)
	if abs(Per-Cur) < 0.001 then
		Cur = Per
	else
		Cur = Cur + (Per-Cur)/6
	end
	return Cur
end

F.Smooth_Update = function(frame)
	local Per = frame.Per or 0
	local Cur = frame.Cur or 0
	if Per ~= Cur then
		frame.Cur = SmoothNumUpdate(Per, Cur)
		--frame.Cur = Per
	end
end

function F.create_Backdrop(f, d1, d2, d3, color1,alpha1, color2,alpha2)
	local bg = CreateFrame("Frame", nil, f, BackdropTemplateMixin and "BackdropTemplate")
	bg: SetFrameLevel(f:GetFrameLevel()-1)
	bg: SetFrameStrata(f:GetFrameStrata())
	bg:SetPoint("TOPLEFT", -d1, d1)
	bg:SetPoint("BOTTOMLEFT", -d1, -d1)
	bg:SetPoint("TOPRIGHT", d1, d1)
	bg:SetPoint("BOTTOMRIGHT", d1, -d1)
	bg: SetBackdrop({
		--bgFile = F.Path("StatusBar\\Raid"),
		bgFile = F.Path("White"),
		edgeFile = F.Path("EdgeFile\\EdgeFile_Backdrop"), 
		edgeSize = d2,
		insets = { left = d3, right = d3, top = d3, bottom = d3 }
	})
	bg: SetBackdropColor(F.Color(color1, alpha1))
	bg: SetBackdropBorderColor(F.Color(color2, alpha2))
	f.Bg = bg
end

function F.create_Font(f, name, size, outline, alpha, horizon, vertical)
	local fs = f:CreateFontString(nil, "OVERLAY")
	fs:SetFont(name, size, outline)
	if not alpha then alpha = 1 end
	fs:SetShadowColor(0.09,0.09,0.09,alpha)
	fs:SetShadowOffset(2,-2)
	if horizon then
		fs:SetJustifyH(horizon)
	end
	if vertical then
		if vertical == "CENTER" then
			vertical = "MIDDLE"
		end
		fs:SetJustifyV(vertical)
	end
	return fs
end

function F.create_Texture(f, layer, texture, color, alpha)
	local tt = f:CreateTexture(nil, layer)
	if texture then
		tt:SetTexture(F.Path(texture))
	end
	if color then
		tt:SetVertexColor(F.Color(color))
	end
	if alpha then
		tt:SetAlpha(alpha)
	end
	return tt
end

F.Create = {}

function F.Create.Texture(frame, layer, sublayer, texture, color, alpha, size, coord)
	if type(layer) == "table" then
		local Info = layer
		Info.layer = Info.layer or "ARTWORK"
		Info.sublayer = Info.sublayer or 0  --[-8, 7] = 0
		local Dummy = frame:CreateTexture(Info.name, Info.layer, Info.template, Info.sublayer)
		if Info.texture then
			Dummy: SetTexture(Info.texture)
		end
		if Info.color then
			Dummy: SetVertexColor(F.Color(Info.color))
		end
		if Info.alpha then
			Dummy: SetAlpha(Info.alpha)
		end
		if Info.size then
			Dummy: SetSize(Info.size[1], Info.size[2])
		end
		if Info.coord then
			Dummy: SetTexCoord(Info.coord[1],Info.coord[2],Info.coord[3],Info.coord[4])
		end
		return Dummy
	else
		local Dummy = frame:CreateTexture(nil, layer, nil, sublayer)
		if texture then
			Dummy: SetTexture(texture)
		end
		if color then
			Dummy: SetVertexColor(F.Color(color))
		end
		if alpha then
			Dummy: SetAlpha(alpha)
		end
		if size then
			Dummy: SetSize(unpack(size))
		end
		if coord then
			Dummy: SetTexCoord(unpack(coord))
		end
		return Dummy
	end
end

function F.Create.MaskTexture(frame, texture, size)
	local Dummy = frame:CreateMaskTexture()
	if texture then
    	Dummy: SetTexture(texture, "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
	end
	if size then
    	Dummy: SetSize(unpack(size))
	end

	return Dummy
end

function F.Create.Font(frame, layer, fontname, fontsize, outline, textcolor, textalpha, sdcolor, sdalpha, sdoffset, horizon, vertical)
	if not frame then return end
	local DEFAULT = {
		layer = "ARTWORK",
		fontname= C.Font.Txt,
		fontsize = 14,
		outline = "",
		textcolor = nil,
		textalpha = 1,
		sdcolor = nil,
		sdalpha = 1,
		sdoffset = {0,0},
		horizon = nil,
		vertical = nil,
	}
	local Info = {}
	if not layer then
		Info = DEFAULT
	elseif type(layer) == "table" then
		Info = layer
		Info.layer = Info.layer or DEFAULT.layer
		Info.fontname = Info.fontname or DEFAULT.fontname
		Info.fontsize = Info.fontsize or DEFAULT.fontsize
		Info.outline = Info.outline or DEFAULT.outline
	else
		Info.layer = layer or DEFAULT.layer
		Info.fontname = fontname or DEFAULT.fontname
		Info.fontsize = fontsize or DEFAULT.fontsize
		Info.outline = outline or DEFAULT.outline
		Info.textcolor = textcolor or DEFAULT.textcolor
		Info.textalpha = textalpha or DEFAULT.textalpha
		Info.sdcolor = sdcolor or DEFAULT.sdcolor
		Info.sdalpha = sdalpha or DEFAULT.sdalpha
		Info.sdoffset = sdoffset or DEFAULT.sdoffset
		Info.horizon = horizon or DEFAULT.horizon
		Info.vertical = vertical or DEFAULT.vertical
	end
	local Dummy = frame:CreateFontString(nil, Info.layer, nil)
	Dummy: SetFont(Info.fontname, Info.fontsize, Info.outline)
	if Info.textcolor then
		Dummy: SetTextColor(F.Color(Info.textcolor, Info.textalpha))
	end
	if Info.sdcolor then
		Dummy: SetShadowColor(F.Color(Info.sdcolor, Info.sdalpha))
	end
	if Info.sdoffset then
		Dummy: SetShadowOffset(unpack(Info.sdoffset))
	end
	if Info.horizon then
		Dummy: SetJustifyH(Info.horizon)
	end
	if Info.vertical then
		if Info.vertical == "CENTER" then
			Info.vertical = "MIDDLE"
		end
		Dummy: SetJustifyV(Info.vertical) --TOP, MIDDLE, BOTTOM
	end
	return Dummy
end

function F.Create.Backdrop(frame, d1, circular, d2, d3, color1, alpha1, color2, alpha2)
	local Backdrop = CreateFrame("Frame", nil, frame, BackdropTemplateMixin and "BackdropTemplate")
	local DEFAULT = {
		wide = 0,
		round = false,
		border = false,
		edge = 0,
		inset = 0,
		cBg = C.Color.Config.Back,
		aBg = 1,
		cBd = C.Color.Config.Back,
		aBd = 1,
	}
	local Info = {}
	if not d1 then
		Info = DEFAULT
	elseif type(d1) == "table" then
		Info = d1
		Info.wide = Info.wide or DEFAULT.wide
		Info.round = Info.round or DEFAULT.round
		Info.border = Info.border or DEFAULT.border
		Info.edge = Info.edge or DEFAULT.edge
		Info.inset = Info.inset or DEFAULT.inset
		Info.cBg = Info.cBg or DEFAULT.cBg
		Info.aBg = Info.aBg or DEFAULT.aBg
		Info.cBd = Info.cBd or DEFAULT.cBd
		Info.aBd = Info.aBd or DEFAULT.aBd
	else
		Info.wide = d1 or DEFAULT.wide
		Info.round = circular or DEFAULT.round
		Info.edge = d2 or DEFAULT.edge
		Info.inset = d3 or DEFAULT.inset
		Info.cBg = color1 or DEFAULT.cBg
		Info.aBg = alpha1 or DEFAULT.aBg
		Info.cBd = color2 or DEFAULT.cBd
		Info.aBd = alpha2 or DEFAULT.aBd
	end
	if Info.border == true then
		Backdrop: SetFrameLevel(frame:GetFrameLevel()+1)
	else
		Backdrop: SetFrameLevel(max(frame:GetFrameLevel()-1,0))
	end
	--Backdrop: SetFrameStrata(frame:GetFrameStrata())
	if Info.border == true then
		Backdrop: SetAllPoints(frame)
	else
		Backdrop: SetPoint("TOPLEFT", -Info.wide, Info.wide)
		Backdrop: SetPoint("BOTTOMLEFT", -Info.wide, -Info.wide)
		Backdrop: SetPoint("TOPRIGHT", Info.wide, Info.wide)
		Backdrop: SetPoint("BOTTOMRIGHT", Info.wide, -Info.wide)
	end

	if Info.round == true then
		Backdrop: SetBackdrop({
			bgFile = F.Path("White"),
			edgeFile = F.Path("EdgeFile\\EdgeFile_Circular"), 
			edgeSize = Info.edge,
			insets = { left = Info.inset, right = Info.inset, top = Info.inset, bottom = Info.inset }
		})
	elseif Info.border == true then
		Backdrop: SetBackdrop({
			bgFile = F.Path("White"),
			edgeFile = F.Path("White"),
			edgeSize = Info.edge,
			insets = { left = Info.inset, right = Info.inset, top = Info.inset, bottom = Info.inset }
		})
	else
		Backdrop: SetBackdrop({
			bgFile = F.Path("White"),
			edgeFile = F.Path("EdgeFile\\EdgeFile_Backdrop"), 
			edgeSize = Info.edge,
			insets = { left = Info.inset, right = Info.inset, top = Info.inset, bottom = Info.inset }
		})
	end
	Backdrop: SetBackdropColor(F.Color(Info.cBg, Info.aBg))
	Backdrop: SetBackdropBorderColor(F.Color(Info.cBd, Info.aBd))

	return Backdrop
end

function F.create_StatusBar(f, texture, orientation, rotate)
	local sb = CreateFrame("StatusBar", nil, f, BackdropTemplateMixin and "BackdropTemplate")
	if texture then
		sb: SetStatusBarTexture(F.Path(texture))
	end
	if orientation then
		sb: SetOrientation(orientation)
	end
	if rotate then
		sb: SetRotatesTexture(rotate)
	end
	return sb
end

F.init_Unit = function(frame, unit, showmenu)
	frame: RegisterForClicks("AnyDown")
	
	frame: SetAttribute("unit", unit)
	frame: SetAttribute("*type1", "target")
	if showmenu then
		frame: SetAttribute("*type2", "togglemenu")
	end
	if unit == "focus" then
		frame: SetAttribute("shift-type1", "macro")
		frame: SetAttribute("macrotext", "/clearfocus")
		frame: SetAttribute("ctrl-type1", "macro")
		frame: SetAttribute("macrotext", "/clearfocus")
	else
		frame: SetAttribute("shift-type1", "focus")
		frame: SetAttribute("ctrl-type1", "focus")
	end
	
	frame: SetAttribute("toggleForVehicle", true)
	RegisterUnitWatch(frame)

	if F.CliqueSupport then
		F.CliqueSupport(frame, unit)
	end
end

F.UnitFrame_OnEnter = function(self)
	-- If showing newbie tips then only show the explanation
	if ( SHOW_NEWBIE_TIPS == "1" ) then
		if ( self.Unit == "player" or  self.Unit == "vehicle") then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip_AddNewbieTip(self, PARTY_OPTIONS_LABEL, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_PARTYOPTIONS);
			return;
		elseif ( self.Unit == "target" and UnitPlayerControlled("target") and not UnitIsUnit("target", "player") and not UnitIsUnit("target", "pet") ) then
			GameTooltip_SetDefaultAnchor(GameTooltip, self);
			GameTooltip_AddNewbieTip(self, PLAYER_OPTIONS_LABEL, 1.0, 1.0, 1.0, NEWBIE_TOOLTIP_PLAYEROPTIONS);
			return;
		end
	end
	F.UnitFrame_UpdateTooltip(self);
	GameTooltip: Show()
end

F.UnitFrame_OnLeave = function(self)
	self.UpdateTooltip = nil;
	if ( SHOW_NEWBIE_TIPS == "1" ) then
		GameTooltip:Hide();
	else
		GameTooltip:FadeOut();
	end
end

F.UnitFrame_UpdateTooltip = function(self)
	GameTooltip_SetDefaultAnchor(GameTooltip, self);
	if ( GameTooltip:SetUnit(self.Unit, self.hideStatusOnTooltip) ) then
		self.UpdateTooltip = F.UnitFrame_UpdateTooltip;
	else
		self.UpdateTooltip = nil;
	end

	local r, g, b = GameTooltip_UnitColor(self.Unit);
	GameTooltipTextLeft1:SetTextColor(r, g, b);
end

----------------------------------------------------------------
--> Hide Blizzard
----------------------------------------------------------------

--> from oUF
local hookedFrames = {}

local HiddenParent = CreateFrame("Frame", nil, UIParent)
HiddenParent:SetAllPoints()
HiddenParent:Hide()
--HiddenParent.unit = "player"

local function insecureHide(self)
	self:Hide()
end

local function resetParent(self, parent)
	if(parent ~= HiddenParent) then
		self:SetParent(HiddenParent)
	end
end

local HandleFrame = function(baseName, doNotReparent, show_alt)
	local frame
	if(type(baseName) == 'string') then
		frame = _G[baseName]
	else
		frame = baseName
	end

	if(frame) then
		frame:UnregisterAllEvents()
		frame:Hide()

		if(not doNotReparent) then
			frame:SetParent(HiddenParent)

			if(not hookedFrames[frame]) then
				hooksecurefunc(frame, 'SetParent', resetParent)

				hookedFrames[frame] = true
			end
		end

		local health = frame.healthBar or frame.healthbar or frame.HealthBar
		if(health) then
			health:UnregisterAllEvents()
		end

		local power = frame.manabar or frame.ManaBar
		if(power) then
			power:UnregisterAllEvents()
		end

		local spell = frame.castBar or frame.spellbar or frame.CastingBarFrame
		if(spell) then
			spell:UnregisterAllEvents()
		end

		local altpowerbar = frame.powerBarAlt or frame.PowerBarAlt
		if (not show_alt) and (altpowerbar) then
			altpowerbar:UnregisterAllEvents()
		end

		local buffFrame = frame.BuffFrame
		if(buffFrame) then
			buffFrame:UnregisterAllEvents()
		end

		local petFrame = frame.petFrame or frame.PetFrame
		if(petFrame) then
			petFrame:UnregisterAllEvents()
		end

		local totFrame = frame.totFrame
		if(totFrame) then
			totFrame:UnregisterAllEvents()
		end

		local classPowerBar = frame.classPowerBar
		if(classPowerBar) then
			classPowerBar:UnregisterAllEvents()
		end

		local ccRemoverFrame = frame.CcRemoverFrame
		if(ccRemoverFrame) then
			ccRemoverFrame:UnregisterAllEvents()
		end

		local debuffFrame = frame.DebuffFrame
		if(debuffFrame) then
			debuffFrame:UnregisterAllEvents()
		end
	end
end

function F.HideUnitFrame(frame, show_alt)
	HandleFrame(frame, false, show_alt)
end

local function RemoveAnchor(f)
	for i, alertSubSystem in pairs(AlertFrame.alertFrameSubSystems) do
		if alertSubSystem.anchorFrame == f then
			tremove(AlertFrame.alertFrameSubSystems, i)
			return 
		end
	end
end

function F.HideFrame(frame, unrevent, unanchor)
	if type(frame) == "string" then
		frame = _G[frame]
	end

	if not frame then
		return
	end

	if frame.UnregisterAllEvents then
		if unrevent then
			frame:UnregisterAllEvents()
		end
        frame:SetParent(HiddenParent)
    else
		frame.Show = frame.Hide
	end
	
	if unanchor then
		RemoveAnchor(frame)
	end
end

function F.IsAddonEnabled(name)
	local state
	for i = 1,C_AddOns.GetNumAddOns() do
		local addon, title, notes, loadable, reason, security, updateAvailable = C_AddOns.GetAddOnInfo(i)
		if addon == name then
			state = (C_AddOns.GetAddOnEnableState(i, UnitName("player"))) or 0
			if state == 0 then
				state = nil
			end
			if (reason and (reason == "DISABLED" or reason == "DEP_DISABLED")) then
				state = nil
			end
		end
	end

	return state
end

----------------------------------------------------------------
--> Scale
----------------------------------------------------------------

function F.AutoScale()
	SetCVar("useUiScale", 1)
	--local ScreenDPIScale = GetScreenDPIScale()
	local height = floor(UIParent:GetHeight() + 0.5)
	local scale = GetCVar("uiScale")
	local newScale
	if height ~= 1080 then
		newScale = height*scale/1080
		SetCVar("uiScale", newScale)
		DEFAULT_CHAT_FRAME:AddMessage("Scale:"..newScale)
	end
	--DEFAULT_CHAT_FRAME:AddMessage("1080 P")
end

----------------------------------------------------------------

F.Avoid_Clash = 0

function F.Avoid_Clash_Update()
	if F.IsAddonEnabled("ElvUI") then
		F.Avoid_Clash = 1
	elseif F.IsAddonEnabled("EuiScript") then
		F.Avoid_Clash = 1
	end
end