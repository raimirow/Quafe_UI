local OW = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)
local rad = math.rad
local sin = math.sin
local cos = math.cos
local floor = math.floor
local ceil = math.ceil

--local LibThreatClassic = F.IsClassic and LibStub:GetLibrary("ThreatClassic-1.0")
local LibThreatClassic = F.IsClassic and LibStub:GetLibrary("LibThreatClassic2")
local function UnitThreatSituationAlter(unit, target)
	if F.IsClassic and LibThreatClassic then
    	return LibThreatClassic:UnitThreatSituation(unit, target)
	else
		return UnitThreatSituation(unit, target)
	end
end
local function UnitDetailedThreatSituationAlter(unit, target)
	if F.IsClassic and LibThreatClassic then
		return LibThreatClassic:UnitDetailedThreatSituation(unit, target)
	else
		return UnitDetailedThreatSituation(unit, target)
	end
	--isTanking, threatStatus, threatPercent, rawThreatPercent, threatValue
end

----------------------------------------------------------------
--> 
----------------------------------------------------------------

local function Bar1_Template(frame, direction)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(16,16)
    Bar: SetPoint("CENTER")

    local Bar_Fill = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar1"), C.Color.Main1, 0.9, {512,512})
    local Bar_Fill1 = F.Create.Texture(Bar, "ARTWORK", 3, OW.Path("HUD_Bar1_Fill2"), C.Color.Main3, 0.6, {512,512})
    local Bar_Bg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("HUD_Bar1"), C.Color.Main0, 0.4, {512,512})
    local Bar_BgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("HUD_Bar1"), C.Color.Main1, 0.4, {512,512})
    local Bar_Sd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("HUD_Bar1_Sd"), C.Color.Main0, 0.4, {512,512})
    local Bar_Glow = F.Create.Texture(Bar, "ARTWORK", 4, OW.Path("HUD_Bar1_Glow"), {r=243/255,g=244/255,b=246/255}, 0.2, {512,512})

    local FlashI = {}
    local FlashO = {}
    local d
    for i = 1,10 do
        if direction == "LEFT" then
            d = rad(-131.3-(30.9/9*(i-1)))
        else
            d = rad(131.3+(30.9/9*(i-1)) - 180)
        end
        FlashI[i] = F.Create.Texture(Bar, "OVERLAY", 1, OW.Path("HUD_Bar1_Ex1"), C.Color.Warn1, 0.8, {128,128})
        FlashI[i]: SetPoint("CENTER", Bar, "CENTER", 379*cos(d), 379*sin(d))
        FlashI[i]: SetRotation(d)
        FlashI[i].D = d
        FlashI[i].Num = 0
        FlashI[i]: SetAlpha(0)

        FlashO[i] = F.Create.Texture(Bar, "OVERLAY", 1, OW.Path("HUD_Bar1_Ex1"), C.Color.Warn1, 0.8, {128,128})
        FlashO[i]: SetPoint("CENTER", Bar, "CENTER", 379*cos(d), 379*sin(d))
        FlashO[i]: SetRotation(d)
        FlashO[i].D = d
        FlashO[i].Num = 0
        FlashO[i]: SetAlpha(0)
    end

    local Ring = F.Create.MaskTexture(Bar, OW.Path("Bar_Ring"), {1024,1024})
    Ring: SetPoint("CENTER", Bar, "CENTER", 0, 0)

    local Ring1 = F.Create.MaskTexture(Bar, OW.Path("Bar_Ring"), {1024,1024})
    Ring1: SetPoint("CENTER", Bar, "CENTER", 0, 0)
    Ring1: SetRotation(rad(180), {x=0.5, y=0.5})

    Bar_Fill: AddMaskTexture(Ring)
    Bar_Glow: AddMaskTexture(Ring)
    Bar_Fill1: AddMaskTexture(Ring1)

    if direction == "LEFT" then
        Bar_Fill: SetTexCoord(0,1,0,1)
        Bar_Fill: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Fill1: SetTexCoord(0,1,0,1)
        Bar_Fill1: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(0,1,0,1)
        Bar_Bg: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(0,1,0,1)
        Bar_BgGlow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(0,1,0,1)
        Bar_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(0,1,0,1)
        Bar_Glow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Ring.Base = 50.3
        Ring.Coef = -1

        local RingI = F.Create.MaskTexture(Bar, OW.Path("HUD_Bar1_Ex3"), {512,512})
        RingI: SetPoint("TOPRIGHT", Bar, "CENTER")

        local RingO = F.Create.MaskTexture(Bar, OW.Path("HUD_Bar1_Ex2"), {512,512})
        RingO: SetPoint("TOPRIGHT", Bar, "CENTER")

        for i = 1,10 do
            FlashI[i]:AddMaskTexture(RingI)
            FlashO[i]:AddMaskTexture(RingO)
        end
    elseif direction == "RIGHT" then
        Bar_Fill: SetTexCoord(1,0,0,1)
        Bar_Fill: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Fill1: SetTexCoord(1,0,0,1)
        Bar_Fill1: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(1,0,0,1)
        Bar_Bg: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(1,0,0,1)
        Bar_BgGlow: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(1,0,0,1)
        Bar_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(1,0,0,1)
        Bar_Glow: SetPoint("TOPLEFT", Bar, "CENTER")
        Ring.Base = -50.3
        Ring.Coef = 1

        local RingI = F.Create.MaskTexture(Bar, OW.Path("HUD_Bar1_Ex5"), {512,512})
        RingI: SetPoint("TOPLEFT", Bar, "CENTER")

        local RingO = F.Create.MaskTexture(Bar, OW.Path("HUD_Bar1_Ex4"), {512,512})
        RingO: SetPoint("TOPLEFT", Bar, "CENTER")

        for i = 1,10 do
            FlashI[i]:AddMaskTexture(RingI)
            FlashO[i]:AddMaskTexture(RingO)
        end
    end

    local TIMER_STOP = true
    local DummyTimer = Bar:CreateAnimationGroup()
    DummyTimer: SetLooping("REPEAT")

	local DummyAmin = DummyTimer:CreateAnimation()
    DummyAmin: SetDuration(0.02)
    DummyAmin: SetOrder(1)
    
	DummyTimer:SetScript("OnLoop", function(self)
        for i = 1,10 do
            if FlashI[i].Num > 0 then
                if FlashI[i].Num == 20 then
                    FlashI[i]: SetAlpha(0.8)
                    FlashO[i]: SetAlpha(0.8)
                end
                FlashI[i].Num = max(FlashI[i].Num - 1, 0)
                FlashI[i]: SetPoint("CENTER", Bar, "CENTER", (379+FlashI[i].Num)*cos(FlashI[i].D), (379+FlashI[i].Num)*sin(FlashI[i].D))
                FlashO[i]: SetPoint("CENTER", Bar, "CENTER", (379-FlashI[i].Num)*cos(FlashO[i].D), (379-FlashI[i].Num)*sin(FlashO[i].D))
                if FlashI[i].Num <= 0 then
                    FlashI[i]: SetAlpha(0)
                    FlashO[i]: SetAlpha(0)
                end
                TIMER_STOP = false
            end
        end
        if TIMER_STOP then
            self:Stop()
        end
	end)
    DummyTimer: SetScript("OnStop", function(self)
        for i = 1,10 do
            FlashI[i]: SetAlpha(0)
            FlashO[i]: SetAlpha(0)
            FlashI[i].Num = 0
        end
    end)

    Bar:SetScript("OnHide", function(self)
        DummyTimer: Stop()
    end)
	--DummyTimer:Play()
	--DummyTimer:Stop()
    
    Bar.Ring = Ring
    Bar.Ring1 = Ring1
    Bar.Fill = Bar_Fill
    Bar.Fill1 = Bar_Fill1
    Bar.Flash = Flash
    Bar.FlashI = FlashI
    --Bar.FlashO = FlashO
    Bar.Timer = DummyTimer

    Bar.FlashValueHold = 10

    return Bar
end

local function Bar1_UpdateFlash(frame, value)
    value = value * 10
    local f_value = floor(value)
    local c_value = ceil(value)
    if c_value < frame.FlashValueHold then
        for i = c_value + 1, frame.FlashValueHold do
            frame.FlashI[i].Num = 20
        end
        frame.FlashValueHold = c_value
        if not frame.Timer:IsPlaying() then
            frame.Timer:Play()
        end
        --frame.Timer:Show()
    elseif f_value > frame.FlashValueHold then
        frame.FlashValueHold = f_value
    end
end

local function Bar1_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local degree = frame.Ring.Base + frame.Ring.Coef * 34.3 * value
        frame.Ring: SetRotation(rad(degree), {x=0.5, y=0.5})
        Bar1_UpdateFlash(frame, value)

        if (not frame.OldPer) and (value <= 0.2) then
            frame.Fill: SetVertexColor(F.Color(C.Color.Warn1))
        elseif (not frame.OldPer) and (value > 0.2) then
            frame.Fill: SetVertexColor(F.Color(C.Color.Main1))
        elseif (value <= 0.2 and frame.OldPer > 0.2) then
            frame.Fill: SetVertexColor(F.Color(C.Color.Warn1))
        elseif (value > 0.2 and frame.OldPer <= 0.2) then
            frame.Fill: SetVertexColor(F.Color(C.Color.Main1))
        end

        frame.OldPer = value
    end
end

local function Bar1_Ring1_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local degree = frame.Ring.Base + 180 + frame.Ring.Coef * 34.3 * (1-value)
        frame.Ring1: SetRotation(rad(degree), {x=0.5, y=0.5})
        frame.OldPer = value
    end
end

local function Bar2_Template(frame, direction)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(16,16)
    Bar: SetPoint("CENTER")

    local Bar_Fill = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar2"), C.Color.Main3, 0.9, {512,512})
    local Bar_Bg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("HUD_Bar2"), C.Color.Main0, 0.4, {512,512})
    local Bar_BgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("HUD_Bar2"), C.Color.Main1, 0.4, {512,512})
    local Bar_Sd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("HUD_Bar2_Sd"), C.Color.Main0, 0.4, {512,512})
    local Bar_Glow = F.Create.Texture(Bar, "ARTWORK", 3, OW.Path("HUD_Bar2_Glow"), {r=243/255,g=244/255,b=246/255}, 0.2, {512,512})
    local Nonius = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar2_N1"), C.Color.Main3, 0.9, {512,16})
    local NoniusSd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("HUD_Bar2_N1_Sd"), C.Color.Main0, 0.4, {512,16})
    Nonius: SetPoint("RIGHT", Bar, "CENTER")
    NoniusSd: SetPoint("RIGHT", Bar, "CENTER")

    local Ring = Bar: CreateMaskTexture()
    Ring: SetTexture(OW.Path("HUD_Ring"), "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    Ring: SetSize(1024,1024)
    Ring: SetPoint("CENTER", Bar, "CENTER", 0, 0)

    Bar_Fill: AddMaskTexture(Ring)
    Bar_Glow: AddMaskTexture(Ring)

    if direction == "LEFT" then
        Bar_Fill: SetTexCoord(0,1,0,1)
        Bar_Fill: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(0,1,0,1)
        Bar_Bg: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(0,1,0,1)
        Bar_BgGlow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(0,1,0,1)
        Bar_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(0,1,0,1)
        Bar_Glow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Ring.Base = 50.3
        Ring.Coef = -1
        Ring.BaseN = -0.9
    elseif direction == "RIGHT" then
        Bar_Fill: SetTexCoord(1,0,0,1)
        Bar_Fill: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(1,0,0,1)
        Bar_Bg: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(1,0,0,1)
        Bar_BgGlow: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(1,0,0,1)
        Bar_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(1,0,0,1)
        Bar_Glow: SetPoint("TOPLEFT", Bar, "CENTER")
        Ring.Base = -50.3
        Ring.Coef = 1
        Ring.BaseN = 1 + 180
    end

    Bar.Ring = Ring
    Bar.Fill = Bar_Fill
    Bar.Nonius = Nonius
    Bar.NoniusSd = NoniusSd

    return Bar
end

local function Bar2_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local degree = frame.Ring.Base + frame.Ring.Coef * 34 * value
        frame.Ring: SetRotation(rad(degree), {x=0.5, y=0.5})

        degree = frame.Ring.Base + frame.Ring.BaseN + frame.Ring.Coef * 32.5 * value
        frame.Nonius: SetRotation(rad(degree), {x=1, y=0.5})
        frame.NoniusSd: SetRotation(rad(degree), {x=1, y=0.5})

        frame.OldPer = value
    end
end

local function Bar3_Template(frame, direction)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(16,16)
    Bar: SetPoint("CENTER")
    Bar: SetAlpha(0)
    Bar.State = "Hide"

    local Bar_Fill = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar3"), C.Color.Main3, 0.9, {512,256})
    local Bar_Bg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("HUD_Bar3"), C.Color.Main0, 0.4, {512,256})
    local Bar_BgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("HUD_Bar3"), C.Color.Main1, 0.4, {512,256})
    local Bar_Sd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("HUD_Bar3_Sd"), C.Color.Main0, 0.4, {512,256})
    local Bar_Glow = F.Create.Texture(Bar, "ARTWORK", 3, OW.Path("HUD_Bar3_Glow"), {r=243/255,g=244/255,b=246/255}, 0.2, {512,256})
    local Nonius = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar3_N1"), C.Color.Main3, 0.9, {512,16})
    local NoniusSd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("HUD_Bar3_N1_Sd"), C.Color.Main0, 0.4, {512,16})
    Nonius: SetPoint("RIGHT", Bar, "CENTER")
    NoniusSd: SetPoint("RIGHT", Bar, "CENTER")

    local Bd1 = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar3_Bd1"), C.Color.Main1, 0.9, {512,256})
    local Bd1_Sd = F.Create.Texture(Bar, "ARTWORK", 1, OW.Path("HUD_Bar3_Bd1_Sd"), C.Color.Main0, 0.4, {512,256})

    local Ring = Bar: CreateMaskTexture()
    Ring: SetTexture(OW.Path("HUD_Ring"), "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    Ring: SetSize(1024,1024)
    Ring: SetPoint("CENTER", Bar, "CENTER", 0, 0)

    Bar_Fill: AddMaskTexture(Ring)
    Bar_Glow: AddMaskTexture(Ring)

    if direction == "LEFT" then
        Bar_Fill: SetTexCoord(0,1,0,1)
        Bar_Fill: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(0,1,0,1)
        Bar_Bg: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(0,1,0,1)
        Bar_BgGlow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(0,1,0,1)
        Bar_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(0,1,0,1)
        Bar_Glow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bd1: SetTexCoord(0,1,0,1)
        Bd1: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bd1_Sd: SetTexCoord(0,1,0,1)
        Bd1_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
        Ring.Base = 29.7
        Ring.Coef = -1
        Ring.BaseN = -0.6
    elseif direction == "RIGHT" then
        Bar_Fill: SetTexCoord(1,0,0,1)
        Bar_Fill: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(1,0,0,1)
        Bar_Bg: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(1,0,0,1)
        Bar_BgGlow: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(1,0,0,1)
        Bar_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(1,0,0,1)
        Bar_Glow: SetPoint("TOPLEFT", Bar, "CENTER")
        Bd1: SetTexCoord(1,0,0,1)
        Bd1: SetPoint("TOPLEFT", Bar, "CENTER")
        Bd1_Sd: SetTexCoord(1,0,0,1)
        Bd1_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
        Ring.Base = -29.7
        Ring.Coef = 1
        Ring.BaseN = 0.6 + 180
    end

    Bar.Ring = Ring
    Bar.Fill = Bar_Fill
    Bar.Nonius = Nonius
    Bar.NoniusSd = NoniusSd

    return Bar
end

local function Bar3_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        if value == 0 and frame.State == "Show" then
            frame:SetAlpha(0)
            frame.State = "Hide"
        elseif frame.State == "Hide" then
            frame:SetAlpha(1)
            frame.State = "Show"
        end
        if frame.State == "Show" then
            local degree = frame.Ring.Base + frame.Ring.Coef * 13.7 * value
            frame.Ring: SetRotation(rad(degree), 0.5,0.5)

            degree = frame.Ring.Base + frame.Ring.BaseN + frame.Ring.Coef * 12.5 * value
            frame.Nonius: SetRotation(rad(degree), 1,0.5)
            frame.NoniusSd: SetRotation(rad(degree), 1,0.5)
        end

        frame.OldPer = value
    end
end

local function Bar4_Template(frame, direction)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(16,16)
    Bar: SetPoint("CENTER")
    Bar: SetAlpha(0)
    Bar.State = "Hide"

    local Bar_Fill = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar4"), C.Color.Main3, 0.9, {512,256})
    local Bar_Bg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("HUD_Bar4"), C.Color.Main0, 0.4, {512,256})
    local Bar_BgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("HUD_Bar4"), C.Color.Main1, 0.4, {512,256})
    local Bar_Sd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("HUD_Bar4_Sd"), C.Color.Main0, 0.4, {512,256})
    local Bar_Glow = F.Create.Texture(Bar, "ARTWORK", 3, OW.Path("HUD_Bar4_Glow"), {r=243/255,g=244/255,b=246/255}, 0.2, {512,256})

    local Bd1 = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar4_Bd1"), C.Color.Main1, 0.9, {512,256})
    local Bd1_Sd = F.Create.Texture(Bar, "ARTWORK", 1, OW.Path("HUD_Bar4_Bd1_Sd"), C.Color.Main0, 0.4, {512,256})

    local Ring = Bar: CreateMaskTexture()
    Ring: SetTexture(OW.Path("HUD_Ring"), "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    Ring: SetSize(1024,1024)
    Ring: SetPoint("CENTER", Bar, "CENTER", 0, 0)

    Bar_Fill: AddMaskTexture(Ring)
    Bar_Glow: AddMaskTexture(Ring)

    if direction == "LEFT" then
        Bar_Fill: SetTexCoord(0,1,0,1)
        Bar_Fill: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(0,1,0,1)
        Bar_Bg: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(0,1,0,1)
        Bar_BgGlow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(0,1,0,1)
        Bar_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(0,1,0,1)
        Bar_Glow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bd1: SetTexCoord(0,1,0,1)
        Bd1: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bd1_Sd: SetTexCoord(0,1,0,1)
        Bd1_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
        Ring.Base = 29.7
        Ring.Coef = -1
    elseif direction == "RIGHT" then
        Bar_Fill: SetTexCoord(1,0,0,1)
        Bar_Fill: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(1,0,0,1)
        Bar_Bg: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(1,0,0,1)
        Bar_BgGlow: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(1,0,0,1)
        Bar_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(1,0,0,1)
        Bar_Glow: SetPoint("TOPLEFT", Bar, "CENTER")
        Bd1: SetTexCoord(1,0,0,1)
        Bd1: SetPoint("TOPLEFT", Bar, "CENTER")
        Bd1_Sd: SetTexCoord(1,0,0,1)
        Bd1_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
        Ring.Base = -29.7
        Ring.Coef = 1
    end

    Bar.Ring = Ring
    Bar.Fill = Bar_Fill

    return Bar
end

local function Bar4_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        if value > 0 and frame.State == "Hide" then
            frame:SetAlpha(1)
            frame.State = "Show"
        elseif value == 0 and frame.State == "Show" then
            frame:SetAlpha(0)
            frame.State = "Hide"
        end
        if frame.State == "Show" then
            local degree = frame.Ring.Base + frame.Ring.Coef * 13.7 * value
            frame.Ring: SetRotation(rad(degree), {x=0.5,y=0.5})
        end

        frame.OldPer = value
    end
end

local function Bar5_Template(frame, direction)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(16,16)
    Bar: SetPoint("CENTER")
    Bar: SetAlpha(0)

    local Bar_Fill = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("HUD_Bar5"), C.Color.Main1, 0.9, {512,512})
    local Bar_Bg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("HUD_Bar5"), C.Color.Main0, 0.4, {512,512})
    local Bar_BgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("HUD_Bar5"), C.Color.Main1, 0.4, {512,512})
    local Bar_Sd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("HUD_Bar5_Sd"), C.Color.Main0, 0.4, {512,512})
    local Bar_Glow = F.Create.Texture(Bar, "ARTWORK", 3, OW.Path("HUD_Bar5_Glow"), {r=243/255,g=244/255,b=246/255}, 0.2, {512,512})

    local Ring = Bar: CreateMaskTexture()
    Ring: SetTexture(OW.Path("HUD_Ring"), "CLAMPTOBLACKADDITIVE", "CLAMPTOBLACKADDITIVE")
    Ring: SetSize(1024,1024)
    Ring: SetPoint("CENTER", Bar, "CENTER", 0, 0)

    Bar_Fill: AddMaskTexture(Ring)
    Bar_Glow: AddMaskTexture(Ring)

    if direction == "LEFT" then
        Bar_Fill: SetTexCoord(0,1,0,1)
        Bar_Fill: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(0,1,0,1)
        Bar_Bg: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(0,1,0,1)
        Bar_BgGlow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(0,1,0,1)
        Bar_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(0,1,0,1)
        Bar_Glow: SetPoint("TOPRIGHT", Bar, "CENTER")
        Ring.Base = 50.3
        Ring.Coef = -1
    elseif direction == "RIGHT" then
        Bar_Fill: SetTexCoord(1,0,0,1)
        Bar_Fill: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Bg: SetTexCoord(1,0,0,1)
        Bar_Bg: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_BgGlow: SetTexCoord(1,0,0,1)
        Bar_BgGlow: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Sd: SetTexCoord(1,0,0,1)
        Bar_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
        Bar_Glow: SetTexCoord(1,0,0,1)
        Bar_Glow: SetPoint("TOPLEFT", Bar, "CENTER")
        Ring.Base = -50.3
        Ring.Coef = 1
    end

    Bar.Ring = Ring
    Bar.Fill = Bar_Fill

    return Bar
end

local function Bar5_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    frame._OldValue = value
    if not frame.OldPer or frame.OldPer ~= value then          
        if frame.Shown then
            local degree = frame.Ring.Base + frame.Ring.Coef * 34 * value
            frame.Ring: SetRotation(rad(degree), {x=0.5, y=0.5})
        end

        frame.OldPer = value
    end
end

local function Border1_Template(frame, direction)
    local Border = CreateFrame("Frame", nil, frame)
    Border: SetSize(16,16)
    Border: SetPoint("CENTER")

    local Bd1 = F.Create.Texture(Border, "ARTWORK", 2, OW.Path("HUD_Bd1"), C.Color.Main1, 0.9, {512,512})
    local Bd1_Sd = F.Create.Texture(Border, "ARTWORK", 1, OW.Path("HUD_Bd1_Sd"), C.Color.Main0, 0.4, {512,512})
    if direction == "LEFT" then
        Bd1: SetTexCoord(0,1,0,1)
        Bd1: SetPoint("TOPRIGHT", Bar, "CENTER")
        Bd1_Sd: SetTexCoord(0,1,0,1)
        Bd1_Sd: SetPoint("TOPRIGHT", Bar, "CENTER")
    elseif direction == "RIGHT" then
        Bd1: SetTexCoord(1,0,0,1)
        Bd1: SetPoint("TOPLEFT", Bar, "CENTER")
        Bd1_Sd: SetTexCoord(1,0,0,1)
        Bd1_Sd: SetPoint("TOPLEFT", Bar, "CENTER")
    end

    return Border
end

----------------------------------------------------------------
--> Player
----------------------------------------------------------------

local PowerColor = {
	--Insane =  { r = 132/255, g = 52/255, b = 254/255},
	Insane =  {r = 168/255, g = 112/255, b = 254/255},
	Damage1 = {r = 249/255, g = 124/255, b = 134/255},
	Damage2 = {r = 248/255, g = 238/255, b = 114/255},
}

local function Priest_Event(frame, event, ...)
    if F.IsClassic then return end
	if event == "PLAYER_LOGIN" then
		frame: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
	end
	if event == "PLAYER_LOGIN" or event == "PLAYER_SPECIALIZATION_CHANGED" then
		if GetSpecialization() == SPEC_PRIEST_SHADOW then
			--frame: RegisterEvent("UPDATE_SHAPESHIFT_FORMS")
			frame: RegisterUnitEvent("UNIT_AURA", "player")
			event = "UNIT_AURA"
			frame.Bar5.Fill: SetVertexColor(F.Color(PowerColor.Insane))
		else
			frame: UnregisterEvent("UNIT_AURA")
			if frame.Bar5.Insane then
				frame.Bar5.Insane = nil
			end
		end
	elseif (event == "UNIT_AURA") then
		if GetSpecialization() == SPEC_PRIEST_SHADOW then
			local insane = IsInsane();  --194249 虚空形态
			if (insane and not frame.Bar5.Insane) then
				--> Gained insanity
                frame.Bar5.Shown = true
				frame.Bar5: SetAlpha(1)
			elseif (not insane and frame.Bar5.Insane) then
				--> Lost insanity
                frame.Bar5.Shown = false
                frame.Bar5: SetAlpha(0)
			end
			frame.Bar5.Insane = insane;
		end
	end
end

local function HUD_Player_OnEvent(frame, event, ...)
    Priest_Event(frame, event, ...)
end

local function HUD_Player_RgEvent(frame)
    frame.Left: RegisterEvent("PLAYER_LOGIN")
end

local function HUD_Player(frame)
    local HUD_Player = CreateFrame("Frame", nil, frame)
    HUD_Player: SetSize(16,16)
    HUD_Player: SetPoint("CENTER")

    local Bar1 = Bar1_Template(HUD_Player, "LEFT")
    local Bar2 = Bar2_Template(HUD_Player, "LEFT")
    local Bar4 = Bar4_Template(HUD_Player, "LEFT")
    local Bar5 = Bar5_Template(HUD_Player, "LEFT")
    local Bd1 = Border1_Template(HUD_Player, "LEFT")

    HUD_Player: SetScript("OnEvent", function(self, event, ...)
        HUD_Player_OnEvent(self, event, ...)
    end)

    HUD_Player.Bar1 = Bar1
    HUD_Player.Bar2 = Bar2
    HUD_Player.Bar4 = Bar4
    HUD_Player.Bar5 = Bar5
    frame.Left = HUD_Player
end

----------------------------------------------------------------
--> Target
----------------------------------------------------------------

local function GetThreatColor(status,tank)
    if tank then
        status = 3 - status
    end
    if status == 0 then
        return C.Color.Main1
    elseif status == 1 then
        return C.Color.Main2
    elseif status == 2 then
        return C.Color.Warn1
    elseif status == 3 then
        return C.Color.Warn1
    else
        return C.Color.Main1
    end
end

local function Threat_IsTank(unit)
	local role
	if not F.IsClassic then
		role = GetSpecializationRoleByID(GetInspectSpecialization(unit))
	end
	if role and role == "TANK" then
		return true
	else
		return false
	end
end

local function Threat_Update(frame)
	if UnitAffectingCombat("player") and UnitExists("target") and not UnitIsDeadOrGhost("target") then
		if UnitCanAttack("player", "target") and not (UnitIsDead("target") or UnitIsFriend("player", "target") or UnitPlayerControlled("target")) then
			local status, threatpct = select(2, UnitDetailedThreatSituationAlter("player", "target"))
			if status and threatpct then
				threatpct = threatpct/100
                if not frame.Shown then
                    frame.Shown = true
				    frame: SetAlpha(1)
                end
                frame.Fill: SetVertexColor(F.Color(GetThreatColor(status,frame.IsTank)))
                frame.UpdateValue(frame, threatpct)
			else
				frame.Shown = false
			    frame: SetAlpha(0)
			end
		else
			frame.Shown = false
			frame: SetAlpha(0)
		end
	else
		frame.Shown = false
		frame: SetAlpha(0)
	end
end

local function Threat_RegisterCallback(frame)
	LibThreatClassic.RegisterCallback(frame, "ThreatUpdated", function()
		Threat_Update(frame)
	end)
end

local function Threat_Event(frame, event, ...)
	if event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_SPECIALIZATION_CHANGED" then
		frame.IsTank = Threat_IsTank("player")
	elseif event == "PLAYER_ENTERING_WORLD" or event == "PLAYER_REGEN_DISABLED" or event == "PLAYER_REGEN_ENABLED" or event == "PLAYER_TARGET_CHANGED" or event == "UNIT_THREAT_LIST_UPDATE" or event == "UNIT_THREAT_SITUATION_UPDATE" then
		Threat_Update(frame)
	end
end

local function Threat_RegisterCallback(frame)
	LibThreatClassic.RegisterCallback(frame, "ThreatUpdated", function()
		Threat_Update(frame.Bar5)
	end)
end

local function HUD_Target_RgEvent(frame)
    frame.Right: RegisterEvent("PLAYER_ENTERING_WORLD")
	if not F.IsClassic then
		frame.Right: RegisterEvent("PLAYER_SPECIALIZATION_CHANGED")
		frame.Right: RegisterUnitEvent("UNIT_THREAT_LIST_UPDATE", "target")
		frame.Right: RegisterUnitEvent("UNIT_THREAT_SITUATION_UPDATE", "target")
	end
	frame.Right: RegisterEvent("PLAYER_TARGET_CHANGED")
	frame.Right: RegisterEvent("PLAYER_REGEN_DISABLED")
	frame.Right: RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function HUD_Target_OnEvent(frame, event, ...)
    Threat_Event(frame.Bar5, event, ...)
end

local function HUD_Target(frame)
    local HUD_Target = CreateFrame("Frame", nil, frame)
    HUD_Target: SetSize(16,16)
    HUD_Target: SetPoint("CENTER")

    local Bar1 = Bar1_Template(HUD_Target, "RIGHT")
    local Bar2 = Bar2_Template(HUD_Target, "RIGHT")
    local Bar5 = Bar5_Template(HUD_Target, "RIGHT")
    Bar5.UpdateValue = Bar5_Update
    Bar5.UpdateMaxValue = Bar5_Update
    F.SetSmooth(Bar5, true)

    local Bd1 = Border1_Template(HUD_Target, "RIGHT")

    HUD_Target: SetScript("OnEvent", function(self, event, ...)
        HUD_Target_OnEvent(self, event, ...)
    end)

    if F.IsClassic then
		Threat_RegisterCallback(HUD_Target)
	end

    HUD_Target.Bar1 = Bar1
    HUD_Target.Bar2 = Bar2
    HUD_Target.Bar5 = Bar5
    frame.Right = HUD_Target
end

----------------------------------------------------------------
--> HUD
----------------------------------------------------------------

local function HUD_RgEvent(frame)
    frame: RegisterEvent("PLAYER_ENTERING_WORLD")
    frame: RegisterEvent("PLAYER_TARGET_CHANGED")
    frame: RegisterEvent("PLAYER_REGEN_DISABLED")
    frame: RegisterEvent("PLAYER_REGEN_ENABLED")
end

local function HUD_SlideUpdate(self)
	if UnitAffectingCombat("player") or UnitExists("target") then
		if self.State == "Hide" then
			if F.IsClassic then
				self.State = "Show"
				self:SetAlpha(1)
			else
				self.SlideIn: Play()
			end
		end
	else
		if self.State == "Show" then
			if F.IsClassic then
				self.State = "Hide"
				self:SetAlpha(0)
			else
				self.SlideOut: Play()
			end
		end
	end
end

local function HUD_OnEvent(frame)
    frame: SetScript("OnEvent", HUD_SlideUpdate)
end

local function HUD_OnShow(frame)
    frame: SetScript("OnShow", function(self)
        HUD_SlideUpdate(self)
    end)
end

local function HUD_OnUpdate(frame)
    local Dummy = frame:CreateAnimationGroup()
    Dummy: SetLooping("REPEAT") --[NONE, REPEAT, or BOUNCE].

	local DummyAmin = Dummy:CreateAnimation()
    DummyAmin: SetDuration(0.2)
    DummyAmin: SetOrder(1)
    
	Dummy:SetScript("OnLoop", function(self)
       HUD_SlideUpdate(frame)
	end)
	Dummy:Play()
	--Dummy:Stop()
    frame.Timer = Dummy
end

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

local OW_HUD = CreateFrame("Frame", "Quafe_Overwatch.HUD", E, "OW_HUD_SlideTemplate")
OW_HUD: SetSize(16,16)
OW_HUD: SetPoint("CENTER", UIParent, "CENTER")
OW_HUD: SetFrameStrata("LOW")
OW_HUD.Init = false
OW_HUD.State = "Hide"
if F.IsClassic then
	OW_HUD: SetAlpha(0)
else
	OW_HUD: Hide()
end

local function OW_HUD_Player_HpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar1_Update(OW_HUD.Left.Bar1, arg2)
    elseif arg1 == "Event" then
        
    end
end

local function OW_HUD_Player_PpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar2_Update(OW_HUD.Left.Bar2, arg2)
        if OW_HUD.Left.Bar5.Insane then
            Bar5_Update(OW_HUD.Left.Bar5, arg2)
        end
    elseif arg1 == "Event" then

    end
end

local function OW_HUD_Player_AsUpdate(arg1,arg2)
    if arg1 == "Update" then
        Bar1_Ring1_Update(OW_HUD.Left.Bar1, arg2)
    end
end

local function OW_HUD_Player_MnUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar4_Update(OW_HUD.Left.Bar4, arg2,arg3)
    end
end

local function OW_HUD_Target_HpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar1_Update(OW_HUD.Right.Bar1, arg2)
    elseif arg1 == "Event" then
        
    end
end

local function OW_HUD_Target_PpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar2_Update(OW_HUD.Right.Bar2, arg2)
    elseif arg1 == "Event" then

    end
end

local function OW_HUD_Target_AsUpdate(arg1,arg2)
    if arg1 == "Update" then
        Bar1_Ring1_Update(OW_HUD.Right.Bar1, arg2)
    end
end

local function OW_HUD_Load()
    if Quafe_DB.Profile[Quafe_DBP.Profile].OW_HUD.Enable then
        HUD_Player(OW_HUD)
        HUD_Player_RgEvent(OW_HUD)

        HUD_Target(OW_HUD)
        HUD_Target_RgEvent(OW_HUD)

        tinsert(E.UBU.Player.HP, OW_HUD_Player_HpUpdate)
        tinsert(E.UBU.Player.PP, OW_HUD_Player_PpUpdate)
        tinsert(E.UBU.Player.AS, OW_HUD_Player_AsUpdate)
        tinsert(E.UBU.Player.MN, OW_HUD_Player_MnUpdate)

        tinsert(E.UBU.Target.HP, OW_HUD_Target_HpUpdate)
        tinsert(E.UBU.Target.PP, OW_HUD_Target_PpUpdate)
        tinsert(E.UBU.Target.AS, OW_HUD_Target_AsUpdate)

        HUD_RgEvent(OW_HUD)
        HUD_OnEvent(OW_HUD)
        HUD_OnShow(OW_HUD)
        --HUD_OnUpdate(OW_HUD)

        OW_HUD.Init = true
    end
end

local function OW_HUD_Toggle(arg1,arg2)
    if arg1 == "ON" then
		if not OW_HUD.Init then
			OW_HUD_Load()
		end
        if not OW_HUD:IsShown() then
			OW_HUD: Show()
		end
        F.UBGU_ForceUpdate()
	elseif arg1 == "OFF" then
		OW_HUD: Hide()
		Quafe_NoticeReload()
	elseif arg1 == "SCALE" then
		OW_HUD: SetScale(arg2)
	end
end

local OW_HUD_Config = {
	Database = {
		["OW_HUD"] = {
			["Enable"] = false,
			Scale = 1,
		},
	},

    Config = {
        Name = "Overwatch HUD"..L['UNFINISHED'],
        Type = "Switch",
        Click = function(self, button)
			if InCombatLockdown() then return end
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_HUD.Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_HUD.Enable = false
				self.Text:SetText(L["OFF"])
				OW_HUD_Toggle("OFF")
			else
				Quafe_DB.Profile[Quafe_DBP.Profile].OW_HUD.Enable = true
				self.Text:SetText(L["ON"])
				OW_HUD_Toggle("ON")
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile].OW_HUD.Enable then
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
                    self.Slider: SetValue(Quafe_DB.Profile[Quafe_DBP.Profile].OW_HUD.Scale)
					self.Slider: HookScript("OnValueChanged", function(s, value)
                        value = floor(value*100+0.5)/100
                        Quafe_DB.Profile[Quafe_DBP.Profile].OW_HUD.Scale = value
						OW_HUD_Toggle("SCALE",value)
					end)
                end,
                Show = nil,
            },
		},
    },
}

OW_HUD.Load = OW_HUD_Load
OW_HUD.Config = OW_HUD_Config
tinsert(E.Module, OW_HUD)