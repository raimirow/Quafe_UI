local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

----------------------------------------------------------------
--> Local
----------------------------------------------------------------

local _G = getfenv(0)
local format = string.format
local insert = table.insert

----------------------------------------------------------------
--> Color Swatches
----------------------------------------------------------------

local COLOR_SWATCHES = {}

COLOR_SWATCHES[1] = { --Red
	[1] = {r = 244, g =  67, b =  54}, --primary 500
	[2] = {r = 239, g = 154, b = 154}, --200
	[3] = {r = 239, g =  83, b =  80}, --400
	[4] = {r = 229, g =  57, b =  53}, --600
	[5] = {r = 198, g =  40, b =  40}, --800
}

COLOR_SWATCHES[2] = { --Pink
	[1] = {r = 233, g =  30, b =  99}, --primary 500
	[2] = {r = 244, g = 143, b = 177}, --200
	[3] = {r = 236, g =  64, b = 122}, --400
	[4] = {r = 216, g =  27, b =  96}, --600
	[5] = {r = 173, g =  20, b =  87}, --800
}

COLOR_SWATCHES[3] = { --Purple
	[1] = {r = 156, g =  39, b = 176}, --primary 500
	[2] = {r = 206, g = 147, b = 216}, --200
	[3] = {r = 171, g =  71, b = 188}, --400
	[4] = {r = 142, g =  36, b = 170}, --600
	[5] = {r = 106, g =  27, b = 154}, --800
}

COLOR_SWATCHES[4] = { --Deep Purple
	[1] = {r = 103, g =  58, b = 183}, --primary 500
	[2] = {r = 179, g = 157, b = 219}, --200
	[3] = {r = 126, g =  87, b = 194}, --400
	[4] = {r =  94, g =  53, b = 177}, --600
	[5] = {r =  69, g =  39, b = 160}, --800
}

COLOR_SWATCHES[5] = { --Indigo
	[1] = {r =  63, g =  81, b = 181}, --primary 500
	[2] = {r = 159, g = 168, b = 218}, --200
	[3] = {r =  92, g = 107, b = 192}, --400
	[4] = {r =  57, g =  73, b = 171}, --600
	[5] = {r =  40, g =  53, b = 147}, --800
}

COLOR_SWATCHES[6] = { --Blue
	[1] = {r =  33, g = 150, b = 243}, --primary 500
	[2] = {r = 144, g = 202, b = 249}, --200
	[3] = {r =  66, g = 165, b = 245}, --400
	[4] = {r =  30, g = 136, b = 229}, --600
	[5] = {r =  21, g = 101, b = 192}, --800
}

COLOR_SWATCHES[7] = { --Light Blue
	[1] = {r =   3, g = 169, b = 244}, --primary 500
	[2] = {r = 129, g = 212, b = 250}, --200
	[3] = {r =  41, g = 182, b = 246}, --400
	[4] = {r =   3, g = 155, b = 229}, --600
	[5] = {r =   2, g = 119, b = 189}, --800
}

COLOR_SWATCHES[8] = { --Cyan
	[1] = {r =   0, g = 188, b = 212}, --primary 500
	[2] = {r = 128, g = 222, b = 234}, --200
	[3] = {r =  38, g = 198, b = 218}, --400
	[4] = {r =   0, g = 172, b = 193}, --600
	[5] = {r =   0, g = 131, b = 143}, --800
}

COLOR_SWATCHES[9] = { --Teal
	[1] = {r =   0, g = 150, b = 136}, --primary 500
	[2] = {r = 128, g = 203, b = 196}, --200
	[3] = {r =  38, g = 166, b = 154}, --400
	[4] = {r =   0, g = 137, b = 123}, --600
	[5] = {r =   0, g = 105, b =  92}, --800
}

COLOR_SWATCHES[10] = { --Green
	[1] = {r =  76, g = 175, b =  80}, --primary 500
	[2] = {r = 165, g = 214, b = 167}, --200
	[3] = {r = 102, g = 187, b = 106}, --400
	[4] = {r =  67, g = 160, b =  71}, --600
	[5] = {r =  46, g = 125, b =  50}, --800
}

COLOR_SWATCHES[11] = { --Light Green
	[1] = {r = 139, g = 195, b =  74}, --primary 500
	[2] = {r = 197, g = 225, b = 165}, --200
	[3] = {r = 156, g = 204, b = 101}, --400
	[4] = {r = 124, g = 179, b =  66}, --600
	[5] = {r =  85, g = 139, b =  47}, --800
}

COLOR_SWATCHES[12] = { --Lime
	[1] = {r = 205, g = 220, b =  57}, --primary 500
	[2] = {r = 230, g = 238, b = 156}, --200
	[3] = {r = 212, g = 225, b =  87}, --400
	[4] = {r = 192, g = 202, b =  51}, --600
	[5] = {r = 158, g = 157, b =  36}, --800
}

COLOR_SWATCHES[13] = { --Light Yellow
	[1] = {r = 255, g = 235, b =  59}, --primary 500
	[2] = {r = 255, g = 245, b = 157}, --200
	[3] = {r = 255, g = 238, b =  88}, --400
	[4] = {r = 253, g = 216, b =  53}, --600
	[5] = {r = 249, g = 168, b =  37}, --800
}

COLOR_SWATCHES[14] = { --Yellow
	[1] = {r = 249, g = 206, b =  29}, --primary 500
	[2] = {r = 252, g = 230, b = 141}, --200
	[3] = {r = 250, g = 213, b =  62}, --400
	[4] = {r = 246, g = 190, b =  26}, --600
	[5] = {r = 242, g = 147, b =  18}, --800
}

COLOR_SWATCHES[15] = { --Orange
	[1] = {r = 255, g = 152, b =   0}, --primary 500
	[2] = {r = 255, g = 204, b = 128}, --200
	[3] = {r = 255, g = 167, b =  38}, --400
	[4] = {r = 251, g = 140, b =   0}, --600
	[5] = {r = 239, g = 108, b =   0}, --800
}

COLOR_SWATCHES[16] = { --Deep Orange
	[1] = {r = 255, g =  87, b =  34}, --primary 500
	[2] = {r = 255, g = 171, b = 145}, --200
	[3] = {r = 255, g = 112, b =  67}, --400
	[4] = {r = 244, g =  81, b =  30}, --600
	[5] = {r = 216, g =  67, b =  21}, --800
}

COLOR_SWATCHES[17] = { --Grey
	[1] = {r = 158, g = 158, b = 158}, --primary 500
	[2] = {r = 250, g = 250, b = 250}, --200
	[3] = {r = 224, g = 224, b = 224}, --400
	[4] = {r =  97, g =  97, b =  97}, --600
	[5] = {r =  33, g =  33, b =  33}, --800
}

COLOR_SWATCHES[18] = { --Blue Grey
	[1] = {r =  96, g = 125, b = 139}, --primary 500
	[2] = {r = 176, g = 190, b = 197}, --200
	[3] = {r = 120, g = 144, b = 156}, --400
	[4] = {r =  84, g = 110, b = 122}, --600
	[5] = {r =  55, g =  71, b =  79}, --800
}

COLOR_SWATCHES[19] = { --Brown
	[1] = {r = 121, g =  85, b =  72}, --primary 500
	[2] = {r = 188, g = 170, b = 164}, --200
	[3] = {r = 141, g = 110, b =  99}, --400
	[4] = {r = 109, g =  76, b =  65}, --600
	[5] = {r =  78, g =  52, b =  46}, --800
}

----------------------------------------------------------------
--> Color Profile
----------------------------------------------------------------

C.Color.Main0 = {r =   4, g =   4, b =   4}
C.Color.Main1 = {r = 150, g = 254, b = 240}
C.Color.Main2 = {r = 248, g = 192, b =  84}
C.Color.Main3 = {r = 234, g = 162, b =  80}
C.Color.Warn1 = {r = 248, g =  58, b = 106}

C.Color.Theme = {
	["MEKA1"] = {
		Main0 = {r =   4, g =   4, b =   4},
		Main1 = {r = 150, g = 254, b = 240},
		Main2 = {r = 248, g = 192, b =  84},
		Main3 = {r = 150, g = 254, b = 240},
		Warn1 = {r = 248, g =  58, b = 106},
	},
	["MEKA2"] = {
		Main0 = {r =   4, g =   4, b =   4},
		Main1 = {r = 150, g = 254, b = 240},
		Main2 = {r = 248, g = 192, b =  84},
		Main3 = {r = 248, g = 192, b =  84},
		Warn1 = {r = 248, g =  58, b = 106},
	},
	["Overwatch1"] = {
		Main0 = {r =   4, g =   4, b =   4},
		Main1 = {r = 243, g = 244, b = 246},
		Main2 = {r = 248, g = 192, b =  84},
		Main3 = {r = 243, g = 244, b = 246},
		Warn1 = {r = 248, g =  58, b = 106},
	},
	["Overwatch2"] = {
		Main0 = {r =   4, g =   4, b =   4},
		Main1 = {r = 243, g = 244, b = 246},
		--Main2 = {r = 248, g = 192, b =  84},
		Main2 = C.Color.Y1,
		Main3 = {r =  31, g = 174, b = 255},
		Warn1 = {r = 248, g =  58, b = 106},
	},
	["Blue1"] = {
		Main0 = {r =   4, g =   4, b =   4},
		Main1 = {r =  18, g = 234, b = 252},
		Main2 = {r = 248, g = 192, b =  84},
		Main3 = {r =  18, g = 234, b = 252},
		Warn1 = {r = 248, g =  58, b = 106},
	},
	["Blue2"] = {
		Main0 = {r =   4, g =   4, b =   4},
		Main1 = {r =  18, g = 234, b = 252},
		Main2 = {r = 248, g = 192, b =  84},
		Main3 = {r = 248, g = 192, b =  84},
		Warn1 = {r = 248, g =  58, b = 106},
	},
	["Valkyrja1"] = {
		Main0 = {r =   4, g =   4, b =   4},
		Main1 = {r = 234, g = 162, b =  44},
		Main2 = {r =  18, g = 234, b = 252},
		Main3 = {r = 234, g = 162, b =  44},
		Warn1 = {r = 248, g =  58, b = 106},
	},
}

--- ------------------------------------------------------------
--> Color Pick
--- ------------------------------------------------------------

local Quafe_Color = CreateFrame("Frame", nil, E)

local function Quafe_Color_Load()
	local theme = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State or "MEKA1"
	if theme == "UD" then
		C.Color.Main1 = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.Main1
		C.Color.Main2 = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.Main2
		C.Color.Main3 = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.Main3
		C.Color.Warn1 = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.Warn1
	else
		if not C.Color.Theme[theme] then theme = "MEKA1" end
		C.Color.Main1 = C.Color.Theme[theme].Main1
		C.Color.Main2 = C.Color.Theme[theme].Main2
		C.Color.Main3 = C.Color.Theme[theme].Main3
		C.Color.Warn1 = C.Color.Theme[theme].Warn1
	end
end

local function ColorDropdown_Create()
	local DorpMenu = {}
	local num = 2
	DorpMenu[1] = {
		Text = L['User-Defined'],
		Click = function(self, button)
			Quafe_UDF_ColorPick: Show()
		end,
	}
	for k,v in pairs(C.Color.Theme) do
		DorpMenu[num] = {
			--Text = format("%sCO|r%sL|r%sO|r%sR|r", F.Hex(v.Main1), F.Hex(v.Main2), F.Hex(v.Main3), F.Hex(v.Warn1)),■
			Text = format("%sColor ■|r%s ■|r%s ■|r%s ■|r", F.Hex(v.Main1), F.Hex(v.Main2), F.Hex(v.Main3), F.Hex(v.Warn1)),
			Click = function(self, button)
				Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State = k
				Quafe_NoticeReload()
			end,
		}
		num = num + 1
	end

	return DorpMenu
end

local Quafe_Color_Config = {
	Database = {
		["Quafe_Color"] = {
			State = "Blue1",
			Main1 = C.Color.Theme.Blue1.Main1,
			Main2 = C.Color.Theme.Blue1.Main2,
			Main3 = C.Color.Theme.Blue1.Main3,
			Warn1 = C.Color.Theme.Blue1.Warn1,
		},
	},

	Config = {
		Name = L['COLOR'],
		Type = "Dropdown",
		Show = function(self)
			local theme = Quafe_DB.Profile[Quafe_DBP.Profile].Quafe_Color.State
			if theme then
				local color = C.Color.Theme[theme]
				if theme == "UD" then
					self.Text:SetText(L['User-Defined'])
				elseif color then
					self.Text:SetText(format("%sColor ■|r%s ■|r%s ■|r%s ■|r", F.Hex(color.Main1), F.Hex(color.Main2), F.Hex(color.Main3), F.Hex(color.Warn1)))
				end
			end
		end,
		DropMenu = ColorDropdown_Create(),
	},
}

Quafe_Color.Load = Quafe_Color_Load
Quafe_Color.Config = Quafe_Color_Config
insert(E.Module, Quafe_Color)