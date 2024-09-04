local OW = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)
local tinsert = tinsert
local max = math.max
local format = string.format
local floor = math.floor
local tan = math.tan
local rad = math.rad

----------------------------------------------------------------
--> Left
----------------------------------------------------------------

local TAN_4 = format("%.2f",tan(rad(4)))
--[[
local HpBar_Num = {
    [1] = {21,18},
    [2] = {22,23},
    [3] = {22,23},
    [4] = {22,23},
    [5] = {22,23},
    [6] = {22,23},
}

local HB_tx1 = 1+40*6
local HB_tx2 = 39+40*6
--]]

local NUM_40 = {
    [0] = {20,   2/1024, 42/1024},
    [1] = {20,  46/1024, 86/1024},
    [2] = {20,  90/1024,130/1024},
    [3] = {20, 134/1024,174/1024},
    [4] = {20, 178/1024,218/1024},
    [5] = {20, 222/1024,262/1024},
    [6] = {20, 266/1024,306/1024},
    [7] = {20, 310/1024,350/1024},
    [8] = {20, 354/1024,394/1024},
    [9] = {20, 398/1024,438/1024},
    ["K"] = {20, 442/1024,482/1024},
    ["M"] = {20, 486/1024,526/1024},
    ["G"] = {20, 530/1024,570/1024},
    ["N"] = {20, 1023/1024,1024/1024},
}

local NUM_20 = {
    [0] = {12,   2/1024, 26/1024},
    [1] = {12,  30/1024, 54/1024},
    [2] = {12,  58/1024, 82/1024},
    [3] = {12,  86/1024,110/1024},
    [4] = {12, 114/1024,138/1024},
    [5] = {12, 142/1024,166/1024},
    [6] = {12, 170/1024,194/1024},
    [7] = {12, 198/1024,222/1024},
    [8] = {12, 226/1024,250/1024},
    [9] = {12, 254/1024,278/1024},
    ["K"] = {12, 282/1024,306/1024},
    ["M"] = {12, 310/1024,334/1024},
    ["G"] = {12, 338/1024,362/1024},
    ["/"] = {12, 366/1024,390/1024},
    ["N"] = {12, 1023/1024,1024/1024},
}

local Unit_Init = function(frame)
	F.init_Unit(frame, frame.Unit, true)
	frame: SetScript("OnEnter", F.UnitFrame_OnEnter)
	frame: SetScript("OnLeave", F.UnitFrame_OnLeave)
end

local function HpBar_Template(frame)
    local HpBar = CreateFrame("Frame", nil, frame)
    HpBar: SetSize(228,44)
    HpBar: SetPoint("BOTTOMLEFT")

    local Bar = F.Create.Texture(HpBar, "ARTWORK", 1, OW.Path("Bar1_1"), C.Color.Main1, 0.9, {256,64})
    Bar: SetPoint("CENTER")

    local BarGlow = F.Create.Texture(HpBar, "ARTWORK", 2, OW.Path("Bar1_1Glow"), C.Color.Main1, 0.4, {256,64})
    BarGlow: SetPoint("CENTER")

    local BarBg = F.Create.Texture(HpBar, "BACKGROUND", 1, OW.Path("Bar1_1"), C.Color.Main0, 0.4, {256,64})
    BarBg: SetPoint("CENTER")
    local BarBgGlow = F.Create.Texture(HpBar, "BACKGROUND", 3, OW.Path("Bar1_1"), C.Color.Main1, 0.4, {256,64})
    BarBgGlow: SetPoint("CENTER")

    local BarSd = F.Create.Texture(HpBar, "BACKGROUND", 2, OW.Path("Bar1_1Sd"), C.Color.Main0, 0.4, {256,64})
    BarSd: SetPoint("CENTER")

    local BarFill = F.Create.MaskTexture(HpBar, OW.Path("Bar1_1Fill2"), {256,64})
    BarFill: SetPoint("RIGHT", HpBar, "RIGHT", 0,0)

    Bar: AddMaskTexture(BarFill)
    BarGlow: AddMaskTexture(BarFill)

    HpBar.Bar = Bar
    HpBar.Fill = BarFill
    HpBar.Bg = BarBg
    HpBar.Sd = BarSd

    return HpBar
end

local function HpBar_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local x = - 1 - 211 * (1 - value)
        frame.Fill: SetPoint("RIGHT", frame, "RIGHT", x,0)
        frame.OldPer = value
    end
end

local function Absorb_Template(frame)
    local AbsorbBar = CreateFrame("Frame", nil, frame)
    AbsorbBar: SetSize(232,51) --472-8,110-8
    AbsorbBar: SetFrameLevel(frame:GetFrameLevel()+3)

    local Bar = F.Create.Texture(AbsorbBar, "ARTWORK", 2, OW.Path("Bar1_4"), C.Color.Main3, 0.4, {256,64})
    Bar: SetPoint("CENTER")

    local BarBd = F.Create.Texture(AbsorbBar, "ARTWORK", 3, OW.Path("Bar1_4Bd"), C.Color.Main1, 0.9, {256,64})
    BarBd: SetPoint("CENTER")

    local BarSd = F.Create.Texture(AbsorbBar, "ARTWORK", 1, OW.Path("Bar1_4Sd"), C.Color.Main0, 0.4, {256,64})
    BarSd: SetPoint("CENTER")

    local BarFill = F.Create.MaskTexture(AbsorbBar, OW.Path("Bar1_1Fill2"), {256,64})
    BarFill: SetPoint("RIGHT", AbsorbBar, "RIGHT", 0,0)

    Bar: AddMaskTexture(BarFill)
    BarBd: AddMaskTexture(BarFill)
    BarSd: AddMaskTexture(BarFill)

    local Nonius = AbsorbBar: CreateTexture(nil, "ARTWORK")
    Nonius: SetTexture(OW.Path("Bar1_3"))
    Nonius: SetSize(20,44)
    --Nonius: SetPoint("LEFT", AbsorbBar, "LEFT", 0,-7)
    --Nonius: SetPoint("LEFT", AbsorbBar, "LEFT", 210,-6+211*TAN_4)
    Nonius: SetPoint("RIGHT", frame, "RIGHT", 0,0)
    Nonius: SetTexCoord(471/512,511/512, 1/512,89/512)
    Nonius: SetVertexColor(F.Color(C.Color.Main1))

    local NoniusSd = AbsorbBar: CreateTexture(nil, "BACKGROUND")
    NoniusSd: SetTexture(OW.Path("Bar1_3"))
    NoniusSd: SetSize(20,44)
    NoniusSd: SetPoint("CENTER", Nonius, "CENTER")
    NoniusSd: SetTexCoord(471/512,511/512, 91/512,179/512)
    NoniusSd: SetVertexColor(F.Color(C.Color.Main0))
    NoniusSd: SetAlpha(0.4)
    --Nonius: Hide()

    AbsorbBar.Nonius = Nonius
    AbsorbBar.Fill = BarFill

    return AbsorbBar
end

local function Absorb_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        if value == 0 then
            frame: SetAlpha(0)
        else
            local x = - 5 - 211 * (1 - value)
            frame.Fill: SetPoint("RIGHT", frame, "RIGHT", x,0)
            frame.Nonius:SetPoint("RIGHT", frame, "RIGHT", x,7+TAN_4*x)
            frame: SetAlpha(1)
        end
        frame.OldPer = value
    end
end

local function PpBarFlash_Template(frame)
    local Flash = CreateFrame("Frame", nil, frame, "OW_PlayerPowerFlashTemplate")
    Flash: SetSize(38,38)
    
    local inner1 = Flash: CreateTexture(nil, "OVERLAY")
    inner1: SetTexture(OW.Path("Bar2_2"))
    inner1: SetSize(38,38)
    inner1: SetTexCoord(79/256,155/256, 79/256,155/256)
    inner1: SetPoint("CENTER")
    inner1: SetVertexColor(F.Color(C.Color.Main3))
    inner1: SetAlpha(0.4)
    
    --local inner2 = Flash: CreateTexture(nil, "BACKGROUND")
    --inner2: SetTexture(OW.Path("Bar2_2"))
    --inner2: SetSize(38,38)
    --inner2: SetTexCoord(1/256,77/256, 79/256,155/256)
    --inner2: SetPoint("CENTER")
    --inner2: SetVertexColor(F.Color(C.Color.Main1))
    --inner2: SetAlpha(0.8)
    
    local outter1 = Flash: CreateTexture(nil, "ARTWORK")
    outter1: SetTexture(OW.Path("Bar2_2"))
    outter1: SetSize(38,38)
    outter1: SetTexCoord(79/256,155/256, 1/256,77/256)
    outter1: SetPoint("CENTER")
    outter1: SetVertexColor(F.Color(C.Color.Main3))
    outter1: SetAlpha(0)

    local outter2 = Flash: CreateTexture(nil, "BORDER")
    outter2: SetTexture(OW.Path("Bar2_2"))
    outter2: SetSize(38,38)
    outter2: SetTexCoord(1/256,77/256, 1/256,77/256)
    outter2: SetPoint("CENTER")
    outter2: SetVertexColor(F.Color(C.Color.Main3))
    outter2: SetAlpha(0.4)

    return Flash
end

local function PpBarMana_Template(frame)
    local Mana = CreateFrame("Frame", nil, frame)
    Mana: SetSize(12,10)

    local Nonius = Mana: CreateTexture(nil, "ARTWORK")
    Nonius: SetTexture(OW.Path("Bar2_1"))
    Nonius: SetSize(12,10)
    Nonius: SetPoint("CENTER", Mana, "CENTER")
    --Nonius: SetPoint("LEFT", AbsorbBar, "LEFT", 210,-6+211*TAN_4)
    Nonius: SetTexCoord(476/512,500/512, 2/128,20/128)
    Nonius: SetVertexColor(F.Color(C.Color.Main1))

    local NoniusSd = Mana: CreateTexture(nil, "BACKGROUND")
    NoniusSd: SetTexture(OW.Path("Bar2_1"))
    NoniusSd: SetSize(12,10)
    NoniusSd: SetPoint("CENTER", Mana, "CENTER")
    NoniusSd: SetTexCoord(476/512,500/512, 23/128,43/128)
    NoniusSd: SetVertexColor(F.Color(C.Color.Main0))
    NoniusSd: SetAlpha(0.4)

    return Mana
end

local function PpBar_Template(frame)
    local PpBar = CreateFrame("Frame", nil, frame)
    PpBar: SetSize(197,22)
    PpBar: SetPoint("BOTTOMLEFT")

    local Bar = F.Create.Texture(PpBar, "ARTWORK", 1, OW.Path("Bar2_1"), C.Color.Main3, 1, {197,22}, {2/512,396/512, 2/128,46/128})
    Bar: SetPoint("LEFT")

    local BarBg = F.Create.Texture(PpBar, "BACKGROUND", 2, OW.Path("Bar2_1"), C.Color.Main0, 0.4, {197,22}, {2/512,396/512, 2/128,46/128})
    BarBg: SetPoint("CENTER")

    local BarBgGlow = F.Create.Texture(PpBar, "BACKGROUND", 3, OW.Path("Bar2_1"), C.Color.Main1, 0.4, {197,22}, {2/512,396/512, 2/128,46/128})
    BarBgGlow: SetPoint("CENTER")

    local BarSd = F.Create.Texture(PpBar, "BACKGROUND", 1, OW.Path("Bar2_1"), C.Color.Main0, 0.4, {197,22}, {2/512,396/512, 50/128,94/128})
    BarSd: SetPoint("CENTER")

    local Icon = F.Create.Texture(PpBar, "ARTWORK", 1, OW.Path("Bar2_1"), C.Color.Main1, 1, {17,20}, {400/512,434/512, 2/128,42/128})
    Icon: SetPoint("BOTTOMRIGHT", PpBar, "BOTTOMLEFT", -8,-8)

    local IconSd = F.Create.Texture(PpBar, "BACKGROUND", 1, OW.Path("Bar2_1"), C.Color.Main0, 0.4, {17,20}, {438/512,472/512, 2/128,42/128})
    IconSd: SetPoint("CENTER", Icon, "CENTER")

    local Flash = PpBarFlash_Template(PpBar)
    Flash: SetPoint("CENTER", PpBar, "CENTER", -96,-96*TAN_4)
    Flash: Show()

    local FlashModel = CreateFrame("PlayerModel", nil, Flash)
    FlashModel: SetFrameLevel(Flash:GetFrameLevel()+1)
    if F.IsClassic then
        FlashModel: SetModel("spells\\magic_precast_hand.m2")
    else
        FlashModel: SetModel(1381669) --1381669 --622770 --984698
    end
    FlashModel: SetKeepModelOnHide(true)
    FlashModel: SetSize(38,38)
    FlashModel: SetPoint("CENTER", Flash, "CENTER")
    FlashModel: Show()

    local Mana = PpBarMana_Template(PpBar)
    Mana: SetPoint("CENTER", PpBar, "CENTER", -96,-14-96*TAN_4)
    Mana: SetAlpha(0)
    Mana.State = "Hide"

    PpBar.Bar = Bar
    PpBar.Bg = Bg
    PpBar.Sd = Sd
    PpBar.Icon = Icon
    PpBar.Flash = Flash
    PpBar.Mana = Mana

    return PpBar
end

local function PpBar_Update(frame, d)
    if not d then d = 0 end
    if d < 0 then d = 0 end
    if d > 1 then d = 1 end
    if not frame.OldPer or frame.OldPer ~= d then
        local x = max(197*d, 0.0001)
        frame.Bar: SetSize(x,22)
        frame.Bar: SetTexCoord(2/512,(2+2*x)/512, 2/128,46/128)
        frame.Flash: SetPoint("CENTER", frame, "CENTER", (-96+192*d),(-96+192*d)*TAN_4)
        frame.OldPer = d
    end
end

local function PpBar_ManaUpdate(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.Mana.OldPer or frame.Mana.OldPer ~= value then
         if value == 0 and frame.Mana.State == "Show" then
            frame.Mana:SetAlpha(0)
            frame.Mana.State = "Hide"
        elseif frame.Mana.State == "Hide" then
            frame.Mana:SetAlpha(1)
            frame.Mana.State = "Show"
        end
        if frame.Mana.State == "Show" then
            local x = 192*value
            frame.Mana: SetPoint("CENTER", frame, "CENTER", (-96+x),-14+(-96+x)*TAN_4)
            frame.Mana: SetAlpha(1)
        end
        frame.Mana.OldPer = value
    end
end

local function LeftNum_Template(frame)
    local Nums = CreateFrame("Frame", nil, frame)
    Nums: SetSize(8,8)
    
    local Num40 = {}
    for i = 1,5 do
        Num40[i] = Nums: CreateTexture(nil, "ARTWORK")
        Num40[i]: SetTexture(OW.Path("Num1_1"))
        Num40[i]: SetVertexColor(F.Color(C.Color.Main1))
        Num40[i]: SetSize(NUM_40[0][1],32)
        Num40[i]: SetTexCoord(NUM_40[0][2],NUM_40[0][3], 2/256,66/256)
        if i == 1 then
            Num40[i]: SetPoint("BOTTOMLEFT", Nums, "BOTTOMLEFT", 0,0)
        else
            Num40[i]: SetPoint("BOTTOMLEFT", Num40[i-1], "BOTTOMLEFT", (NUM_40[0][1]-5),(NUM_40[0][1]-5)*TAN_4)
        end
    end

    local Num40Sd = {}
    for i = 1,5 do
        Num40Sd[i] = Nums: CreateTexture(nil, "BACKGROUND")
        Num40Sd[i]: SetTexture(OW.Path("Num1_1"))
        Num40Sd[i]: SetVertexColor(F.Color(C.Color.Main0))
        Num40Sd[i]: SetAlpha(0.4)
        Num40Sd[i]: SetSize(NUM_40[0][1],32)
        Num40Sd[i]: SetTexCoord(NUM_40[0][2],NUM_40[0][3], 70/256,134/256)
        Num40Sd[i]: SetPoint("CENTER", Num40[i], "CENTER")
    end

    local Num20 = {}
    for i = 1,6 do
        Num20[i] = Nums: CreateTexture(nil, "ARTWORK")
        Num20[i]: SetTexture(OW.Path("Num1_1"))
        Num20[i]: SetVertexColor(F.Color(C.Color.Main1))
        Num20[i]: SetSize(NUM_20[0][1],19)
        Num20[i]: SetTexCoord(NUM_20[0][2],NUM_20[0][3], 138/256,176/256)
        if i == 1 then
            Num20[i]: SetPoint("BOTTOMLEFT", Num40[5], "BOTTOMLEFT", NUM_40[0][1]+NUM_20[0][1],(NUM_40[0][1]+NUM_20[0][1])*TAN_4)
        elseif i == 6 then
            Num20[i]: SetSize(NUM_20["/"][1],19)
            Num20[i]: SetTexCoord(NUM_20["/"][2],NUM_20["/"][3], 138/256,176/256)
            --Num20[i]: SetPoint("BOTTOMLEFT", Num20[i-1], "BOTTOMLEFT", (NUM_20[0][1]-3),(NUM_20[0][1]-3)*TAN_4)
            Num20[i]: SetPoint("BOTTOMLEFT", Num40[5], "BOTTOMLEFT", (NUM_40[0][1]-6),(NUM_40[0][1]-6)*TAN_4)
        else
            Num20[i]: SetPoint("BOTTOMLEFT", Num20[i-1], "BOTTOMLEFT", (NUM_20[0][1]-4),(NUM_20[0][1]-4)*TAN_4)
        end
    end

    local Num20Sd = {}
    for i = 1,6 do
        Num20Sd[i] = Nums: CreateTexture(nil, "BACKGROUND")
        Num20Sd[i]: SetTexture(OW.Path("Num1_1"))
        Num20Sd[i]: SetVertexColor(F.Color(C.Color.Main0))
        Num20Sd[i]: SetAlpha(0.4)
        Num20Sd[i]: SetSize(NUM_20[0][1],19)
        Num20Sd[i]: SetTexCoord(NUM_20[0][2],NUM_20[0][3], 180/256,218/256)
        Num20Sd[i]: SetPoint("CENTER", Num20[i], "CENTER")

        if i == 6 then
            Num20Sd[i]: SetSize(NUM_20["/"][1],19)
            Num20Sd[i]: SetTexCoord(NUM_20["/"][2],NUM_20["/"][3], 180/256,218/256)
        end
    end

    Nums.Num40 = Num40
    Nums.Num40Sd = Num40Sd
    Nums.Num20 = Num20
    Nums.Num20Sd = Num20Sd

    return Nums
end

local function LeftNum_HpPos(frame,n)
    frame.Num40[1]: SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 6+(NUM_40[0][1]-6)*n,6+(NUM_40[0][1]-6)*n*TAN_4)
end

local function LeftNum_PpPos(frame,n)
    frame.Num20[1]: SetPoint("BOTTOMLEFT", frame.Num40[5], "BOTTOMLEFT", NUM_40[0][1]+4+(NUM_20[0][1]-4)*n,(NUM_40[0][1]+4+(NUM_20[0][1]-4)*n)*TAN_4)
end

local function LeftNum_HpUpdate(frame, d)
    if not frame.OldHpValue or frame.OldHpValue ~= d then
        local d0,d1,d2,d3,d4,d5
        local pos = 0
        if d >= 1e10 then
            d0 = d/1e9
            d5 = "G"
        elseif d >= 1e7 then
            d0 = d/1e6
            d5 = "M"
        elseif d >= 1e4 then
            d0 = d/1e3
            d5 = "K"
        else
            d0 = d
            d5 = "N"
        end

        if d5 == "N" then
            d1 = "N"
            d5,d4,d3,d2 = F.BreakNums(d0, 4)
        else
            d4,d3,d2,d1 = F.BreakNums(d0, 4)
        end

        if d1 == "N" then
            if d2 == 0 then
                d2 = "N"
                if d3 == 0 then
                    d3 = "N"
                    if d4 == 0 then
                        d4 = "N"
                        pos = -4
                    else
                        pos = -3
                    end
                else
                    pos = -2
                end
            else
                pos = -1
            end
        elseif d1 == 0 then
            d1 = "N"
            if d2 == 0 then
                d2 = "N"
                if d3 == 0 then
                    d3 = "N"
                    pos = -3
                else
                    pos = -2
                end
            else
                pos = -1
            end
        end

        frame.Num40[1]: SetTexCoord(NUM_40[d1][2],NUM_40[d1][3], 2/256,66/256)
        frame.Num40[2]: SetTexCoord(NUM_40[d2][2],NUM_40[d2][3], 2/256,66/256)
        frame.Num40[3]: SetTexCoord(NUM_40[d3][2],NUM_40[d3][3], 2/256,66/256)
        frame.Num40[4]: SetTexCoord(NUM_40[d4][2],NUM_40[d4][3], 2/256,66/256)
        frame.Num40[5]: SetTexCoord(NUM_40[d5][2],NUM_40[d5][3], 2/256,66/256)

        frame.Num40Sd[1]: SetTexCoord(NUM_40[d1][2],NUM_40[d1][3], 70/256,134/256)
        frame.Num40Sd[2]: SetTexCoord(NUM_40[d2][2],NUM_40[d2][3], 70/256,134/256)
        frame.Num40Sd[3]: SetTexCoord(NUM_40[d3][2],NUM_40[d3][3], 70/256,134/256)
        frame.Num40Sd[4]: SetTexCoord(NUM_40[d4][2],NUM_40[d4][3], 70/256,134/256)
        frame.Num40Sd[5]: SetTexCoord(NUM_40[d5][2],NUM_40[d5][3], 70/256,134/256)

        if not frame.OldHpPos or frame.OldHpPos ~= pos then
            LeftNum_HpPos(frame,pos)
            frame.OldHpPos = pos
        end

        frame.OldHpValue = d
    end
end

local function LeftNum_PpUpdate(frame, d)
    if not frame.OldPpValue or frame.OldPpValue ~= d then
        local d0,d1,d2,d3,d4,d5
        local pos = 0
        if d >= 1e10 then
            d0 = d/1e9
            d5 = "G"
        elseif d >= 1e7 then
            d0 = d/1e6
            d5 = "M"
        elseif d >= 1e4 then
            d0 = d/1e3
            d5 = "K"
        else
            d0 = d
            d5 = "N"
        end

        if d5 == "N" then
            d1 = "N"
            d5,d4,d3,d2 = F.BreakNums(d0, 4)
        else
            d4,d3,d2,d1 = F.BreakNums(d0, 4)
        end

        if d1 == "N" then
            if d2 == 0 then
                d2 = "N"
                if d3 == 0 then
                    d3 = "N"
                    if d4 == 0 then
                        d4 = "N"
                        pos = -4
                    else
                        pos = -3
                    end
                else
                    pos = -2
                end
            else
                pos = -1
            end
        elseif d1 == 0 then
            d1 = "N"
            if d2 == 0 then
                d2 = "N"
                if d3 == 0 then
                    d3 = "N"
                    pos = -3
                else
                    pos = -2
                end
            else
                pos = -1
            end
        end

        frame.Num20[1]: SetTexCoord(NUM_20[d1][2],NUM_20[d1][3], 138/256,176/256)
        frame.Num20[2]: SetTexCoord(NUM_20[d2][2],NUM_20[d2][3], 138/256,176/256)
        frame.Num20[3]: SetTexCoord(NUM_20[d3][2],NUM_20[d3][3], 138/256,176/256)
        frame.Num20[4]: SetTexCoord(NUM_20[d4][2],NUM_20[d4][3], 138/256,176/256)
        frame.Num20[5]: SetTexCoord(NUM_20[d5][2],NUM_20[d5][3], 138/256,176/256)

        frame.Num20Sd[1]: SetTexCoord(NUM_20[d1][2],NUM_20[d1][3], 180/256,218/256)
        frame.Num20Sd[2]: SetTexCoord(NUM_20[d2][2],NUM_20[d2][3], 180/256,218/256)
        frame.Num20Sd[3]: SetTexCoord(NUM_20[d3][2],NUM_20[d3][3], 180/256,218/256)
        frame.Num20Sd[4]: SetTexCoord(NUM_20[d4][2],NUM_20[d4][3], 180/256,218/256)
        frame.Num20Sd[5]: SetTexCoord(NUM_20[d5][2],NUM_20[d5][3], 180/256,218/256)

        if not frame.OldPpPos or frame.OldPpPos ~= pos then
            LeftNum_PpPos(frame,pos)
            frame.OldPpPos = pos
        end

        frame.OldPpValue = d
    end
end

local function Portrait_Artwork(frame)
    local Border = CreateFrame("Frame", nil, frame)
    Border: SetAllPoints(frame)

    local Back = CreateFrame("Frame", nil, Border)
    Back: SetSize(156,170)
    Back: SetPoint("CENTER")
    Back: SetFrameLevel(frame:GetFrameLevel())
    
    local Bg1 = Back: CreateTexture(nil, "BACKGROUND")
    Bg1: SetTexture(OW.Path("Player_Bd1"))
    Bg1: SetSize(156,170)
    Bg1: SetTexCoord(1/1024,313/1024, 1/1024,341/1024)
    Bg1: SetPoint("CENTER")
    Bg1: SetVertexColor(F.Color(C.Color.Main3))
    Bg1: SetAlpha(0.2)

    local Bd1 = Back: CreateTexture(nil, "BORDER")
    Bd1: SetTexture(OW.Path("Player_Bd1"))
    Bd1: SetSize(156,170)
    Bd1: SetTexCoord(316/1024,628/1024, 1/1024,341/1024)
    Bd1: SetPoint("CENTER")
    Bd1: SetVertexColor(F.Color(C.Color.Main3))
    Bd1: SetAlpha(0.5)

    local Bd2 = Back: CreateTexture(nil, "ARTWORK")
    Bd2: SetTexture(OW.Path("Player_Bd1"))
    Bd2: SetSize(156,170)
    Bd2: SetTexCoord(631/1024,943/1024, 1/1024,341/1024)
    Bd2: SetPoint("CENTER")
    Bd2: SetVertexColor(F.Color(C.Color.Main3))
    Bd2: SetAlpha(0.4)

    local Flash = CreateFrame("Frame", nil, Border, "OW_PlayerPortraitFlashTemplate")
	Flash: SetSize(170,170)
	Flash: SetFrameLevel(frame:GetFrameLevel()+1)
	Flash: SetPoint("CENTER", Border, "CENTER")

    local FlashBd = Flash: CreateTexture(nil, "BORDER")
    FlashBd: SetTexture(OW.Path("Player_Bd1"))
    FlashBd: SetSize(156,170)
    FlashBd: SetTexCoord(316/1024,628/1024, 1/1024,341/1024)
    FlashBd: SetPoint("CENTER")
    FlashBd: SetVertexColor(F.Color(C.Color.Main3))
    FlashBd: SetAlpha(0.75)

    Flash: Show()

    local Front = CreateFrame("Frame", nil, Border)
    Front: SetSize(156,170)
    Front: SetPoint("CENTER")
    Front: SetFrameLevel(frame:GetFrameLevel()+2)

    local Bd3 = Front: CreateTexture(nil, "ARTWORK")
    Bd3: SetTexture(OW.Path("Player_Bd1"))
    Bd3: SetSize(156,170)
    Bd3: SetTexCoord(1/1024,313/1024, 682/1024,1023/1024)
    Bd3: SetPoint("CENTER")
    Bd3: SetAlpha(1)

    local Bd4 = Back: CreateTexture(nil, "ARTWORK")
    Bd4: SetTexture(OW.Path("Player_Bd1"))
    Bd4: SetSize(156,170)
    Bd4: SetTexCoord(316/1024,628/1024, 682/1024,1023/1024)
    Bd4: SetPoint("CENTER")
    Bd4: SetAlpha(1)

    local Bd5 = Front: CreateTexture(nil, "ARTWORK")
    Bd5: SetTexture(OW.Path("Player_Bd1"))
    Bd5: SetSize(156,170)
    Bd5: SetTexCoord(316/1024,628/1024, 344/1024,684/1024)
    Bd5: SetPoint("CENTER")
    Bd5: SetAlpha(1)

    local Bd6 = Back: CreateTexture(nil, "ARTWORK")
    Bd6: SetTexture(OW.Path("Player_Bd1"))
    Bd6: SetSize(156,170)
    Bd6: SetTexCoord(631/1024,943/1024, 344/1024,684/1024)
    Bd6: SetPoint("CENTER")
    Bd6: SetAlpha(1)

    Border.Bg1 = Bg1
    Border.Bd1 = Bd1
    Border.Bd2 = Bd2
    Border.BdF = FlashBd

    return Border
end

local Portrait_ColorUpdate = function(frame, color)
    frame.Bg1: SetVertexColor(F.Color(color))
    frame.Bd1: SetVertexColor(F.Color(color))
    frame.Bd2: SetVertexColor(F.Color(color))
    frame.BdF: SetVertexColor(F.Color(color))
end

local Portrait_StatusUpdate = function(frame, event)
    if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_UPDATE_RESTING" then
        if UnitAffectingCombat("player") then
            Portrait_ColorUpdate(frame.PortraitBorder, {r=249/255, g=124/255, b=134/255})
        elseif IsResting() then
            --Portrait_ColorUpdate(frame.PortraitBorder, {r=220/255, g=182/255, b=64/255})
            Portrait_ColorUpdate(frame.PortraitBorder, {r=248/255, g=238/255, b=114/255})
        else
            Portrait_ColorUpdate(frame.PortraitBorder, C.Color.Main3)
        end
    end
end

local RaceModelList = {
    [1]  = {
        [2] = {1, 0.9, 0,0,-0.06, 0},
        [3] = {1, 0.95, 0,0.01,0, 0},
    }, --Human 人类
    [2]  = {
        [2] = {1, 0.75, 0.1,-0.01,-0.17, 10},
        [3] = {1, 0.9, 0.1,-0.02,-0.04, 0},
    }, --Orc 兽人
    [3]  = {
        [2] = {1, 0.8, 0.1,-0.02,-0.06, 0},
        [3] = {1, 0.8, 0.1,-0.035,-0.06, 0},
    }, --Dwarf 矮人
    [4]  = {
        [2] = {1, 0.85, 0.1,-0.02,-0.08, 5},
        [3] = {1, 0.9, 0.1,-0.05,-0.02, 0},
    }, --NightElf 暗夜精灵
    [5]  = {
        [2] = {1, 0.8, 0.1,-0.04,-0.10, 5},
        [3] = {1, 0.85, 0.1,-0.01,-0.02, 5},
    }, --Scourge 被遗忘者
    [6]  = {
        [2] = {1, 0.6, 0,0.00,-0.30, 10},
        [3] = {1, 0.8, 0,0.03,-0.15, 0},
    }, --Tauren 牛头人
    [7]  = {
        [2] = {1, 0.80, 0,0,-0.06, 0},
        [3] = {1, 0.85, 0,0,-0.04, 0},
    }, --Gnome 侏儒
    [8]  = {
        [2] = {1, 0.9, 0.1,-0.02,-0.04, -10},
        [3] = {1, 0.9, 0.1,-0.02,-0.04, 0},
    }, --Troll 巨魔
    [9]  = {
        [2] = {1, 0.8, 0.1,-0.08, 0, 0},
        [3] = {1, 0.8, 0.1,-0.02, 0, 0},
    }, --Goblin 哥布林
    [10] = {
        [2] = {1, 0.9, 0.1,-0.03,-0.06, 5},
        [3] = {1, 0.9, 0.1,-0.07,-0.02, -5},
    }, --BloodElf 血精灵
    [11] = {
        [2] = {1, 0.9, 0,-0.04,-0.06, 5},
        [3] = {1, 1, 0,0.02,0.02, -10}, --1022598
    }, --Draenei 德莱尼
    --[12] = {}, --FelOrc 邪兽人
    --[13] = {}, --Naga_ 娜迦
    --[14] = {}, --Broken 破碎者
    --[15] = {}, --Skeleton 骷髅
    --[16] = {}, --Vrykul 维库
    --[17] = {}, --Tuskarr 海象人
    --[18] = {}, --ForestTroll 森林巨魔
    --[19] = {}, --Taunka 牦牛人
    --[20] = {}, --NorthrendSkeleton 诺森德骷髅
    --[21] = {}, --IceTroll 冰霜巨魔
    [22] = {
        [2] = {1, 0.95, 0,0.02,-0.10, 0}, --307454
        [3] = {1, 0.98, 0,0.08,-0.04, -5}, --307453 1000764
    }, --Worgen 狼人
    --[23] = {}, --Gilnean 吉尔尼斯人
    [24] = {
        [2] = {1, 0.95, 0.0,0.02,-0.02, -5},
        [3] = {1, 0.90, 0.0,0.00,-0.02, -5},
    }, --Pandaren 熊猫人中立
    --[25] = {}, --Pandaren 熊猫人联盟
    --[26] = {}, --Pandaren 熊猫人部落
    [27] = {
        [2] = {1, 0.96, 0,0.05,-0.02, -5},
        [3] = {1, 0.95, 0.0,0.01,-0.00, 0},
    }, --Nightborne 夜之子
    --[28] = {}, --HighmountainTauren 至高岭牛头人
    --[29] = {}, --Void Elf 虚空精灵
    --[30] = {}, --LightforgedDraenei 光铸德莱尼
    [31] = {
        [2] = {1, 1, 0,-0.01,-0.00, 0},
        [3] = {1, 0.95, 0,0.05,-0.02, -5},
    }, --ZandalariTroll 赞达拉巨魔
    [32] = {
        [2] = {1, 0.95, 0,0.02,-0.04, 0},
        [3] = {1, 0.98, 0,0.01,-0.00, -10},
    }, --KulTiran 库尔提拉斯人
    --[33] = {}, --ThinHuman 瘦人
    --[34] = {}, --DarkIronDwarf 黑铁矮人
    [35] = {
        [2] = {1, 0.9, 0,0,-0.04, 0},
        [3] = {1, 0.9, 0,0,-0.04, 0},
    }, --Vulpera 狐人
    --[36] = {}, --MagharOrc 玛格汉兽人
    --[37] = {}, --Mechagnome 机械侏儒
}

RaceModelList[25] = RaceModelList[24] --Pandaren 熊猫人联盟
RaceModelList[26] = RaceModelList[24] --Pandaren 熊猫人部落
RaceModelList[28] = RaceModelList[6] --HighmountainTauren 至高岭牛头人
RaceModelList[29] = RaceModelList[10] --Void Elf 虚空精灵
RaceModelList[30] = RaceModelList[11] --LightforgedDraenei 光铸德莱尼
RaceModelList[34] = RaceModelList[3] --DarkIronDwarf 黑铁矮人
RaceModelList[36] = RaceModelList[2] --MagharOrc 玛格汉兽人
RaceModelList[37] = RaceModelList[7] --Mechagnome 机械侏儒


local RaceModelFileList = {
    [1011653] = RaceModelList[1][2], -- 人类男 狼人男人类形态
    [1000764] = RaceModelList[1][3], -- 人类女 狼人女人类形态
}

local function Portrait_UpdateScale(frame)
    --local UI_Scale = UIParent:GetScale()
    local UI_Scale = GetCVar("uiScale")
	frame: SetModelScale(0.711/(Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale*UI_Scale))
end

local SLOTS = {1,3,5,6,16,17,18} -- 1 头, 3 肩, 5 胸, 6 腰带, 16 主手, 17 副手, 18 远程
local SLOTS_NAME = {
    [1] = "HEADSLOT", 
    [3] = "SHOULDERSLOT", 
    [5] = "CHESTSLOT", 
    [6] = "WRISTSLOT", 
    [16] = "MAINHANDSLOT", 
    [17] = "SECONDARYHANDSLOT", 
    [18] = "SHOULDERSLOT"
}

local function Portrait_UpdateDress(frame, init)
    --isTransmogrified, hasPending, isPendingCollected, canTransmogrify, cannotTransmogrifyReason, hasUndo, isHideVisual, texture = C_Transmog.GetSlotInfo(slot, type)
    for k,SlotID in ipairs(SLOTS) do
        --[[
        local item = GetInventoryItemLink("player", SlotID)
        local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID = C_Transmog.GetSlotVisualInfo(SlotID, LE_TRANSMOG_TYPE_APPEARANCE);
	    --local isTransmogrified, _, _, _, _, _, isHideVisual, texture = C_Transmog.GetSlotInfo(SlotID, LE_TRANSMOG_TYPE_APPEARANCE);
        if item then
            if appliedSourceID and appliedSourceID ~= 0 then
                frame:TryOn(appliedSourceID)
            else
                frame:TryOn(baseSourceID)
            end
        else
            frame:UndressSlot(SlotID)
        end
        --]]
        if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[SlotID] then
            if F.IsClassic then
                local item = GetInventoryItemLink("player", SlotID)
                if item then
                    frame:TryOn(item)
                else
                    frame:UndressSlot(SlotID)
                end
            else
                --local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID = C_Transmog.GetSlotVisualInfo(SlotID, LE_TRANSMOG_TYPE_APPEARANCE);
                local transmogLocation = TransmogUtil.CreateTransmogLocation(SLOTS_NAME[SlotID], Enum.TransmogType.Appearance, Enum.TransmogModification.None)
                local baseSourceID, baseVisualID, appliedSourceID, appliedVisualID = C_Transmog.GetSlotVisualInfo(transmogLocation);
                if appliedSourceID and appliedSourceID ~= 0 then
                    frame:TryOn(appliedSourceID)
                elseif baseSourceID and baseSourceID ~= 0 then
                    frame:TryOn(baseSourceID)
                else
                    frame:UndressSlot(SlotID)
                end
            end
            
        else
            frame:UndressSlot(SlotID)
        end
    end
end

local PORTRAIT_RACEID, PORTRAIT_GENDER, PORTRAIT_FILEID
local function Portrait_UpdateRace(frame)
    PORTRAIT_RACEID = select(3,UnitRace("player"))
    PORTRAIT_GENDER = UnitSex("player") --1 = Neutrum / Unknown, 2 = Male, 3 = Female
    if PORTRAIT_RACEID and PORTRAIT_GENDER then
        --self: SetCustomRace(PORTRAIT_RACEID, PORTRAIT_GENDER) PORTRAIT_GENDER: 0 Male, 1 Female
        --PORTRAIT_RACEID = 2
        --PORTRAIT_GENDER = 3
        --frame: SetCustomRace(PORTRAIT_RACEID, PORTRAIT_GENDER-2)
        frame: SetAutoDress(true)
        frame: RefreshUnit()
        frame: SetAnimation(0, 0)
        PORTRAIT_FILEID = frame:GetModelFileID()

        if RaceModelFileList[PORTRAIT_FILEID] then
            frame: SetCamDistanceScale(RaceModelFileList[PORTRAIT_FILEID][1])
            frame: SetPortraitZoom(RaceModelFileList[PORTRAIT_FILEID][2])
            frame: SetPosition(RaceModelFileList[PORTRAIT_FILEID][3],RaceModelFileList[PORTRAIT_FILEID][4],RaceModelFileList[PORTRAIT_FILEID][5])
            frame: SetRotation(rad(RaceModelFileList[PORTRAIT_FILEID][6]))
        elseif RaceModelList[PORTRAIT_RACEID] and RaceModelList[PORTRAIT_RACEID][PORTRAIT_GENDER] then
            frame: SetCamDistanceScale(RaceModelList[PORTRAIT_RACEID][PORTRAIT_GENDER][1])
            frame: SetPortraitZoom(RaceModelList[PORTRAIT_RACEID][PORTRAIT_GENDER][2])
            frame: SetPosition(RaceModelList[PORTRAIT_RACEID][PORTRAIT_GENDER][3],RaceModelList[PORTRAIT_RACEID][PORTRAIT_GENDER][4],RaceModelList[PORTRAIT_RACEID][PORTRAIT_GENDER][5])
            frame: SetRotation(rad(RaceModelList[PORTRAIT_RACEID][PORTRAIT_GENDER][6]))
        else
            frame: SetCamDistanceScale(1)
            frame: SetPortraitZoom(0.9)
            frame: SetPosition(0,0,-0.05)
            frame: SetRotation(rad(0))
        end
    end
end

local function Portrait_Model(frame)
    --local Model = CreateFrame("PlayerModel", nil, frame)
    local Model = CreateFrame("DressUpModel", nil, frame)
    --Model: SetSize(74,90)
    Model: SetSize(70,110)
    --Model: SetPoint("BOTTOM", frame, "CENTER", 0,-36)
    Model: SetPoint("BOTTOM", frame, "CENTER", 0,-40)
    Model: SetFrameLevel(frame:GetFrameLevel()+1)
    --Model: SetAutoDress(true)
    Model: SetUnit("player")
    Model: SetParticlesEnabled(true)
    Model: SetSheathed(true)
    --Model: SetDoBlend()
    --Model: SetUseTransmogSkin(true)
    --Model: StopAnimKit()
    --Model: SetAnimation(804, 1)
    
    local Last = 3
    local A_Timer = frame:CreateAnimationGroup()
    A_Timer: SetLooping("NONE") --[NONE, REPEAT, or BOUNCE].
	local A_TimerAmin = A_Timer:CreateAnimation()
    A_TimerAmin: SetDuration(20)
    A_TimerAmin: SetOrder(1)
    A_Timer:SetScript("OnFinished", function(self, requested)
        if Last > 0 then
            if Last == 3 then
                A_TimerAmin: SetDuration(1)
            end
            --Portrait_UpdateRace(Model)
            Portrait_UpdateDress(Model)
            Last = Last - 1
            self:Play()
        else
            Last = 3
        end
    end)
    
    Portrait_UpdateRace(Model)
    Portrait_UpdateDress(Model)

    Model: RegisterEvent("PLAYER_LOGIN")
    --Model: RegisterEvent("PLAYER_ENTERING_WORLD")
    Model: RegisterEvent("UI_SCALE_CHANGED")
    --Model: RegisterUnitEvent("UNIT_MODEL_CHANGED", "player")
	Model: RegisterUnitEvent("UNIT_PORTRAIT_UPDATE", "player")
    --Model: RegisterEvent("PLAYER_EQUIPMENT_CHANGED")
    Model: SetScript("OnEvent", function(self,event)
        if event == "PLAYER_LOGIN" then
            A_Timer:Play()
        elseif event == "PLAYER_ENTERING_WORLD" then
            Portrait_UpdateRace(self)
            Portrait_UpdateDress(self)
            A_Timer:Play()
        elseif event == "PLAYER_EQUIPMENT_CHANGED" then
            Portrait_UpdateDress(self)
        elseif event == "UNIT_PORTRAIT_UPDATE" then
            Portrait_UpdateRace(self)
            Portrait_UpdateDress(self)
        elseif event == "UI_SCALE_CHANGED" then
            Portrait_UpdateScale(self)
        end
    end)

    Model: SetScript("OnShow", function(self)
        Portrait_UpdateDress(self)
    end)

    return Model
end

local function Badge_Template(frame)
    local Badge = CreateFrame("Frame", nil, frame)
    Badge: SetSize(34,42)
    Badge: SetFrameLevel(frame:GetFrameLevel()+4)
    
    local Bg = Badge: CreateTexture(nil, "BACKGROUND")
    Bg: SetTexture(OW.Path("Player_Bd2"))
    Bg: SetSize(34,42)
    Bg: SetTexCoord(141/256,209/256, 1/128,85/128)
    Bg: SetVertexColor(F.Color(C.Color.Alliance[2]))
    Bg: SetPoint("CENTER")
    Bg: SetAlpha(1)

    local Bd = Badge: CreateTexture(nil, "ARTWORK")
    Bd: SetTexture(OW.Path("Player_Bd2"))
    Bd: SetSize(34,42)
    Bd: SetTexCoord(1/256,69/256, 1/128,85/128)
    Bd: SetVertexColor(243/255, 244/255, 246/255)
    Bd: SetPoint("CENTER")
    Bd: SetAlpha(1)

    local BdSd = Badge: CreateTexture(nil, "BACKGROUND")
    BdSd: SetTexture(OW.Path("Player_Bd2"))
    BdSd: SetSize(34,42)
    BdSd: SetTexCoord(71/256,139/256, 1/128,85/128)
    BdSd: SetVertexColor(F.Color(C.Color.Main0))
    BdSd: SetPoint("CENTER")
    BdSd: SetAlpha(0.4)

    local Icon = Badge: CreateTexture(nil, "ARTWORK")
    Icon: SetTexture(OW.Path("Player_Bd3"))
    Icon: SetSize(24,30)
    Icon: SetTexCoord(1/128,49/128, 1/128,61/128)
    Icon: SetVertexColor(243/255, 244/255, 246/255)
    Icon: SetPoint("CENTER", Badge, "CENTER", 0,1)
    Icon: SetAlpha(1)

    local IconSd = Badge: CreateTexture(nil, "BORDER")
    IconSd: SetTexture(OW.Path("Player_Bd3"))
    IconSd: SetSize(24,30)
    IconSd: SetTexCoord(51/128,99/128, 1/128,61/128)
    IconSd: SetVertexColor(F.Color(C.Color.Main0))
    IconSd: SetPoint("CENTER")
    IconSd: SetAlpha(0.4)

    Badge.Bg = Bg
    Badge.Icon = Icon
    Badge.IconSd = IconSd

    return Badge
end

local function PVP_Flag_Update(frame, factionGroup)
    if factionGroup == "Alliance" then
        frame.Badge.Icon: SetTexCoord(1/128,49/128, 1/128,61/128)
        frame.Badge.IconSd: SetTexCoord(51/128,99/128, 1/128,61/128)
        frame.Badge.Bg: SetVertexColor(F.Color(C.Color.Alliance[2]))
    elseif factionGroup == "Horde" then
        frame.Badge.Icon: SetTexCoord(1/128,49/128, 63/128,123/128)
        frame.Badge.IconSd: SetTexCoord(51/128,99/128, 63/128,123/128)
        frame.Badge.Bg: SetVertexColor(F.Color(C.Color.Horde[2]))
    else
        frame.Badge.Icon: SetTexCoord(127/128,128/128, 127/128,128/128)
        frame.Badge.IconSd: SetTexCoord(127/128,128/128, 127/128,128/128)
    end
end

local function Player_Frame(frame)
    local Portrait = CreateFrame("Button", "Quafe_Overwatch "..L['PLAYER_FRAME'], frame, "SecureUnitButtonTemplate")
    Portrait: SetSize(156,170)
    Portrait: SetPoint("BOTTOMLEFT")
    Portrait.Unit = "player"
    Unit_Init(Portrait)

    local Portrait_Bd = Portrait_Artwork(Portrait)
    local Portrait_Model = Portrait_Model(Portrait)
    local Badge = Badge_Template(frame)
    Badge: SetPoint("TOP", Portrait_Model, "BOTTOM", 0,10)

    local HP = CreateFrame("Frame", nil, frame)
    HP: SetFrameLevel(Portrait:GetFrameLevel()+2)
    HP: SetSize(226,45)
    HP: SetPoint("BOTTOMLEFT", Portrait, "BOTTOMRIGHT", -6,50)

    local HP_Bar = HpBar_Template(HP)
    HpBar_Update(HP_Bar, 1)

    local Absorb = Absorb_Template(HP)
    Absorb: SetPoint("CENTER", HP, "CENTER", 1,0)

    local PP = CreateFrame("Frame", nil, frame)
    PP: SetSize(197,22)
    PP: SetPoint("BOTTOMLEFT", Portrait, "BOTTOMRIGHT", 20,34)

    local PP_Bar = PpBar_Template(PP)
    PpBar_Update(PP_Bar, 1)

    local Nums = LeftNum_Template(frame)
    Nums: SetPoint("BOTTOMLEFT", HP, "TOPLEFT", 8,-10)
    LeftNum_HpUpdate(Nums, 2040000)
    LeftNum_PpUpdate(Nums, 2040000)

    frame.HP = HP
    frame.HP.Bar1 = HP_Bar
    frame.HP.Absorb = Absorb
    frame.PP = PP
    frame.PP.Bar1 = PP_Bar
    frame.Portrait = Portrait
    frame.Portrait.Model = Portrait_Model
    frame.PortraitBorder = Portrait_Bd
    frame.Nums = Nums
    frame.Badge = Badge
end

local function PlayerFrame_RgEvent(frame)
    frame: RegisterEvent("PLAYER_ENTERING_WORLD")
	frame: RegisterUnitEvent("UNIT_FACTION", "player")
    frame: RegisterEvent("PLAYER_REGEN_DISABLED")
    frame: RegisterEvent("PLAYER_REGEN_ENABLED")
    frame: RegisterEvent("PLAYER_UPDATE_RESTING")
end

local function PlayerFrame_OnEvent(frame, event, ...)
    if event == "PLAYER_ENTERING_WORLD" or event == "UNIT_FACTION" then
        local ispvp = UnitIsPVP("player");
        if ispvp then
            local factionGroup = UnitFactionGroup("player")
            PVP_Flag_Update(frame, factionGroup)
        end
        frame.Badge: SetShown(ispvp)
    end
    Portrait_StatusUpdate(frame, event)
end

local function PlayerFrame_SetEvent(frame)
    frame: SetScript("OnEvent", PlayerFrame_OnEvent)
end

----------------------------------------------------------------
--> Pet
----------------------------------------------------------------

local function Pet_HpBar_Template(frame)
    local HpBar = CreateFrame("Frame", nil, frame)
    HpBar: SetSize(48,24) --96,48

    local Bar = F.Create.Texture(HpBar, "ARTWORK", 1, OW.Path("Bar4_1"), C.Color.Main1, 0.9, {64,32})
    Bar: SetPoint("CENTER")

    local BarGlow = F.Create.Texture(HpBar, "ARTWORK", 2, OW.Path("Bar4_1Glow"), C.Color.Main1, 0.4, {64,32})
    BarGlow: SetPoint("CENTER")

    local BarBg = F.Create.Texture(HpBar, "BACKGROUND", 1, OW.Path("Bar4_1"), C.Color.Main0, 0.4, {64,32})
    BarBg: SetPoint("CENTER")
    local BarBgGlow = F.Create.Texture(HpBar, "BACKGROUND", 3, OW.Path("Bar4_1"), C.Color.Main1, 0.4, {64,32})
    BarBgGlow: SetPoint("CENTER")

    local BarSd = F.Create.Texture(HpBar, "BACKGROUND", 2, OW.Path("Bar4_1Sd"), C.Color.Main0, 0.4, {64,32})
    BarSd: SetPoint("CENTER")

    local BarFill = F.Create.MaskTexture(HpBar, OW.Path("Bar1_1Fill2"), {256,64})
    BarFill: SetPoint("RIGHT", HpBar, "RIGHT", 0,0)

    Bar: AddMaskTexture(BarFill)
    BarGlow: AddMaskTexture(BarFill)

    HpBar.Fill = BarFill

    return HpBar
end

local function Pet_HpBar_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local x = 5 - 42 * (1 - value)
        frame.Fill: SetPoint("RIGHT", frame, "RIGHT", x,0)
        frame.OldPer = value
    end
end

local function Pet_Frame(frame)
    local PetFrame = CreateFrame("Button", "Quafe_Overwatch "..L['PET_FRAME'], frame, "SecureUnitButtonTemplate")
    PetFrame: SetSize(36+46,36)
    PetFrame: SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT", 292,108)
    PetFrame.Unit = "pet"
    Unit_Init(PetFrame)

    local Portrait = CreateFrame("Frame", nil, PetFrame)
    Portrait: SetSize(36,36)
    Portrait: SetPoint("BOTTOMLEFT")

    local Icon = Portrait:CreateTexture(nil, "ARTWORK")
    Icon: SetTexture(OW.Path("Pet_Bd1"))
    Icon: SetTexCoord(75/256,147/256, 1/256,73/256)
    Icon: SetSize(36,36)
    Icon: SetPoint("CENTER")
    Icon: SetVertexColor(F.Color(C.Color.Main1))

    local IconSd = Portrait:CreateTexture(nil, "BACKGROUND")
    IconSd: SetTexture(OW.Path("Pet_Bd1"))
    IconSd: SetTexCoord(1/256,73/256, 1/256,73/256)
    IconSd: SetSize(36,36)
    IconSd: SetPoint("CENTER")
    IconSd: SetAlpha(0.4)
    IconSd: SetVertexColor(F.Color(C.Color.Main0))

    local HP = CreateFrame("Frame", nil, PetFrame)
    HP: SetFrameLevel(Portrait:GetFrameLevel()+2)
    HP: SetSize(24,18)
    HP: SetPoint("BOTTOMLEFT", Portrait, "BOTTOMLEFT", 43,1)

    local HpBar = Pet_HpBar_Template(HP)
    HpBar: SetPoint("BOTTOMLEFT", HP, "BOTTOMLEFT", 0,2)

    HP.Bar = HpBar
    Pet_HpBar_Update(HP.Bar, 1)

    frame.PetFrame = PetFrame
    frame.PetFrame.HP = HP
    frame.PetFrame.Portrait = Portrait
    frame.PetFrame.Portrait.Icon = Icon
end

local function SetHappiness(frame)
    if not F.IsClassic then return end
	local happiness, damagePercentage, loyaltyRate = GetPetHappiness();
	--> 1 = unhappy, 2 = content, 3 = happy
	local hasPetUI, isHunterPet = HasPetUI();

	if ( not happiness or not isHunterPet ) then
        frame.Portrait.Icon: SetVertexColor(F.Color(C.Color.Main1))
		frame.tooltip = nil
		return;	
	end

	if ( happiness == 1 ) then
        frame.Portrait.Icon: SetVertexColor(F.Color(C.Color.Warn1))
	elseif ( happiness == 2 ) then
        frame.Portrait.Icon: SetVertexColor(F.Color(C.Color.Main2))
	elseif ( happiness == 3 ) then
        frame.Portrait.Icon: SetVertexColor(F.Color(C.Color.Main1))
	end

	frame.tooltip = _G["PET_HAPPINESS"..happiness];
	frame.tooltipDamage = format(PET_DAMAGE_PERCENTAGE, damagePercentage);
	if ( loyaltyRate < 0 ) then
		frame.tooltipLoyalty = _G["LOSING_LOYALTY"];
	elseif ( loyaltyRate > 0 ) then
		frame.tooltipLoyalty = _G["GAINING_LOYALTY"];
	else
		frame.tooltipLoyalty = nil;
	end
end

local function Happiness_OnEnter(frame)
    if F.IsClassic then
        frame: HookScript("OnEnter", function(self)
            if ( self.tooltip ) then
                GameTooltip:AddLine(" ")
                GameTooltip:AddLine(self.tooltip);
                if ( self.tooltipDamage ) then
                    GameTooltip:AddLine(self.tooltipDamage, "", 1, 1, 1);
                end
                if ( self.tooltipLoyalty ) then
                    GameTooltip:AddLine(self.tooltipLoyalty, "", 1, 1, 1);
                end
            end
            GameTooltip:Show()
        end)
    end
end

local function PetFrame_RgEvent(frame)
    if F.IsClassic then
        frame: RegisterEvent("PLAYER_ENTERING_WORLD")
        frame: RegisterUnitEvent("UNIT_PET", "player")
        frame: RegisterEvent("PET_UI_UPDATE")
        frame: RegisterEvent("UNIT_HAPPINESS")
    end
end

local function PetFrame_SetEvent(frame)
    if F.IsClassic then
        frame: SetScript("OnEvent", SetHappiness)
    end
end

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

local OW_PlayerFrame = CreateFrame("Frame", "Quafe_Overwatch.PlayerFrame", E)
OW_PlayerFrame: SetSize(156,170)
OW_PlayerFrame: SetFrameStrata("LOW")
OW_PlayerFrame.Init = false

local function OW_PlayerFrame_HpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        HpBar_Update(OW_PlayerFrame.HP.Bar1, arg2)
    elseif arg1 == "Event" then
        LeftNum_HpUpdate(OW_PlayerFrame.Nums, arg3)
    end
end

local function OW_PlayerFrame_PpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        --PpBar_Update(OW_PlayerFrame.PP.Bar1, arg2.Cur)
        PpBar_Update(OW_PlayerFrame.PP.Bar1, arg2)
    elseif arg1 == "Event" then
        --LeftNum_PpUpdate(OW_PlayerFrame.Nums, arg2.Min)
        LeftNum_PpUpdate(OW_PlayerFrame.Nums, arg3)
    end
end

local function OW_PlayerFrame_AsUpdate(arg1,arg2)
    if arg1 == "Update" then
        --Absorb_Update(OW_PlayerFrame.HP.Absorb, arg2.Cur)
        Absorb_Update(OW_PlayerFrame.HP.Absorb, arg2)
    end
end

local function OW_PlayerFrame_MnUpdate(arg1,arg2)
    if arg1 == "Update" then
        --PpBar_ManaUpdate(OW_PlayerFrame.PP.Bar1, arg2.Cur)
        PpBar_ManaUpdate(OW_PlayerFrame.PP.Bar1, arg2)
    end
end

local function OW_PetFrame_HpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Pet_HpBar_Update(OW_PlayerFrame.PetFrame.HP.Bar, arg2)
    elseif arg1 == "Event" then
       
    end
end

local function Joystick_Update(self, elapsed)
	local x2 = Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosX
	local y2 = Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosY
	local x0,y0 = OW_PlayerFrame: GetCenter()
	local x1,y1 = self: GetCenter()
	local step = floor(1/(GetFramerate())*1e3)/1e3
	if x0 ~= x1 then
		x2 = x2 + (x1-x0)*step/2
	end
	if y0 ~= y1 then
		y2 = y2 + (y1-y0)*step/2
	end
	OW_PlayerFrame: SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x2,y2)
	Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosX = x2
	Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosY = y2
    F.OW_MinimapFrame_Pos(x2,y2)
end

local function OW_PlayerFrame_Load()
    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable then
        OW_PlayerFrame: SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosX,Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.PosY)
        F.CreateJoystick(OW_PlayerFrame, 156,170, "Quafe_Overwatch "..L['PLAYER_FRAME'])
		OW_PlayerFrame.Joystick.postUpdate = Joystick_Update
        
        Player_Frame(OW_PlayerFrame)
        PlayerFrame_RgEvent(OW_PlayerFrame)
        PlayerFrame_SetEvent(OW_PlayerFrame)
        tinsert(E.UBU.Player.HP, OW_PlayerFrame_HpUpdate)
        tinsert(E.UBU.Player.PP, OW_PlayerFrame_PpUpdate)
        tinsert(E.UBU.Player.AS, OW_PlayerFrame_AsUpdate)
        tinsert(E.UBU.Player.MN, OW_PlayerFrame_MnUpdate)

        Pet_Frame(OW_PlayerFrame)
        PetFrame_RgEvent(OW_PlayerFrame.PetFrame)
        PetFrame_SetEvent(OW_PlayerFrame.PetFrame)
        Happiness_OnEnter(OW_PlayerFrame.PetFrame)
        tinsert(E.UBU.Pet.HP, OW_PetFrame_HpUpdate)

        if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale then
			OW_PlayerFrame: SetScale(Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale)
		end

        OW_PlayerFrame.Init = true
    end
end

local function OW_PlayerFrame_Toggle(arg1, arg2)
    if arg1 == "ON" then
		if not OW_PlayerFrame.Init then
			OW_PlayerFrame_Load()
		end
        if not OW_PlayerFrame:IsShown() then
			OW_PlayerFrame: Show()
		end
        PlayerFrame_OnEvent(OW_PlayerFrame, "PLAYER_ENTERING_WORLD")
        F.UBGU_ForceUpdate()
	elseif arg1 == "OFF" then
		OW_PlayerFrame: Hide()
		Quafe_NoticeReload()
	elseif arg1 == "SCALE" then
		OW_PlayerFrame: SetScale(arg2)
        Portrait_UpdateScale(OW_PlayerFrame.Portrait.Model)
    elseif arg1 == "PORTRAIT" then
        Portrait_UpdateDress(OW_PlayerFrame.Portrait.Model)
	end
end

local OW_PlayerFrame_Config = {
	Database = {
		["OW_PlayerFrame"] = {
			["Enable"] = true,
			["PosX"] = 100,
			["PosY"] = 60,
			Scale = 1,
            Portrait = {
                [1] = true,
                [3] = true,
                [5] = true,
                [6] = true,
            }
		},
	},

    Config = {
        Name = "Overwatch "..L['PLAYER_FRAME'],
        Type = "Switch",
        Click = function(self, button)
			if InCombatLockdown() then return end
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable = false
				self.Text:SetText(L["OFF"])
				OW_PlayerFrame_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable = true
				self.Text:SetText(L["ON"])
				OW_PlayerFrame_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable then
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
                    self.Slider: SetValue(Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale)
					self.Slider: HookScript("OnValueChanged", function(s, value)
                        value = floor(value*100+0.5)/100
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Scale = value
						OW_PlayerFrame_Toggle("SCALE", value)
					end)
                end,
                Show = nil,
            },
            [2] = {
                Name = L['SHOW_HEAD_SLOT'],
                Type = "Switch",
                Click = function(self, button)
                    if InCombatLockdown() then return end
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[1] then
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[1] = false
                        self.Text:SetText(L["OFF"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    else
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[1] = true
                        self.Text:SetText(L["ON"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    end
                end,
                Show = function(self)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[1] then
                        self.Text:SetText(L["ON"])
                    else
                        self.Text:SetText(L["OFF"])
                    end
                end,
            },
            [3] = {
                Name = L['SHOW_SHOULDER_SLOT'],
                Type = "Switch",
                Click = function(self, button)
                    if InCombatLockdown() then return end
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[3] then
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[3] = false
                        self.Text:SetText(L["OFF"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    else
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[3] = true
                        self.Text:SetText(L["ON"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    end
                end,
                Show = function(self)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[3] then
                        self.Text:SetText(L["ON"])
                    else
                        self.Text:SetText(L["OFF"])
                    end
                end,
            },
            [4] = {
                Name = L['SHOW_CHEST_SLOT'],
                Type = "Switch",
                Click = function(self, button)
                    if InCombatLockdown() then return end
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[5] then
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[5] = false
                        self.Text:SetText(L["OFF"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    else
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[5] = true
                        self.Text:SetText(L["ON"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    end
                end,
                Show = function(self)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[5] then
                        self.Text:SetText(L["ON"])
                    else
                        self.Text:SetText(L["OFF"])
                    end
                end,
            },
            [5] = {
                Name = L['SHOW_WAIST_SLOT'],
                Type = "Switch",
                Click = function(self, button)
                    if InCombatLockdown() then return end
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[6] then
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[6] = false
                        self.Text:SetText(L["OFF"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    else
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[6] = true
                        self.Text:SetText(L["ON"])
                        OW_PlayerFrame_Toggle("PORTRAIT")
                    end
                end,
                Show = function(self)
                    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Portrait[6] then
                        self.Text:SetText(L["ON"])
                    else
                        self.Text:SetText(L["OFF"])
                    end
                end,
            },
		},
    },
}

OW_PlayerFrame.Load = OW_PlayerFrame_Load
OW_PlayerFrame.Config = OW_PlayerFrame_Config
tinsert(E.Module, OW_PlayerFrame)