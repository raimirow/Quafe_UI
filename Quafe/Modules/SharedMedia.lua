local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Local

local SharedMedia = LibStub("LibSharedMedia-3.0")
if not SharedMedia then return end

local TypeBackground = SharedMedia.MediaType.BACKGROUND
local TypeBorder = SharedMedia.MediaType.BORDER
local TypeFont = SharedMedia.MediaType.FONT
local TypeStatusbar = SharedMedia.MediaType.STATUSBAR
local TypeSound = SharedMedia.MediaType.SOUND

--> Fonts
local Locale_koKR = SharedMedia.LOCALE_BIT_koKR
local Locale_zhCN = SharedMedia.LOCALE_BIT_zhCN
local Locale_zhTW = SharedMedia.LOCALE_BIT_zhTW
local Locale_western = SharedMedia.LOCALE_BIT_western

----------------------------------------------------------------
--> Background
----------------------------------------------------------------



----------------------------------------------------------------
--> Border
----------------------------------------------------------------

SharedMedia:Register(TypeBorder, "SlimWhite", F.Path("EdgeFile\\EdgeFile_Backdrop"))
SharedMedia:Register(TypeBorder, "SlimBlack", F.Path("EdgeFile\\EdgeFile_Layer"))

----------------------------------------------------------------
--> Font
----------------------------------------------------------------

--SharedMedia:Register(TypeFont, "Overwatch", F.Path("Fonts\\BigNoodleTooOblique.ttf"), Locale_western)
--SharedMedia:Register(TypeFont, "Overwatch", F.Path("Fonts\\BigNoodleTooOblique.ttf"), Locale_zhCN)

----------------------------------------------------------------
--> Statusbar
----------------------------------------------------------------

SharedMedia:Register(TypeStatusbar, "BottomLine", F.Path("StatusBar\\BottomLine"))
SharedMedia:Register(TypeStatusbar, "Wildstar", F.Path("StatusBar\\WildstarTexture"))

----------------------------------------------------------------
--> Sound
----------------------------------------------------------------

SharedMedia:Register(TypeSound, "D.VA Annyeong", F.Path("Sound\\D.Va_Annyeong.ogg"))
SharedMedia:Register(TypeSound, "D.VA Need healing", F.Path("Sound\\D.Va_Need_healing.ogg"))
SharedMedia:Register(TypeSound, "D.VA Ultimateready", F.Path("Sound\\D.Va_Ultimate_ready.ogg"))
SharedMedia:Register(TypeSound, "D.Va Ding", F.Path("Sound\\D.Va_Ding.ogg"))