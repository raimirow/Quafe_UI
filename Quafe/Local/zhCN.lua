local TIE, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale

if not (GetLocale() == "zhCN") then return end

----------------------------------------------------------------
--> zhCN
----------------------------------------------------------------
--[[
L['RELOAD_UI'] = '重载界面'

L['CONFIGMODE'] = '进入设置模式'
L['MOVE_FRAME'] = '移动框体'
L['RESET_POSITION'] = '恢复默认位置'
L['AUTO_SCALE'] = '自动缩放'
L['SCALE'] = '缩放比例'
L['WIDGET'] = '附件'
L['TOOLTIP_AURAID'] = '鼠标提示 增益效果编号'
L['TOOLTIP_SPELLID'] = '鼠标提示 技能编号'
L['TF_HUD_ART'] = '泰坦陨落 驾驶舱装饰'

--
L['LATENCY'] = '延迟'
L['LATENCY_HOME'] = '本地'
L['LATENCY_WORLD'] = '世界'
L['FRAME_RATE'] = '帧数'
L['MEMORY_USAGE'] = '内存占用'
--]]
-- -------------------------------------------------------------

--> General
L['ON'] = "开启"
L['OFF'] = "关闭"
L['INVALID'] = "无效"
L['START'] = "开始"
L['OK'] = "确认"
L['CONFIRM'] = "确认"
L['LATER'] = "稍后"
L['YES'] = "是的"
L['NO'] = "不"
L['BACK'] = "返回"
L['EXIT'] = "退出"
L['CANCEL'] = "取消"
L['DELETE'] = '删除'

--> Unit
L['PLAYER'] = '玩家'
L['TARGET'] = '目标'
L['PET'] = '宠物'
L['FOCUS'] = '焦点'
L['ALL_UNIT'] = '所有人'

--> Communication Menu
L['BINDING_COMMUNICATIONMENU'] = '交流菜单'
L['THANK'] = "感谢"
L['HELLO'] = "你好"
L['DANCE'] = "跳舞"
L['HEALME'] = "需要治疗"
L['RUDE'] = "粗鲁"
L['AUTOLOOT'] = "自动拾取"
L['SHEATHE'] = "收起武器" 
L['UNSHEATHE'] = "取出武器"
L.FactionStandingID = {
	[0] = "未知",
	[1] = "仇恨",
	[2] = "敌对",
	[3] = "冷淡",
	[4] = "中立",
	[5] = "友善",
	[6] = "尊敬",
	[7] = "崇敬",
    [8] = "崇拜",
    [9] = "巅峰",
}

--> SystemInfo
L['MBC'] = "小地图按钮"
L['FRIEND'] = "好友"
L['WEEKDAY_LIST'] = {"星期日","星期一","星期二","星期三","星期四","星期五","星期六"}
L['MOUTH_LIST'] = {"1月", "2月", "3月", "4月", "5月", "6月", "7月", "8月", "9月", "10月", "11月", "12月"}
L['DAY'] = "日"

--> 集合石
L['MEETINGSTONE'] = "集合石"
L['申请人数'] = "申请人数"
L['申请中活动'] = "申请中活动"
L['“%s”总数'] = "“%s”总数"
L['活动总数'] = "活动总数"
L['关注请求'] = "关注请求"

--> Minimap
L['NO_MAIL'] = "没有邮件"

--> 设置界面
L['CONFIG_CONFIG'] = 'CONFIG'
L['CONFIG_AURAWATCH'] = 'AURAWATCH'
L['CONFIG_CONTROLS'] = 'CONTROLS'
L['CONFIG_PROFILE'] = 'PROFILE'

L['INVALID'] = "无效"
L['SCALE'] = "缩放比例"
L['STYLE'] = '样式'
L['MOVE_FRAME'] = "移动框体"

L['RELOAD_TO_APPLY'] = "设置已保存  重载界面后生效"
L['APPLY_RELOAD'] = "点击确认将立即重载界面"
L['RESET_TEXT1'] = ""
L['RESET_TEXT2'] = ""

L['OBJECTIVE_TRACKER'] = "任务追踪"
L['COMMUNICATION_MENU'] = '交流菜单'
L['BUFF_FRAME'] = '增益减益栏'
L['CHAT_FRAME'] = '聊天栏'
L['CAST_BAR'] = '施法条'
L['MINI_MAP'] = '小地图'

-->Scale
L['AUTO_SCALE'] = "自动缩放"
L['FIX_SCALE'] = "修复缩放"

-->Mouse
L['MOUSE'] = "鼠标"
L['RAW_MOUSE'] = "原生鼠标（Raw Mouse）"
L['MOUSE_POLLING'] = "鼠标数据更新频率（Hz）"
L['MOUSE_RESOLUTION'] = "鼠标移动的每英寸点数（DPI）"

-->Blizzard Frames
L["BLIZZARD_FRAMES"] = "暴雪默认框体"
L['PLAYER_FRAME'] = "玩家框体"
L['TARGET_FRAME'] = "目标框体"
L['FOCUS_FRAME'] = "焦点框体"
L['PARTY_FRAME'] = "小队框体"
L['BOSS_FRAME'] = "首领框体"

-->Action Bar
L['ACTION_BAR'] = '动作条'
L['ACTION_STYLE_RING'] = "圆形"

-->Watcher
L['FCS'] = '技能监控'
L['AURA'] = '增益减益'
L['SPELL'] = '技能'
L['COLOR'] = '颜色'
L['UNIT'] = '单位'
L['CASTER'] = '施法者'
L['ADD'] = '添加'
L['ADD_FCS'] = '添加技能监控'
L['LOAD_DEFAULT'] = '载入默认设置'
L["MEKA_BL"] = 'MEKA 计时条 左'
L["MEKA_BR"] = 'MEKA 计时条 右'
L["MEKA_IL"] = 'MEKA 图标 左'
L["MEKA_IR"] = 'MEKA 图标 右'

-->Bag
L['SELL_JUNK'] = '卖出垃圾物品'
L['BAG'] = '背包'
L['GROUP_REFRESH_RATE'] = '分组刷新频率'
L['BAG_GROUP_REFRESH'] = '刷新背包分组'
L['手动刷新'] = '手动刷新'
L['打开时刷新'] = '打开时刷新'
L['实时刷新'] = '实时刷新'
L['重置金币数据'] = '重置金币数据'
L['背包金币数据已重置'] = '背包金币数据已重置'

-->Assistant
L['ASSISTANT'] = '附件'
L['RESURRECTION_NOTIFICATION'] = '战斗中复生通知'

-->CastingBar
L['施法条'] = '施法条'