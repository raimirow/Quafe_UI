local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Local

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local tinsert = tinsert
--DisableAddOn(index or "name"[, "character"])

----------------------------------------------------------------
--> Default Layout Setup wizard
----------------------------------------------------------------

local function Picture_Frame(frame)
	local Dummy = CreateFrame("Frame", nil, frame)
	Dummy: SetSize(820,420)
	Dummy: Hide()

	local Backdrop = F.Create.Backdrop(Dummy, 2, true, 6, 6, C.Color.Main0, 0.9, C.Color.Main0, 0.9)
	local Picture = F.Create.Texture(Dummy, "ARTWORK", 1, "", nil, nil, {1024,512})
	Picture: SetPoint("CENTER")

	Dummy.Texture = Picture

	return Dummy
end

local function Load_Overwatch_Layout()
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color then
		Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State = "Overwatch2"
		local theme = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State
		C.Color.Main1 = C.Color.Theme[theme].Main1
		C.Color.Main2 = C.Color.Theme[theme].Main2
		C.Color.Main3 = C.Color.Theme[theme].Main3
		C.Color.Warn1 = C.Color.Theme[theme].Warn1
	end
	--> ON
	if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame then
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable = true
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame then
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable = true
	end
	--> OFF
	--if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_InfoBar then
	--	Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_InfoBar.Enable = false
	--end
	if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame then
		Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame.Enable = false
	end
end

local function Load_MEKA_Layout()
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color then
		Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State = "Blue1"
		local theme = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State
		C.Color.Main1 = C.Color.Theme[theme].Main1
		C.Color.Main2 = C.Color.Theme[theme].Main2
		C.Color.Main3 = C.Color.Theme[theme].Main3
		C.Color.Warn1 = C.Color.Theme[theme].Warn1
	end
	--> ON
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_InfoBar then
		Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_InfoBar.Enable = true
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame then
		Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame.Enable = true
	end
	--> OFF
	if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame then
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable = false
	end
	if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame then
		Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable = false
	end
end

local function Button_Template(frame, color, title)
	local Dummy = CreateFrame("Button", nil, frame)
	Dummy: SetSize(240,28)

	local Bg = F.Create.Backdrop(Dummy, 2, true, 2, 2, color, 0.9, color, 0.9)
    local Text = F.Create.Font(Dummy, "ARTWORK", C.Font.Txt, 16, nil, C.Color.W3,1, C.Color.Config.Back,0.9, {1,-1}, "CENTER", "CENTER")
    Text: SetPoint("CENTER", Dummy, "CENTER", 0,0)

    Dummy: SetScript("OnEnter", function(self)
		Bg: SetBackdropColor(F.Color(color, 0.7))
        Bg: SetBackdropBorderColor(F.Color(C.Color.W3, 0.9))
		if Dummy.Texture then
			frame.Picture.Texture: SetTexture(Dummy.Texture)
			frame.Picture: Show()
		end
	end)
	Dummy: SetScript("OnLeave", function(self)
		Bg: SetBackdropColor(F.Color(color, 0.9))
        Bg: SetBackdropBorderColor(F.Color(color, 0.9))
		frame.Picture: Hide()
	end)
	
	Dummy: SetScript("OnClick", function(self)
		Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Setupwizard.Init = true
	end)

	Dummy: SetScript("OnShow", function(self)
		Text: SetText(title)
	end)

    return Dummy
end

local function MEKA_ButtonFrame(frame,index)
    local MEKA_Button = Button_Template(frame, C.Color.Config.Bar2, L['LOAD_MEKA_LAYOUT'])
	MEKA_Button: SetPoint("CENTER", frame, "TOP", 0,-180-44*(index-1))
	MEKA_Button.Texture = F.Path("Picture\\MEKA")
    
    MEKA_Button: HookScript("OnClick", function(self, button)
		Load_MEKA_Layout()
		Quafe_WarningReload()
	end)

	frame.MEKA_Button = MEKA_Button
end

local function Overwatch_ButtonFrame(frame,index)
    local Overwatch_Button = Button_Template(frame, C.Color.Config.Bar2, L['LOAD_OVERWATCH_LAYOUT'])
	Overwatch_Button: SetPoint("CENTER", frame, "TOP", 0,-180-44*(index-1))
	Overwatch_Button.Texture = F.Path("Picture\\Overwatch")
    
    Overwatch_Button: HookScript("OnClick", function(self, button)
		Load_Overwatch_Layout()
		Quafe_WarningReload()
	end)

	frame.Overwatch_Button = Overwatch_Button
end

local function Exit_ButtonFrame(frame,index)
    local Exit_Button = Button_Template(frame, C.Color.Config.Exit, L['EXIT'])
	Exit_Button: SetPoint("CENTER", frame, "TOP", 0,-180-44*(index-1))
    
    Exit_Button: HookScript("OnClick", function(self, button)
		frame: Hide()
	end)

	frame.Exit_Button = Exit_Button
end

local function Setupwizard_Artwork(frame)
    local Backdrop = F.Create.Backdrop(frame, 2, true, 6, 6, C.Color.Main0, 0.9, C.Color.Main0, 0.9)
    local TiTle = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 20, nil, C.Color.W3,1, C.Color.Config.Back,1, {1,-1}, "LEFT", "CENTER")
    TiTle: SetText("Quafe UI "..L['SETUP_WIZARD'])
    TiTle: SetPoint("CENTER", frame, "TOP", 0,-60)
	local Line = F.Create.Texture(frame, "ARTWORK", 1, F.Path("White"), C.Color.W3, 0.25, {360,2})
	Line: SetPoint("CENTER", TiTle, "CENTER", 0,-60)

	frame.Picture = Picture_Frame(frame)
	frame.Picture: SetPoint("LEFT", frame, "RIGHT", 10,0)
	
	MEKA_ButtonFrame(frame, 1)
	Overwatch_ButtonFrame(frame, 2)
    Exit_ButtonFrame(frame, 3)
end

local Quafe_Setupwizard = CreateFrame("Frame", "Quafe_Setupwizard", E)
Quafe_Setupwizard: SetFrameStrata("HIGH")
Quafe_Setupwizard: SetToplevel(true)
Quafe_Setupwizard: SetSize(360,420)
Quafe_Setupwizard: SetPoint("LEFT", UIParent, "LEFT", 20,0)
Quafe_Setupwizard: Hide()

local function Quafe_Setupwizard_Load()
    Setupwizard_Artwork(Quafe_Setupwizard)
	if not Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Setupwizard.Init then
		Quafe_Setupwizard: Show()
	end
end

local Quafe_Setupwizard_Config = {
	Database = {
		["Quafe_Setupwizard"] = {
			Init = false,
		},
	},

	Config = {
		Name = L['SETUP_WIZARD'],
		Text = L['OPEN'],
		Type = "Trigger",
		Click = function(self, button)
			Quafe_Setupwizard: Show()
			if Quafe_Config then
				Quafe_Config: Hide()
			end
		end,
		Sub = nil,
	},
}

Quafe_Setupwizard.Load = Quafe_Setupwizard_Load
Quafe_Setupwizard.Config = Quafe_Setupwizard_Config
tinsert(E.Module, 1, Quafe_Setupwizard)

