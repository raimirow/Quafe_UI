local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Local
--local ChatModule = Quafe:NewModule("Chat", "AceHook-3.0")

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

local match = string.match

----------------------------------------------------------------
--> Init
----------------------------------------------------------------

local function Quafe_ChatFrame_FontSize()
	--> 增加聊天栏字体大小选项
	for i = 1, 7 do
		CHAT_FONT_HEIGHTS[i] = i + 10
	end
end

local function Quafe_ChatFrame_Init(f)
	CHAT_FRAME_TAB_NORMAL_NOMOUSE_ALPHA = 0
	CHAT_FRAME_TAB_SELECTED_NOMOUSE_ALPHA = 0
	--CHAT_TIMESTAMP_FORMAT = TIMESTAMP_FORMAT_HHMM_24HR
	F.HideFrame(ChatFrameMenuButton, true)
	if F.IsClassic then

	else
		F.HideFrame(QuickJoinToastButton, true)
	end
	Quafe_ChatFrame_FontSize()
end

----------------------------------------------------------------
--> Skin
----------------------------------------------------------------

local backdrop = {
	bgFile = F.Path("White"),
	edgeFile = "",
	tile = true, tileSize = 16, edgeSize = 0,
	insets = {left = 0, right = 0, top = 0, bottom = 0}
}

local function HideTexture(f)
	f:SetTexture(nil)
	f.SetTexture = function() return end
end

local function QuafeChatMenu_SetShown(frame, editbox)
	if QuafeChatMenu then
		if QuafeChatMenu: IsShown() then
			QuafeChatMenu: Hide()
		else
			QuafeChatMenu: ClearAllPoints()
			QuafeChatMenu: SetPoint("BOTTOMLEFT", frame, "TOPRIGHT", 4,4)
			QuafeChatMenu: Show()
		end
	end
	editbox: ClearFocus()
end

local function MenuButton_Template(frame, editbox)
	local MenuButton = CreateFrame("Button", frame:GetName().."MenuButton", frame, "BackdropTemplate")
	MenuButton: SetFrameLevel(frame:GetFrameLevel()+1)
	MenuButton: SetWidth(28)
	MenuButton: SetPoint("TOPRIGHT", editbox, "TOPLEFT", -4,-3)
	MenuButton: SetPoint("BOTTOMRIGHT", editbox, "BOTTOMLEFT", -4,3)
	MenuButton: SetBackdrop(backdrop)
	MenuButton: SetBackdropColor(F.Color(C.Color.Black, 0))
	MenuButton: RegisterForClicks("LeftButtonUp", "RightButtonUp")
	MenuButton: SetAlpha(0.4)
	--MenuButton: Hide()

	local Icon1 = MenuButton: CreateTexture(nil, "ARTWORK")
	Icon1: SetTexture(F.Path("Config_ArrowDown"))
    Icon1: SetSize(28,28)
    Icon1: SetPoint("CENTER")
    Icon1: SetVertexColor(F.Color(C.Color.White))

	local Icon2 = MenuButton: CreateTexture(nil, "ARTWORK")
    Icon2: SetTexture(F.Path("Icons\\ChatIcon16"))
    Icon2: SetSize(16,16)
    Icon2: SetPoint("CENTER")
    Icon2: SetVertexColor(F.Color(C.Color.White))
	Icon2: SetAlpha(0)

	MenuButton: SetScript("OnEnter", function(self, button)
		--Icon: SetVertexColor(F.Color(C.Color.Y3))
		self: SetAlpha(1)
		C_Timer.After(5, function()
			Icon1: SetAlpha(1)
			Icon2: SetAlpha(0)
			if not (editbox:HasFocus()) then
				self: SetAlpha(0.4)
			end
		end)
		Icon1: SetAlpha(0)
		Icon2: SetAlpha(1)

		--QuafeChatMenu_SetShown(self, editbox)
	end)

	MenuButton: SetScript("OnLeave", function(self, button)
		--Icon: SetVertexColor(F.Color(C.Color.White))
		--if not (editbox:HasFocus()) then
		--	self: SetAlpha(0.4)
		--end
	end)

	MenuButton: SetScript("OnMouseDown", function(self, button)
		Icon2: SetTexCoord(-0.1,1.1,-0.1,1.1)
	end)
	MenuButton: SetScript("OnMouseUp", function(self, button)
		Icon2: SetTexCoord(0,1,0,1)
		QuafeChatMenu_SetShown(self, editbox)
	end)

	return MenuButton
end

local function Quafe_ChatFrame_Skin_Event(f, event)
	for _, frameName in pairs(CHAT_FRAMES) do
		local ChatFrame = _G[frameName]
		if not ChatFrame.styled then
            local Tab = _G[frameName.."Tab"]
            local EditBox = _G[frameName.."EditBox"]
            local i = ChatFrame:GetID()
			 
			for tex = 1, #CHAT_FRAME_TEXTURES do
				_G[frameName..CHAT_FRAME_TEXTURES[tex]]:SetTexture(nil)
			end
			
			if i == 2 then
				
			end
			
			local ebParts = {"Left", "Mid", "Right", "Middle"}
			for _, ebParts in ipairs(ebParts) do
				if _G[frameName.."EditBox"..ebParts] then
					HideTexture(_G[frameName.."EditBox"..ebParts])
				end
				if _G[frameName.."EditBoxFocus"..ebParts] then
					HideTexture(_G[frameName.."EditBoxFocus"..ebParts])
				end
				if _G[frameName.."Tab"..ebParts] then
					HideTexture(_G[frameName.."Tab"..ebParts])
				end
				if _G[frameName.."TabHighlight"..ebParts] then
					HideTexture(_G[frameName.."TabHighlight"..ebParts])
				end
				if _G[frameName.."TabSelected"..ebParts] then
					HideTexture(_G[frameName.."TabSelected"..ebParts])
				end
			end
			
			F.HideFrame(_G[frameName.."ButtonFrame"], true)
			F.HideFrame(_G[frameName.."EditBoxLanguage"], true)
			if (not F.IsClassic) then
				F.HideFrame(ChatFrame.ScrollBar, true)
			end
			
			ChatFrame: SetShadowColor(0,0,0)
			ChatFrame: SetShadowOffset(1,-1)
			ChatFrame: SetSpacing(1)
			
			ChatFrame: SetFading(true)
			ChatFrame: SetFadeDuration(1.5)  --> 3
			ChatFrame: SetTimeVisible(20)  --> 120
			
			Tab: SetClampedToScreen(true)
			Tab: SetAlpha(0)
			Tab.noMouseAlpha = 0
			ChatFrame: SetClampedToScreen(true)
			
			local FrameBack = CreateFrame("Frame", frameName.."_Backdrop", ChatFrame, "BackdropTemplate")
			FrameBack: SetFrameLevel(ChatFrame:GetFrameLevel()-1)
			if i == 2 then
				FrameBack: SetPoint("TOPLEFT", ChatFrame, "TOPLEFT", -4-28,26)
			else
				--FrameBack: SetPoint("TOPLEFT", ChatFrame, "TOPLEFT", -3,3)
				FrameBack: SetPoint("TOPLEFT", ChatFrame, "TOPLEFT", -4-28,4)
			end
			--FrameBack: SetPoint("BOTTOMRIGHT", ChatFrame, "BOTTOMRIGHT", 1+26,-3)
			FrameBack: SetPoint("BOTTOMRIGHT", ChatFrame, "BOTTOMRIGHT", 4,-4)
			FrameBack: SetBackdrop(backdrop)
			FrameBack: SetBackdropColor(F.Color(C.Color.Black, 0.6))
			--FrameBack: SetClampedToScreen(true)
			FrameBack: SetAlpha(1)
			FrameBack: Hide()

			--ChatFrame.ScrollBar: SetThumbTexture(F.Path("Config_Slider"), "ARTWORK")
			local FrameSlider = CreateFrame("Slider", frameName.."_Slider", ChatFrame)
			FrameSlider: SetFrameLevel(FrameBack:GetFrameLevel()+2)
			FrameSlider: SetOrientation("VERTICAL")
			FrameSlider: SetThumbTexture(F.Path("Config_Slider"), "ARTWORK")
			FrameSlider: SetSize(18,18)
			--FrameSlider: SetPoint("TOPRIGHT", FrameBack, "TOPRIGHT", -3,-8)
			--FrameSlider: SetPoint("BOTTOMRIGHT", FrameBack, "BOTTOMRIGHT", -3,8)
			FrameSlider: SetPoint("TOPLEFT", FrameBack, "TOPLEFT", 5,-8)
			FrameSlider: SetPoint("BOTTOMLEFT", FrameBack, "BOTTOMLEFT", 5,8)
			FrameSlider: SetMinMaxValues(1, 2)
			FrameSlider: SetValue(1)
			FrameSlider: SetValueStep(1)
			FrameSlider: SetObeyStepOnDrag(true)
			FrameSlider: SetAlpha(0.4)
			
			FrameSlider: SetScript("OnValueChanged", function(self, value)
				local min, max = self:GetMinMaxValues();
				self:GetParent(): SetScrollOffset(max - value);
			end)
			
			ChatFrame.Slider = FrameSlider

			local function Slider_Update(self)
				local numMessages = ChatFrame:GetNumMessages()
				local Scroll_Offset = ChatFrame:GetScrollOffset()
				local isShown = numMessages > 1;
				if isShown then
					numMessages = max(1,numMessages);
					self.Slider:SetMinMaxValues(1, numMessages);
					self.Slider:SetValue(numMessages - Scroll_Offset);
					-- If the chat frame was already faded in, and something caused the scrollbar to show
					-- it also needs to update fading in addition to showing.
					--if (self.hasBeenFaded) then
					--	FCF_FadeInScrollbar(self);
					--end
				end
			end
			ChatFrame.Slider: RegisterEvent("PLAYER_ENTERING_WORLD")
			--ChatFrame.Slider: RegisterEvent("VARIABLES_LOADED")
			ChatFrame.Slider: SetScript("OnEvent", function(self, event, isLogin, isReload)
				if isLogin or isReload then
					C_Timer.After(1, function() 
						local numMessages = ChatFrame:GetNumMessages();
						--local Scroll_Offset = ChatFrame:GetScrollOffset()
						local isShown = numMessages > 1;
						if isShown then
							numMessages = max(2,numMessages);
							--self: SetMinMaxValues(1, numMessages);
							--self: SetValue(numMessages);
							--self: SetValue(1);
							--ChatFrame_ScrollToBottom()
							print("")
						end
					end)
				end
				--self: UnregisterEvent("PLAYER_ENTERING_WORLD")
			end)
			ChatFrame:SetOnScrollChangedCallback(function(messageFrame, offset)
				messageFrame.Slider:SetValue(messageFrame:GetNumMessages() - offset);
			end);
			ChatFrame:AddOnDisplayRefreshedCallback(Slider_Update);
			
			local FrameSliderHelp = CreateFrame("Frame", nil, ChatFrame)
			FrameSliderHelp: SetFrameLevel(FrameBack:GetFrameLevel()+1)
			FrameSliderHelp: SetPoint("TOPLEFT", FrameSlider, "TOPLEFT", -14, 30)
			FrameSliderHelp: SetPoint("BOTTOMRIGHT", FrameSlider, "BOTTOMRIGHT", 18, -30)
			
			FrameSliderHelp: SetScript("OnEnter", function(self)
				FrameSlider: SetAlpha(0.9)
			end)
			FrameSliderHelp: SetScript("OnLeave", function(self)
				if not (FrameSlider:IsMouseOver() or FrameBack:IsShown()) then
					FrameSlider: SetAlpha(0.4)
				end
			end)
			FrameSlider: SetScript("OnLeave", function(self)
				if (not (FrameSlider:IsMouseOver() or FrameSliderHelp:IsMouseOver())) and FrameSliderHelp:IsShown() and (not FrameBack:IsShown()) then
					FrameSlider: SetAlpha(0.4)
				end
			end)
			
			local FrameSliderBack = FrameSlider:CreateTexture(nil, "BACKGROUND")
			FrameSliderBack: SetTexture(F.Path("White"))
			FrameSliderBack: SetVertexColor(F.Color(C.Color.White2))
			FrameSliderBack: SetWidth(4)
			FrameSliderBack: SetPoint("TOP", FrameSlider, "TOP", 0,0)
			FrameSliderBack: SetPoint("BOTTOM", FrameSlider, "BOTTOM", 0,0)
			FrameSliderBack: SetAlpha(0.4)
			
			EditBox: ClearAllPoints()
			EditBox: SetPoint("TOPLEFT", ChatFrame, "BOTTOMLEFT", 0, -4)
			EditBox: SetPoint("TOPRIGHT", ChatFrame, "BOTTOMRIGHT", -26, -4)

			local EditBoxBack = CreateFrame("Frame", nil, EditBox, "BackdropTemplate")
			EditBoxBack: SetFrameLevel(EditBox:GetFrameLevel()-1)
			EditBoxBack: SetPoint("TOPLEFT", EditBox, "TOPLEFT", 0, -3)
			EditBoxBack: SetPoint("BOTTOMRIGHT", EditBox, "BOTTOMRIGHT", 4+26, 3)
			EditBoxBack: SetBackdrop(backdrop)
			EditBoxBack: SetBackdropColor(F.Color(C.Color.Black, 0.6))
			EditBoxBack: Hide()

			local MenuButton = MenuButton_Template(ChatFrame,EditBox)
			
			--local EditBox_Language = CreateFrame("Button", frameName.."EditBox_Language", EditBoxBack, "SecureActionButtonTemplate")
			local EditBox_Language = CreateFrame("Button", frameName.."EditBox_Language", EditBoxBack)
			EditBox_Language: SetFrameLevel(EditBox:GetFrameLevel()+1)
			EditBox_Language: SetPoint("TOPLEFT", EditBoxBack, "TOPRIGHT", -26, 0)
			EditBox_Language: SetPoint("BOTTOMRIGHT", EditBoxBack, "BOTTOMRIGHT", 0, 0)
			--EditBox_Language: SetNormalFontObject(DialogButtonNormalText)
			EditBox_Language: SetNormalFontObject(DialogButtonHighlightText)
			EditBox_Language: SetText(_G["INPUT_"..EditBox:GetInputLanguage()])
			--EditBox_Language: SetAttribute("type", "click")
			--EditBox_Language: SetAttribute("clickbutton", _G[frameName.."EditBoxLanguage"])
			EditBox_Language: SetScript("OnClick", function(self)
				EditBox: ToggleInputLanguage()
			end)
			EditBox: HookScript("OnInputLanguageChanged", function(self)
				local variable = _G["INPUT_"..self:GetInputLanguage()]
				EditBox_Language: SetText(variable)
			end)
			
			local EditBox_LanguageBorder = EditBox_Language: CreateTexture(nil, "ARTWORK")
			EditBox_LanguageBorder: SetTexture(F.Path("White"))
			EditBox_LanguageBorder: SetVertexColor(F.Color(C.Color.White))
			EditBox_LanguageBorder: SetAlpha(0.9)
			EditBox_LanguageBorder: SetPoint("TOPLEFT", EditBox_Language, "TOPLEFT", 0,-4)
			EditBox_LanguageBorder: SetPoint("BOTTOMRIGHT", EditBox_Language, "BOTTOMLEFT", 2,4)
			
			EditBox: Hide()
			EditBox: HookScript("OnEditFocusGained", function(self)
				--UIFrameFadeIn(EditBoxBack, 0.2, 0, 1)
				EditBoxBack: Show()
				--MenuButton: Show()
				MenuButton: SetAlpha(1)
				MenuButton: SetBackdropColor(F.Color(C.Color.Black, 0.6))
				FrameBack: Show()
				FrameSlider: SetAlpha(0.9)
				FrameSliderHelp: Hide()
				--EditBoxBack_MenuButton:Raise();
			end)
			EditBox: HookScript("OnEditFocusLost", function(self)
				--UIFrameFadeOut(EditBoxBack, 0.2, 1, 0)
				EditBoxBack: Hide()
				--MenuButton: Hide()
				MenuButton: SetAlpha(0.4)
				MenuButton: SetBackdropColor(F.Color(C.Color.Black, 0))
				FrameBack: Hide()
				FrameSlider: SetAlpha(0.4)
				FrameSliderHelp: Show()
				if QuafeChatMenu then
					if QuafeChatMenu: IsShown() then
						QuafeChatMenu: Hide()
					end
				end
			end)

			if i ~= 1 then
				ChatFrame1EditBox: HookScript("OnEditFocusGained", function(self)
					FrameBack: Show()
					FrameSlider: SetAlpha(0.9)
					FrameSliderHelp: Hide()
				end)
				ChatFrame1EditBox: HookScript("OnEditFocusLost", function(self)
					FrameBack: Hide()
					FrameSlider: SetAlpha(0.4)
					FrameSliderHelp: Show()
				end)
			end
			
			ChatFrame.styled = true
		end
	end
end

local function Quafe_ChatFrame_Skin(frame)
	local Skin = CreateFrame("Frame", nil, frame)
	Skin: RegisterEvent("UPDATE_CHAT_WINDOWS")
	Skin: RegisterEvent("UPDATE_FLOATING_CHAT_WINDOWS")
	if F.IsClassic then
	else
		Skin: RegisterEvent("PET_BATTLE_CLOSE")
	end
	
	Skin: SetScript("OnEvent", function(self, event, ...)
		if event == "PLAYER_ENTERING_WORLD" then
			self:UnregisterEvent("PLAYER_ENTERING_WORLD")
		else
			Quafe_ChatFrame_Skin_Event(self, event)
		end
	end)
end

----------------------------------------------------------------
--> EditBox ChatMenu
----------------------------------------------------------------

local function ChatMenu_GetEditbox()
	return ChatFrame_OpenChat("")
	--[[
	for _, frameName in pairs(CHAT_FRAMES) do
		if _G[frameName.."EditBox"]:HasFocus() then
			return _G[frameName.."EditBox"]
		end
	end
	return _G[DEFAULT_CHAT_FRAME.."EditBox"]
	--]]
end

local CHAT_CHANNEL = {
	{Text = SAY_MESSAGE, Type = "SAY"},
	{Text = YELL_MESSAGE, Type = "YELL"},
	{Text = WHISPER_MESSAGE, Type = "WHISPER"},
	{Text = EMOTE_MESSAGE, Type = "EMOTE"},
	{Text = PARTY_MESSAGE, Type = "PARTY"},
	{Text = RAID_MESSAGE, Type = "RAID"},
	{Text = RAID_WARNING, Type = "RAID_WARNING"},
	{Text = INSTANCE, Type = "INSTANCE_CHAT"},
	{Text = GUILD, Type = "GUILD"},
	{Text = OFFICER, Type = "OFFICER"},
}

local function ChatMenu_GetChannelName(index)
	if type(index) == "number" then
		local localID, channelName, instanceID, isCommunitiesChannel = GetChannelName(index)
		if ( channelName ) then
			if ( isCommunitiesChannel ) then
				channelName = ChatFrame_ResolveChannelName(channelName);
			elseif ( instanceID > 0 ) then
				channelName = channelName.." "..instanceID;
			end
			return channelName
		end
	else
		return index
	end
end

local function ChatMenu_ChannelOnClick(frame, button, chattype, index)
	if chattype == "WHISPER" then
		EditBox = ChatFrame_OpenChat(SLASH_SMART_WHISPER1.." ");
		EditBox: SetText(SLASH_SMART_WHISPER1.." "..EditBox:GetText());
	elseif chattype == "CHANNEL" then
		local EditBox = ChatMenu_GetEditbox()
		EditBox: SetAttribute("channelTarget", index)
		EditBox: SetAttribute("chatType", chattype)
		ChatEdit_UpdateHeader(EditBox)
	else
		local EditBox = ChatMenu_GetEditbox()
		EditBox: SetAttribute("chatType", chattype)
		ChatEdit_UpdateHeader(EditBox)
	end
	frame.ChatMenuFrame: Hide()
end

local function ChatMenu_ChatFrame(frame)
	local ChatFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	ChatFrame: SetSize(150,10+22*10)
	ChatFrame: SetBackdrop({
		bgFile = F.Path("White"),
		edgeFile = F.Path("White"),
		tile = true, tileSize = 16, edgeSize = 2,
		insets = {left = -2, right = -2, top = -2, bottom = -2}
	})
	ChatFrame: SetBackdropColor(F.Color(C.Color.Main0, 0.9))
	ChatFrame: SetBackdropBorderColor(F.Color(C.Color.White, 0.4))
	ChatFrame: Hide()

	local Channels = {}
	for k,v in ipairs(CHAT_CHANNEL) do
		Channels[k] = CreateFrame("Button", nil, ChatFrame, "BackdropTemplate")
		Channels[k]: SetSize(138, 20)
		if k == 1 then
			Channels[k]: SetPoint("BOTTOM", ChatFrame, "BOTTOM", 0,6)
		else
			Channels[k]: SetPoint("BOTTOM", Channels[k-1], "TOP", 0,2)
		end
		Channels[k]: SetBackdrop(backdrop)
		Channels[k]: SetBackdropColor(F.Color(C.Color.White2, 0))

		local Label = F.Create.Font(Channels[k], "ARTWORK", C.Font.Txt, 14, nil, nil, nil, nil, nil, nil, "LEFT", "CENTER")
		Label: SetPoint("TOPLEFT", Channels[k], "TOPLEFT", 4,-2)
		Label: SetPoint("BOTTOMRIGHT", Channels[k], "BOTTOMRIGHT", -4,2)
		Label: SetText(ChatMenu_GetChannelName(v.Text))

		Channels[k]: RegisterForClicks("LeftButtonDown", "RightButtonDown")
		Channels[k]: SetScript("OnClick", function(self, button)
			ChatMenu_ChannelOnClick(frame, button, v.Type, v.Text)
		end)
		Channels[k]: SetScript("OnEnter", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0.4))
		end)
		Channels[k]: SetScript("OnLeave", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0))
		end)
	end

	frame.ChatMenuChatFrame = ChatFrame
	frame.ChatMenuFrame: HookScript("OnHide", function(self)
		frame.ChatMenuChatFrame: Hide()
	end)
end

local function ChatMenu_ChannelFrame(frame)
	local ChannelFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	ChannelFrame: SetSize(200,10+22*10)
	ChannelFrame: SetBackdrop({
		bgFile = F.Path("White"),
		edgeFile = F.Path("White"),
		tile = true, tileSize = 16, edgeSize = 2,
		insets = {left = -2, right = -2, top = -2, bottom = -2}
	})
	ChannelFrame: SetBackdropColor(F.Color(C.Color.Main0, 0.9))
	ChannelFrame: SetBackdropBorderColor(F.Color(C.Color.White, 0.4))
	ChannelFrame: Hide()

	local Channels = {}
	for k = 1,10 do
		Channels[k] = CreateFrame("Button", nil, ChannelFrame, "BackdropTemplate")
		Channels[k]: SetSize(188, 20)
		if k == 1 then
			Channels[k]: SetPoint("BOTTOM", ChannelFrame, "BOTTOM", 0,6)
		else
			Channels[k]: SetPoint("BOTTOM", Channels[k-1], "TOP", 0,2)
		end
		Channels[k]: SetBackdrop(backdrop)
		Channels[k]: SetBackdropColor(F.Color(C.Color.White2, 0))

		local Label = F.Create.Font(Channels[k], "ARTWORK", C.Font.Txt, 14, nil, nil, nil, nil, nil, nil, "LEFT", "CENTER")
		Label: SetPoint("TOPLEFT", Channels[k], "TOPLEFT", 4,-2)
		Label: SetPoint("BOTTOMRIGHT", Channels[k], "BOTTOMRIGHT", -4,2)
		Label: SetText(ChatMenu_GetChannelName(k))

		Channels[k]: RegisterForClicks("LeftButtonDown", "RightButtonDown")
		Channels[k]: SetScript("OnClick", function(self, button)
			ChatMenu_ChannelOnClick(frame, button, "CHANNEL", k)
		end)
		Channels[k]: SetScript("OnEnter", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0.4))
		end)
		Channels[k]: SetScript("OnLeave", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0))
		end)

		Channels[k].Label = Label
	end

	ChannelFrame: SetScript("OnShow", function(self)
		local num = 0
		for k = 1,10 do
			local name = ChatMenu_GetChannelName(k)
			if name then
				Channels[k]: Show()
				if k == 1 then
					Channels[k]: SetPoint("BOTTOM", self, "BOTTOM", 0,6)
				else
					Channels[k]: SetPoint("BOTTOM", Channels[k-1], "TOP", 0,2)
				end
				Channels[k].Label: SetText(name)
				num = num + 1
			else
				Channels[k]: Hide()
				if k == 1 then
					Channels[k]: SetPoint("BOTTOM", self, "BOTTOM", 0,-16)
				else
					Channels[k]: SetPoint("BOTTOM", Channels[k-1], "TOP", 0,-20)
				end
			end
		end
		self: SetHeight(10+22*num)
	end)

	frame.ChatMenuChannelFrame = ChannelFrame
	frame.ChatMenuFrame: HookScript("OnHide", function(self)
		frame.ChatMenuChannelFrame: Hide()
	end)
end

local function ChatMenu_LanguageFrame(frame)
	local LanguageFrame = CreateFrame("Frame", nil, frame, "BackdropTemplate")
	LanguageFrame: SetSize(150,10+22*2)
	LanguageFrame: SetBackdrop({
		bgFile = F.Path("White"),
		edgeFile = F.Path("White"),
		tile = true, tileSize = 16, edgeSize = 2,
		insets = {left = -2, right = -2, top = -2, bottom = -2}
	})
	LanguageFrame: SetBackdropColor(F.Color(C.Color.Main0, 0.9))
	LanguageFrame: SetBackdropBorderColor(F.Color(C.Color.White, 0.4))
	LanguageFrame: Hide()

	local Languages = {}
	for k = 1,2 do
		Languages[k] = CreateFrame("Button", nil, LanguageFrame, "BackdropTemplate")
		Languages[k]: SetSize(138, 20)
		if k == 1 then
			Languages[k]: SetPoint("BOTTOM", LanguageFrame, "BOTTOM", 0,6)
		else
			Languages[k]: SetPoint("BOTTOM", Languages[k-1], "TOP", 0,2)
		end
		Languages[k]: SetBackdrop(backdrop)
		Languages[k]: SetBackdropColor(F.Color(C.Color.White2, 0))

		local Label = F.Create.Font(Languages[k], "ARTWORK", C.Font.Txt, 14, nil, nil, nil, nil, nil, nil, "LEFT", "CENTER")
		Label: SetPoint("TOPLEFT", Languages[k], "TOPLEFT", 4,-2)
		Label: SetPoint("BOTTOMRIGHT", Languages[k], "BOTTOMRIGHT", -4,2)

		Languages[k]: RegisterForClicks("LeftButtonDown", "RightButtonDown")
		Languages[k]: SetScript("OnClick", function(self, button)
			local EditBox = ChatMenu_GetEditbox()
			EditBox.language, EditBox.languageID = GetLanguageByIndex(k)
			frame.ChatMenuFrame: Hide()
		end)
		Languages[k]: SetScript("OnEnter", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0.4))
		end)
		Languages[k]: SetScript("OnLeave", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0))
		end)

		Languages[k].Label = Label
	end

	LanguageFrame: SetScript("OnShow", function(self)
		local num = 0
		for k = 1,2 do
			local name, languageID = GetLanguageByIndex(k)
			if name then
				Languages[k]: Show()
				if k ~= 1 then
					Languages[k]: SetPoint("BOTTOM", Languages[k-1], "TOP", 0,2)
				end
				Languages[k].Label: SetText(name)
				num = num + 1
			else
				Languages[k]: Hide()
				if k ~= 1 then
					Languages[k]: SetPoint("BOTTOM", Languages[k-1], "TOP", 0,-20)
				end
			end
		end
		self: SetHeight(10+22*num)
	end)

	frame.ChatMenuLanguageFrame = LanguageFrame
	frame.ChatMenuFrame: HookScript("OnHide", function(self)
		frame.ChatMenuLanguageFrame: Hide()
	end)
end

local function ChatMenu_HideMenus(frame)
	frame.ChatMenuChatFrame: Hide()
	frame.ChatMenuChannelFrame: Hide()
	frame.ChatMenuLanguageFrame: Hide()
end

local function ChatMenu_ReplyClick(frame, self, button)
	local editBox = ChatMenu_GetEditbox()
	local lastTold, lastToldType = ChatEdit_GetLastToldTarget();
	if ( lastTold ) then
		--BN_WHISPER FIXME
		editBox:SetAttribute("chatType", lastToldType);
		editBox:SetAttribute("tellTarget", lastTold);
		ChatEdit_UpdateHeader(editBox);
		if ( editBox ~= ChatEdit_GetActiveWindow() ) then
			ChatFrame_OpenChat("", chatFrame);
		end
	else
		-- Error message
	end
	frame.ChatMenuFrame: Hide()
end

local function ChatMenu_ChatClick(frame, self, button)
	--frame.ChatMenuChatFrame: SetShown(not frame.ChatMenuChatFrame:IsShown())
	frame.ChatMenuChatFrame: Show()
	frame.ChatMenuChatFrame: SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 12,0)
end

local function ChatMenu_ChannelClick(frame, self, button)
	--frame.ChatMenuChannelFrame: SetShown(not frame.ChatMenuChannelFrame:IsShown())
	frame.ChatMenuChannelFrame: Show()
	frame.ChatMenuChannelFrame: SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 12,0)
end

local function ChatMenu_VoiceMacroClick(frame, self, button)

end

local function ChatMenu_EmoteClick(frame, self, button)

end

local function ChatMenu_LanguageClick(frame, self, button)
	frame.ChatMenuLanguageFrame: Show()
	frame.ChatMenuLanguageFrame: SetPoint("BOTTOMLEFT", self, "BOTTOMRIGHT", 12,0)
end

local CHATMENU_LIST = {
	{	--回复
		Text = REPLY_MESSAGE,
		Click = ChatMenu_ReplyClick,
	},
	{	--聊天
		Text = CHAT,
		Enter = ChatMenu_ChatClick,
	},
	{	--频道
		Text = CHANNEL,
		Enter = ChatMenu_ChannelClick,
	},
	--[[
	{	--谈话
		Text = VOICEMACRO_LABEL,
		Enter = ChatMenu_VoiceMacroClick,
	},
	{	--表情
		Text = EMOTE_MESSAGE,
		Enter = ChatMenu_EmoteClick,
	},
	--]]
	{	--语言
		Text = LANGUAGE,
		Enter = ChatMenu_LanguageClick,
	},
}

local function Quafe_ChatMenu(frame)
	local ChatMenuFrame = CreateFrame("Frame", "QuafeChatMenu", frame, "BackdropTemplate")
	ChatMenuFrame: SetSize(100,10+22*4)
	ChatMenuFrame: SetBackdrop({
		bgFile = F.Path("White"),
		edgeFile = F.Path("White"),
		tile = true, tileSize = 16, edgeSize = 2,
		insets = {left = -2, right = -2, top = -2, bottom = -2}
	})
	ChatMenuFrame: SetBackdropColor(F.Color(C.Color.Main0, 0.9))
	ChatMenuFrame: SetBackdropBorderColor(F.Color(C.Color.White, 0.4))
	ChatMenuFrame: Hide()

	local Menus = {}
	for k,v in ipairs(CHATMENU_LIST) do
		Menus[k] = CreateFrame("Button", nil, ChatMenuFrame, "BackdropTemplate")
		Menus[k]: SetSize(88, 20)
		if k == 1 then
			Menus[k]: SetPoint("BOTTOM", ChatMenuFrame, "BOTTOM", 0,6)
		else
			Menus[k]: SetPoint("BOTTOM", Menus[k-1], "TOP", 0,2)
		end
		Menus[k]: SetBackdrop(backdrop)
		Menus[k]: SetBackdropColor(F.Color(C.Color.White2, 0))

		local Label = F.Create.Font(Menus[k], "ARTWORK", C.Font.Txt, 14, nil, nil, nil, nil, nil, nil, "LEFT", "CENTER")
		Label: SetPoint("TOPLEFT", Menus[k], "TOPLEFT", 4,-2)
		Label: SetPoint("BOTTOMRIGHT", Menus[k], "BOTTOMRIGHT", -4,2)
		Label: SetText(v.Text)

		Menus[k]: RegisterForClicks("LeftButtonDown", "RightButtonDown")
		if v.Click then
			Menus[k]: SetScript("OnClick", function(self, button)
				v.Click(frame, self, button)
			end)
		end
		Menus[k]: SetScript("OnEnter", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0.4))
			ChatMenu_HideMenus(frame)
			if v.Enter then
				v.Enter(frame, self, button)
			end
		end)
		Menus[k]: SetScript("OnLeave", function(self)
			self: SetBackdropColor(F.Color(C.Color.White2, 0))
		end)
	end

	ChatMenuFrame: SetScript("OnShow", function(self)
		
	end)
	ChatMenuFrame: SetScript("OnHide", function(self)
		
	end)

	frame.ChatMenuFrame = ChatMenuFrame
end

--[[
宏
语言
表情
谈话
频道
聊天
回复
--]]

----------------------------------------------------------------
--> Voice Menu
----------------------------------------------------------------

local function ChatFrame_VoiceMenu_Event(frame)
	CombatLogQuickButtonFrame_CustomTexture: SetAlpha(0)

	--ChatAlertFrame
	ChatFrameChannelButton: SetParent(frame)
	ChatFrameChannelButton: ClearAllPoints()
	ChatFrameChannelButton: SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
	if F.IsClassic then
	else
		ChatFrameToggleVoiceDeafenButton: SetParent(frame)
		ChatFrameToggleVoiceDeafenButton: ClearAllPoints();
		ChatFrameToggleVoiceDeafenButton: SetPoint("BOTTOM", ChatFrameChannelButton, "TOP", 0, 2);

		ChatFrameToggleVoiceMuteButton: SetParent(frame)
		ChatFrameToggleVoiceMuteButton: ClearAllPoints();
		ChatFrameToggleVoiceMuteButton: SetPoint("BOTTOM", ChatFrameToggleVoiceDeafenButton, "TOP", 0, 2);
	end
	--VoiceActivityManager: ClearAllPoints()
	--VoiceActivityManager: SetPoint("BOTTOMLEFT", frame, "BOTTOMLEFT")
end

local function Quafe_ChatFrame_VoiceMenuFrame(frame)
	local VoiceMenuButton = CreateFrame("Frame", nil, frame)
	VoiceMenuButton: SetSize(28,28)
	--VoiceMenuButton: SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPLEFT", -4, 4)
	VoiceMenuButton: SetPoint("BOTTOMRIGHT", ChatFrame1, "TOPLEFT", -4, 8)

	local Icon = VoiceMenuButton: CreateTexture(nil, "ARTWORK")
    Icon: SetTexture(F.Path("Config_ArrowUp"))
    Icon: SetSize(28,28)
    Icon: SetPoint("CENTER", VoiceMenuButton, "CENTER", 0,-4)
    Icon: SetVertexColor(F.Color(C.Color.White))
	Icon: SetAlpha(0.4)

	local VoiceMenuHold = CreateFrame("Frame", nil, frame)
	VoiceMenuHold: SetSize(32,32)
	VoiceMenuHold: SetPoint("BOTTOMLEFT", VoiceMenuButton, "BOTTOMLEFT")
	VoiceMenuHold: Hide()

	VoiceMenuButton: SetScript("OnEnter", function(self, button)
		C_Timer.After(5, function()
			VoiceMenuButton: Show()
			VoiceMenuHold: Hide()
		end)
		VoiceMenuHold: Show()
		VoiceMenuButton: Hide()
	end)

	VoiceMenuHold: RegisterEvent("PLAYER_ENTERING_WORLD")
	VoiceMenuHold: SetScript("OnEvent", function(self, event, ...)
		ChatFrame_VoiceMenu_Event(self)
	end)

	VoiceMenuHold: SetScript("OnShow", function(self)

	end)
end

----------------------------------------------------------------
--> Chat History
----------------------------------------------------------------

local function Quafe_ChaTFrame_SaveHistory(event, ...)
	local TEMP = {}
    for i = 1, select('#', ...) do
        TEMP[i] = select(i, ...) or false
    end
	if #TEMP > 0 then
		TEMP["Event"] = event
		table.insert(Quafe_DBP.ChatFrame_History, TEMP)
		if #Quafe_DBP.ChatFrame_History > 100 then
			table.remove(Quafe_DBP.ChatFrame_History, 1)
		end
	end
end

local function Quafe_ChatFrame_DisplayHistory()
	if not Quafe_DBP.ChatFrame_History then return end
	DEFAULT_CHAT_FRAME:AddMessage("--------------------------------")
	for i = 1, #Quafe_DBP.ChatFrame_History do
		ChatFrame_MessageEventHandler(DEFAULT_CHAT_FRAME, Quafe_DBP.ChatFrame_History[i]["Event"], unpack(Quafe_DBP.ChatFrame_History[i]))
	end
	DEFAULT_CHAT_FRAME:AddMessage("--------------------------------")
end

local History_Event = {
	"CHAT_MSG_SAY",
	"CHAT_MSG_YELL",
	"CHAT_MSG_WHISPER",
	"CHAT_MSG_WHISPER_INFORM",
	"CHAT_MSG_BN_WHISPER",
	"CHAT_MSG_BN_WHISPER_INFORM",
	"CHAT_MSG_CHANNEL",
	--"CHAT_MSG_EMOTE",
	"CHAT_MSG_GUILD",
	"CHAT_MSG_GUILD_ACHIEVEMENT",
	"CHAT_MSG_OFFICER",
	"CHAT_MSG_PARTY",
	"CHAT_MSG_PARTY_LEADER",
	"CHAT_MSG_RAID",
	"CHAT_MSG_RAID_LEADER",
	"CHAT_MSG_RAID_WARNING",
	--"CHAT_MSG_BATTLEGROUND",
	--"CHAT_MSG_BATTLEGROUND_LEADER",
}

local function Quafe_ChatFrame_History(frame)
	if not Quafe_DBP then
		Quafe_DBP = {}
	end
	if not Quafe_DBP.ChatFrame_History then
		Quafe_DBP.ChatFrame_History = {}
	end
	
	local Quafe_ChatFrame_History = CreateFrame("Frame", nil, frame)
	for k, v in ipairs(History_Event) do
		Quafe_ChatFrame_History: RegisterEvent(v)
	end
    Quafe_ChatFrame_History: SetScript("OnEvent", function(self, event, ...)
		Quafe_ChaTFrame_SaveHistory(event, ...)
	end)
	Quafe_ChatFrame_DisplayHistory()

	frame.History = Quafe_ChatFrame_History
end

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

local Quafe_ChatFrame = CreateFrame("Frame", "Quafe_ChatFrame", E)
Quafe_ChatFrame.Init = false

local function Quafe_ChatFrame_Load()
	if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ChatFrame.Enable then
		Quafe_ChatFrame_Init(Quafe_ChatFrame)
		Quafe_ChatFrame_Skin(Quafe_ChatFrame)
		Quafe_ChatMenu(Quafe_ChatFrame)
		ChatMenu_ChatFrame(Quafe_ChatFrame)
		ChatMenu_ChannelFrame(Quafe_ChatFrame)
		ChatMenu_LanguageFrame(Quafe_ChatFrame)
		Quafe_ChatFrame_VoiceMenuFrame(Quafe_ChatFrame)
		Quafe_ChatFrame_History(Quafe_ChatFrame)
		Quafe_ChatFrame.Init = true
	end
end

local function Quafe_ChatFrame_Toggle(arg)
	if arg == "ON" then
		Quafe_NoticeReload()
	elseif arg == "OFF" then
		Quafe_NoticeReload()
	end
end

local Quafe_ChatFrame_Config = {
	Database = {
		Quafe_ChatFrame = {
			Enable = true,
		},
	},

	Config = {
		Name = "Quafe "..L['CHAT_FRAME'],
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ChatFrame.Enable then
				Quafe_ChatFrame_Toggle("OFF")
				Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ChatFrame.Enable = false
				self.Text:SetText(L["OFF"])
			else
				Quafe_ChatFrame_Toggle("ON")
				Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ChatFrame.Enable = true
				self.Text:SetText(L["ON"])
			end
		end,
		Show = function(self)
			if Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_ChatFrame.Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = nil,
	},
}

Quafe_ChatFrame.Load = Quafe_ChatFrame_Load
Quafe_ChatFrame.Config = Quafe_ChatFrame_Config
insert(E.Module, Quafe_ChatFrame)

----------------------------------------------------------------

-- ScrollingMessageFrame:SetScrollOffset(offset)
-- ScrollingMessageFrame:GetScrollOffset()

-- ScrollingMessageFrame:GetMaxLines() - Get the maximum number of lines the frame can display.
-- ScrollingMessageFrame:GetMaxScrollRange()