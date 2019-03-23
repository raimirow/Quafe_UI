local E, C, F, L = unpack(select(2, ...))  -->Engine, Config, Function, Locale
local WatcherList = {}

--- ------------------------------------------------------------
--> 死骑
--- ------------------------------------------------------------

WatcherList.DEATHKNIGHT = {
	[1] = {
		-->鲜血
		{ --血之瘟疫
			Show = true,  Style = "BR",  Color = C.Color.R3,
			Aura = "55078",  Unit = "target",  Filter = "Debuff"
		},
	},
	[2] = {
		-->冰霜
		{ --冷酷严冬
			Show = true,  Style = "CL",  Color = C.Color.B1,      
			Spell = "196770",
			Aura = "196770", Unit = "player", Filter = "Buff"
		},
		{ --心灵冰冻
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "47528",
		},

		{ --冰霜瘟疫
			Show = true,  Style = "BR",  Color = C.Color.B1,
			Aura = "55095",  Unit = "target",  Filter = "Debuff"
		},
		{ --寒酷突袭
			Show = true,  Style = "BR",  Color = C.Color.B1,
			Aura = "253595",  Unit = "player",  Filter = "Buff"
		},
	},
	[3] = {
		-->邪恶
		{ --心灵冰冻
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "47528",
		},

		{ --黑暗冲裁者
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "207349", SpellColor = C.Color.Bar["F5512C"],
		},
		{ --召唤石像鬼
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "49206", SpellColor = C.Color.Y1,
		},
		{ --黑暗突变
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "63560", SpellColor = C.Color.Y1,
		},
		{ --亡者大军
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "42650", SpellColor = C.Color.Y1,
		},
		
		{ --恶性瘟疫
			Show = true,  Style = "BR",  Color = C.Color.Rune[3],
			Aura = "191587",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --枯萎凋零-亵渎
			Show = true,  Style = "BR",  Color = C.Color.Rune[2],
			Aura = "218100",  Unit = "player",  Filter = "Buff", AuraColor = C.Color.Rune[2],
			Spell = "152280", SpellColor = C.Color.Y1,
		},
		{ --枯萎凋零
			Show = false,  Style = "BR",  Color = C.Color.Rune[2],
			Aura = "188290",  Unit = "player",  Filter = "Buff",
			Spell = "152280", SpellColor = C.Color.Y1,
		},
		{ --天启
			Show = true,  Style = "BR",  Color = C.Color.Bar["F5512C"],      
			Spell = "220143", SpellColor = C.Color.Y1,
		},
		{ --溃烂之伤
			Show = false,  Style = "BR",  Color = C.Color.Bar["CE3176"],
			Aura = "194310",  Unit = "target",  Filter = "Debuff",
		},
	},
}

--- ------------------------------------------------------------
--> 德鲁伊
--- ------------------------------------------------------------

WatcherList.DRUID = {
	[1] = {	
		-->平衡
		{ --阳炎术
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["E31D4E"],
			Aura = "164815", Unit = "target", Caster = "player", Filter = "Debuff",   
		},
		{ --月火术
			Show = true,  Style = "MEKA_BR",  Color = C.Color.B1,
			Aura = {"155625", "164547", "164812"}, Unit = "target", Caster = "player", Filter = "Debuff",   
		},
		{ --星辰耀斑
			Show = true, Style = "MEKA_BR",
			Aura = "202347", Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.Bar["95DEE4"]
		},

		{ --日光增效
			Show = true,  Style = "MEKA_BL",  Color = C.Color.Bar["E31D4E"],
			Aura = "164545", Unit = "player", Caster = "player", Filter = "Buff",   
		},
		{ --月火术
			Show = true,  Style = "MEKA_BL",  Color = C.Color.B1,
			Aura = {"155625", "164547", "164812"}, Unit = "player", Caster = "player", Filter = "Buff",   
		},
		{ --星辰领主
			Show = true,  Style = "MEKA_BL",
			Aura = "279709", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.G2 
		},
	},
	[2] = {
		-->野性
		{ --痛击
			Show = true,  Style = "MEKA_BR",
			Aura = {"106830","192090"}, Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.Bar["CE3176"],
		},
		{ --割裂
			Show = true, Style = "MEKA_BR",
			Aura = "1079", Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.R1,
		},
		{ --斜掠
			Show = true, Style = "MEKA_BR",
			Aura = "155722", Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.Bar["F5512C"],
		},
		{ --月火术
			Show = true,  Style = "MEKA_BR",
			Aura = {"155625", "164547", "164812"}, Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.B1,
		},

		{ --迎头痛击
			Show = true,  Style = "MEKA_BL",
			Spell = "106839", SpellColor = C.Color.R3
		},
		{ --血腥爪击
			Show = true, Style = "MEKA_BL",
			Aura = "145152", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.R3,
		},
		{ --掠食者的迅捷
			Show = true, Style = "MEKA_BL",
			Aura = "69369", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.G1,
		},
		{ --猛虎之怒
			Show = true,  Style = "MEKA_BL",
			Spell = "5217", SpellColor = C.Color.Y1
		},

		
	},
	[3] = {
		-->守护
		{ --痛击
			Show = true,  Style = "MEKA_BR",
			Aura = {"106830","192090"}, Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.Bar["CE3176"],
		},
		{ --月火术
			Show = true,  Style = "MEKA_BR",
			Aura = {"155625", "164547", "164812"}, Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.B1,
		},

		{ --迎头痛击
			Show = true,  Style = "MEKA_BL",
			Spell = "106839", SpellColor = C.Color.R3
		},
		{ --铁鬃
			Show = true,  Style = "MEKA_BL",
			Aura = "192081", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.G2,
		},
		{ --粉碎
			Show = true,  Style = "MEKA_BL",
			Aura = "158792", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.B2,
		},
		{ --艾露恩的卫士
			Show = true,  Style = "MEKA_BL",
			Aura = "213680", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.Bar["CE3176"],
		},

	},
	[4] = {
		-->恢复
		{ --自然之愈
			Show = true,  Style = "MEKA_BL",  Color = C.Color.B1,
			Spell = "88423",
		},
		{ --迅捷治愈
			Show = true,  Style = "MEKA_BL",  Color = C.Color.Bar["F5512C"],  
			Spell = "18562",
		},
		{ --野性成长
			Show = true,  Style = "MEKA_BL",  Color = C.Color.G1,  
			Spell = "48438", 
		},

		{ --阳炎术
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["E31D4E"],
			Aura = "164815", Unit = "target", Caster = "player", Filter = "Debuff",   
		},
		{ --月火术
			Show = true,  Style = "MEKA_BR",  Color = C.Color.B1,
			Aura = {"155625", "164547", "164812"}, Unit = "target", Caster = "player", Filter = "Debuff",   
		},
	},
}

--- ------------------------------------------------------------
--> 法师
--- ------------------------------------------------------------

WatcherList.MAGE = {
	[1] = {
		-->
	},
	[2] = {
		-->
	},
	[3] = {
		-->
	},
}

--- ------------------------------------------------------------
--> 猎人
--- ------------------------------------------------------------

WatcherList.HUNTER = {
	[1] = {
		-->野兽
		{ --治疗宠物
			Show = true,  Style = "MEKA_BL",  Color = C.Color.Bar["F5512C"],
			Aura = "136", Unit = "pet", Caster = "player", Filter = "Buff", AuraColor = C.Color.Bar["F5512C"],
		},
		{ --狂野怒火
			Show = true,  Style = "MEKA_BL",  Color = C.Color.Bar["F5512C"],
			Aura = "19574", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.Bar["F5512C"],
			Spell = "19574", SpellColor = C.Color.Y1
		},
		{ --野性守护
			Show = true,  Style = "MEKA_BL",  Color = C.Color.Bar["F5512C"],
			Aura = "193530", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.Bar["F5512C"],
			Spell = "193530", SpellColor = C.Color.Y1
		},

		{ --倒刺射击
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["F5512C"],      
			Spell = "217200",
		},
		{ --杀戮命令
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["F5512C"],      
			Spell = "34026",
		},
		{ --野兽顺劈
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["F5512C"],
			Aura = "118455", Unit = "pet", Caster = "player", Filter = "Buff", AuraColor = C.Color.R1,
		},
		{ --反制射击
			Show = true,  Style = "MEKA_BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "147362",
		},

		{ --夺命黑鸦
			Show = true,  Style = "BR",  Color = C.Color.Bar["F5512C"],
			Aura = "131894", Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.Bar["F5512C"],
			Spell = "131894", SpellColor = C.Color.Y1
		},
		
	},
	[2] = {
		-->射击
		{ --急速射击
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "257044",
		},
		{ --瞄准射击
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "19434",
		},
		
		{ --反制射击
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "147362",
		},

		{ --毒蛇钉刺
			Show = true,  Style = "BR",  Color = C.Color.G2,
			Aura = "271788",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
	},
	[3] = {
		-->生存
		{Show = false,  Style = "Bar",   Type = "Aura",   Aura = "201081",   Unit = "player",  Filter = "Buff",     Color = C.Color.B1,  Name = "作战技巧"},
		{Show = false,  Style = "Bar",   Type = "Aura",   Aura = "190931",   Unit = "player",  Filter = "Buff",     Color = C.Color.B1,  Name = "猫鼬撕咬"},
		{Show = false,  Style = "Bar",   Type = "Aura",   Aura = "118253",   Unit = "target",  Filter = "Debuff",   Color = C.Color.G1,  Name = "毒蛇钉刺"},
		{Show = false,  Style = "Bar",   Type = "Aura",   Aura = "185855",   Unit = "target",  Filter = "Debuff",   Color = C.Color.R1,  Name = "裂痕"},
		
		{Show = false,  Style = "Icon",  Type = "Spell",  Spell = "202800",  Unit = nil,                            Color = C.Color.Y1,  Name = "侧翼打击"},
		{Show = false,  Style = "Icon",  Type = "Spell",  Spell = "190928",  Unit = nil,                            Color = C.Color.Y1,  Name = "猫鼬撕咬"},
		{Show = false,  Style = "Icon",  Type = "Spell",  Spell = "191433",  Unit = nil,                            Color = C.Color.Y1,  Name = "爆炸陷阱"},
	},
}

--- ------------------------------------------------------------
--> 武僧
--- ------------------------------------------------------------

WatcherList.MONK = {
	[1] = {
		-->酒仙

	},
	[2] = {
		-->织雾
		{ --雷光聚神茶
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],
			Aura = "116680", Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.G2,
			Spell = "116680", SpellColor = C.Color.Bar["F5512C"],
		},
		{ --复苏之雾
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "115151",
		},
		{ --做茧缚命
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "116849",
		},
		{ --清创生血
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "115450",
		},
		{ --还魂术
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "115310",
		},
		{ --精华之泉
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "191837",
		},
		
		{ --禅院教诲
			Show = true,  Style = "BL",  Color = C.Color.G1,
			Aura = "202090",  Unit = "player",  Filter = "Buff",
		},
		{ --幻灭踢
			Show = true,  Style = "BL",  Color = C.Color.R1,
			Spell = "100784",
		},
		{ --旭日东升踢
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],
			Spell = "107428",
		},
	},
	[3] = {
		-->踏风
		{ --旭日东升踢
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "107428",
		},
		{ --怒雷破
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "113656",
		},
		{ --升龙霸
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "152175",
		},
		{ --切喉手
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "116705",
		},
		{ --风火雷电
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "137639",
			Aura = "137639", Unit = "player", Filter = "Buff",
		},
		{ --白虎拳
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "261947",
		},
		
		{ --连击
			Show = true,  Style = "BL",  Color = C.Color.G1,
			Aura = "196741",  Unit = "player",  Filter = "Buff"
		},
		{ --转化力量
			Show = false,  Style = "BL",  Color = C.Color.B1,
			Aura = "195321",  Unit = "player",  Filter = "Buff"
		},
		{ --白虎下凡
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "123904",
		},
	},
}

--- ------------------------------------------------------------
--> 牧师
--- ------------------------------------------------------------

WatcherList.PRIEST = {
	[1] = {
		-->戒律
		{ --苦修
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "47540",
		},
		{ --真言术：慰
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "129250",
		},
		{ --教派分歧
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "214621",
		},
		
		{ --纯净术
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "527",
		},
		{ --真言术：耀
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "194509",
		},
		{ --真言术：盾
			Show = false,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "17",
		},
		
		{ --净化邪恶
			Show = true,  Style = "BR",  Color = C.Color.R1,
			Aura = "204213",  Unit = "target",  Filter = "Debuff",
		},
		{ --暗言术：痛
			Show = true,  Style = "BR",  Color = C.Color.Bar["F5512C"],
			Aura = "589",  Unit = "target",  Filter = "Debuff",
		},
		{ --天堂之羽
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "121536",
		},
		{ --真言术：盾
			Show = true,  Style = "BL",  Color = C.Color.G1,
			Aura = "17",  Unit = "player",  Filter = "Buff", AuraColor = C.Color.G1,
			Spell = "17", SpellColor = C.Color.Y1,
		},
		{ --救赎
			Show = true,  Style = "BL",  Color = C.Color.G1,
			Aura = "194384",  Unit = "player",  Filter = "Buff", AuraColor = C.Color.B1,
		},
	},
	[2] = {
		-->神圣
		{ --圣言术：静
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "2050",
		},
		{ --圣言术：灵
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "34861",
		},
		{ --愈合祷言
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "33076",
		},

		{ --圣言术：罚
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "88625",
		},
		{ --神圣之火
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "14914",
		},
		{ --纯净术
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "527",
		},

		{ --天堂之羽
			Show = true,  Style = "BL",  Color = C.Color.Bar["F5512C"],      
			Spell = "121536",
		},
	},
	[3] = {
		-->暗影
		{ --心灵震爆
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "8092",
		},
		{ --暗言术：虚
			Show = false,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "205351",
		},
		{ --虚空爆发
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "228260",
		},
		{ --暗言术：灭
			Show = false,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "32379",
		},
		{ --虚空洪流
			Show = true,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "263165",
		},
		{ --黑暗升华
			Show = false,  Style = "CL",  Color = C.Color.Bar["F5512C"],      
			Spell = "280711",
		},
		
		{ --群体驱散
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "32375",
		},
		{ --沉默
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "15487",
		},
		{ --黑暗虚空
			Show = false,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "263346",
		},
		{ --暗影冲撞
			Show = true,  Style = "CR",  Color = C.Color.Bar["F5512C"],      
			Spell = "205385",
		},

		{ --虚空形态
			Show = true,  Style = "BL",  Color = C.Color.G1,
			Aura = "194249",  Unit = "player",  Filter = "Buff"
		},
		{ --消散
			Show = true,  Style = "BL",  Color = C.Color.B1,
			Aura = "47585",  Unit = "player",  Filter = "Buff"
		},
		{ --真言术：盾
			Show = true, Style = "BL", Color = C.Color.G1,
			Aura = "17", Unit = "player", Filter = "Buff", AuraColor = C.Color.G1,
			Spell = "17", SpellColor = C.Color.Y1,
		},

		{ --暗言术：痛
			Show = true,  Style = "BR",  Color = C.Color.Bar["F5512C"],
			Aura = "589",  Unit = "target",  Filter = "Debuff",
		},
		{ --吸血鬼之触
			Show = true,  Style = "BR",  Color = C.Color.B1,
			Aura = "34914",  Unit = "target",  Filter = "Debuff", Dura = 24,
		},
		{ --虚空洪流
			Show = true,  Style = "BR",  Color = C.Color.Bar["CE3176"],
			Spell = "205065",
		},
		{ --摧心魔
			Show = true,  Style = "BR",  Color = C.Color.Bar["E31D4E"],
			Spell = "200174",
		},
	},
}

--- ------------------------------------------------------------
--> 萨满
--- ------------------------------------------------------------

WatcherList.SHAMAN = {
	[1] = {
		-->元素
		{ --烈焰震击
			Show = true, Style = "BR", Color = C.Color.R1,
			Aura = "188389",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --引雷针
			Show = true, Style = "BR",  Color = C.Color.B1,
			Aura = "197209",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --元素冲击 173183 173184 118522
			Show = true, Style = "BL",  Color = C.Color.Bar["95DEE4"],
			Aura = "173184",  Unit = "player", Caster = "player", Filter = "Buff",
		},
		{ --风暴守护者
			Show = true, Style = "BL",
			Aura = "191634", Unit = "player", Filter = "Buff", AuraColor = C.Color.B1,
			Spell = "191634", SpellColor = C.Color.B1,
		},
		
		{ --熔岩爆裂
			Show = true, Style = "CL",  Color = C.Color.R1,
			Aura = nil,
			Spell = "51505",
		},
		{ --烈焰震击
			Show = true, Style = "CL",  Color = C.Color.Bar["95DEE4"],
			Aura = nil,        
			Spell = "188389",
		},
		{ --大地震击
			Show = true, Style = "CL",  Color = C.Color.Bar["95DEE4"],
			Aura = nil,        
			Spell = "8042",
		},
		
		{ --风剪
			Show = true, Style = "CR",  Color = C.Color.Bar["F5512C"],
			Spell = "57994",
		},
		{ --元素冲击
			Show = false, Style = "CR",  Color = C.Color.Bar["95DEE4"],
			Aura = nil,        
			Spell = "191634",
		},
		{ --元素冲击
			Show = false, Style = "CR",  Color = C.Color.Bar["95DEE4"],
			Aura = nil,        
			Spell = "117014",
		},
	},
	[2] = {
		-->增强
		{ --山崩
			Show = true, Style = "BL",  Color = C.Color.Bar["CE3176"],
			Aura = "202004",  Unit = "player", Filter = "Buff", AuraColor = C.Color.Bar["CE3176"],
		},
		{ --火舌
			Show = true, Style = "BL",  Color = C.Color.R1,
			Aura = "194084",  Unit = "player", Filter = "Buff",
		},
		{ --冰雹
			Show = true, Style = "BL",  Color = C.Color.B1,
			Aura = "196834",  Unit = "player", Filter = "Buff",
		},
		{ --风剪
			Show = false, Style = "BR",  Color = C.Color.Bar["F5512C"],
			Spell = "57994",
		},
		{ --降雨
			Show = true, Style = "BR",  Color = C.Color.B1,
			Aura = "215864",  Unit = "player",  Filter = "Buff",
		},
		{ --大地之刺
			Show = true, Style = "BR",  Color = C.Color.Bar["F5512C"],
			Aura = "188089",  Unit = "target", Caster = "player", Filter = "Debuff",
		},

		{ --石化
			Show = true, Style = "CL",  Color = C.Color.Bar["F5512C"],
			Spell = "193786",
		},
		{ --火舌
			Show = true, Style = "CL",  Color = C.Color.Bar["F5512C"],
			Spell = "193796",
		},
		{ --风暴打击
			Show = true, Style = "CL",  Color = C.Color.Bar["F5512C"],
			Aura = "201846",  Unit = "player", Caster = "player", Filter = "Buff",
			Spell = "17364",
		},
		{ --大地之刺
			Show = true, Style = "CL",  Color = C.Color.Bar["F5512C"],
			Aura = "188089",  Unit = "target", Caster = "player", Filter = "Debuff",
			Spell = "188089",
		},

		{ --风剪
			Show = true, Style = "CR",  Color = C.Color.Bar["F5512C"],
			Spell = "57994",
		},
		{ --裂地术
			Show = true, Style = "CR",  Color = C.Color.Bar["F5512C"],
			Spell = "197214",
		},
		{ --毁灭闪电
			Show = true, Style = "CR",  Color = C.Color.Bar["F5512C"],
			Spell = "187874",
		},
		
	},
	[3] = {
		-->恢复
		{ --风剪
			Show = true, Style = "CR",  Color = C.Color.Bar["F5512C"],
			Spell = "57994",
		},
	},
}

--- ------------------------------------------------------------
--> 术士
--- ------------------------------------------------------------

WatcherList.WARLOCK = {
	[1] = {
		-->痛苦
		{ --召唤黑眼
			Show = true,  Style = "MEKA_BL",
			Spell = "205180", SpellColor = C.Color.B1,
		},
		{ --死亡之箭
			Show = true,  Style = "MEKA_BL",
			Spell = "264106", SpellColor = C.Color.Bar["F5512C"],
		},

		{ --诡异魅影
			Show = false,  Style = "CL",
			Aura = "205179",  Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.Bar["6131FF"],
			Spell = "205179", SpellColor = C.Color.Y1,
		},
		
		{ --恶魔法阵
			Show = true,  Style = "CR",
			Aura = "48018",  Unit = "player", Caster = "player", Filter = "Buff", AuraColor = C.Color.B2,
			Spell = "48020", SpellColor = C.Color.Y1,
		},
		{ --恶魔掌控
			Show = true,  Style = "CR",
			Spell = "119910", SpellColor = C.Color.Y1,
		},

		{ --痛苦无常
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["F5512C"],
			Aura = "痛苦无常",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --生命虹吸
			Show = true,  Style = "MEKA_BR",  Color = C.Color.G2,
			Aura = "63106",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --腐蚀术
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["CE3176"],
			Aura = "146739",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --痛楚
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["F5512C"],
			Aura = "980",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --鬼影缠身
			Show = true,  Style = "MEKA_BR",
			Aura = "48181",  Unit = "target", Caster = "player", Filter = "Debuff", AuraColor = C.Color.G2,
			Spell = "48181", SpellColor = C.Color.Y1,
		},
		{ --腐蚀之种
			Show = true,  Style = "MEKA_BR",  Color = C.Color.Bar["6131FF"],
			Aura = "27243",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
	},
	[2] = {
		-->恶魔学识
		{ --末日降临
			Show = true,  Style = "BR",  Color = C.Color.G2,
			Aura = "603",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --恶魔增效
			Show = true,  Style = "BR",  Color = C.Color.B1,
			Aura = "193396",  Unit = "pet", Caster = "player", Filter = "Buff",
		},
		{ --暗影启迪
			Show = true,  Style = "BR",  Color = C.Color.Bar["F5512C"],
			Aura = "196606",  Unit = "player", Caster = "player", Filter = "Buff",
		},

		{ --召唤恐惧猎犬
			Show = true,  Style = "CL",
			Spell = "104316", SpellColor = C.Color.Y1,
		},

	},
	[3] = {
		-->毁灭
		{ --腐蚀术
			Show = true,  Style = "BR",  Color = C.Color.Bar["CE3176"],
			Aura = "157736",  Unit = "target", Caster = "player", Filter = "Debuff",
		},
		{ --爆燃
			Show = true,  Style = "BR",  Color = C.Color.B1,
			Aura = "117828",  Unit = "player", Caster = "player", Filter = "Buff",
		},
		{ --燃烧
			Show = true,  Style = "BR",  Color = C.Color.Bar["F5512C"],
			Spell = "17962",
		},
		{ --灭杀
			Show = true,  Style = "BR",  Color = C.Color.G2,
			Aura = "196414",  Unit = "target", Caster = "player", Filter = "Debuff",
		},

		{ --爆燃
			Show = true,  Style = "BL",  Color = C.Color.B1,
			Aura = "235156",  Unit = "player", Caster = "player", Filter = "Buff",
		},
		{ --恶魔之火
			Show = true,  Style = "BL",  Color = C.Color.G2,
			Spell = "196447",
		},
		{ --次元裂隙
			Show = true,  Style = "BL",  Color = C.Color.Bar["CE3176"],
			Spell = "196586",
		},
		{ --浩劫
			Show = true,  Style = "BL",  Color = C.Color.Bar["E31D4E"],
			Spell = "80240",
		},
	},
}

----------------------------------------------------------------
--> Load
----------------------------------------------------------------

E.Aurawatch = WatcherList
