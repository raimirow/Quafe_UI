local P, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Local

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

----------------------------------------------------------------
--> Function
----------------------------------------------------------------

F.Debug = 0.000000001

F.Void = function() end

F.PlayerClass = select(2, UnitClass("player"))

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

----------------------------------------------------------------

F.Color = function(color, alpha)
	local c = color
	if c.r > 1 then
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
		return format("|cff%02x%02x%02x",rgb.r*255,rgb.g*255,rgb.b*255)
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
F.RotateTexture = function(texture, angle)
	local LRx, LRy = CalculateCorner(angle + 45);
	local LLx, LLy = CalculateCorner(angle + 135);
	local ULx, ULy = CalculateCorner(angle + 225);
	local URx, URy = CalculateCorner(angle - 45);

	texture: SetTexCoord(ULx, ULy, LLx, LLy, URx, URy, LRx, LRy);
end

----------------------------------------------------------------

--> 同步闪烁
F.Alpha = 0
F.Last1 = 0
F.Last2 = 0
F.Last5 = 0
F.Last10 = 0
F.Last10H = 0.05
F.Last25 = 0
F.Last25H = 0.02
local Transfer = 0
local flash = CreateFrame("Frame", nil, UIParent)
flash:SetScript("OnUpdate",function(self, elapsed)
	local step = floor((1.5/GetFramerate())*1e3)/1e3
	if Transfer == 0 then
		F.Alpha = F.Alpha + step
	elseif Transfer == 1 then
		F.Alpha = F.Alpha - step
	else
		F.Alpha = 0
		Transfer = 0
	end
	if F.Alpha <= 0 then
		F.Alpha = 0
		Transfer = 0
	elseif F.Alpha >= 1 then
		F.Alpha = 1
		Transfer = 1
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
	if not P.Value[unit].Health then
		P.Value[unit].Health = {}
	end
	P.Value[unit].Health.Per = h
	P.Value[unit].Health.Min = minHealth
	P.Value[unit].Health.Max = maxHealth
end

function F.Smooth_Absorb(unit)
	local u
	if (unit == "player") and UnitHasVehiclePlayerFrameUI("player") then
		u = "vehicle"
	elseif (unit == "pet") and UnitHasVehiclePlayerFrameUI("player") then
		u = "player"
	else
		u = unit
	end
	local TotalAbsorb = UnitGetTotalAbsorbs(u)
	P.Value[unit].Absorb.Min = TotalAbsorb
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
	if not P.Value[unit].Power then
		P.Value[unit].Power = {}
	end
	P.Value[unit].Power.Per = p
	P.Value[unit].Power.Min = minPower
	P.Value[unit].Power.Max = maxPower
	P.Value[unit].Power.Type = powerType
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
	if not P.Value[unit].Mana then
		P.Value[unit].Mana = {}
	end
	P.Value[unit].Mana.Per = per
	P.Value[unit].Mana.Min = minMana
	P.Value[unit].Mana.Max = maxMana
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

F.Smooth_Update = function(f)
	local limit = 30/GetFramerate()
	local per = f.Per or 0
	local cur = f.Cur or 0
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


function F.create_Backdrop(f, d1, d2, d3, color1,alpha1, color2,alpha2)
	local bg = CreateFrame("Frame", nil, f)
	bg: SetFrameLevel(f:GetFrameLevel()-1)
	bg: SetFrameStrata(f:GetFrameStrata())
	bg:SetPoint("TOPLEFT", -d1, d1)
	bg:SetPoint("BOTTOMLEFT", -d1, -d1)
	bg:SetPoint("TOPRIGHT", d1, d1)
	bg:SetPoint("BOTTOMRIGHT", d1, -d1)
	bg: SetBackdrop({
		bgFile = F.Path("StatusBar\\Raid"),
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
	fs:SetShadowColor(0,0,0,alpha)
	fs:SetShadowOffset(1.5,-1)
	if horizon then
		fs:SetJustifyH(horizon)
	end
	if vertical then
		fs:SetJustifyV(vertical)
	end
	return fs
end

function F.create_Texture(f, layer, texture, color, alpha)
	local tt = f:CreateTexture(nil, layer)
	if texture then
		tt:SetTexture(F.Media..texture)
	end
	if color then
		tt:SetVertexColor(F.Color(color))
	end
	if alpha then
		tt:SetAlpha(alpha)
	end
	return tt
end

function F.create_StatusBar(f, texture, orientation, rotate)
	local sb = CreateFrame("StatusBar", nil, f)
	if texture then
		sb: SetStatusBarTexture(F.Media..texture) 
	end
	if orientation then
		sb: SetOrientation(orientation)
	end
	if rotate then
		sb: SetRotatesTexture(rotate)
	end
	return sb
end

F.init_Unit = function(f, unit, showmenu)
	f: RegisterForClicks("AnyDown")
	
	f: SetAttribute("unit", unit)
	f: SetAttribute("*type1", "target")
	if showmenu then
		f: SetAttribute("*type2", "togglemenu")
	end
	if unit == "focus" then
		f: SetAttribute("shift-type1", "macro")
		f: SetAttribute("macrotext", "/clearfocus")
		f: SetAttribute("ctrl-type1", "macro")
		f: SetAttribute("macrotext", "/clearfocus")
	else
		f: SetAttribute("shift-type1", "focus")
		f: SetAttribute("ctrl-type1", "focus")
	end
	
	f: SetAttribute("toggleForVehicle", true)
	RegisterUnitWatch(f)
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
local HiddenParent = CreateFrame("Frame")
HiddenParent:Hide()

local HandleFrame = function(baseName)
	local frame
	if(type(baseName) == 'string') then
		frame = _G[baseName]
	else
		frame = baseName
	end

	if(frame) then
		frame:UnregisterAllEvents()
		frame:Hide()

		-- Keep frame hidden without causing taint
		frame:SetParent(HiddenParent)

		local health = frame.healthbar
		if(health) then
			health:UnregisterAllEvents()
		end

		local power = frame.manabar
		if(power) then
			power:UnregisterAllEvents()
		end

		local spell = frame.spellbar
		if(spell) then
			spell:UnregisterAllEvents()
		end

		local altpowerbar = frame.powerBarAlt
		if(altpowerbar) then
			altpowerbar:UnregisterAllEvents()
		end
	end
end

function F.HideUnitFrame(frame)
	HandleFrame(frame)
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

----------------------------------------------------------------
--> Scale
----------------------------------------------------------------

function F.AutoScale()
	SetCVar("useUiScale", 1)
	local height = floor(UIParent:GetHeight() + 0.5)
	local scale = GetCVar("uiScale")
	local newScale
	if height ~= 1080 then
		newScale = height*scale/1080
		SetCVar("uiScale", newScale)
		DEFAULT_CHAT_FRAME:AddMessage("Scale:"..newScale)
	end
	DEFAULT_CHAT_FRAME:AddMessage("1080 P")
end

----------------------------------------------------------------