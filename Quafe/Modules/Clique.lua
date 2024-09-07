local E, C, F, L = unpack(Quafe)  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> API Localization
----------------------------------------------------------------

local _G = getfenv(0)
local min = math.min
local max = math.max
local format = string.format
local floor = math.floor
local sqrt = math.sqrt
local sin = math.sin
local cos = math.cos
local rad = math.rad

local insert = table.insert
local remove = table.remove
local wipe = table.wipe

local find = string.find

----------------------------------------------------------------
--> Clique
----------------------------------------------------------------

local function CliqueSupport(object, unit)
	--> For Clique, sourced from oUF.
	if (Clique) then
		unit = gsub(unit, "(%d)", "")
		if Quafe_DB.Profile[Quafe_DBP.Profile].Clique and Quafe_DB.Profile[Quafe_DBP.Profile].Clique.Enable and Quafe_DB.Profile[Quafe_DBP.Profile].Clique[unit] then
			_G.ClickCastFrames = ClickCastFrames or {}
			ClickCastFrames[object] = true
		end
	end
end
F.CliqueSupport = CliqueSupport

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

local CliqueSupportFrame = CreateFrame("Frame", nil, E)

local CliqueSupportFrame_Config = {
	Database = {
		Clique = {
			Enable = false,
			player = true,
			pet = true,
			target = true,
			targettarget = true,
			focus = true,
			focustarget = true,
			party = true,
			boss = true,
		},
	},

	Config = {
		Name = L['CLIQUE_SUPPORT'],
		Type = "Switch",
		Click = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.Enable then
				Quafe_DB.Profile[Quafe_DBP.Profile].Clique.Enable = false
				self.Text:SetText(L["OFF"])
				Quafe_NoticeReload()
			else
				Quafe_DB.Profile[Quafe_DBP.Profile].Clique.Enable = true
				self.Text:SetText(L["ON"])
				Quafe_NoticeReload()
			end
		end,
		Show = function(self, button)
			if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.Enable then
				self.Text:SetText(L["ON"])
			else
				self.Text:SetText(L["OFF"])
			end
		end,
		Sub = {
			[1] = {
				Name = L['PLAYER_FRAME'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.player then
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.player = false
						self.Text:SetText(L["OFF"])
						Quafe_NoticeReload()
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.player = true
						self.Text:SetText(L["ON"])
						Quafe_NoticeReload()
					end
				end,
				Show = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.player then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[2] = {
				Name = L['TARGET_FRAME'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.target then
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.target = false
						self.Text:SetText(L["OFF"])
						Quafe_NoticeReload()
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.target = true
						self.Text:SetText(L["ON"])
						Quafe_NoticeReload()
					end
				end,
				Show = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.target then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[3] = {
				Name = L['FOCUS_FRAME'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.focus then
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.focus = false
						self.Text:SetText(L["OFF"])
						Quafe_NoticeReload()
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.focus = true
						self.Text:SetText(L["ON"])
						Quafe_NoticeReload()
					end
				end,
				Show = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.focus then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[4] = {
				Name = L['PARTY_FRAME'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.party then
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.party = false
						self.Text:SetText(L["OFF"])
						Quafe_NoticeReload()
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.party = true
						self.Text:SetText(L["ON"])
						Quafe_NoticeReload()
					end
				end,
				Show = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.party then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
			[5] = {
				Name = L['BOSS_FRAME'],
				Type = "Switch",
				Click = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.boss then
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.boss = false
						self.Text:SetText(L["OFF"])
						Quafe_NoticeReload()
					else
						Quafe_DB.Profile[Quafe_DBP.Profile].Clique.boss = true
						self.Text:SetText(L["ON"])
						Quafe_NoticeReload()
					end
				end,
				Show = function(self, button)
					if Quafe_DB.Profile[Quafe_DBP.Profile].Clique.boss then
						self.Text:SetText(L["ON"])
					else
						self.Text:SetText(L["OFF"])
					end
				end,
			},
		},
	},
}

CliqueSupportFrame.Config = CliqueSupportFrame_Config
insert(E.Module, CliqueSupportFrame)

