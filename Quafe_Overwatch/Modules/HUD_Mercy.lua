local OW = unpack(select(2, ...))  -->Engine
local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)

----------------------------------------------------------------
--> General
----------------------------------------------------------------

local function Bar1_Template(frame)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(512,30) --594,58

    local BarFill = F.Create.Texture(Bar, "ARTWORK", 1, OW.Path("Bar5"), C.Color.Main1, 0.9, {512,32})
    BarFill: SetPoint("CENTER")
    local BarFill1 = F.Create.Texture(Bar, "ARTWORK", 3, OW.Path("Bar5Fill2"), C.Color.Main3, 0.6, {512,32})
    BarFill1: SetPoint("CENTER")
    local BarGlow = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("Bar5Glow"), {r=243/255,g=244/255,b=246/255}, 0.2, {512,32})
    BarGlow: SetPoint("CENTER")
    local BarBg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("Bar5"), C.Color.Main0, 0.4, {512,32})
    BarBg: SetPoint("CENTER")
    local BarBgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("Bar5"), C.Color.Main1, 0.4, {512,32})
    BarBgGlow: SetPoint("CENTER")
    local BarSd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("Bar5Sd"), C.Color.Main0, 0.4, {512,32})
    BarSd: SetPoint("CENTER")

    local Fill = F.Create.MaskTexture(Bar, OW.Path("Bar5Fill"), {512,32})
    Fill: SetPoint("RIGHT", Bar, "RIGHT", 0, 0)

    local Fill1 = F.Create.MaskTexture(Bar, OW.Path("Bar5Fill"), {512,32})
    Fill1: SetPoint("LEFT", Bar, "LEFT", 0, 0)

    BarFill: AddMaskTexture(Fill)
    BarGlow: AddMaskTexture(Fill)
    BarFill1: AddMaskTexture(Fill1)

    Bar.Fill = Fill
    Bar.Fill1 = Fill1
    Bar.BarFill = BarFill

    return Bar
end

local function Bar1_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local x =  - 290 * (1 - value)
        frame.Fill: SetPoint("RIGHT", frame, "RIGHT", x,0)

        if (not frame.OldPer) and (value <= 0.2) then
            frame.BarFill: SetVertexColor(F.Color(C.Color.Warn1))
        elseif (not frame.OldPer) and (value > 0.2) then
            frame.BarFill: SetVertexColor(F.Color(C.Color.Main1))
        elseif (value <= 0.2 and frame.OldPer > 0.2) then
            frame.BarFill: SetVertexColor(F.Color(C.Color.Warn1))
        elseif (value > 0.2 and frame.OldPer <= 0.2) then
            frame.BarFill: SetVertexColor(F.Color(C.Color.Main1))
        end

        frame.OldPer = value
    end
end

local function Bar1_Fill1_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local x = 290 * (1 - value)
        frame.Fill1: SetPoint("LEFT", frame, "LEFT", x,0)
        frame.OldPer = value
    end
end

local function Bar2_Template(frame)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(512,12)

    local BarFill = F.Create.Texture(Bar, "ARTWORK", 1, OW.Path("Bar6"), C.Color.Main3, 0.9, {512,16})
    BarFill: SetPoint("CENTER")
    local BarGlow = F.Create.Texture(Bar, "ARTWORK", 2, OW.Path("Bar6Glow"), {r=243/255,g=244/255,b=246/255}, 0.2, {512,16})
    BarGlow: SetPoint("CENTER")
    local BarBg = F.Create.Texture(Bar, "BACKGROUND", 2, OW.Path("Bar6"), C.Color.Main0, 0.4, {512,16})
    BarBg: SetPoint("CENTER")
    local BarBgGlow = F.Create.Texture(Bar, "BACKGROUND", 3, OW.Path("Bar6"), C.Color.Main1, 0.4, {512,16})
    BarBgGlow: SetPoint("CENTER")
    local BarSd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("Bar6Sd"), C.Color.Main0, 0.4, {512,16})
    BarSd: SetPoint("CENTER")

    local Fill = F.Create.MaskTexture(Bar, OW.Path("Bar5Fill"), {512,32})
    Fill: SetPoint("RIGHT", Bar, "RIGHT", -3, 0)

    BarFill: AddMaskTexture(Fill)
    BarGlow: AddMaskTexture(Fill)

    Bar.Fill = Fill

    return Bar
end

local function Bar2_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local x =  -3 - 287 * (1 - value)
        frame.Fill: SetPoint("RIGHT", frame, "RIGHT", x,0)
        frame.OldPer = value
    end
end

local function Bar3_Template(frame)
    local Bar = CreateFrame("Frame", nil, frame)
    Bar: SetSize(512,64)

    local BarFill = F.Create.Texture(Bar, "ARTWORK", 1, OW.Path("Bar7"), C.Color.Main1, 0.9, {512,64})
    BarFill: SetPoint("CENTER")
    local BarSd = F.Create.Texture(Bar, "BACKGROUND", 1, OW.Path("Bar7Sd"), C.Color.Main0, 0.4, {512,64})
    BarSd: SetPoint("CENTER")

    local Fill = F.Create.MaskTexture(Bar, OW.Path("Bar5Fill"), {1024,64})
    Fill: SetPoint("RIGHT", Bar, "RIGHT", 116, 0)
    --Fill: SetPoint("RIGHT", Bar, "RIGHT", -174, 0)
    BarFill: AddMaskTexture(Fill)
    BarSd: AddMaskTexture(Fill)

    local Nonius = F.Create.Texture(Bar, "ARTWORK", 5, OW.Path("Bar7Bd1"), C.Color.Main1, 0.9, {32,64})
    Nonius: SetPoint("CENTER", Fill, "CENTER", 284,0)
    local NoniusSd = F.Create.Texture(Bar, "ARTWORK", 4, OW.Path("Bar7Bd1Sd"), C.Color.Main0, 0.4, {32,64})
    NoniusSd: SetPoint("CENTER", Nonius, "CENTER")

    Bar.Fill = Fill
    Bar.BarFill = BarFill
    Bar.Nonius = Nonius

    return Bar
end

local function Bar3_Update(frame, value)
    if not value then value = 0 end
    value = F.Clamp(value, 0,1)
    if not frame.OldPer or frame.OldPer ~= value then
        local x = 116 - 290 * (1 - value)
        frame.Fill: SetPoint("RIGHT", frame, "RIGHT", x,0)

        frame.OldPer = value
    end
end

local function Num_Template(frame)
    local Num = CreateFrame("Frame", nil, frame)
    Num: SetFrameLevel(frame:GetFrameLevel()+2)
    Num: SetSize(16,16)

    local Num1 = F.Create.Font(Num, "ARTWORK", C.Font.NumSmall, 14, nil, C.Color.Main1,1, C.Color.Main0,0, {1,-1}, "RIGHT", "CENTER")
    local Num2 = F.Create.Font(Num, "ARTWORK", C.Font.NumSmall, 14, nil, C.Color.Main1,1, C.Color.Main0,0, {1,-1}, "LEFT", "CENTER")
    local Num3 = F.Create.Font(Num, "ARTWORK", C.Font.Num, 14, nil, C.Color.Main1,1, C.Color.Main0,0, {1,-1}, "CENTER", "CENTER")
    Num3: SetPoint("CENTER")
    Num3: SetText("--")
    Num1: SetPoint("RIGHT", Num, "LEFT")
    Num2: SetPoint("LEFT", Num, "RIGHT")

    local Bg = F.Create.Texture(Num, "BACKGROUND", 1, OW.Path("Bar5Fill3"), C.Color.Main0, 0.4, {256,16})
    Bg: SetPoint("CENTER", Num, "CENTER", 0,-1)

    Num.HP = Num1
    Num.PP = Num2

    return Num
end

local function Num_Update(frame, value1, value2)
    if value1 then
        frame.Num.HP: SetText(F.FormatNum(value1,1))
    end
    if value2 then
        frame.Num.PP: SetText(F.FormatNum(value2,1))
    end
end

local function Name_Template(frame)
    local Name = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 16, "OUTLINE", C.Color.Main1,1, C.Color.Main0,0, {1,-1}, "CENTER", "CENTER")

    return Name
end

----------------------------------------------------------------
--> Player
----------------------------------------------------------------

local function Player_Debuff(frame)
	local Dummy = CreateFrame("Frame", nil, frame)
	
	Dummy.size = 26
	Dummy.gap = 0
	Dummy.fontsize = 10
	Dummy.limit = 20
	Dummy.bufflimit = 10
	Dummy.debufflimit = 10
	Dummy.perline = 10
	Dummy.growthH = "RIGHT"
	Dummy.growthV = "TOP"
	Dummy.unit = frame.Unit
	Dummy.type = nil
	Dummy.filter = "HARMFUL"
	
	Dummy: SetSize(Dummy.size*Dummy.perline, Dummy.size)
	Dummy: SetPoint("BOTTOM", frame, "TOP", 0,10)
	
	F.Aura_Create(Dummy)

    frame.Debuff = Dummy
end

local function Mercy_Player_Artworks(frame)
    local Bar1 = Bar1_Template(frame)
    Bar1: SetPoint("CENTER", frame, "CENTER", 0,0)
    local Bar2 = Bar2_Template(frame)
    Bar2: SetPoint("TOP", Bar1, "BOTTOM", 0,-4)

    frame.Bar1 = Bar1
    frame.Bar2 = Bar2
end

local function Mercy_Player_RgEvent(frame)
    frame: RegisterEvent("PLAYER_ENTERING_WORLD")
    frame: RegisterEvent("PLAYER_REGEN_DISABLED")
    frame: RegisterEvent("PLAYER_REGEN_ENABLED")
    frame: RegisterEvent("PLAYER_TARGET_CHANGED")
end

local function Mercy_Player_SlideUpdate(self)
	if UnitAffectingCombat("player") or UnitExists("target") then
		if self.State == "Hide" then
			if F.IsClassic then
				self: Show()
			else
                self: Show()
			end
            self.State = "Show"
		end
	else
		if self.State == "Show" then
			if F.IsClassic then
				self: Hide()
			else
                self: Hide()
			end
            self.State = "Hide"
		end
	end
end

local function Mercy_Player_OnEvent(frame)
    frame: SetScript("OnEvent", Mercy_Player_SlideUpdate)
end

local Mercy_Player = CreateFrame("Frame", "Quafe_Overwatch.Mercy_Player", E)
Mercy_Player: SetSize(298,30)
Mercy_Player: SetPoint("CENTER", UIParent, "CENTER", 0,-160)
Mercy_Player.Init = false
Mercy_Player.State = "Show"
Mercy_Player.Unit = "player"

local function Mercy_Player_HpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar1_Update(Mercy_Player.Bar1, arg2)
    elseif arg1 == "Event" then
        --LeftNum_HpUpdate(OW_PlayerFrame.Nums, arg3)
    end
end

local function Mercy_Player_PpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar2_Update(Mercy_Player.Bar2, arg2)
    elseif arg1 == "Event" then
        --LeftNum_HpUpdate(OW_PlayerFrame.Nums, arg3)
    end
end

local function Mercy_Player_AsUpdate(arg1,arg2)
    if arg1 == "Update" then
        Bar1_Fill1_Update(Mercy_Player.Bar1, arg2)
    end
end

local function Mercy_Player_Load()
    Mercy_Player_Artworks(Mercy_Player)
    Player_Debuff(Mercy_Player)

    tinsert(E.UBU.Player.HP, Mercy_Player_HpUpdate)
    tinsert(E.UBU.Player.PP, Mercy_Player_PpUpdate)
    tinsert(E.UBU.Player.AS, Mercy_Player_AsUpdate)

    Mercy_Player_RgEvent(Mercy_Player)
    Mercy_Player_OnEvent(Mercy_Player)
end

Mercy_Player.Load = Mercy_Player_Load
--Mercy_Player.Config = Mercy_Player_Config
--tinsert(E.Module, Mercy_Player)

----------------------------------------------------------------
--> Target
----------------------------------------------------------------

local function Target_Aura(frame)
	local Dummy = CreateFrame("Frame", nil, frame)
	
	Dummy.size = 26
	Dummy.gap = 0
	Dummy.fontsize = 10
	Dummy.limit = 20
	Dummy.bufflimit = 10
	Dummy.debufflimit = 10
	Dummy.perline = 10
	Dummy.growthH = "RIGHT"
	Dummy.growthV = "TOP"
	Dummy.unit = frame.Unit
	Dummy.type = "Aura"
	Dummy.filter = nil
	
	Dummy: SetSize(Dummy.size*Dummy.perline, Dummy.size)
	Dummy: SetPoint("BOTTOM", frame, "TOP", 0,34)
	
	F.Aura_Create(Dummy)

    frame.Aura = Dummy
end

local function Name_Color_Update(frame, denied)
	local eColor = {}
	if UnitIsPlayer(frame.Unit) then
		local eClass = select(2, UnitClass(frame.Unit))
		eColor = C.Color.Class[eClass] or C.Color.White
	else
		if denied and (not UnitPlayerControlled(frame.Unit) and UnitIsTapDenied(frame.Unit)) then
			eColor = C.Color.Denied
		else
			local red, green, blue, alpha = UnitSelectionColor(frame.Unit)
			eColor.r = red or 1
			eColor.g = green or 1
			eColor.b = blue or 1
			if eColor.r == 0 and eColor.g == 0 then
				eColor.r = 56/255
				eColor.g = 154/255
			end
		end
	end
	return eColor	
end

local function Mercy_Target_Artworks(frame)
    local Bar1 = Bar1_Template(frame)
    Bar1: SetPoint("CENTER", frame, "CENTER", 0,0)
    local Bar2 = Bar2_Template(frame)
    Bar2: SetPoint("TOP", Bar1, "BOTTOM", 0,-4)
    local Name = Name_Template(frame)
    Name: SetPoint("BOTTOM", frame, "TOP", 0, 10)
    local Num = Num_Template(frame)
    Num: SetPoint("CENTER", frame, "CENTER", 0,1)
    local Castbar = Bar3_Template(frame)
    Castbar: SetPoint("CENTER", frame, "CENTER", 0,0)
    Castbar: Hide()

    frame.Bar1 = Bar1
    frame.Bar2 = Bar2
    frame.Name = Name
    frame.Num = Num
end

local function Mercy_Target_RgEvent(frame)
    frame: RegisterEvent("PLAYER_ENTERING_WORLD")
    frame: RegisterEvent("PLAYER_TARGET_CHANGED")
    frame: RegisterUnitEvent("UNIT_FACTION", "target")
end

local function Mercy_Target_UpdateName(frame)
    if not UnitExists(frame.Unit) then return end
	local level = UnitLevel(frame.Unit)
    local classification = UnitClassification(frame.Unit)
    if level then
        if level < 0 then
            level = "Boss"
        else
            level = format("Lv %s",level)
        end
        if classification == "elite" then
            level = format("%s Elite",level)
        elseif classification == "rare" then
            level = format("%s Rare",level)
        elseif classification == "rareelite" then
            level = format("%s RareElite",level)
        elseif classification == "worldboss" then
            level = format("%s WorldBoss",level)
        end
    end
    if classification == "elite" or classification == "rareelite" or classification == "worldboss" then
        lColor = C.Color.Y2
    elseif classification == "rare" then
        lColor = C.Color.W3
    else
        lColor = C.Color.Main1
    end
    local name, realm = UnitName(frame.Unit)
    --frame.Name: SetText(format("%s%s|r  %s%s|r", F.Hex(lColor),level,F.Hex(Name_Color_Update(frame, true)),name))
    frame.Name: SetText(format("%s%s|r  %s%s|r", F.Hex(lColor),level,F.Hex(C.Color.Main1),name))
end

local function Mercy_Target_OnEvent(frame)
    frame: SetScript("OnEvent", function(self, event)
        Mercy_Target_UpdateName(self)
    end)
end

local Mercy_Target = CreateFrame("Frame", "Quafe_Overwatch.Mercy_Target", E)
Mercy_Target: SetSize(298,30)
Mercy_Target: SetPoint("CENTER", UIParent, "CENTER", 400,-40)
Mercy_Target.Init = false
Mercy_Target.State = "Show"
Mercy_Target.Unit = "target"

local function Mercy_Target_HpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar1_Update(Mercy_Target.Bar1, arg2)
    elseif arg1 == "Event" then
        Num_Update(Mercy_Target, arg3, nil)
    end
end

local function Mercy_Target_PpUpdate(arg1,arg2,arg3)
    if arg1 == "Update" then
        Bar2_Update(Mercy_Target.Bar2, arg2)
    elseif arg1 == "Event" then
        --LeftNum_HpUpdate(OW_PlayerFrame.Nums, arg3)
        Num_Update(Mercy_Target, nil, arg3)
    end
end

local function Mercy_Target_AsUpdate(arg1,arg2)
    if arg1 == "Update" then
        Bar1_Fill1_Update(Mercy_Target.Bar1, arg2)
    end
end

local function Mercy_Target_Load()
    Mercy_Target_Artworks(Mercy_Target)
    Target_Aura(Mercy_Target)

    tinsert(E.UBU.Target.HP, Mercy_Target_HpUpdate)
    tinsert(E.UBU.Target.PP, Mercy_Target_PpUpdate)
    tinsert(E.UBU.Target.AS, Mercy_Target_AsUpdate)

    Mercy_Target_RgEvent(Mercy_Target)
    Mercy_Target_OnEvent(Mercy_Target)

    F.init_Unit(Mercy_Target, Mercy_Target.Unit, true)
	Mercy_Target: SetScript("OnEnter", F.UnitFrame_OnEnter)
	Mercy_Target: SetScript("OnLeave", F.UnitFrame_OnLeave)
end

Mercy_Target.Load = Mercy_Target_Load
--Mercy_Target.Config = Mercy_Target_Config
--tinsert(E.Module, Mercy_Target)