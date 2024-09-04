local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

local LOCALE = {}

--- ------------------------------------------------------------
--> General
--- ------------------------------------------------------------

LOCALE['ON'] = "ON"
LOCALE['OFF'] = "OFF"
LOCALE['INVALID'] = "INVALID"
LOCALE['START'] = "Start"
LOCALE['OK'] = "OK"
LOCALE['CONFIRM'] = "Confirm"
LOCALE['LATER'] = "Later"
LOCALE['YES'] = "Yes"
LOCALE['NO'] = "No"
LOCALE['BACK'] = "Back"
LOCALE['EXIT'] = "Exit"
LOCALE['CANCEL'] = "Cancel"
LOCALE['DELETE'] = 'Delete'

LOCALE['OPEN'] = 'Open'
LOCALE['CLOSE'] = 'Close'

LOCALE['NEW'] = 'New'
LOCALE['COPY'] = 'Copy'
LOCALE['RENAME'] = 'Rename'
LOCALE['EDIT'] = 'Edit'

LOCALE['SHOW'] = 'Show'
LOCALE['HIDE'] = 'Hide'

LOCALE['UNFINISHED'] = ' (unfinished)'

LOCALE['ALIGN_CENTER'] = 'Align Center' --8.3.0.52

--- ------------------------------------------------------------
--> Unit
--- ------------------------------------------------------------

LOCALE['PLAYER'] = 'Player'
LOCALE['TARGET'] = 'Target'
LOCALE['PET'] = 'Pet'
LOCALE['FOCUS'] = 'Focus'
LOCALE['ALL_UNIT'] = 'All Unit'

--- ------------------------------------------------------------
--> Communication Menu
--- ------------------------------------------------------------

LOCALE['BINDING_COMMUNICATIONMENU'] = 'Binding Communication Menu'
LOCALE['THANK'] = "THANK"
LOCALE['HELLO'] = "HELLO"
LOCALE['DANCE'] = "DANCE"
LOCALE['HEALME'] = "NEED HEALING"
LOCALE['RUDE'] = "RUDE"
LOCALE['AUTOLOOT'] = "AUTO LOOT"
LOCALE['SHEATHE'] = "SHEATHE" 
LOCALE['UNSHEATHE'] = "UNSHEATHE"

LOCALE['ACKNOWLEDGE'] = 'ACKNOWLEDGE' --8.3.0.54
LOCALE['OOM'] = 'OUT OF MANA' --8.3.0.54

LOCALE.FactionStandingID = {
	[0] = FACTION_STANDING_LABEL0,
	[1] = FACTION_STANDING_LABEL1,
	[2] = FACTION_STANDING_LABEL2,
	[3] = FACTION_STANDING_LABEL3,
	[4] = FACTION_STANDING_LABEL4,
	[5] = FACTION_STANDING_LABEL5,
	[6] = FACTION_STANDING_LABEL6,
	[7] = FACTION_STANDING_LABEL7,
    [8] = FACTION_STANDING_LABEL8,
    [9] = "Paragón",
}

--- -----------------------------------------------------------
--> 信息栏
--- -----------------------------------------------------------

LOCALE['MBC'] = "Minimap Buttons Collect"
LOCALE['FRIEND'] = "Friends"
LOCALE['WEEKDAY_LIST'] = {"Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"}
LOCALE['MOUTH_LIST'] = {"January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"}
LOCALE['DAY'] = "Day"

--- -----------------------------------------------------------
--> LRD
--- -----------------------------------------------------------

LOCALE['MEETINGSTONE'] = "Meeting Stone"
LOCALE['申请人数'] = "Applications"
LOCALE['申请中活动'] = "Activities in application"
LOCALE['“%s”总数'] = "“%s”sum total"
LOCALE['活动总数'] = "Total"
LOCALE['关注请求'] = "Request attention"

--- -----------------------------------------------------------
--> 小地图
--- -----------------------------------------------------------

LOCALE['NO_MAIL'] = "No mail"
LOCALE['COORD'] = "Coord"

--- -----------------------------------------------------------
--> 设置界面
--- -----------------------------------------------------------

LOCALE['CONFIG_CONFIG'] = 'CONFIG'
LOCALE['CONFIG_AURAWATCH'] = 'AURAWATCH'
LOCALE['CONFIG_CONTROLS'] = 'CONTROLS'
LOCALE['CONFIG_PROFILE'] = 'PROFILE'

LOCALE['INVALID'] = "Invalid"
LOCALE['SCALE'] = "Scale"
LOCALE['STYLE'] = 'Style'
LOCALE['DEFAULT'] = 'Default'
LOCALE['PROFILE_NAME'] = 'Profile Name'
LOCALE['NEW_PROFILE'] = 'New Profile'

LOCALE['RELOAD_TO_APPLY'] = "The config has be changed, please reload UI to apply"
LOCALE['APPLY_RELOAD'] = "Click the confirm button to reload UI"
LOCALE['RESET_TEXT1'] = ""
LOCALE['RESET_TEXT2'] = ""

LOCALE['OPEN_SETUP_WIZARD'] = "Open Setup wizard" --v63
LOCALE['OPEN_CONFIG_FRAME'] = "Open Setting Frame" --v63
LOCALE['LOAD_CONFIG_FRAME'] = "Load detail setting options" --v63

LOCALE['OBJECTIVE_TRACKER'] = "Object Tracker"
LOCALE['PLAYER_POWER_BAR_ALTER'] = "Player PowerBarAlt" --v62
LOCALE['COMMUNICATION_MENU'] = 'Communication Menu'
LOCALE['BUFF_FRAME'] = 'Buff and Debuff'
LOCALE['CHAT_FRAME'] = 'Chat Frame'
LOCALE['CAST_BAR'] = 'Cast Bar'
LOCALE['MINI_MAP'] = 'Minimap'

LOCALE['ULTIMATE_FRAME'] = 'Ultimate (Power Bar)' --8.3.0.52
LOCALE['ALPHA_OUTCOMBAT'] = 'Alpha Out of Combat' --8.3.0.52
LOCALE['SYNC_WITH_PLAYERFRAME'] = 'Sync with PlayerFrame' --8.3.0.52

LOCALE['SETUP_WIZARD'] = 'Setup wizard' --v57

LOCALE['LOAD_MEKA_LAYOUT'] = 'Load MEKA layout' --v57
LOCALE['LOAD_OVERWATCH_LAYOUT'] = 'Load Overwatch layout' --v57
LOCALE['CUSTOM_LAYOUT'] = 'Custom layout' --v64

--> 移动框体
LOCALE['MOVE_FRAME'] = "Moving Frame"
LOCALE['RESET_POSITION'] = 'Reset Position'

--> Scale
LOCALE['AUTO_SCALE'] = "Auto Scale"
LOCALE['FIX_SCALE'] = "Fix Scale"

--> Color
LOCALE['COLOR'] = "Color"
LOCALE['User-Defined'] = "User-Defined"

--> Font
LOCALE['FONT'] = "Font" -- v64
LOCALE['TEXT'] = "Text" -- v64
LOCALE['NUM'] = "Number" -- v64
LOCALE['BIG_TN'] = "Big text and number" -- v64

--> Mouse
LOCALE['MOUSE'] = "Mouse"
LOCALE['RAW_MOUSE'] = "Raw Mouse"
LOCALE['RAW_MOUSE_ACCELERATION'] = "Raw Mouse Acceleration"
LOCALE['MOUSE_POLLING'] = "Mouse Polling（Hz）"
LOCALE['MOUSE_RESOLUTION'] = "Mouse Resolution（DPI）"

--> Blizzard Frames
LOCALE["BLIZZARD_FRAMES"] = "WoW Default Frames"
LOCALE['PLAYER_FRAME'] = "Player Frame"
LOCALE['PET_FRAME'] = "Pet Frame" --v63
LOCALE['TARGET_FRAME'] = "Target Frame"
LOCALE['TARGET_TARGET_FRAME'] = "Target of Target Frame" --v63
LOCALE['FOCUS_FRAME'] = "Focus Frame"
LOCALE['FOCUS_TARGET_FRAME'] = "Target of Focus Frame" --v63
LOCALE['PARTY_FRAME'] = "Party Frame"
LOCALE['BOSS_FRAME'] = "Boss Frame"

--> Action Bar
LOCALE['ACTION_BAR'] = 'Action Bar'
LOCALE['ACTION_STYLE_RING'] = "Ring"

--> Watcher
LOCALE['FCS'] = 'FCS'
LOCALE['ICON'] = 'Icon'
LOCALE['AURA'] = 'Aura'
LOCALE['SPELL'] = 'Spell'
LOCALE['COLOR'] = 'Color'
LOCALE['UNIT'] = 'Unit'
LOCALE['CASTER'] = 'Caster'
LOCALE['ADD'] = 'Add'
LOCALE['ADD_FCS'] = 'Add watcher'
LOCALE['LOAD_DEFAULT'] = 'Load the default profile'
LOCALE["MEKA_BL"] = 'MEKA Bar Left'
LOCALE["MEKA_BR"] = 'MEKA Bar Right'
LOCALE["MEKA_IL"] = 'MEKA Icon Left'
LOCALE["MEKA_IR"] = 'MEKA Icon Right'

LOCALE['FCS_FILTER'] = 'Only show Buff on friendly unit and Debuff on enemy unit' --8.3.0.55

LOCALE['FCS_NEW_TIPS'] = '|cffdca240Steps|r 1.select Type, 2.select Icon (can skip), 3.Fill ID or Name of Buff/Debuff/Spell, 4.Add.\n\n|cffdca240Watch several Buff/Debuffs|r use ";" separate each Buff/Debuff can watch Buff/Debuffs at \nsame time. e.g. 1112;1113;1114;1115\n\n|cffdca240Watch two Buff/Debuffs with Icon watcher|r use "," separate the two Buff/Debuffs, the first \none shown in center, the second one shown in edge. e.g. Power word: shield,Weak soul.' --v58

--> Bag
LOCALE['SELL_JUNK'] = 'Sell junk'
LOCALE['BAG'] = 'Bag'
LOCALE['GROUP_REFRESH_RATE'] = 'Refresh rate'
LOCALE['BAG_GROUP_REFRESH'] = 'Refresh bag group'
LOCALE['手动刷新'] = 'Manual'
LOCALE['关闭时刷新'] = 'Refresh on closed'
LOCALE['实时刷新'] = 'Real-time refresh'
LOCALE['重置金币数据'] = 'Refresh coin data'
LOCALE['背包金币数据已重置'] = 'Coin data has be refreshed'

LOCALE['SOLD'] = 'Sold' --8.3.0.53
LOCALE['GAINED'] = 'Gained' --8.3.0.53

--> Assistant
LOCALE['ASSISTANT'] = 'Assistant'
LOCALE['RESURRECTION_NOTIFICATION'] = 'Resurrection Notification'
LOCALE['SKIN_ORDERHALL'] = 'Skin infobar of order hall'
LOCALE['SKIN_CHARACTER'] = 'Shin character frame'

--> CastingBar
LOCALE['CAST_BAR'] = 'Cast Bar'
LOCALE['GCD'] = 'Global CD (GCD)' --v60
LOCALE['MIRROR_BAR'] = 'Mirror bar (breath etc.)' --v60
LOCALE['SWING_BAR'] = 'Swing bar' --v60
LOCALE['PLAYER_SPELLNAME'] = 'Spell name of Player' --v61

--> ClassPowerBar
LOCALE['CLASS'] = 'Class'
LOCALE['CLASS_POINT'] = 'ClassPower Point'

--> InfoBar
LOCALE['INFO_BAR'] = 'Information bar'
LOCALE['经验条'] = 'Experience bar'
LOCALE['艾泽里特'] = 'Azerite'

--> HUD
LOCALE['POWER_NUM'] = 'Power Value'
LOCALE['MEKAHUD'] = {
	["OFF"] = 'OFF',
	['LOOP'] = 'LOOP',
	['RING'] = 'RING',
}
LOCALE['RING_TOPLEFT'] = 'TopLeft Bar Tracking'
LOCALE['RING_TL'] = {
	["COMBO"] = 'Combo',
	["ABSORB"] = 'Absorb',
}
LOCALE['COMBAT_SHOW'] = 'Showed in entering combat'

--> IFF
LOCALE['IFF'] = 'Target and Focus'
LOCALE['BUFF_LIMIT_NUM'] = 'Num limit of buff'
LOCALE['DEBUFF_LIMIT_NUM'] = 'Num limit of debuff'

--> PartyRaid
LOCALE['SHOW_POWERBAR'] = 'Show Powerbar'
LOCALE['PARTY_RAID'] = 'Party and Raid'
LOCALE['RAID5'] = 'PartyFrame for Healer'

--> MinimapIcon
LOCALE['MINIMAPICON_LEFT_CLICK'] = 'Left click: Open settings'

--> Clique
LOCALE['CLIQUE_SUPPORT'] = 'Clique click-casting support'

LOCALE['SHOW_HEAD_SLOT'] = 'Show head slot in portrait'
LOCALE['SHOW_SHOULDER_SLOT'] = 'Show shoulder slot in portrait'
LOCALE['SHOW_CHEST_SLOT'] = 'Show chest slot in portrait'
LOCALE['SHOW_WAIST_SLOT'] = 'Show waist slot in portrait'

---------------------------------------------------------------
--> 经典怀旧服
---------------------------------------------------------------

LOCALE['AUTOSHOT_BAR'] = 'Auto Shot Bar'
LOCALE['SOUL_SHARD'] = 'Soul Shards'

---------------------------------------------------------------
--> 
---------------------------------------------------------------

C.Locale["enUS"] = LOCALE