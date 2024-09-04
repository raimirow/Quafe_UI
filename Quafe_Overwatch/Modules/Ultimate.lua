local OW = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> API and Variable
----------------------------------------------------------------

local _G = getfenv(0)
local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local asin = math.asin
local cos = math.cos
local acos = math.acos
local tan = math.tan
local atan = math.atan
local rad = math.rad
local modf = math.modf
local GetTime = _G.GetTime

----------------------------------------------------------------
--> CENTER
----------------------------------------------------------------

local NUM_40 = {
    [0] = {20,   2/512, 42/512},
    [1] = {16,  46/512, 78/512},
    [2] = {20,  90/512,130/512},
    [3] = {20, 134/512,174/512},
    [4] = {20, 178/512,218/512},
    [5] = {20, 222/512,262/512},
    [6] = {20, 266/512,306/512},
    [7] = {20, 310/512,350/512},
    [8] = {20, 354/512,394/512},
    [9] = {20, 398/512,438/512},
    ["%"] = {18, 442/512,478/512},
    ["N"] = {4, 511/512,512/512},
}

local function PpBar_Template(frame)
    local PpBar = CreateFrame("Frame", nil, frame)
    PpBar: SetSize(118,118)
    PpBar: SetPoint("CENTER")

    local Bar = CreateFrame("Frame", nil, PpBar)
    Bar: SetAllPoints(PpBar)

    local Bar1 = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("Bar3_2"), C.Color.Main2, 0.9, {59,118}, {1/1024,119/1024, 1/512,237/512})
    Bar1: SetPoint("RIGHT", Bar, "CENTER")

    local Bar1Sd = F.Create.Texture(Bar, "ARTWORK", 1, OW.Path("Bar3_2"), C.Color.Main2, 0.9, {59,118}, {1/1024,119/1024, 1/512,237/512})
    Bar1Sd: SetPoint("RIGHT", Bar, "CENTER")

    local Bar2 = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("Bar3_2"), C.Color.Main2, 0.9, {59,118}, {119/1024,237/1024, 1/512,237/512})
    Bar2: SetPoint("LEFT", Bar, "CENTER")

    local Bar2Sd = F.Create.Texture(Bar, "ARTWORK", 1, OW.Path("Bar3_2"), C.Color.Main2, 0.9, {59,118}, {119/1024,237/1024, 1/512,237/512})
    Bar2Sd: SetPoint("LEFT", Bar, "CENTER")

    local BarBg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("Bar3_3"), C.Color.Main0, 0.4, {118,118}, {1/512,237/512, 1/512,237/512})
    BarBg: SetPoint("CENTER", Bar, "CENTER")

    local BarBgSd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("Bar3_3"), C.Color.Main0, 0.4, {118,118}, {239/512,475/512, 1/512,237/512})
    BarBgSd: SetPoint("CENTER", Bar, "CENTER")

    local BarBgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("Bar3_3"), C.Color.Main1, 0.4, {118,118}, {1/512,237/512, 1/512,237/512})
    BarBgGlow: SetPoint("CENTER", Bar, "CENTER")

    local Ring1 = F.Create.MaskTexture(Bar, OW.Path("Bar_Ring"), {256,256})
    Ring1: SetPoint("CENTER", Bar, "CENTER", 0, 0)

    local Ring2 = F.Create.MaskTexture(Bar, OW.Path("Bar_Ring"), {256,256})
    Ring2: SetPoint("CENTER", Bar, "CENTER", 0, 0)

    Bar1: AddMaskTexture(Ring1)
    Bar1Sd: AddMaskTexture(Ring1)
    Bar2: AddMaskTexture(Ring2)
    Bar2Sd: AddMaskTexture(Ring2)

    local Bd1 = F.Create.Texture(PpBar, "ARTWORK", 1, OW.Path("Bar3_3"), C.Color.Main2, 0.9, {118,118}, {1/512,237/512, 239/512,475/512})
    Bd1: SetPoint("CENTER")

    local Bd1Sd = F.Create.Texture(PpBar, "BACKGROUND", 1, OW.Path("Bar3_3"), C.Color.Main0, 0.4, {118,118}, {239/512,475/512, 239/512,475/512})
    Bd1Sd: SetPoint("CENTER")

    local Bd2 = F.Create.Texture(PpBar, "ARTWORK", 1, OW.Path("Ultimate_Bd1"), C.Color.Main1, 0.4, {160,160}, {2/1024,322/1024, 2/512,322/512})
    Bd2: SetPoint("CENTER")

    local Bd2Sd = F.Create.Texture(PpBar, "BACKGROUND", 1, OW.Path("Ultimate_Bd1"), C.Color.Main1, 0.4, {160,160}, {326/1024,646/1024, 2/512,322/512})
    Bd2Sd: SetPoint("CENTER")

    PpBar.Ring1 = Ring1
    PpBar.Ring2 = Ring2

    return PpBar
end

local function PpBar_Update(frame, value)
    if not value then value = 0 end
    --value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local d1 = F.Clamp(value, 0,0.5) * 360 - 270.01
        local d2 = F.Clamp(value, 0.5,1) * 360 - 270.01
        frame.Ring1: SetRotation(rad(d1), 0.5,0.5)
        frame.Ring2: SetRotation(rad(d2), 0.5,0.5)
    end
end


local function PpFull_Template(frame)
    local Full = CreateFrame("Frame", nil, frame)
    Full: SetSize(118,118)
    Full: SetPoint("CENTER")
    Full: SetAlpha(1)

    local Icon = Full: CreateTexture(nil, "ARTWORK")
    Icon: SetTexture(F.Path("Watcher\\Valkyrie"))
    Icon: SetVertexColor(243/255, 244/255, 246/255)
    Icon: SetAlpha(0.9)
    Icon: SetPoint("CENTER")
    Icon: SetSize(64,64)
    --Icon: SetTexCoord(326/1024,646/1024, 2/512,322/512)

    Full.Icon = Icon

    return Full
end

local function PpNum_Template(frame)
    local Nums = CreateFrame("Frame", nil, frame)
    Nums: SetSize(32,32)
    Nums: SetAlpha(0)
    Nums._Show = false
    
    local Num40 = {}
    for i = 1,3 do
        Num40[i] = Nums: CreateTexture(nil, "ARTWORK")
        Num40[i]: SetTexture(OW.Path("Num2_1"))
        Num40[i]: SetVertexColor(243/255, 244/255, 246/255)
        Num40[i]: SetSize(NUM_40[0][1],32)
        Num40[i]: SetTexCoord(NUM_40[0][2],NUM_40[0][3], 1/256,65/256)
        if i == 1 then
            Num40[i]: SetPoint("RIGHT", Nums, "RIGHT", 0,0)
        else
            Num40[i]: SetPoint("BOTTOMRIGHT", Num40[i-1], "BOTTOMLEFT", 5,0)
        end
    end

    local Num40Sd = {}
    for i = 1,3 do
        Num40Sd[i] = Nums: CreateTexture(nil, "ARTWORK")
        Num40Sd[i]: SetTexture(OW.Path("Num2_1"))
        Num40Sd[i]: SetVertexColor(F.Color(C.Color.Main0))
        Num40Sd[i]: SetAlpha(0.4)
        Num40Sd[i]: SetSize(NUM_40[0][1],32)
        Num40Sd[i]: SetTexCoord(NUM_40[0][2],NUM_40[0][3], 1/256,65/256)
        Num40Sd[i]: SetPoint("CENTER", Num40[i], "CENTER")
    end

    Nums.Num40 = Num40
    Nums.Num40Sd = Num40Sd

    return Nums
end

local function PpNum_PpUpdate(frame, parent, p, v, power_type)
    if (not frame.OldValue) or (frame.OldValue ~= d) or (not frame.OldType) or (frame.OldType ~= power_type) then
        if power_type == 0 and p >= 1 then
            if frame._Show then
                parent.Full: SetAlpha(1)
                frame: SetAlpha(0)
                frame._Show = false
            end
            return
        else
            if not frame._Show then
                parent.Full: SetAlpha(0)
                frame: SetAlpha(1)
                frame._Show = true
            end
        end
        local d1,d2,d3
        if power_type == 0 then
            d1 = "%"
            d2,d3 = F.BreakNums(100*p, 3)
        else
            d1,d2,d3 = F.BreakNums(F.Clamp(v, 0, 999), 3)
        end

        if d1 == "%" then
            if p < 0.1 then
                d3 = "N"
                frame: SetSize(NUM_40[d2][1]+NUM_40[d1][1], 32)
            else
                frame: SetSize(NUM_40[d3][1]+NUM_40[d2][1]+NUM_40[d1][1]-5, 32)
            end
        else
            if v < 10 then
                d2 = "N"
                d3 = "N"
                frame: SetSize(NUM_40[d1][1]-4, 32)
            elseif v < 100 then
                d3 = "N"
                frame: SetSize(NUM_40[d2][1]+NUM_40[d1][1]-7, 32)
            else
                frame: SetSize(NUM_40[d3][1]+NUM_40[d2][1]+NUM_40[d1][1]-10, 32)
            end
        end

        frame.Num40[1]: SetSize(NUM_40[d1][1],32)
        frame.Num40[1]: SetTexCoord(NUM_40[d1][2],NUM_40[d1][3], 1/256,65/256)
        frame.Num40[2]: SetSize(NUM_40[d2][1],32)
        frame.Num40[2]: SetTexCoord(NUM_40[d2][2],NUM_40[d2][3], 1/256,65/256)
        frame.Num40[3]: SetSize(NUM_40[d3][1],32)
        frame.Num40[3]: SetTexCoord(NUM_40[d3][2],NUM_40[d3][3], 1/256,65/256)

        frame.Num40Sd[1]: SetSize(NUM_40[d1][1],32)
        frame.Num40Sd[1]: SetTexCoord(NUM_40[d1][2],NUM_40[d1][3], 68/256,132/256)
        frame.Num40Sd[2]: SetSize(NUM_40[d2][1],32)
        frame.Num40Sd[2]: SetTexCoord(NUM_40[d2][2],NUM_40[d2][3], 68/256,132/256)
        frame.Num40Sd[3]: SetSize(NUM_40[d3][1],32)
        frame.Num40Sd[3]: SetTexCoord(NUM_40[d3][2],NUM_40[d3][3], 68/256,132/256)
    end
end

local function Ultimate_UpdateAlpha(frame, arg)
    local alpha = arg or Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlphaOutCombat or 1
    if UnitAffectingCombat("player") then
        frame: SetAlpha(1)
    else
        frame: SetAlpha(alpha)
    end
end

local function Ultimate_Frame(frame)
    local PP = PpBar_Template(frame)
    local Full = PpFull_Template(frame)
    local Nums = PpNum_Template(frame)
    Nums: SetPoint("CENTER")

    frame: RegisterEvent("PLAYER_ENTERING_WORLD")
    frame: RegisterEvent("PLAYER_REGEN_DISABLED")
    frame: RegisterEvent("PLAYER_REGEN_ENABLED")
    frame: SetScript("OnEvent", function(self, event, ...)
        Ultimate_UpdateAlpha(frame)
    end)

    frame.PP = PP
    frame.Full = Full
    frame.Nums = Nums
end

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

local OW_UltimateFrame = CreateFrame("Frame", "Quafe_Overwatch.Ultimate", E, "SecureHandlerStateTemplate")
OW_UltimateFrame: SetSize(118,118)
OW_UltimateFrame: SetPoint("CENTER", UIParent, "BOTTOM", 0,220)
OW_UltimateFrame: SetFrameStrata("LOW")
OW_UltimateFrame.Visibility = "[petbattle]hide; show"
OW_UltimateFrame.Init = false

local function OW_UltimateFrame_HpUpdate(arg1,arg2)
    if arg1 == "Update" then
        --HpBar_Update(OW_UltimateFrame.HP.Bar1, arg2.Per)
    elseif arg1 == "Event" then
        --LeftNum_HpUpdate(OW_UltimateFrame.Nums, arg2.Min)
    end
end

local function OW_UltimateFrame_PpUpdate(arg1,arg2,arg3,arg4,arg5)
    if arg1 == "Update" then
        PpBar_Update(OW_UltimateFrame.PP, arg2)
    elseif arg1 == "Event" then
        PpNum_PpUpdate(OW_UltimateFrame.Nums, OW_UltimateFrame, arg2, arg3, arg5)
    end
end

local function OW_UltimateFrame_AsUpdate(arg1,arg2)
    if arg1 == "Update" then
        --Absorb_Update(OW_UltimateFrame.HP.Absorb, arg2.Per)
    end
end

local function OW_UltimateFrame_MnUpdate(arg1,arg2)
    if arg1 == "Update" then
        --PpBar_ManaUpdate(OW_UltimateFrame.PP.Mana, arg2.Per)
    end
end

local function Joystick_Update(self, elapsed)
	local x2 = Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosX
	local y2 = Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosY
	local x0,y0 = OW_UltimateFrame: GetCenter()
	local x1,y1 = self: GetCenter()
	local step = floor(1/(GetFramerate())*1e3)/1e3
	if x0 ~= x1 then
		x2 = x2 + (x1-x0)*step/2
	end
	if y0 ~= y1 then
		y2 = y2 + (y1-y0)*step/2
	end
    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlignCenter then
	    OW_UltimateFrame: SetPoint("CENTER", UIParent, "BOTTOM", 0,y2)
    else
        OW_UltimateFrame: SetPoint("CENTER", UIParent, "BOTTOM", x2,y2)
    end
	Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosX = x2
	Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosY = y2
end

local function OW_UltimateFrame_Load()
    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Enable then
        if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlignCenter then
            OW_UltimateFrame: SetPoint("CENTER", UIParent, "BOTTOM", 0,Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosY)
        else
            OW_UltimateFrame: SetPoint("CENTER", UIParent, "BOTTOM", Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosX,Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosY)
        end
        F.CreateJoystick(OW_UltimateFrame, 118,118, "Quafe.Overwatch "..L['ULTIMATE_FRAME'])
		OW_UltimateFrame.Joystick.postUpdate = Joystick_Update

        Ultimate_Frame(OW_UltimateFrame)
        --tinsert(E.UBU.Player.HP, OW_UltimateFrame_HpUpdate)
        tinsert(E.UBU.Player.PP, OW_UltimateFrame_PpUpdate)
        --tinsert(E.UBU.Player.AS, OW_UltimateFrame_AsUpdate)
        --tinsert(E.UBU.Player.MN, OW_UltimateFrame_MnUpdate)
        RegisterStateDriver(OW_UltimateFrame, "visibility", OW_UltimateFrame.Visibility)
        --UnregisterStateDriver(OW_UltimateFrame, "visibility")

        if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Scale then
			OW_UltimateFrame: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Scale)
		end

        OW_UltimateFrame.Init = true
    end
end

local function OW_UltimateFrame_Toggle(arg1, arg2)
    if arg1 == "ON" then
        if not OW_UltimateFrame.Init then
            OW_UltimateFrame_Load()
        else
            RegisterStateDriver(OW_UltimateFrame, "visibility", OW_UltimateFrame.Visibility)
        end
        if not OW_UltimateFrame:IsShown() then
			OW_UltimateFrame: Show()
		end
        F.UBGU_ForceUpdate()
    elseif arg1 == "OFF" then
        UnregisterStateDriver(OW_UltimateFrame, "visibility")
        OW_UltimateFrame: Hide()
        --Quafe_NoticeReload()
    elseif arg1 == "Scale" then
        OW_UltimateFrame: SetScale(arg2)
    elseif arg1 == "Alpha" then
        Ultimate_UpdateAlpha(OW_UltimateFrame, arg2)
    elseif arg1 == "Center" then
        if arg2 == "ON" then
            OW_UltimateFrame: SetPoint("CENTER", UIParent, "BOTTOM", 0,Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosY)
        elseif arg2 == "OFF" then
            OW_UltimateFrame: SetPoint("CENTER", UIParent, "BOTTOM", Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosX,Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.PosY)
        end
    end
end

local OW_UltimateFrame_Config = {
	Database = {
		["OW_UltimateFrame"] = {
			["Enable"] = false,
			["PosX"] = 0,
			["PosY"] = 220,
			Scale = 1,
            AlignCenter = true,
            AlphaOutCombat = 1,
		},
	},
    
    Config = {
        Name = "Overwatch "..L['ULTIMATE_FRAME'],
        Type = "Switch",
        Click = function(self, button)
			if InCombatLockdown() then return end
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Enable = false
				self.Text:SetText(L["OFF"])
				OW_UltimateFrame_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Enable = true
				self.Text:SetText(L["ON"])
				OW_UltimateFrame_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
        Sub = {
			[1] = {
                Name = L['SCALE'],
                Type = "Slider",
                State = "ALL",
				Click = nil,
                Load = function(self)
                    self.Slider: SetMinMaxValues(0.5, 2)
					self.Slider: SetValueStep(0.05)
                    self.Slider: SetValue(Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Scale)
					self.Slider: HookScript("OnValueChanged", function(s, value)
                        value = floor(value*100+0.5)/100
						OW_UltimateFrame_Toggle("Scale", value)
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.Scale = value
					end)
                end,
                Show = nil,
            },
            [2] = {
                Name = L['ALPHA_OUTCOMBAT'],
                Type = "Slider",
                State = "ALL",
				Click = nil,
                Load = function(self)
                    self.Slider: SetMinMaxValues(0, 1)
					self.Slider: SetValueStep(0.05)
                    self.Slider: SetValue(Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlphaOutCombat)
					self.Slider: HookScript("OnValueChanged", function(s, value)
                        value = floor(value*100+0.5)/100
						OW_UltimateFrame_Toggle("Alpha", value)
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlphaOutCombat = value
					end)
                end,
                Show = nil,
            },
            [3] = {
                Name = L['ALIGN_CENTER'],
                Type = "Switch",
                Click = function(self, button)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlignCenter then
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlignCenter = false
                        self.Text:SetText(L["OFF"])
                        OW_UltimateFrame_Toggle("Center", "OFF")
                    else
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlignCenter = true
                        self.Text:SetText(L["ON"])
                        OW_UltimateFrame_Toggle("Center", "ON")
                    end
                end,
                Show = function(self)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_UltimateFrame.AlignCenter then
                        self.Text:SetText(L["ON"])
                    else
                        self.Text:SetText(L["OFF"])
                    end
                end,
            },
		},
    },
}

OW_UltimateFrame.Load = OW_UltimateFrame_Load
OW_UltimateFrame.Config = OW_UltimateFrame_Config
tinsert(E.Module, OW_UltimateFrame)

