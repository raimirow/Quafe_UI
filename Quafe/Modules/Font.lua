local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)
local insert = table.insert
local wipe = table.wipe
local sort = table.sort

local LibShareMeida = LibStub("LibSharedMedia-3.0")
local SORTED_LIST = {}

----------------------------------------------------------------
--> Font List
----------------------------------------------------------------

local function Set_List(frame, list) -- Set the list of values for the dropdown (key => value pairs)
	frame.List = list or LibShareMeida:HashTable("font")
    frame.List.Arimo = F.Path("Fonts\\Arimo.ttf")
    frame.List.ShareTech = F.Path("Fonts\\ShareTech.ttf")
    frame.List.Share = F.Path("Fonts\\Share.ttf")
end

local function textSort(a,b)
    return string.upper(a) < string.upper(b)
end

local function Sort_List(frame)
    wipe(SORTED_LIST)
    local num = 0
    for k,v in pairs(frame.List) do
        insert(SORTED_LIST, k)
    end
    sort(SORTED_LIST, textSort)
end

local function Update_Font(frame)
    C.Font.Txt = frame.List[Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Font.Txt] or C.Font.Txt
    C.Font.Num = frame.List[Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Font.Num] or C.Font.Num
    C.Font.Big = frame.List[Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Font.Big] or C.Font.Big
end

----------------------------------------------------------------
--> Font
----------------------------------------------------------------

local Quafe_Font = CreateFrame("Frame", nil, E)

local function Quafe_Font_Load()
	Set_List(Quafe_Font)
    Sort_List(Quafe_Font)
    Update_Font(Quafe_Font)
end

local function Quafe_Font_Toggle(arg1,arg2)
    Update_Font(Quafe_Font)
end

local function FontDropdown_Refresh(dropmenu, data)
    wipe(dropmenu)
	for k,v in ipairs(SORTED_LIST) do
		dropmenu[k] = {
            Text = v,
            Font = Quafe_Font.List[v] ~= v and Quafe_Font.List[v] or LibShareMeida:Fetch('font',v),
			Click = function(self, button)
				Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Font[data] = v
                Quafe_Font_Toggle()
				Quafe_NoticeReload()
			end,
		}
	end
end

local Quafe_Font_Config = {
	Database = {
		Quafe_Font = {
			Txt = UNIT_NAME_FONT,
            Num = "Arimo",
            Big = "Share",
		},
	},

	Config = {
		Name = L['FONT'],
		Type = "Blank",
		Sub = {
            [1] = {
                Name = L['TEXT'],
                Type = "Dropdown",
                Show = function(self)
                    self.Text:SetText(Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Font.Txt)
                end,
                DropMenu = {},
                DropMenuData = "Txt",
                DropdownRefresh = FontDropdown_Refresh,
            },
            [2] = {
                Name = L['NUM'],
                Type = "Dropdown",
                Show = function(self)
                    self.Text:SetText(Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Font.Num)
                end,
                DropMenu = {},
                DropMenuData = "Num",
                DropdownRefresh = FontDropdown_Refresh,
            },
            [3] = {
                Name = L['BIG_TN'],
                Type = "Dropdown",
                Show = function(self)
                    self.Text:SetText(Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Font.Big)
                end,
                DropMenu = {},
                DropMenuData = "Big",
                DropdownRefresh = FontDropdown_Refresh,
            },
        },
	},
}

Quafe_Font.Load = Quafe_Font_Load
Quafe_Font.Config = Quafe_Font_Config
insert(E.Module, Quafe_Font)