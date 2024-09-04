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

local function Button_Template(frame, color, title, done)
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
		if done then
			Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Setupwizard.Init = true
		end
	end)

	Dummy: SetScript("OnShow", function(self)
		Text: SetText(title)
	end)

    return Dummy
end

local function MEKA_ButtonFrame(frame,index)
    local MEKA_Button = Button_Template(frame, C.Color.B1, L['LOAD_MEKA_LAYOUT'], true)
	MEKA_Button: SetPoint("CENTER", frame, "TOP", 0,-180-44*(index-1))
	MEKA_Button.Texture = F.Path("Picture\\MEKA")
    
    MEKA_Button: HookScript("OnClick", function(self, button)
		Load_MEKA_Layout()
		Quafe_WarningReload()
	end)

	frame.MEKA_Button = MEKA_Button
end

local function Overwatch_ButtonFrame(frame,index)
    local Overwatch_Button = Button_Template(frame, C.Color.B1, L['LOAD_OVERWATCH_LAYOUT'], true)
	Overwatch_Button: SetPoint("CENTER", frame, "TOP", 0,-180-44*(index-1))
	Overwatch_Button.Texture = F.Path("Picture\\Overwatch")
    
    Overwatch_Button: HookScript("OnClick", function(self, button)
		Load_Overwatch_Layout()
		Quafe_WarningReload()
	end)

	frame.Overwatch_Button = Overwatch_Button
end

local function Custom_ButtonFrame(frame,index)
    local Custom_Button = Button_Template(frame, C.Color.B1, L['CUSTOM_LAYOUT'])
	Custom_Button: SetPoint("CENTER", frame, "TOP", 0,-180-44*(index-1))
	Custom_Button.Texture = nil
    
    Custom_Button: HookScript("OnClick", function(self, button)
		frame: Hide()
		frame.CustomSetupwizard: Show()
		--frame.CustomSetupwizard: Hide()
		--frame.CustomSetupwizard: Show()
	end)

	frame.Custom_Button = Custom_Button
end

local function Exit_ButtonFrame(frame,index)
    local Exit_Button = Button_Template(frame, C.Color.Y1, L['EXIT'], true)
	Exit_Button: SetPoint("CENTER", frame, "TOP", 0,-180-44*(index-1))
    
    Exit_Button: HookScript("OnClick", function(self, button)
		frame: Hide()
	end)

	frame.Exit_Button = Exit_Button
end

local function Setupwizard_Artwork(frame)
    local Backdrop = F.Create.Backdrop(frame, 2, true, 6, 6, C.Color.Main0, 0.9, C.Color.Main0, 0.9)
    local TiTle = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 20, nil, C.Color.W3,1, C.Color.Config.Back,1, {1,-1}, "LEFT", "MIDDLE")
    TiTle: SetText("Quafe UI "..L['SETUP_WIZARD'])
    TiTle: SetPoint("CENTER", frame, "TOP", 0,-60)
	local Line = F.Create.Texture(frame, "ARTWORK", 1, F.Path("White"), C.Color.W3, 0.25, {360,2})
	Line: SetPoint("CENTER", TiTle, "CENTER", 0,-60)

	frame.Picture = Picture_Frame(frame)
	frame.Picture: SetPoint("LEFT", frame, "RIGHT", 10,0)
	
	MEKA_ButtonFrame(frame, 1)
	Overwatch_ButtonFrame(frame, 2)
	Custom_ButtonFrame(frame,3)
    Exit_ButtonFrame(frame, 4)
end

----------------------------------------------------------------
--> Custom Layout Setup wizard
----------------------------------------------------------------

local function CSW_Picture_Frame(frame)
	local Dummy = CreateFrame("Frame", nil, frame)
	Dummy: SetSize(946,540)

	local Backdrop = F.Create.Backdrop(Dummy, 2, true, 6, 6, C.Color.Main0, 0.9, C.Color.Main0, 0.9)
	local Picture = F.Create.Texture(Dummy, "ARTWORK", 1, F.Path("Picture\\CSW_Backdrop"), nil, nil, {1024,1024})
	Picture: SetPoint("CENTER")

	Dummy.Picture = Picture

	return Dummy
end

local function CSW_BackButton_Template(frame)
	local Dummy = CreateFrame("Button", nil, frame)
	Dummy: SetSize(96, 28)

	local Icon = F.Create.Texture(Dummy, "ARTWORK", 1, F.Path("Config_Arrow"), C.Color.W3, 1, {32,32})
	Icon: SetPoint("LEFT", Dummy, "LEFT", 0,0)
	local Text = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 16, nil, C.Color.W3,1, C.Color.Config.Back,1, {1,-1}, "CENTER", "CENTER")
	Text: SetPoint("CENTER", Dummy, "CENTER", 10,0)
	local Bg = F.Create.Backdrop(Dummy, 2, true, 2, 2, C.Color.Config.Bar1, 0, C.Color.Config.Bar1, 0)

	Dummy: SetScript("OnEnter", function(self)
        Bg: SetBackdropBorderColor(F.Color(C.Color.W3, 0.9))
	end)
	Dummy: SetScript("OnLeave", function(self)
        Bg: SetBackdropBorderColor(F.Color(C.Color.W3, 0))
	end)
	Dummy: SetScript("OnClick", function(self)
		frame:Hide()
		Quafe_Setupwizard:Show()
	end)
	Dummy: SetScript("OnShow", function(self)
		Text: SetText(L['BACK'])
	end)

	return Dummy
end

local function CSW_PlayerConfirm(database)
	if database and database == "OVERWATCH" then
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color then
			Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State = "Overwatch2"
			local theme = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State
			C.Color.Main1 = C.Color.Theme[theme].Main1
			C.Color.Main2 = C.Color.Theme[theme].Main2
			C.Color.Main3 = C.Color.Theme[theme].Main3
			C.Color.Warn1 = C.Color.Theme[theme].Warn1
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame then
			Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable = true
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame then
			Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable = true
		end
	else
		if Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame then
			Quafe_DB.Profile[Quafe_DBP.Profile].OW_PlayerFrame.Enable = false
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame then
			Quafe_DB.Profile[Quafe_DBP.Profile].OW_MinimapFrame.Enable = false
		end
	end

	if database and database == "MEKA" then
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color then
			Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State = "Blue1"
			local theme = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State
			C.Color.Main1 = C.Color.Theme[theme].Main1
			C.Color.Main2 = C.Color.Theme[theme].Main2
			C.Color.Main3 = C.Color.Theme[theme].Main3
			C.Color.Warn1 = C.Color.Theme[theme].Warn1
		end
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame then
			Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame.Enable = true
		end
	else
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame then
			Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_PlayerFrame.Enable = false
		end
	end
end

local function CSW_HudConfirm(database)
	if (not database) or database == "NONE" then
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD then
			Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.State = "OFF"
		end
	else
		if Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD then
			Quafe_DB.Profile[Quafe_DBP.Profile].MEKA_HUD.State = database
		end
	end
end

local function CSW_ActionConfirm(database)
	if database and database == "MEKA" then
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ActionBar then
			Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ActionBar.Enable = true
		end
	else
		if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ActionBar then
			Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ActionBar.Enable = false
		end
	end
end

local function CSW_OnConfirm(frame)
	CSW_PlayerConfirm(frame.Custom_List.ButtonHolds[1].Select)
	CSW_HudConfirm(frame.Custom_List.ButtonHolds[2].Select)
	CSW_ActionConfirm(frame.Custom_List.ButtonHolds[3].Select)
end

local function CSW_ConfirmButton_Template(frame)
	local Dummy = CreateFrame("Button", nil, frame)
	Dummy: SetSize(240, 28)

	local Text = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 16, nil, C.Color.W3,1, C.Color.Config.Back,1, {1,-1}, "CENTER", "CENTER")
	Text: SetPoint("CENTER", Dummy, "CENTER", 0,0)
	local Bg = F.Create.Backdrop(Dummy, 2, true, 2, 2, C.Color.Y1, 0.9, C.Color.Y1, 0.9)

	Dummy: SetScript("OnEnter", function(self)
		Bg: SetBackdropColor(F.Color(C.Color.Y1, 0.7))
        Bg: SetBackdropBorderColor(F.Color(C.Color.W3, 0.9))
	end)
	Dummy: SetScript("OnLeave", function(self)
		Bg: SetBackdropColor(F.Color(C.Color.Y1, 0.9))
        Bg: SetBackdropBorderColor(F.Color(C.Color.Y1, 0.9))
	end)
	Dummy: SetScript("OnClick", function(self)
		CSW_OnConfirm(frame)
		Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Setupwizard.Init = true
		Quafe_WarningReload()
	end)
	Dummy: SetScript("OnShow", function(self)
		Text: SetText(L['CONFIRM'])
	end)

	return Dummy
end

local function UpdateLineButtonState(frame)
	local Children = {frame:GetChildren()}
	for k,v in ipairs(Children) do
		if frame.Select == v.Select then
			v.Color = C.Color.B1
			v.Picture: Show()
		else
			v.Color = C.Color.W2
			v.Picture: Hide()
		end
		if v:IsMouseOver() then
			v.Bg: SetBackdropColor(F.Color(v.Color, 0.7))
			v.Bg: SetBackdropBorderColor(F.Color(C.Color.W3, 0.9))
		else
			v.Bg: SetBackdropColor(F.Color(v.Color, 0.9))
			v.Bg: SetBackdropBorderColor(F.Color(v.Color, 0.9))
		end
	end
end

local function CSW_Button_Template(frame, index, title_text, texture, size, position)
	local Dummy = CreateFrame("Button", nil, frame)
	Dummy: SetSize(128, 28)
	Dummy: SetPoint("LEFT", frame, "LEFT", 20+144*index,-6)
	Dummy.Color = C.Color.W2

	local Text = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 16, nil, C.Color.W3,1, C.Color.Config.Back,1, {1,-1}, "CENTER", "CENTER")
	Text: SetPoint("CENTER", Dummy, "CENTER", 0,0)
	Text: SetText(L['INVALID'])
	local Bg = F.Create.Backdrop(Dummy, 2, true, 2, 2, Dummy.Color, 0.9, Dummy.Color, 0.9)

	local Picture = Dummy: CreateTexture(nil, "ARTWORK")
	if texture then
		Picture: SetTexture(F.Path("Picture\\"..texture))
		Picture: SetSize(unpack(size))
		Picture: SetPoint("CENTER", frame.Picture, "CENTER", position[1], position[2])
	end
	Picture: Hide()
	
	Dummy: SetScript("OnEnter", function(self)
		Bg: SetBackdropColor(F.Color(self.Color, 0.7))
        Bg: SetBackdropBorderColor(F.Color(C.Color.W3, 0.9))
	end)
	Dummy: SetScript("OnLeave", function(self)
		Bg: SetBackdropColor(F.Color(self.Color, 0.9))
        Bg: SetBackdropBorderColor(F.Color(self.Color, 0.9))
	end)
	Dummy: SetScript("OnClick", function(self)
		if frame.Select == Dummy.Select then
			frame.Select = nil
		else
			frame.Select = Dummy.Select
		end
		UpdateLineButtonState(frame)
	end)
	Dummy: SetScript("OnShow", function(self)
		Text: SetText(title_text)
	end)

	Dummy.Text = Text
	Dummy.Bg = Bg
	Dummy.Picture = Picture

	return Dummy
end

local Mouse_Wheel = function(scroll, slider)
	scroll:EnableMouseWheel(true)
	scroll:SetScript("OnMouseWheel", function(self, d)
		local maxRange = scroll:GetVerticalScrollRange()
		local Range = scroll:GetVerticalScroll()
		Range = max(min(Range - d*30, maxRange), 0)
		scroll: SetVerticalScroll(Range)
		slider: SetValue(Range)
	end)
end

local function CSW_Scroll_Template(frame)
	local Scroll = CreateFrame("ScrollFrame", nil, frame)
	Scroll: SetSize(540,540)
	
	local Slider = CreateFrame("Slider", nil, Scroll)
	Slider: SetOrientation("VERTICAL")
	Slider: SetThumbTexture(F.Path("Config_Slider"), "ARTWORK")
	Slider: SetSize(18,536)
	Slider: SetPoint("LEFT", Scroll, "RIGHT", 10, 0)
	Slider: SetMinMaxValues(0, 540)
	Slider: SetValue(F.Debug)
	Slider: SetValueStep(1)
	Slider: Enable()
	Slider: Hide()

	local SliderBg = F.Create.Texture(Slider, "BACKGROUND", 1, F.Path("White"), C.Color.W3, 0.4, {4,536})
	SliderBg: SetPoint("CENTER", Slider, "CENTER", 0,0)
	
	Slider: SetScript("OnValueChanged", function(self)
		--local maxRange = Scroll:GetVerticalScrollRange()
		Scroll: SetVerticalScroll(self:GetValue())
	end)

	local Hold = CreateFrame("Frame", nil, Scroll)
	Hold: SetSize(540, 2)
	Scroll: SetScrollChild(Hold)
	Mouse_Wheel(Scroll, Slider)

	Scroll.Hold = Hold
	Scroll.Slider = Slider
	Scroll.Bar = {}

	return Scroll
end

local function CSW_List_Template(frame, title_text)
	local Dummy = CreateFrame("Frame", nil, frame)
	Dummy: SetSize(frame:GetWidth(),84)

	local Line = F.Create.Texture(Dummy, "ARTWORK", 1, F.Path("White"), C.Color.W3, 0.25)
	Line: SetPoint("TOPLEFT", Dummy, "TOPLEFT", 0,0)
	Line: SetPoint("BOTTOMRIGHT", Dummy, "TOPRIGHT", 0,-2)

	local TiTle = F.Create.Font(Dummy, "ARTWORK", C.Font.Txt, 14, nil, C.Color.W3,0.9, C.Color.Config.Back,1, {1,-1}, "LEFT", "CENTER")
    TiTle: SetPoint("TOPLEFT", Line, "BOTTOMLEFT", 2,-2)

	Dummy: SetScript("OnShow", function(self)
		TiTle: SetText(title_text)
	end)

	return Dummy
end

local function CustomSetupwizard_List(frame)
	local Custom_List = CreateFrame("Frame", nil, frame)
	Custom_List: SetPoint("TOPLEFT", frame, "TOPLEFT", 0,-52)
	Custom_List: SetPoint("BOTTOMRIGHT", frame, "BOTTOMRIGHT", 0,52)

	local ButtonHolds = {}

	ButtonHolds[1] = CSW_List_Template(Custom_List, L['PLAYER_FRAME'].." / "..L['MINI_MAP'])
	ButtonHolds[1]: SetPoint("TOP", Custom_List, "TOP")
	ButtonHolds[1].Button1 = CSW_Button_Template(ButtonHolds[1], 0, "MEKA", "CSW_MK_PlayerFrame", {1024,256}, {0,-160})
	ButtonHolds[1].Button1.Select = "MEKA"
	ButtonHolds[1].Button2 = CSW_Button_Template(ButtonHolds[1], 1, "Overwatch", "CSW_OW_PlayerFrame", {1024,128}, {0,-180})
	ButtonHolds[1].Button2.Select = "OVERWATCH"
	
	ButtonHolds[2] = CSW_List_Template(Custom_List, "HUD")
	ButtonHolds[2]: SetPoint("TOP", ButtonHolds[1], "BOTTOM")
	ButtonHolds[2].Button1 = CSW_Button_Template(ButtonHolds[2], 0, "MEKA Ring", "CSW_MK_Ring", {1024,256}, {0,0})
	ButtonHolds[2].Button1.Select = "RING"
	ButtonHolds[2].Button2 = CSW_Button_Template(ButtonHolds[2], 1, "MEKA Loop", "CSW_MK_Loop", {1024,256}, {0,0})
	ButtonHolds[2].Button2.Select = "LOOP"

	ButtonHolds[3] = CSW_List_Template(Custom_List, L['ACTION_BAR'])
	ButtonHolds[3]: SetPoint("TOP", ButtonHolds[2], "BOTTOM")
	ButtonHolds[3].Button1 = CSW_Button_Template(ButtonHolds[3], 0, "MEKA", "CSW_MK_Action", {256,64}, {0,-240})
	ButtonHolds[3].Button1.Select = "MEKA"

	ButtonHolds[4] = CSW_List_Template(Custom_List, "")
	ButtonHolds[4]: SetPoint("TOP", ButtonHolds[3], "BOTTOM")

	frame.Custom_List = Custom_List
	frame.Custom_List.ButtonHolds = ButtonHolds
end

local function CustomSetupwizard_Artwork(frame)
    local Backdrop = F.Create.Backdrop(frame, 2, true, 6, 6, C.Color.Main0, 0.9, C.Color.Main0, 0.9)
    local TiTle = F.Create.Font(frame, "ARTWORK", C.Font.Txt, 16, nil, C.Color.W2,1, C.Color.Config.Back,1, {1,-1}, "LEFT", "CENTER")
    TiTle: SetText(L['CUSTOM_LAYOUT'])
    TiTle: SetPoint("CENTER", frame, "TOP", 0,-26)
	--local Line = F.Create.Texture(frame, "ARTWORK", 1, F.Path("White"), C.Color.W3, 0.25, {360,2})
	--Line: SetPoint("CENTER", TiTle, "CENTER", 0,-26)

	local Back_Button = CSW_BackButton_Template(frame)
	Back_Button: SetPoint("LEFT", frame, "TOPLEFT", 10,-26)

	local Confirm_Button = CSW_ConfirmButton_Template(frame)
	Confirm_Button: SetPoint("CENTER", frame, "BOTTOM", 0,26)

	--frame.Scroll = CSW_Scroll_Template(frame)
	--frame.Scroll: SetPoint("CENTER", frame, "CENTER", 0, 0)

	local Picture = CSW_Picture_Frame(frame)
	Picture: SetPoint("LEFT", frame, "RIGHT", 10,0)
end

local function CustomSetupwizard_Frame(frame)
	local CustomSetupwizard = CreateFrame("Frame", nil, E)
	CustomSetupwizard: SetFrameStrata("HIGH")
	CustomSetupwizard: SetToplevel(true)
	CustomSetupwizard: SetSize(40-16+144*3,540)
	CustomSetupwizard: SetPoint("LEFT", frame, "LEFT")
	CustomSetupwizard: Hide()

	CustomSetupwizard_Artwork(CustomSetupwizard)
	CustomSetupwizard_List(CustomSetupwizard)

	frame.CustomSetupwizard = CustomSetupwizard
end

----------------------------------------------------------------
--> Setup wizard Load
----------------------------------------------------------------

local Quafe_Setupwizard = CreateFrame("Frame", "Quafe_Setupwizard", E)
Quafe_Setupwizard: SetFrameStrata("HIGH")
Quafe_Setupwizard: SetToplevel(true)
Quafe_Setupwizard: SetSize(360,420)
Quafe_Setupwizard: SetPoint("LEFT", UIParent, "LEFT", 20,0)
Quafe_Setupwizard: Hide()

local function Quafe_Setupwizard_Load()
    Setupwizard_Artwork(Quafe_Setupwizard)
	CustomSetupwizard_Frame(Quafe_Setupwizard)
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

