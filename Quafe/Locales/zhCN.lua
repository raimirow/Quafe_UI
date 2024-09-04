local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

local LOCALE = {}

--- ------------------------------------------------------------
--> General
--- ------------------------------------------------------------

LOCALE['ON'] = "开启"
LOCALE['OFF'] = "关闭"
LOCALE['INVALID'] = "无效"
LOCALE['START'] = "开始"
LOCALE['OK'] = "确认"
LOCALE['CONFIRM'] = "确认"
LOCALE['LATER'] = "稍后"
LOCALE['YES'] = "是的"
LOCALE['NO'] = "不"
LOCALE['BACK'] = "返回"
LOCALE['EXIT'] = "退出"
LOCALE['CANCEL'] = "取消"
LOCALE['DELETE'] = '删除'

LOCALE['OPEN'] = '打开'
LOCALE['CLOSE'] = '关闭'

LOCALE['NEW'] = '新建'
LOCALE['COPY'] = '复制'
LOCALE['RENAME'] = '重命名'
LOCALE['EDIT'] = '编辑'

LOCALE['SHOW'] = '显示'
LOCALE['HIDE'] = '隐藏'

LOCALE['UNFINISHED'] = ' (未完成)'

LOCALE['ALIGN_CENTER'] = '居中对齐' --8.3.0.52

--- ------------------------------------------------------------
--> Unit
--- ------------------------------------------------------------

LOCALE['PLAYER'] = '玩家'
LOCALE['TARGET'] = '目标'
LOCALE['PET'] = '宠物'
LOCALE['FOCUS'] = '焦点'
LOCALE['ALL_UNIT'] = '所有人'

--- ------------------------------------------------------------
--> Communication Menu
--- ------------------------------------------------------------

LOCALE['BINDING_COMMUNICATIONMENU'] = '交流菜单'
LOCALE['THANK'] = "感谢"
LOCALE['HELLO'] = "你好"
LOCALE['DANCE'] = "跳舞"
LOCALE['HEALME'] = "需要治疗"
LOCALE['RUDE'] = "粗鲁"
LOCALE['AUTOLOOT'] = "自动拾取"
LOCALE['SHEATHE'] = "收起武器" 
LOCALE['UNSHEATHE'] = "取出武器"

LOCALE['ACKNOWLEDGE'] = '收到' --8.3.0.54
LOCALE['OOM'] = '法力不足' --8.3.0.54

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
    [9] = "巅峰",
}

--- -----------------------------------------------------------
--> 信息栏
--- -----------------------------------------------------------

LOCALE['MBC'] = "小地图按钮收集"
LOCALE['FRIEND'] = "好友"
LOCALE['WEEKDAY_LIST'] = {"星期日","星期一","星期二","星期三","星期四","星期五","星期六"}
LOCALE['MOUTH_LIST'] = {"1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"}
LOCALE['DAY'] = "日"

--- -----------------------------------------------------------
--> LRD
--- -----------------------------------------------------------

LOCALE['MEETINGSTONE'] = "集合石"
LOCALE['申请人数'] = "申请人数"
LOCALE['申请中活动'] = "申请中活动"
LOCALE['“%s”总数'] = "“%s”总数"
LOCALE['活动总数'] = "活动总数"
LOCALE['关注请求'] = "关注请求"

--- -----------------------------------------------------------
--> 小地图
--- -----------------------------------------------------------

LOCALE['NO_MAIL'] = "没有邮件"
LOCALE['COORD'] = "坐标"

--- -----------------------------------------------------------
--> 设置界面
--- -----------------------------------------------------------

LOCALE['CONFIG_CONFIG'] = 'CONFIG'
LOCALE['CONFIG_AURAWATCH'] = 'AURAWATCH'
LOCALE['CONFIG_CONTROLS'] = 'CONTROLS'
LOCALE['CONFIG_PROFILE'] = 'PROFILE'

LOCALE['INVALID'] = "无效"
LOCALE['SCALE'] = "缩放比例"
LOCALE['STYLE'] = '样式'
LOCALE['DEFAULT'] = '默认'
LOCALE['PROFILE_NAME'] = '配置文件名称'
LOCALE['NEW_PROFILE'] = '新建配置文件'

LOCALE['RELOAD_TO_APPLY'] = "设置已保存  重载界面后生效"
LOCALE['APPLY_RELOAD'] = "点击确认将立即重载界面"
LOCALE['RESET_TEXT1'] = ""
LOCALE['RESET_TEXT2'] = ""

LOCALE['OPEN_SETUP_WIZARD'] = "打开设置向导" --v63
LOCALE['OPEN_CONFIG_FRAME'] = "打开设置界面" --v63
LOCALE['LOAD_CONFIG_FRAME'] = "加载详细设置选项" --v63

LOCALE['OBJECTIVE_TRACKER'] = "任务追踪"
LOCALE['PLAYER_POWER_BAR_ALTER'] = "玩家特殊能量条" --v62
LOCALE['COMMUNICATION_MENU'] = '交流菜单'
LOCALE['BUFF_FRAME'] = '增益减益栏'
LOCALE['CHAT_FRAME'] = '聊天栏'
LOCALE['MINI_MAP'] = '小地图'

LOCALE['ULTIMATE_FRAME'] = '终极技能充能 (能量条)' --8.3.0.52
LOCALE['ALPHA_OUTCOMBAT'] = '脱战透明度' --8.3.0.52
LOCALE['SYNC_WITH_PLAYERFRAME'] = '与玩家框体同步' --8.3.0.52

LOCALE['SETUP_WIZARD'] = '设置向导' --v57

LOCALE['LOAD_MEKA_LAYOUT'] = '载入MEKA界面配置' --v57
LOCALE['LOAD_OVERWATCH_LAYOUT'] = '载入Overwatch界面配置' --v57
LOCALE['CUSTOM_LAYOUT'] = '自定义界面配置' --v64

--> 移动框体
LOCALE['MOVE_FRAME'] = "移动框体"
LOCALE['RESET_POSITION'] = '恢复默认位置'

--> Scale
LOCALE['AUTO_SCALE'] = "自动缩放"
LOCALE['FIX_SCALE'] = "修复缩放"

--> Color
LOCALE['COLOR'] = "颜色"
LOCALE['User-Defined'] = "自定义"

--> Font
LOCALE['FONT'] = "字体" -- v64
LOCALE['TEXT'] = "文字" -- v64
LOCALE['NUM'] = "数字" -- v64
LOCALE['BIG_TN'] = "大文字和数字" -- v64

--> Mouse
LOCALE['MOUSE'] = "鼠标"
LOCALE['RAW_MOUSE'] = "原生鼠标（Raw Mouse）"
LOCALE['RAW_MOUSE_ACCELERATION'] = "鼠标移动加速"
LOCALE['MOUSE_POLLING'] = "鼠标数据更新频率（Hz）"
LOCALE['MOUSE_RESOLUTION'] = "鼠标移动的每英寸点数（DPI）"

--> Blizzard Frames
LOCALE["BLIZZARD_FRAMES"] = "暴雪默认框体"
LOCALE['PLAYER_FRAME'] = "玩家框体"
LOCALE['PET_FRAME'] = "宠物框体" --v63
LOCALE['TARGET_FRAME'] = "目标框体"
LOCALE['TARGET_TARGET_FRAME'] = "目标的目标框体" --v63
LOCALE['FOCUS_FRAME'] = "焦点框体"
LOCALE['FOCUS_TARGET_FRAME'] = "焦点的目标框体" --v63
LOCALE['PARTY_FRAME'] = "小队框体"
LOCALE['BOSS_FRAME'] = "首领框体"

--> Action Bar
LOCALE['ACTION_BAR'] = '动作条'
LOCALE['ACTION_STYLE_RING'] = "圆形"

--> Watcher
LOCALE['FCS'] = '技能监控'
LOCALE['ICON'] = '图标'
LOCALE['AURA'] = '增益减益'
LOCALE['SPELL'] = '技能'
LOCALE['COLOR'] = '颜色'
LOCALE['UNIT'] = '单位'
LOCALE['CASTER'] = '施法者'
LOCALE['ADD'] = '添加'
LOCALE['ADD_FCS'] = '添加技能监控'
LOCALE['LOAD_DEFAULT'] = '载入默认设置'
LOCALE["MEKA_BL"] = 'MEKA 计时条 左'
LOCALE["MEKA_BR"] = 'MEKA 计时条 右'
LOCALE["MEKA_IL"] = 'MEKA 图标 左'
LOCALE["MEKA_IR"] = 'MEKA 图标 右'

LOCALE['FCS_FILTER'] = '只显示友方Buff和敌方Debuff' --8.3.0.55

LOCALE['FCS_NEW_TIPS'] = '|cffdca240添加步骤|r 1.选样式, 2.选图标(可略过), 3.填写Buff/Debuff/技能的ID或者名称, 4.添加.\n\n|cffdca240同时监控多个Buff/Debuff|r 用";"隔开每个Buff/Debuff, 可以同时监控几个Buff/Debuff.\n例如 1112;1113;1114;1115\n\n|cffdca240图标同时监控两个Buff/Debuff|r 用","隔开两个Buff/Debuff, 第一个在中心显示, 第二\n个在边框显示. 例如 真言术：盾,虚弱灵魂.' --v58

--> Bag
LOCALE['SELL_JUNK'] = '卖出垃圾物品'
LOCALE['BAG'] = '背包'
LOCALE['GROUP_REFRESH_RATE'] = '分组刷新频率'
LOCALE['BAG_GROUP_REFRESH'] = '刷新背包分组'
LOCALE['手动刷新'] = '手动刷新'
LOCALE['关闭时刷新'] = '关闭时刷新'
LOCALE['实时刷新'] = '实时刷新'
LOCALE['重置金币数据'] = '重置金币数据'
LOCALE['背包金币数据已重置'] = '背包金币数据已重置'

LOCALE['SOLD'] = '售出:' --8.3.0.53
LOCALE['GAINED'] = '获得:' --8.3.0.53

--> Assistant
LOCALE['ASSISTANT'] = '附件'
LOCALE['RESURRECTION_NOTIFICATION'] = '战斗中复生通知'
LOCALE['SKIN_ORDERHALL'] = '美化职业大厅信息栏'
LOCALE['SKIN_CHARACTER'] = '美化角色界面'

--> CastingBar
LOCALE['CAST_BAR'] = '施法条'
LOCALE['GCD'] = '公共CD (GCD)' --v60
LOCALE['MIRROR_BAR'] = '镜像条(呼吸条等)' --v60
LOCALE['SWING_BAR'] = '武器攻击条' --v60
LOCALE['PLAYER_SPELLNAME'] = '玩家法术名称' --v61

--> ClassPowerBar
LOCALE['CLASS'] = '职业'
LOCALE['CLASS_POINT'] = '职业能量条和连击点'

--> InfoBar
LOCALE['INFO_BAR'] = '信息栏'
LOCALE['经验条'] = '经验条'
LOCALE['艾泽里特'] = '艾泽里特'

--> HUD
LOCALE['POWER_NUM'] = '能量数字'
LOCALE['MEKAHUD'] = {
	["OFF"] = '关闭',
	['LOOP'] = 'LOOP',
	['RING'] = 'RING',
}
LOCALE['RING_TOPLEFT'] = '左上角显示'
LOCALE['RING_TL'] = {
	["COMBO"] = '连击点',
	["ABSORB"] = '吸收量',
}
LOCALE['COMBAT_SHOW'] = '进入战斗时显示'

--> IFF
LOCALE['IFF'] = '目标和焦点'
LOCALE['BUFF_LIMIT_NUM'] = '增益最大数量'
LOCALE['DEBUFF_LIMIT_NUM'] = '减益最大数量'

--> PartyRaid
LOCALE['SHOW_POWERBAR'] = '显示能量条'
LOCALE['PARTY_RAID'] = '小队和团队'
LOCALE['RAID5'] = '治疗用小队框体'

--> MinimapIcon
LOCALE['MINIMAPICON_LEFT_CLICK'] = '左键点击: 打开设置界面'

--> Clique
LOCALE['CLIQUE_SUPPORT'] = 'Clique 点击施法支持'

LOCALE['SHOW_HEAD_SLOT'] = '头像显示头部装备'
LOCALE['SHOW_SHOULDER_SLOT'] = '头像显示肩甲'
LOCALE['SHOW_CHEST_SLOT'] = '头像显示胸甲'
LOCALE['SHOW_WAIST_SLOT'] = '头像显示腰带'

---------------------------------------------------------------
--> 经典怀旧服
---------------------------------------------------------------

LOCALE['AUTOSHOT_BAR'] = '自动射击条'
LOCALE['SOUL_SHARD'] = '灵魂碎片'

---------------------------------------------------------------
--> 
---------------------------------------------------------------

C.Locale["zhCN"] = LOCALE