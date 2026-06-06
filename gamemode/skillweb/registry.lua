GM.Skills = {}
GM.SkillModifiers = {}
GM.SkillFunctions = {}
GM.SkillModifierFunctions = {}

function GM:AddSkill(id, name, description, x, y, connections, tree)
	local skill = {Connections = table.ToAssoc(connections or {})}

	if CLIENT then
		skill.x = x
		skill.y = y

		-- TODO: Dynamic skill descriptions based on modifiers on the skill.

		skill.Description = description
	end

	if #name == 0 then
		name = "Skill "..id
		skill.Disabled = true
	end

	skill.Name = name
	skill.Tree = tree

	self.Skills[id] = skill

	return skill
end

-- Use this after all skills have been added. It assigns dynamic IDs!
function GM:AddTrinket(name, swepaffix, pairedweapon, veles, weles, tier, description, status, stocks)
	local skill = {Connections = {}}

	skill.Name = name
	skill.Trinket = swepaffix
	skill.Status = status

	local datatab = {PrintName = name, DroppedEles = weles, Tier = tier, Description = description, Status = status, Stocks = stocks}

	if pairedweapon then
		skill.PairedWeapon = "weapon_zs_t_" .. swepaffix
	end

	self.ZSInventoryItemData["trinket_" .. swepaffix] = datatab
	self.Skills[#self.Skills + 1] = skill

	return #self.Skills, self.ZSInventoryItemData["trinket_" .. swepaffix]
end

-- I'll leave this here, but I don't think it's needed.
function GM:GetTrinketSkillID(trinketname)
	for skillid, skill in pairs(GM.Skills) do
		if skill.Trinket and skill.Trinket == trinketname then
			return skillid
		end
	end
end

function GM:AddSkillModifier(skillid, modifier, amount)
	self.SkillModifiers[skillid] = self.SkillModifiers[skillid] or {}
	self.SkillModifiers[skillid][modifier] = (self.SkillModifiers[skillid][modifier] or 0) + amount
end

function GM:AddSkillFunction(skillid, func)
	self.SkillFunctions[skillid] = self.SkillFunctions[skillid] or {}
	table.insert(self.SkillFunctions[skillid], func)
end

function GM:SetSkillModifierFunction(modid, func)
	self.SkillModifierFunctions[modid] = func
end

function GM:MkGenericMod(modifiername)
	return function(pl, amount) pl[modifiername] = math.Clamp(amount + 1.0, 0.0, 1000.0) end
end

-- These are used for position on the screen
TREE_HEALTHTREE = 1
TREE_SPEEDTREE = 2
TREE_SUPPORTTREE = 3
TREE_BUILDINGTREE = 4
TREE_MELEETREE = 5
TREE_GUNTREE = 6

-- Dummy skill used for "connecting" to their trees.
SKILL_NONE = 0

--[[
SKILL_U_AMMOCRATE = 0 -- Unlock alternate arsenal crate that only sells cheap ammo (remove from regular?)
SKILL_U_DECOY = 0 -- "Unlock: Decoy", "Unlocks purchasing the Decoy\nZombies believe it is a human\nCan be destroyed\nExplodes when destroyed"

SKILL_OVERCHARGEFLASHLIGHT = 0 -- Your flashlight now produces a blinding flash that stuns zombies\nYour flashlight now breaks after one use

Unlock: Explosive body armor - Allows you to purchase explosive body armor, which knocks back both you and nearby zombies when you fall below 25 hp.
Olympian - +50% throw power\nsomething bad
Unlock: Antidote Medic Gun - Unlocks purchasing the Antidote Medic Gun\nTarget poison damage resistance +100%\nTarget immediately cleansed of all debuffs\nTarget is no longer healed or hastened
]]

-- unimplemented

SKILL_SPEED1 = 1
SKILL_SPEED2 = 2
SKILL_SPEED3 = 3
SKILL_SPEED4 = 4
SKILL_SPEED5 = 5
SKILL_BACKPEDDLER = 18
SKILL_LOADEDHULL = 20
SKILL_REINFORCEDHULL = 21
SKILL_REINFORCEDBLADES = 22
SKILL_AVIATOR = 23
SKILL_U_BLASTTURRET = 24
SKILL_TWINVOLLEY = 26
SKILL_TURRETOVERLOAD = 27
SKILL_LIGHTCONSTRUCT = 34
SKILL_QUICKDRAW = 39
SKILL_QUICKRELOAD = 41
SKILL_VITALITY2 = 45
SKILL_BARRICADEEXPERT = 77
SKILL_BATTLER1 = 48
SKILL_BATTLER2 = 49
SKILL_BATTLER3 = 50
SKILL_BATTLER4 = 51
SKILL_BATTLER5 = 52
SKILL_HEAVYSTRIKES = 53
SKILL_COMBOKNUCKLE = 62
SKILL_U_CRAFTINGPACK = 64
SKILL_JOUSTER = 65
SKILL_SCAVENGER = 67
SKILL_U_ZAPPER_ARC = 68
SKILL_ULTRANIMBLE = 70
SKILL_D_FRAIL = 71
SKILL_U_MEDICCLOUD = 72
SKILL_SMARTTARGETING = 73
SKILL_GOURMET = 76
SKILL_BLOODARMOR = 79
SKILL_REGENERATOR = 80
SKILL_SAFEFALL = 83
SKILL_VITALITY3 = 84
SKILL_TANKER = 86
SKILL_U_CORRUPTEDFRAGMENT = 87
SKILL_WORTHINESS3 = 78
SKILL_WORTHINESS4 = 88
SKILL_FOCUS = 40
SKILL_WORTHINESS1 = 42
SKILL_WORTHINESS2 = 43
SKILL_WOOISM = 46
SKILL_U_DRONE = 28
SKILL_U_NANITECLOUD = 29
SKILL_STOIC1 = 6
SKILL_STOIC2 = 7
SKILL_STOIC3 = 8
SKILL_STOIC4 = 9
SKILL_STOIC5 = 10
SKILL_SURGEON1 = 11
SKILL_SURGEON2 = 12
SKILL_SURGEON3 = 13
SKILL_HANDY1 = 14
SKILL_HANDY2 = 15
SKILL_HANDY3 = 16
SKILL_MOTIONI = 17
SKILL_PHASER = 19
SKILL_TURRETLOCK = 25
SKILL_HAMMERDISCIPLINE = 30
SKILL_FIELDAMP = 31
SKILL_U_ROLLERMINE = 32
SKILL_HAULMODULE = 33
SKILL_TRIGGER_DISCIPLINE1 = 35
SKILL_TRIGGER_DISCIPLINE2 = 36
SKILL_TRIGGER_DISCIPLINE3 = 37
SKILL_D_PALSY = 38
SKILL_EGOCENTRIC = 44
SKILL_D_HEMOPHILIA = 47
SKILL_LASTSTAND = 54
SKILL_D_NOODLEARMS = 55
SKILL_GLASSWEAPONS = 56
SKILL_CANNONBALL = 57
SKILL_D_CLUMSY = 58
SKILL_CHEAPKNUCKLE = 59
SKILL_CRITICALKNUCKLE = 60
SKILL_KNUCKLEMASTER = 61
SKILL_D_LATEBUYER = 63
SKILL_VITALITY1 = 66
SKILL_TAUT = 69
SKILL_INSIGHT = 74
SKILL_GLUTTON = 75
SKILL_D_WEAKNESS = 81
SKILL_PREPAREDNESS = 82
SKILL_D_WIDELOAD = 85
SKILL_FORAGER = 89
SKILL_LANKY = 90
SKILL_PITCHER = 91
SKILL_BLASTPROOF = 92
SKILL_MASTERCHEF = 93
SKILL_SUGARRUSH = 94
SKILL_U_STRENGTHSHOT = 95
SKILL_STABLEHULL = 96
SKILL_LIGHTWEIGHT = 97
SKILL_AGILEI = 98
SKILL_U_CRYGASGREN = 99
SKILL_SOFTDET = 100
SKILL_STOCKPILE = 101
SKILL_ACUITY = 102
SKILL_VISION = 103
SKILL_U_ROCKETTURRET = 104
SKILL_RECLAIMSOL = 105
SKILL_ORPHICFOCUS = 106
SKILL_IRONBLOOD = 107
SKILL_BLOODLETTER = 108
SKILL_HAEMOSTASIS = 109
SKILL_SLEIGHTOFHAND = 110
SKILL_AGILEII = 111
SKILL_AGILEIII = 112
SKILL_BIOLOGYI = 113
SKILL_BIOLOGYII = 114
SKILL_BIOLOGYIII = 115
SKILL_FOCUSII = 116
SKILL_FOCUSIII = 117
SKILL_EQUIPPED = 118
SKILL_SURESTEP = 119
SKILL_INTREPID = 120
SKILL_CARDIOTONIC = 121
SKILL_BLOODLUST = 122
SKILL_SCOURER = 123
SKILL_LANKYII = 124
SKILL_U_ANTITODESHOT = 125
SKILL_DISPERSION = 126
SKILL_MOTIONII = 127
SKILL_MOTIONIII = 128
SKILL_D_SLOW = 129
SKILL_BRASH = 130
SKILL_CONEFFECT = 131
SKILL_CIRCULATION = 132
SKILL_SANGUINE = 133
SKILL_ANTIGEN = 134
SKILL_INSTRUMENTS = 135
SKILL_HANDY4 = 136
SKILL_HANDY5 = 137
SKILL_TECHNICIAN = 138
SKILL_BIOLOGYIV = 139
SKILL_SURGEONIV = 140
SKILL_DELIBRATION = 141
SKILL_DRIFT = 142
SKILL_WARP = 143
SKILL_LEVELHEADED = 144
SKILL_ROBUST = 145
SKILL_STOWAGE = 146
SKILL_TRUEWOOISM = 147
SKILL_UNBOUND = 148

SKILLMOD_HEALTH = 1
SKILLMOD_SPEED = 2
SKILLMOD_WORTH = 3
SKILLMOD_FALLDAMAGE_THRESHOLD_MUL = 4
SKILLMOD_FALLDAMAGE_RECOVERY_MUL = 5
SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL = 6
SKILLMOD_FOODRECOVERY_MUL = 7
SKILLMOD_FOODEATTIME_MUL = 8
SKILLMOD_JUMPPOWER_MUL = 9
SKILLMOD_RELOADSPEED_MUL = 11
SKILLMOD_DEPLOYSPEED_MUL = 12
SKILLMOD_UNARMED_DAMAGE_MUL = 13
SKILLMOD_UNARMED_SWING_DELAY_MUL = 14
SKILLMOD_MELEE_DAMAGE_MUL = 15
SKILLMOD_HAMMER_SWING_DELAY_MUL = 16
SKILLMOD_CONTROLLABLE_SPEED_MUL = 17
SKILLMOD_CONTROLLABLE_HANDLING_MUL = 18
SKILLMOD_CONTROLLABLE_HEALTH_MUL = 19
SKILLMOD_MANHACK_DAMAGE_MUL = 20
SKILLMOD_BARRICADE_PHASE_SPEED_MUL = 21
SKILLMOD_MEDKIT_COOLDOWN_MUL = 22
SKILLMOD_MEDKIT_EFFECTIVENESS_MUL = 23
SKILLMOD_REPAIRRATE_MUL = 24
SKILLMOD_TURRET_HEALTH_MUL = 25
SKILLMOD_TURRET_SCANSPEED_MUL = 26
SKILLMOD_TURRET_SCANANGLE_MUL = 27
SKILLMOD_BLOODARMOR = 28
SKILLMOD_MELEE_KNOCKBACK_MUL = 29
SKILLMOD_SELF_DAMAGE_MUL = 30
SKILLMOD_AIMSPREAD_MUL = 31
SKILLMOD_POINTS = 32
SKILLMOD_POINT_MULTIPLIER = 33
SKILLMOD_FALLDAMAGE_DAMAGE_MUL = 34
SKILLMOD_MANHACK_HEALTH_MUL = 35
SKILLMOD_DEPLOYABLE_HEALTH_MUL = 36
SKILLMOD_DEPLOYABLE_PACKTIME_MUL = 37
SKILLMOD_DRONE_SPEED_MUL = 38
SKILLMOD_DRONE_CARRYMASS_MUL = 39
SKILLMOD_MEDGUN_FIRE_DELAY_MUL = 40
SKILLMOD_RESUPPLY_DELAY_MUL = 41
SKILLMOD_FIELD_RANGE_MUL = 42
SKILLMOD_FIELD_DELAY_MUL = 43
SKILLMOD_DRONE_GUN_RANGE_MUL = 44
SKILLMOD_HEALING_RECEIVED = 45
SKILLMOD_RELOADSPEED_PISTOL_MUL = 46
SKILLMOD_RELOADSPEED_SMG_MUL = 47
SKILLMOD_RELOADSPEED_ASSAULT_MUL = 48
SKILLMOD_RELOADSPEED_SHELL_MUL = 49
SKILLMOD_RELOADSPEED_RIFLE_MUL = 50
SKILLMOD_RELOADSPEED_XBOW_MUL = 51
SKILLMOD_RELOADSPEED_PULSE_MUL = 52
SKILLMOD_RELOADSPEED_EXP_MUL = 53
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT = 54
SKILLMOD_PULSE_WEAPON_SLOW_MUL = 55
SKILLMOD_MELEE_DAMAGE_TAKEN_MUL = 56
SKILLMOD_POISON_DAMAGE_TAKEN_MUL = 57
SKILLMOD_BLEED_DAMAGE_TAKEN_MUL = 58
SKILLMOD_MELEE_SWING_DELAY_MUL = 59
SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL = 60
SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL = 61
SKILLMOD_MELEE_POWERATTACK_MUL = 62
SKILLMOD_KNOCKDOWN_RECOVERY_MUL = 63
SKILLMOD_MELEE_RANGE_MUL = 64
SKILLMOD_SLOW_EFF_TAKEN_MUL = 65
SKILLMOD_EXP_DAMAGE_TAKEN_MUL = 66
SKILLMOD_FIRE_DAMAGE_TAKEN_MUL = 67
SKILLMOD_PROP_CARRY_CAPACITY_MUL = 68
SKILLMOD_PROP_THROW_STRENGTH_MUL = 69
SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL = 70
SKILLMOD_VISION_ALTER_DURATION_MUL = 71
SKILLMOD_DIMVISION_EFF_MUL = 72
SKILLMOD_PROP_CARRY_SLOW_MUL = 73
SKILLMOD_BLEED_SPEED_MUL = 74
SKILLMOD_MELEE_LEG_DAMAGE_ADD = 75
SKILLMOD_SIGIL_TELEPORT_MUL = 76
SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT = 77
SKILLMOD_POISON_SPEED_MUL = 78
SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL = 79
SKILLMOD_EXP_DAMAGE_RADIUS = 80
SKILLMOD_MEDGUN_RELOAD_SPEED_MUL = 81
SKILLMOD_WEAPON_WEIGHT_SLOW_MUL = 82
SKILLMOD_FRIGHT_DURATION_MUL = 83
SKILLMOD_IRONSIGHT_EFF_MUL = 84
SKILLMOD_BLOODARMOR_DMG_REDUCTION = 85
SKILLMOD_BLOODARMOR_MUL = 86
SKILLMOD_BLOODARMOR_GAIN_MUL = 87
SKILLMOD_LOW_HEALTH_SLOW_MUL = 88
SKILLMOD_PROJ_SPEED = 89
SKILLMOD_SCRAP_START = 90
SKILLMOD_ENDWAVE_POINTS = 91
SKILLMOD_ARSENAL_DISCOUNT = 92
SKILLMOD_CLOUD_RADIUS = 93
SKILLMOD_CLOUD_TIME = 94
SKILLMOD_PROJECTILE_DAMAGE_MUL = 95
SKILLMOD_EXP_DAMAGE_MUL = 96
SKILLMOD_TURRET_RANGE_MUL = 97
SKILLMOD_AIM_SHAKE_MUL = 98
SKILLMOD_MEDDART_EFFECTIVENESS_MUL = 99

local GOOD = "^"..COLORID_GREEN
local BAD = "^"..COLORID_RED

-- Health Tree
GM:AddSkill(SKILL_STOIC1, "Стойкость I", GOOD.."+1 к макс. здоровью\n"..BAD.."-0.75 к скорости передвижения",
                                                                -4,         -6,                 {SKILL_NONE, SKILL_STOIC2}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC2, "Стойкость II", GOOD.."+2 к макс. здоровью\n"..BAD.."-1.5 к скорости передвижения",
                                                                -4,         -4,                 {SKILL_STOIC3, SKILL_VITALITY1, SKILL_REGENERATOR}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC3, "Стойкость III", GOOD.."+4 к макс. здоровью\n"..BAD.."-3 к скорости передвижения",
                                                                -3,         -2,                 {SKILL_STOIC4}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC4, "Стойкость IV", GOOD.."+6 к макс. здоровью\n"..BAD.."-4.5 к скорости передвижения",
                                                                -3,         0,                  {SKILL_STOIC5}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_STOIC5, "Стойкость V", GOOD.."+7 к макс. здоровью\n"..BAD.."-5.25 к速度 передвижения",
                                                                -3,         2,                  {SKILL_BLOODARMOR, SKILL_TANKER}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_D_HEMOPHILIA, "Дебафф: Гемофилия", GOOD.."+10 к начальной ценности\n"..GOOD.."+3 к начальному металлолому\n"..BAD.."При получении урона начинается кровотечение, наносящее 25% доп. урона",
                                                                4,          2,                  {}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_GLUTTON, "Обжора", GOOD.."Получаете до 30 ед. кровавой брони при употреблении еды\n"..GOOD.."Полученная броня может превышать лимит на 40 ед.\n"..BAD.."-5 к макс. здоровью\n"..BAD.."Еда больше не восстанавливает здоровье",
                                                                3,          -2,                 {SKILL_GOURMET, SKILL_BLOODARMOR}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_PREPAREDNESS, "Запасливость", GOOD.."Вашим стартовым предметом может стать случайная еда",
                                                                4,          -6,                 {SKILL_NONE}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_GOURMET, "Гурман", GOOD.."+100% к восстановлению от еды\n"..BAD.."+200% ко времени употребления еды",
                                                                4,          -4,                 {SKILL_PREPAREDNESS, SKILL_VITALITY1}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_HAEMOSTASIS, "Гемостаз", GOOD.."Сопротивление негативным эффектам, пока у вас есть хотя бы 2 ед. кровавой брони\n"..BAD.."Теряете 2 ед. кровавой брони при сопротивлении\n"..BAD.."-25% к поглощению урона кровавой броней",
                                                                4,          6,                  {}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_BLOODLETTER, "Кровопускатель", GOOD.."+100% к генерации кровавой брони\n"..BAD.."Потеря всей кровавой брони наносит 5 ед. урона от кровотечения",
                                                                0,          4,                  {SKILL_ANTIGEN}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_REGENERATOR, "Regenerator", GOOD.."Восстанавливает 1 ед. здоровья каждые 6 сек., если здоровье ниже 60%\n"..BAD.."-6 к макс. здоровью",
                                                                -5,         -2,                 {}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_BLOODARMOR, "Кровавая броня", GOOD.."Восстанавливает 1 ед. кровавой брони каждые 8 сек. до максимума\nБазовый макс. кровавой брони: 20\nБазовое поглощение урона: 50%\n"..BAD.."-13 к макс. здоровью",
                                                                2,          2,                  {SKILL_IRONBLOOD, SKILL_BLOODLETTER, SKILL_D_HEMOPHILIA}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_IRONBLOOD, "Железная кровь", GOOD.."+25% к снижению урона от кровавой брони\n"..GOOD.."Бонус удваивается, если здоровье равно 50% или ниже\n"..BAD.."-50% к макс. кровавой брони",
                                                                2,          4,                  {SKILL_HAEMOSTASIS, SKILL_CIRCULATION}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_D_WEAKNESS, "Дебафф: Слабость", GOOD.."+15 к начальной ценности\n"..GOOD.."+1 очко в конце волны\n"..BAD.."-45 к макс. здоровью",
                                                                1,          -1,                 {}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY1, "Живучесть I", GOOD.."+1 к макс. здоровью",
                                                                0,          -4,                 {SKILL_VITALITY2}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY2, "Живучесть II", GOOD.."+1 к макс. здоровью",
                                                                0,          -2,                 {SKILL_VITALITY3}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_VITALITY3, "Живучесть III", GOOD.."+1 к макс. здоровью",
                                                                0,          -0,                 {SKILL_D_WEAKNESS}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_TANKER, "Танк", GOOD.."+20 к макс. здоровью\n"..BAD.."-15 к скорости передвижения",
                                                                -5,         4,                  {}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_FORAGER, "Добытчик", GOOD.."25% шанс найти еду в ящике с припасами\n"..BAD.."+20% к задержке использования ящика с припасами",
                                                                5,          -2,                 {SKILL_GOURMET}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_SUGARRUSH, "Сахарная лихорадка", GOOD.."+35 к скорости от еды на 14 секунд\n"..BAD.."-35% к восстановлению от еды\n",
                                                                4,          0,                  {SKILL_GOURMET}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_CIRCULATION, "Циркуляция", GOOD.."+1 к макс. кровавой брони",
                                                                4,          4,                  {SKILL_SANGUINE}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_SANGUINE, "Сангвиник", GOOD.."+11 к макс. кровавой брони\n"..BAD.."-9 к макс. здоровью",
                                                                6,          2,                  {}, TREE_HEALTHTREE)
GM:AddSkill(SKILL_ANTIGEN, "Антиген", GOOD.."+5% к поглощению урона кровавой броней\n"..BAD.."-3 к макс. здоровью",
                                                                -2,         4,                  {}, TREE_HEALTHTREE)
-- Speed Tree
GM:AddSkill(SKILL_SPEED1, "Скорость I", GOOD.."+0.75 к скорости передвижения\n"..BAD.."-1 к макс. здоровью",
                                                                -4,         6,                  {SKILL_NONE, SKILL_SPEED2}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED2, "Скорость II", GOOD.."+1.5 к скорости передвижения\n"..BAD.."-2 к макс. здоровью",
                                                                -4,         4,                  {SKILL_SPEED3, SKILL_PHASER, SKILL_SPEED2, SKILL_U_CORRUPTEDFRAGMENT}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED3, "Скорость III", GOOD.."+3 к скорости передвижения\n"..BAD.."-4 к макс. здоровью",
                                                                -4,         2,                  {SKILL_SPEED4}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED4, "Скорость IV", GOOD.."+4.5 к скорости передвижения\n"..BAD.."-6 к макс. здоровью",
                                                                -4,         0,                  {SKILL_SPEED5, SKILL_SAFEFALL}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SPEED5, "Скорость V", GOOD.."+5.25 к скорости передвижения\n"..BAD.."-7 к макс. здоровью",
                                                                -4,         -2,                 {SKILL_ULTRANIMBLE, SKILL_BACKPEDDLER, SKILL_MOTIONI, SKILL_CARDIOTONIC, SKILL_UNBOUND}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_AGILEI, "Подвижность I", GOOD.."+4% к силе прыжка\n"..BAD.."-2 к скорости передвижения",
                                                                4,          6,                  {SKILL_NONE, SKILL_AGILEII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_AGILEII, "Подвижность II", GOOD.."+5% к силе прыжка\n"..BAD.."-3 к скорости передвижения",
                                                                4,          2,                  {SKILL_AGILEIII, SKILL_WORTHINESS3}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_AGILEIII, "Подвижность III", GOOD.."+6% к силе прыжка\n"..BAD.."-4 к скорости передвижения",
                                                                4,          -2,                 {SKILL_SAFEFALL, SKILL_ULTRANIMBLE, SKILL_SURESTEP, SKILL_INTREPID}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_D_SLOW, "Дебафф: Замедление", GOOD.."+15 к начальной ценности\n"..GOOD.."+1 очко в конце волны\n"..BAD.."-33.75 к скорости передвижения",
                                                                0,          -4,                 {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONI, "Движение I", GOOD.."+0.75 к скорости передвижения",
                                                                -2,         -2,                 {SKILL_MOTIONII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONII, "Движение II", GOOD.."+0.75 к скорости передвижения",
                                                                -1,         -1,                 {SKILL_MOTIONIII}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_MOTIONIII, "Движение III", GOOD.."+0.75 к скорости передвижения",
                                                                0,          -2,                 {SKILL_D_SLOW}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_BACKPEDDLER, "Маневренность", GOOD.."Одинаковая скорость движения во всех направлениях\n"..BAD.."-7 к скорости передвижения\n"..BAD.."Получаете урон по ногам при любом ударе ближнего боя",
                                                                -6,         0,                  {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_PHASER, "Фазовый сдвиг", GOOD.."+15% к скорости прохождения сквозь баррикады\n"..BAD.."+15% ко времени телепортации к сигилу",
                                                                -1,         4,                  {SKILL_D_WIDELOAD, SKILL_DRIFT}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_DRIFT, "Дрифт", GOOD.."+5% к скорости прохождения сквозь баррикады",
                                                                1,          3,                  {SKILL_WARP}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_WARP, "Варп", GOOD.."-5% от времени телепортации к сигилу",
                                                                2,          2,                  {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SAFEFALL, "Безопасное падение", GOOD.."-40% к получаемому урону от падения\n"..GOOD.."+50% к скорости подъема после падения\n"..BAD.."+40% к замедлению при приземлении или падении",
                                                                0,          0,                  {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_D_WIDELOAD, "Дебафф: Крупный габарит", GOOD.."+20 к начальной ценности\n"..GOOD.."-5% к задержке ящика с припасами\n"..BAD.."Скорость прохождения ограничена до 1 в первые 6 секунд прохождения",
                                                                1,          1,                  {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_U_CORRUPTEDFRAGMENT, "Разблокировка: Искаженный фрагмент", GOOD.."Открывает покупку Искаженного фрагмента\nВместо этого отправляется к искаженным сигилам",
                                                                -2,         2,                  {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_ULTRANIMBLE, "Сверхловкость", GOOD.."+15 к скорости передвижения\n"..BAD.."-20 к макс. здоровью",
                                                                0,          -6,                 {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_WORTHINESS3, "Ценность III", GOOD.."+5 к начальной ценности\n"..BAD.."-3 к стартовым очки",
                                                                6,          2,                  {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_SURESTEP, "Уверенный шаг", GOOD.."-30% к эффективности замедлений\n"..BAD.."-4 к скорости передвижения",
                                                                6,          0,                  {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_INTREPID, "Бесстрашный", GOOD.."-35% к интенсивности замедления при низком здоровье\n"..BAD.."-4 к скорости передвижения",
                                                                6,          -4,                 {SKILL_ROBUST}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_ROBUST, "Крепкий", GOOD.."-6% к потере скорости передвижения с тяжелым оружием",
                                                                5,          -5,                 {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_CARDIOTONIC, "Кардиотоник", GOOD.."Удерживайте Shift для бега за счет траты кровавой брони\n"..BAD.."-12 к скорости передвижения\n"..BAD.."-20% к поглощению урона кровавой броней\nСпринт дает +40 к скорости движения",
                                                                -6,         -4,                 {}, TREE_SPEEDTREE)
GM:AddSkill(SKILL_UNBOUND, "Освобожденный", GOOD.."-60% к задержке смены оружия, влияющей на скорость передвижения\n"..BAD.."-4 к скорости передвижения",
                                                                -4,         -4,                 {}, TREE_SPEEDTREE)
-- Medic Tree
GM:AddSkill(SKILL_SURGEON1, "Хирург I", GOOD.."-8% к задержке использования аптечки",
                                                                -4,         6,                  {SKILL_NONE, SKILL_SURGEON2}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEON2, "Хирург II", GOOD.."-9% к задержке использования аптечки",
                                                                -3,         3,                  {SKILL_WORTHINESS4, SKILL_SURGEON3}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEON3, "Хирург III", GOOD.."-10% к задержке использования аптечки",
                                                                -2,         0,                  {SKILL_U_MEDICCLOUD, SKILL_D_FRAIL, SKILL_SURGEONIV}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_SURGEONIV, "Хирург IV", GOOD.."-11% к задержке использования аптечки",
                                                                -2,         -3,                 {}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYI, "Биология I", GOOD.."+8% к эффективности мед. инструментов",
                                                                4,          6,                  {SKILL_NONE, SKILL_BIOLOGYII}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYII, "Биология II", GOOD.."+9% к эффективности мед. инструментов",
                                                                3,          3,                  {SKILL_BIOLOGYIII, SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYIII, "Биология III", GOOD.."+10% к эффективности мед. инструментов",
                                                                2,          0,                  {SKILL_U_MEDICCLOUD, SKILL_U_ANTITODESHOT, SKILL_BIOLOGYIV}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_BIOLOGYIV, "Биология IV", GOOD.."+11% к эффективности мед. инструментов",
                                                                2,          -3,                 {}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_D_FRAIL, "Дебафф: Хрупкость", GOOD.."+20 к начальной ценности\n"..GOOD.."+5 к стартовым очкам\n"..BAD.."Ваше здоровье невозможно исцелить выше 25%",
                                                                -4,         -2,                 {}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_U_MEDICCLOUD, "Разблокировка: Лечебная дымовая бомба", GOOD.."Открывает покупку Лечебной дымовой бомбы\nМедленно исцеляет всех людей внутри облака",
                                                                0,          -2,                 {SKILL_DISPERSION}, TREE_SUPPORTTREE).AlwaysActive = true
GM:AddSkill(SKILL_SMARTTARGETING, "Умное наведение", GOOD.."Дротики медицинского оружия наводятся на цель при нажатии ПКМ\n"..BAD.."+75% к задержке выстрела мед. инструментов\n"..BAD.."-30% к эффективности исцеления медицинских дротиков",
                                                                0,          2,                  {}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_RECLAIMSOL, "Восполняемый раствор", GOOD.."60% промахнувшихся медицинских дротиков возвращаются вам\n"..BAD.."+150% к задержке выстрела мед. инструментов\n"..BAD.."-40% к скорости перезарядки мед. инструментов\n"..BAD.."Нельзя дать ускорение игрокам с полным здоровьем",
                                                                0,          4,                  {SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_U_STRENGTHSHOT, "Разблокировка: Пистолет стимуляции", GOOD.."Открывает покупку Пистолета стимуляции\nУрон цели увеличивается на +25% на 10 секунд\nДополнительный нанесенный урон конвертируется вам в очки\nЦель не получает исцеления",
                                                                0,          0,                  {SKILL_SMARTTARGETING}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_WORTHINESS4, "Ценность IV", GOOD.."+5 к начальной ценности\n"..BAD.."-3 к стартовым очкам",
                                                                -5,         2,                  {}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_U_ANTITODESHOT, "Разблокировка: Антидотный пистолет", GOOD.."Открывает покупку Антидотного пистолета\nСтреляет пробивающими зарядами, которые отлично излечивают яд\nОчищает цели от негативных эффектов, принося немного очков\nНе восстанавливает обычное здоровье",
                                                                4,          -2,                 {}, TREE_SUPPORTTREE)
GM:AddSkill(SKILL_DISPERSION, "Дисперсия", GOOD.."+15% к радиусу действия дымовой бомбы\n"..BAD.."-10% к длительности действия дымовой бомбы",
                                                                0,          -4,                 {}, TREE_SUPPORTTREE)

-- Defence Tree
GM:AddSkill(SKILL_HANDY1, "Умелец I", GOOD.."+4% к скорости ремонта",
                                                                -5,         -6,                 {SKILL_NONE, SKILL_HANDY2}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY2, "Умелец II", GOOD.."+5% к скорости ремонта",
                                                                -5,         -4,                 {SKILL_HANDY3, SKILL_U_BLASTTURRET, SKILL_LOADEDHULL}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY3, "Умелец III", GOOD.."+6% к скорости ремонта",
                                                                -5,         -1,                 {SKILL_TAUT, SKILL_HAMMERDISCIPLINE, SKILL_D_NOODLEARMS, SKILL_HANDY4}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY4, "Умелец IV", GOOD.."+7% к скорости ремонта",
                                                                -3,         1,                  {SKILL_HANDY5}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HANDY5, "Умелец V", GOOD.."+8% к скорости ремонта",
                                                                -3,         3,                  {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HAMMERDISCIPLINE, "Владение молотом", GOOD.."-20% к задержке взмаха Плотницким молотом",
                                                                0,          1,                  {SKILL_BARRICADEEXPERT}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_BARRICADEEXPERT, "Укрепитель", GOOD.."Пропсы, по которым ударили молотом в последние 2 сек., получают на 8% меньше урона\n"..GOOD.."Получаете очки за защиту пропсов\n"..BAD.."+30% к задержке взмаха Плотницким молотом",
                                                                0,          3,                  {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_LOADEDHULL, "Заряженный корпус", GOOD.."Управляемая техника взрывается при уничтожении, нанося урон взрывом\n"..BAD.."-10% к здоровью управляемой техники",
                                                                -2,         -4,                 {SKILL_REINFORCEDHULL, SKILL_REINFORCEDBLADES, SKILL_AVIATOR}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_REINFORCEDHULL, "Усиленный корпус", GOOD.."+25% к здоровью управляемой техники\n"..BAD.."-20% к управляемости техники\n"..BAD.."-20% к скорости техники",
                                                                -2,         -2,                 {SKILL_STABLEHULL}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_STABLEHULL, "Стабильный корпус", GOOD.."Управляемая техника не получает урон от столкновений на высокой скорости\n"..BAD.."-20% к скорости техники",
                                                                0,          -3,                 {SKILL_U_DRONE}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_REINFORCEDBLADES, "Усиленные лопасти", GOOD.."+25% к урону мэнхэка\n"..BAD.."-15% к здоровью мэнхэка",
                                                                0,          -5,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_AVIATOR, "Авиатор", GOOD.."+40% к скорости и управляемости техники\n"..BAD.."-25% к здоровью управляемой техники",
                                                                -4,         -2,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_BLASTTURRET, "Разблокировка: Дробовая турель", GOOD.."Открывает покупку Дробовой турели\nСтреляет дробью вместо пистолетных патронов\nУрон выше на близкой дистанции\nНе может сканировать далекие цели",
                                                                -8,         -4,                 {SKILL_TURRETLOCK, SKILL_TWINVOLLEY, SKILL_TURRETOVERLOAD}, TREE_BUILDINGTREE).AlwaysActive = true
GM:AddSkill(SKILL_TURRETLOCK, "Фиксация турели", "-90% к углу сканирования турели\n"..BAD.."-90% к углу захвата цели турелью",
                                                                -6,         -2,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_TWINVOLLEY, "Двойной залп", GOOD.."Выпускает в два раза больше пуль в ручном режиме турели\n"..BAD.."+100% к расходу патронов турели в ручном режиме\n"..BAD.."+50% к задержке выстрела турели в ручном режиме",
                                                                -10,        -5,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_TURRETOVERLOAD, "Перегрузка турели", GOOD.."+100% к скорости сканирования турели\n"..BAD.."-30% к дальности атаки турели",
                                                                -8,         -2,                 {SKILL_INSTRUMENTS}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_DRONE, "Разблокировка: Импульсный дрон", GOOD.."Открывает модификацию «Импульсный дрон»\nСтреляет коротко дистанционными импульсными снарядами вместо пуль",
                                                                2,          -3,                 {SKILL_HAULMODULE, SKILL_U_ROLLERMINE}, TREE_BUILDINGTREE).AlwaysActive = true
GM:AddSkill(SKILL_U_NANITECLOUD, "Разблокировка: Нанитовая дымовая бомба", GOOD.."Открывает покупку Нанитовой дымовой бомбы\nМедленно ремонтирует все пропсы и постройки внутри облака",
                                                                3,          1,                  {SKILL_HAMMERDISCIPLINE}, TREE_BUILDINGTREE).AlwaysActive = true
GM:AddSkill(SKILL_FIELDAMP, "Полевой усилитель", GOOD.."-20% к задержке поля заземлителя и ремонта\n"..BAD.."-40% к радиусу поля заземлителя и ремонта",
                                                                6,          4,                  {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_TECHNICIAN, "Полевой техник", GOOD.."+3% к радиусу поля заземлителя и ремонта\n"..GOOD.."-3% к задержке поля заземлителя и ремонта",
                                                                4,          3,                  {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_ROLLERMINE, "Разблокировка: Роллермайн", GOOD.."Открывает покупку Роллермайнов\nКатится по земле, бьет зомби током и наносит урон",
                                                                3,          -5,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_HAULMODULE, "Разблокировка: Грузовой дрон", GOOD.."Открывает модификацию «Грузовой дрон»\nБыстро перевозит пропсы и предметы, но не может атаковать",
                                                                2,          -1,                 {SKILL_U_NANITECLOUD}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_LIGHTCONSTRUCT, "Легкая сборка", GOOD.."-25% ко времени сворачивания построек\n"..BAD.."-25% к здоровью построек",
                                                                8,          -1,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_STOCKPILE, "Накопительство", GOOD.."Сбор в два раза больше припасов из ящиков снабжения\n"..BAD.."В 2.12 раза дольше задержка использования ящика снабжения",
                                                                8,          -3,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_ACUITY, "Чутье поставщика", GOOD.."Подсвечивает ближайшие ящики снабжения за стенами\n"..GOOD.."Подсвечивает неразвернутые ящики снабжения у игроков за стенами\n"..GOOD.."Подсвечивает брошенные сумки со снабжением за стенами",
                                                                6,          -3,                 {SKILL_INSIGHT, SKILL_STOCKPILE, SKILL_U_CRAFTINGPACK, SKILL_STOWAGE}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_VISION, "Зрение переработчика", GOOD.."Подсвечивает ближайшие утилизаторы за стенами\n"..GOOD.."Подсвечивает неразвернутые утилизаторы у игроков за стенами",
                                                                6,          -6,                 {SKILL_NONE, SKILL_ACUITY}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_ROCKETTURRET, "Разблокировка: Ракетная турель", GOOD.."Открывает покупку Ракетной турели\nСтреляет ракетами вместо пистолетных патронов\nНаносит урон по радиусу. Высокотехнологичная постройка",
                                                                -8,         -0,                 {SKILL_TURRETOVERLOAD}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_INSIGHT, "Чутье покупателя", GOOD.."Подсвечивает ближайшие ящики арсенала за стенами\n"..GOOD.."Подсвечивает неразвернутые ящики арсенала у игроков за стенами\n"..GOOD.."Подсвечивает брошенные сумки арсенала за стенами",
                                                                6,          -0,                 {SKILL_U_NANITECLOUD, SKILL_U_ZAPPER_ARC, SKILL_LIGHTCONSTRUCT, SKILL_D_LATEBUYER}, TREE_BUILDINGTREE).AlwaysActive = true
GM:AddSkill(SKILL_U_ZAPPER_ARC, "Разблокировка: Дуговой заземлитель", GOOD.."Открывает покупку Дугового заземлителя\nБьет током зомби поблизости, разряд перескакивает по цепи\nПостройка среднего тира с долгой перезарядкой. Требует постоянного снабжения импульсными патронами",
                                                                6,          2,                  {SKILL_FIELDAMP, SKILL_TECHNICIAN}, TREE_BUILDINGTREE).AlwaysActive = true
GM:AddSkill(SKILL_D_LATEBUYER, "Дебафф: Поздний покупатель", GOOD.."+20 к начальной ценности\n"..GOOD.."2% скидка в арсенале\n"..BAD.."Невозможно использовать очки в ящиках арсенала до второй половины раунда",
                                                                8,          1,                  {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_U_CRAFTINGPACK, "Разблокировка: Набор крафта", GOOD.."Открывает покупку компонента «Диск пилы»\n"..GOOD.."Открывает покупку компонента «Электробатарея»\n"..GOOD.."Открывает покупку компонента «Процессорные детали»",
                                                                4,          -1,                 {}, TREE_BUILDINGTREE).AlwaysActive = true
GM:AddSkill(SKILL_TAUT, "Натяжение", GOOD.."Получение урона больше не заставляет вас ронять пропсы\n"..BAD.."+40% к замедлению при переноске пропсов",
                                                                -5,         3,                  {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_D_NOODLEARMS, "Дебафф: Руки-макаронины", GOOD.."+5 к начальной ценности\n"..GOOD.."+1 к начальному металлолому\n"..BAD.."Вы не можете подбирать физические объекты руками",
                                                                -7,         2,                  {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_INSTRUMENTS, "Инструменты", GOOD.."+5% к дальности атаки турелей",
                                                                -10,        -3,                 {}, TREE_BUILDINGTREE)
GM:AddSkill(SKILL_STOWAGE, "Накопление ящика", GOOD.."Заряды использования ящика снабжения накапливаются, пока вас нет рядом\n"..BAD.."+15% к задержке использования ящика снабжения",
                                                                4,          -3,                 {}, TREE_BUILDINGTREE)

-- Gunnery Tree
GM:AddSkill(SKILL_TRIGGER_DISCIPLINE1, "Стрелковая подготовка I", GOOD.."+2% к скорости перезарядки оружия\n"..GOOD.."+2% к скорости снаряжения оружия",
                                                                -5,         6,                  {SKILL_TRIGGER_DISCIPLINE2, SKILL_NONE}, TREE_GUNTREE)
GM:AddSkill(SKILL_TRIGGER_DISCIPLINE2, "Стрелковая подготовка II", GOOD.."+3% к скорости перезарядки оружия\n"..GOOD.."+3% к скорости снаряжения оружия",
                                                                -4,         3,                  {SKILL_TRIGGER_DISCIPLINE3, SKILL_D_PALSY, SKILL_EQUIPPED}, TREE_GUNTREE)
GM:AddSkill(SKILL_TRIGGER_DISCIPLINE3, "Стрелковая подготовка III", GOOD.."+4% к скорости перезарядки оружия\n"..GOOD.."+4% к скорости снаряжения оружия",
                                                                -3,         0,                  {SKILL_QUICKRELOAD, SKILL_QUICKDRAW, SKILL_WORTHINESS1, SKILL_EGOCENTRIC}, TREE_GUNTREE)
GM:AddSkill(SKILL_D_PALSY, "Дебафф: Тряска рук", GOOD.."+10 к начальной ценности\n"..GOOD.."-3% к задержке ящика снабжения\n"..BAD.."Точность прицеливания снижается при низком уровне здоровья",
                                                                0,          4,                  {SKILL_LEVELHEADED}, TREE_GUNTREE)
GM:AddSkill(SKILL_LEVELHEADED, "Хладнокровие", GOOD.."-5% к эффекту дрожания прицела",
                                                                -2,         2,                  {}, TREE_GUNTREE)
GM:AddSkill(SKILL_QUICKDRAW, "Быстрое доставание", GOOD.."+65% к скорости снаряжения оружия\n"..BAD.."-15% к скорости перезарядки оружия",
                                                                0,          1,                  {}, TREE_GUNTREE)
GM:AddSkill(SKILL_FOCUS, "Фокусировка I", GOOD.."+3% к сужению прицела\n"..BAD.."-3% к скорости перезарядки оружия",
                                                                5,          6,                  {SKILL_NONE, SKILL_FOCUSII}, TREE_GUNTREE)
GM:AddSkill(SKILL_FOCUSII, "Фокусировка II", GOOD.."+4% к сужению прицела\n"..BAD.."-4% к скорости перезарядки оружия",
                                                                4,          3,                  {SKILL_FOCUSIII, SKILL_SCAVENGER, SKILL_D_PALSY, SKILL_PITCHER}, TREE_GUNTREE)
GM:AddSkill(SKILL_FOCUSIII, "Фокусировка III", GOOD.."+5% к сужению прицела\n"..BAD.."-5% к скорости перезарядки оружия",
                                                                3,          0,                  {SKILL_EGOCENTRIC, SKILL_WOOISM, SKILL_ORPHICFOCUS, SKILL_SCOURER}, TREE_GUNTREE)
GM:AddSkill(SKILL_QUICKRELOAD, "Быстрая перезарядка", GOOD.."+10% к скорости перезарядки оружия\n"..BAD.."-25% к скорости снаряжения оружия",
                                                                -5,         1,                  {SKILL_SLEIGHTOFHAND}, TREE_GUNTREE)
GM:AddSkill(SKILL_SLEIGHTOFHAND, "Ловкость рук", GOOD.."+10% к скорости перезарядки оружия\n"..BAD.."-5% к сужению прицела",
                                                                -5,         -1,                 {}, TREE_GUNTREE)
GM:AddSkill(SKILL_U_CRYGASGREN, "Разблокировка: Криогенная граната", GOOD.."Открывает покупку Криогенной гранаты\nМодификация Кислотной газовой гранаты\nКрио-газ наносит небольшой периодический урон\nЗомби в области действия замедляются",
                                                                2,          -3,                 {SKILL_EGOCENTRIC}, TREE_GUNTREE)
GM:AddSkill(SKILL_SOFTDET, "Мягкая детонация", GOOD.."-40% к получаемому урону от взрывов\n"..BAD.."-10% к радиусу поражения взрыва",
                                                                0,          -5,                 {}, TREE_GUNTREE)
GM:AddSkill(SKILL_ORPHICFOCUS, "Орфический фокус", GOOD.."Разброс 90% при прицеливании через мушку\n"..GOOD.."+2% к сужению прицела\n"..BAD.."Разброс 110% в любое другое время\n"..BAD.."-6% к скорости перезарядки",
                                                                5,          -1,                 {SKILL_DELIBRATION}, TREE_GUNTREE)
GM:AddSkill(SKILL_DELIBRATION, "Тщательность", GOOD.."+1% к сужению прицела",
                                                                6,          -3,                 {}, TREE_GUNTREE)
GM:AddSkill(SKILL_EGOCENTRIC, "Эгоцентризм", GOOD.."-35% к урону по самому себе\n"..BAD.."-5 к макс. здоровью",
                                                                0,          -1,                 {SKILL_BLASTPROOF}, TREE_GUNTREE)
GM:AddSkill(SKILL_BLASTPROOF, "Взрывостойкость", GOOD.."-45% к урону по самому себе\n"..BAD.."-7% к скорости перезарядки\n"..BAD.."-12% к скорости снаряжения оружия",
                                                                0,          -3,                 {SKILL_SOFTDET, SKILL_CANNONBALL, SKILL_CONEFFECT}, TREE_GUNTREE)
GM:AddSkill(SKILL_WOOISM, "Рвение", GOOD.."-50% к потере скорости при прицеливании через мушку\n"..BAD.."-25% к бонусу точности от прицеливания через мушку",
                                                                5,          1,                  {SKILL_TRUEWOOISM}, TREE_GUNTREE)
GM:AddSkill(SKILL_SCAVENGER, "Глаз мародёра", GOOD.."Подсвечивает ближайшее оружие, патроны и предметы за стенами",
                                                                7,          4,                  {}, TREE_GUNTREE)
GM:AddSkill(SKILL_PITCHER, "Подающий", GOOD.."+10% к скорости броска предметов и метательного оружия",
                                                                6,          2,                  {}, TREE_GUNTREE)
GM:AddSkill(SKILL_EQUIPPED, "Расторопность", GOOD.."Вашим стартовым предметом может стать случайный особый брелок",
                                                                -6,         2,                  {}, TREE_GUNTREE)
GM:AddSkill(SKILL_WORTHINESS1, "Ценность I", GOOD.."+5 к начальной ценности\n"..BAD.."-3 к стартовым очкам",
                                                                -4,         -3,                 {}, TREE_GUNTREE)
GM:AddSkill(SKILL_CANNONBALL, "Ядро", "-25% к скорости полета снаряда\n"..GOOD.."+3% к урону снаряда",
                                                                -2,         -3,                 {}, TREE_GUNTREE)
GM:AddSkill(SKILL_SCOURER, "Сборщик", GOOD.."Получаете очки конца волны в виде металлолома\n"..BAD.."Не получаете обычные очки в конце волны",
                                                                4,          -3,                 {}, TREE_GUNTREE)
GM:AddSkill(SKILL_CONEFFECT, "Концентрированный эффект", GOOD.."+5% к урону от взрывов\n"..BAD.."-20% к радиусу поражения взрыва",
                                                                2,          -5,                 {}, TREE_GUNTREE)
GM:AddSkill(SKILL_TRUEWOOISM, "Вуизм", GOOD.."Нет штрафа к точности при движении или прыжках\n"..BAD.."Нет бонуса к точности при приседании или прицеливании через мушку",
                                                                7,          0,                  {}, TREE_GUNTREE)

-- Melee Tree
GM:AddSkill(SKILL_WORTHINESS2, "Ценность IО", GOOD.."+5 к начальной ценности\n"..BAD.."-3 к стартовым очкам",
                                                                4,          0,                  {}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER1, "Боец I", GOOD.."+4% к урону ближнего боя",
                                                                -6,         -6,                 {SKILL_BATTLER2, SKILL_NONE}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER2, "Боец II", GOOD.."+5% к урону ближнего боя",
                                                                -6,         -4,                 {SKILL_BATTLER3, SKILL_LIGHTWEIGHT}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER3, "Боец III", GOOD.."+5% к урону ближнего боя",
                                                                -4,         -2,                 {SKILL_BATTLER4, SKILL_LANKY}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER4, "Боец IV", GOOD.."+6% к урону ближнего боя",
                                                                -2,         0,                  {SKILL_BATTLER5, SKILL_MASTERCHEF, SKILL_D_CLUMSY}, TREE_MELEETREE)
GM:AddSkill(SKILL_BATTLER5, "Боец V", GOOD.."+7% к урону ближнего боя",
                                                                0,          2,                  {SKILL_GLASSWEAPONS, SKILL_BLOODLUST}, TREE_MELEETREE)
GM:AddSkill(SKILL_LASTSTAND, "Последний рубеж", GOOD.."Двойной урон ближнего боя, когда здоровье ниже 25%\n"..BAD.."0.85x к урону холодным оружием в любое другое время",
                                                                0,          6,                  {}, TREE_MELEETREE)
GM:AddSkill(SKILL_GLASSWEAPONS, "Хрупкое оружие", GOOD.."3.5x к урону холодным оружием по зомби\n"..BAD.."Ваше холодное оружие имеет 50% шанс сломаться при ударе по зомби",
                                                                2,          4,                  {}, TREE_MELEETREE)
GM:AddSkill(SKILL_D_CLUMSY, "Дебафф: Неуклюжий", GOOD.."+20 к начальной ценности\n"..GOOD.."+5 к стартовым очкам\n"..BAD.."Вас очень легко сбить с ног",
                                                                -2,         2,                  {}, TREE_MELEETREE)
GM:AddSkill(SKILL_CHEAPKNUCKLE, "Грязная тактика", GOOD.."Замедляет цели при ударе холодным оружием со спины\n"..BAD.."-10% к дальности атаки ближнего боя",
                                                                4,          -2,                 {SKILL_HEAVYSTRIKES, SKILL_WORTHINESS2}, TREE_MELEETREE)
GM:AddSkill(SKILL_CRITICALKNUCKLE, "Критический кулак", GOOD.."Отбрасывает врагов при ударах голыми руками\n"..BAD.."-25% к урону от ударов руками\n"..BAD.."+25% к задержке перед следующим ударом руками",
                                                                6,          -2,                 {SKILL_BRASH}, TREE_MELEETREE)
GM:AddSkill(SKILL_KNUCKLEMASTER, "Мастер рукопашной", GOOD.."+75% к урону от ударов руками\n"..GOOD.."Скорость движения больше не снижается при ударах руками\n"..BAD.."+35% к задержке перед следующим ударом руками",
                                                                6,          -6,                 {SKILL_NONE, SKILL_COMBOKNUCKLE}, TREE_MELEETREE)
GM:AddSkill(SKILL_COMBOKNUCKLE, "Серия ударов", GOOD.."Следующий удар руками выполняется в 2 раза быстрее при попадании по цели\n"..BAD.."Следующий удар руками выполняется в 2 раза медленнее при промахе",
                                                                6,          -4,                 {SKILL_CHEAPKNUCKLE, SKILL_CRITICALKNUCKLE}, TREE_MELEETREE)
GM:AddSkill(SKILL_HEAVYSTRIKES, "Тяжелые удары", GOOD.."+100% к отбрасыванию ближнего боя\n"..BAD.."8% от нанесенного урона ближнего боя возвращается вам в виде самоурона\n"..BAD.."100% возвращаемого урона при ударах голыми руками",
                                                                2,          0,                  {SKILL_BATTLER5, SKILL_JOUSTER}, TREE_MELEETREE)
GM:AddSkill(SKILL_JOUSTER, "Турнирный боец", GOOD.."+10% к урону ближнего боя\n"..BAD.."-100% к отбрасыванию ближнего боя",
                                                                2,          2,                  {}, TREE_MELEETREE)
GM:AddSkill(SKILL_LANKY, "Долговязый I", GOOD.."+10% к дальности атаки ближнего боя\n"..BAD.."-15% к урону ближнего боя",
                                                                -4,         0,                  {SKILL_LANKYII}, TREE_MELEETREE)
GM:AddSkill(SKILL_LANKYII, "Долговязый II", GOOD.."+10% к дальности атаки ближнего боя\n"..BAD.."-15% к урону ближнего боя",
                                                                -4,         2,                  {}, TREE_MELEETREE)
GM:AddSkill(SKILL_MASTERCHEF, "Шеф-повар", GOOD.."Зомби, атакованные кухонным оружием в последнюю секунду, с некоторым шансом оставляют еду после смерти\n"..BAD.."-10% к урону ближнего боя",
                                                                0,          -3,                 {SKILL_BATTLER4}, TREE_MELEETREE)
GM:AddSkill(SKILL_LIGHTWEIGHT, "Налегке", GOOD.."+6 к скорости движения, когда в руках холодное оружие\n"..BAD.."-20% к урону ближнего боя",
                                                                -6,         -2,                 {}, TREE_MELEETREE)
GM:AddSkill(SKILL_BLOODLUST, "Жажда крови", "Вы получаете фантомное здоровье в размере половины нанесенного вам зомби урона\nФантомное здоровье теряется при любом обычном лечении\nФантомное здоровье падает на 5 единиц в секунду\n"..GOOD.."Излечивает 25% от урона ближнего боя за счет оставшегося фантомного здоровья\n"..BAD.."-50% к получаемому лечению",
                                                                -2,         4,                  {SKILL_LASTSTAND}, TREE_MELEETREE)
GM:AddSkill(SKILL_BRASH, "Дерзость", GOOD.."-16% к задержке удара ближнего боя\n"..BAD.."-15 к скорости движения на 10 сек. после убийства в ближнем бою",
                                                                6,          0,                  {}, TREE_MELEETREE)

GM:SetSkillModifierFunction(SKILLMOD_SPEED, function(pl, amount)
	pl.SkillSpeedAdd = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, function(pl, amount)
	pl.MedicHealMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDKIT_COOLDOWN_MUL, function(pl, amount)
	pl.MedicCooldownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_WORTH, function(pl, amount)
	pl.ExtraStartingWorth = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, function(pl, amount)
	pl.FallDamageThresholdMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, function(pl, amount)
	pl.FallDamageSlowDownMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FOODEATTIME_MUL, function(pl, amount)
	pl.FoodEatTimeMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_JUMPPOWER_MUL, function(pl, amount)
	pl.JumpPowerMul = math.Clamp(amount + 1.0, 0.0, 10.0)

	if SERVER then
		pl:ResetJumpPower()
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_DEPLOYSPEED_MUL, function(pl, amount)
	pl.DeploySpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)

	for _, wep in pairs(pl:GetWeapons()) do
		GAMEMODE:DoChangeDeploySpeed(wep)
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR, function(pl, amount)
	local oldarmor = pl:GetBloodArmor()
	local oldcap = pl.MaxBloodArmor or 20
	local new = 20 + math.Clamp(amount, -20, 1000)

	pl.MaxBloodArmor = new

	if SERVER then
		if oldarmor > oldcap then
			local overcap = oldarmor - oldcap
			pl:SetBloodArmor(pl.MaxBloodArmor + overcap)
		else
			pl:SetBloodArmor(pl:GetBloodArmor() / oldcap * new)
		end
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplier = math.Clamp(amount + 1.0, 0.05, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_MUL, function(pl, amount)
	pl.MeleeDamageMultiplier = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SELF_DAMAGE_MUL, function(pl, amount)
	pl.SelfDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_KNOCKBACK_MUL, function(pl, amount)
	pl.MeleeKnockbackMultiplier = math.Clamp(amount + 1.0, 0.0, 10000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_DAMAGE_MUL, function(pl, amount)
	pl.UnarmedDamageMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_UNARMED_SWING_DELAY_MUL, function(pl, amount)
	pl.UnarmedDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BARRICADE_PHASE_SPEED_MUL, function(pl, amount)
	pl.BarricadePhaseSpeedMul = math.Clamp(amount + 1.0, 0.05, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_HAMMER_SWING_DELAY_MUL, function(pl, amount)
	pl.HammerSwingDelayMul = math.Clamp(amount + 1.0, 0.01, 1.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_REPAIRRATE_MUL, function(pl, amount)
	pl.RepairRateMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_AIMSPREAD_MUL, function(pl, amount)
	pl.AimSpreadMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDGUN_FIRE_DELAY_MUL, function(pl, amount)
	pl.MedgunFireDelayMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MEDGUN_RELOAD_SPEED_MUL, function(pl, amount)
	pl.MedgunReloadSpeedMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DRONE_GUN_RANGE_MUL, function(pl, amount)
	pl.DroneGunRangeMul = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_HEALING_RECEIVED, function(pl, amount)
	pl.HealingReceived = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_PISTOL_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierPISTOL = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_SMG_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierSMG1 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_ASSAULT_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierAR2 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_SHELL_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierBUCKSHOT = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_RIFLE_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplier357 = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_XBOW_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierXBOWBOLT = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_PULSE_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierPULSE = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_RELOADSPEED_EXP_MUL, function(pl, amount)
	pl.ReloadSpeedMultiplierIMPACTMINE = math.Clamp(amount + 1.0, 0.0, 100.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, function(pl, amount)
	pl.BarbedArmor = math.Clamp(amount, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PULSE_WEAPON_SLOW_MUL, function(pl, amount)
	pl.PulseWeaponSlowMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.MeleeDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_POISON_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.PoisonDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BLEED_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.BleedDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_SWING_DELAY_MUL, function(pl, amount)
	pl.MeleeSwingDelayMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, function(pl, amount)
	pl.MeleeDamageToBloodArmorMul = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, function(pl, amount)
	pl.MeleeMovementSpeedOnKill = math.Clamp(amount, -15, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_POWERATTACK_MUL, function(pl, amount)
	pl.MeleePowerAttackMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_KNOCKDOWN_RECOVERY_MUL, function(pl, amount)
	pl.KnockdownRecoveryMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_RANGE_MUL, function(pl, amount)
	pl.MeleeRangeMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SLOW_EFF_TAKEN_MUL, function(pl, amount)
	pl.SlowEffTakenMul = math.Clamp(amount + 1.0, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.ExplosiveDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_FIRE_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.FireDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_CAPACITY_MUL, function(pl, amount)
	pl.PropCarryCapacityMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_THROW_STRENGTH_MUL, function(pl, amount)
	pl.ObjectThrowStrengthMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, function(pl, amount)
	pl.PhysicsDamageTakenMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_VISION_ALTER_DURATION_MUL, function(pl, amount)
	pl.VisionAlterDurationMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_DIMVISION_EFF_MUL, function(pl, amount)
	pl.DimVisionEffMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROP_CARRY_SLOW_MUL, function(pl, amount)
	pl.PropCarrySlowMul = math.Clamp(amount + 1.0, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_BLEED_SPEED_MUL, function(pl, amount)
	pl.BleedSpeedMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_LEG_DAMAGE_ADD, function(pl, amount)
	pl.MeleeLegDamageAdd = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_SIGIL_TELEPORT_MUL, function(pl, amount)
	pl.SigilTeleportTimeMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT, function(pl, amount)
	pl.BarbedArmorPercent = math.Clamp(amount, 0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_POISON_SPEED_MUL, function(pl, amount)
	pl.PoisonSpeedMul = math.Clamp(amount + 1.0, 0.1, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, GM:MkGenericMod("ProjDamageTakenMul"))
GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_RADIUS, GM:MkGenericMod("ExpDamageRadiusMul"))
GM:SetSkillModifierFunction(SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, GM:MkGenericMod("WeaponWeightSlowMul"))
GM:SetSkillModifierFunction(SKILLMOD_FRIGHT_DURATION_MUL, GM:MkGenericMod("FrightDurationMul"))
GM:SetSkillModifierFunction(SKILLMOD_IRONSIGHT_EFF_MUL, GM:MkGenericMod("IronsightEffMul"))
GM:SetSkillModifierFunction(SKILLMOD_MEDDART_EFFECTIVENESS_MUL, GM:MkGenericMod("MedDartEffMul"))

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_DMG_REDUCTION, function(pl, amount)
	pl.BloodArmorDamageReductionAdd = amount
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_MUL, function(pl, amount)
	local mul = math.Clamp(amount + 1.0, 0.0, 1000.0)

	pl.MaxBloodArmorMul = mul

	local oldarmor = pl:GetBloodArmor()
	local oldcap = pl.MaxBloodArmor or 20
	local new = pl.MaxBloodArmor * mul

	pl.MaxBloodArmor = new

	if SERVER then
		if oldarmor > oldcap then
			local overcap = oldarmor - oldcap
			pl:SetBloodArmor(pl.MaxBloodArmor + overcap)
		else
			pl:SetBloodArmor(pl:GetBloodArmor() / oldcap * new)
		end
	end
end)

GM:SetSkillModifierFunction(SKILLMOD_BLOODARMOR_GAIN_MUL, GM:MkGenericMod("BloodarmorGainMul"))
GM:SetSkillModifierFunction(SKILLMOD_LOW_HEALTH_SLOW_MUL, GM:MkGenericMod("LowHealthSlowMul"))
GM:SetSkillModifierFunction(SKILLMOD_PROJ_SPEED, GM:MkGenericMod("ProjectileSpeedMul"))

GM:SetSkillModifierFunction(SKILLMOD_ENDWAVE_POINTS, function(pl,amount)
	pl.EndWavePointsExtra = math.Clamp(amount, 0.0, 1000.0)
end)

GM:SetSkillModifierFunction(SKILLMOD_ARSENAL_DISCOUNT, GM:MkGenericMod("ArsenalDiscount"))
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_RADIUS, GM:MkGenericMod("CloudRadius"))
GM:SetSkillModifierFunction(SKILLMOD_CLOUD_TIME, GM:MkGenericMod("CloudTime"))
GM:SetSkillModifierFunction(SKILLMOD_EXP_DAMAGE_MUL, GM:MkGenericMod("ExplosiveDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_PROJECTILE_DAMAGE_MUL, GM:MkGenericMod("ProjectileDamageMul"))
GM:SetSkillModifierFunction(SKILLMOD_TURRET_RANGE_MUL, GM:MkGenericMod("TurretRangeMul"))
GM:SetSkillModifierFunction(SKILLMOD_AIM_SHAKE_MUL, GM:MkGenericMod("AimShakeMul"))

GM:AddSkillModifier(SKILL_SPEED1, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_SPEED1, SKILLMOD_HEALTH, -1)

GM:AddSkillModifier(SKILL_SPEED2, SKILLMOD_SPEED, 1.5)
GM:AddSkillModifier(SKILL_SPEED2, SKILLMOD_HEALTH, -2)

GM:AddSkillModifier(SKILL_SPEED3, SKILLMOD_SPEED, 3)
GM:AddSkillModifier(SKILL_SPEED3, SKILLMOD_HEALTH, -4)

GM:AddSkillModifier(SKILL_SPEED4, SKILLMOD_SPEED, 4.5)
GM:AddSkillModifier(SKILL_SPEED4, SKILLMOD_HEALTH, -6)

GM:AddSkillModifier(SKILL_SPEED5, SKILLMOD_SPEED, 5.25)
GM:AddSkillModifier(SKILL_SPEED5, SKILLMOD_HEALTH, -7)

GM:AddSkillModifier(SKILL_STOIC1, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_STOIC1, SKILLMOD_SPEED, -0.75)

GM:AddSkillModifier(SKILL_STOIC2, SKILLMOD_HEALTH, 2)
GM:AddSkillModifier(SKILL_STOIC2, SKILLMOD_SPEED, -1.5)

GM:AddSkillModifier(SKILL_STOIC3, SKILLMOD_HEALTH, 4)
GM:AddSkillModifier(SKILL_STOIC3, SKILLMOD_SPEED, -3)

GM:AddSkillModifier(SKILL_STOIC4, SKILLMOD_HEALTH, 6)
GM:AddSkillModifier(SKILL_STOIC4, SKILLMOD_SPEED, -4.5)

GM:AddSkillModifier(SKILL_STOIC5, SKILLMOD_HEALTH, 7)
GM:AddSkillModifier(SKILL_STOIC5, SKILLMOD_SPEED, -5.25)

GM:AddSkillModifier(SKILL_VITALITY1, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_VITALITY2, SKILLMOD_HEALTH, 1)
GM:AddSkillModifier(SKILL_VITALITY3, SKILLMOD_HEALTH, 1)

GM:AddSkillModifier(SKILL_MOTIONI, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_MOTIONII, SKILLMOD_SPEED, 0.75)
GM:AddSkillModifier(SKILL_MOTIONIII, SKILLMOD_SPEED, 0.75)

GM:AddSkillModifier(SKILL_FOCUS, SKILLMOD_AIMSPREAD_MUL, -0.03)
GM:AddSkillModifier(SKILL_FOCUS, SKILLMOD_RELOADSPEED_MUL, -0.03)

GM:AddSkillModifier(SKILL_FOCUSII, SKILLMOD_AIMSPREAD_MUL, -0.04)
GM:AddSkillModifier(SKILL_FOCUSII, SKILLMOD_RELOADSPEED_MUL, -0.04)

GM:AddSkillModifier(SKILL_FOCUSIII, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(SKILL_FOCUSIII, SKILLMOD_RELOADSPEED_MUL, -0.05)

GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_RELOADSPEED_MUL, -0.06)
GM:AddSkillModifier(SKILL_ORPHICFOCUS, SKILLMOD_AIMSPREAD_MUL, -0.02)

GM:AddSkillModifier(SKILL_DELIBRATION, SKILLMOD_AIMSPREAD_MUL, -0.01)

GM:AddSkillModifier(SKILL_WOOISM, SKILLMOD_IRONSIGHT_EFF_MUL, -0.25)

GM:AddSkillModifier(SKILL_GLUTTON, SKILLMOD_HEALTH, -5)

GM:AddSkillModifier(SKILL_TANKER, SKILLMOD_HEALTH, 20)
GM:AddSkillModifier(SKILL_TANKER, SKILLMOD_SPEED, -15)

GM:AddSkillModifier(SKILL_ULTRANIMBLE, SKILLMOD_HEALTH, -20)
GM:AddSkillModifier(SKILL_ULTRANIMBLE, SKILLMOD_SPEED, 15)

GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_SELF_DAMAGE_MUL, -0.35)
GM:AddSkillModifier(SKILL_EGOCENTRIC, SKILLMOD_HEALTH, -5)

GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_SELF_DAMAGE_MUL, -0.45)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_RELOADSPEED_MUL, -0.07)
GM:AddSkillModifier(SKILL_BLASTPROOF, SKILLMOD_DEPLOYSPEED_MUL, -0.12)

GM:AddSkillModifier(SKILL_SURGEON1, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.08)
GM:AddSkillModifier(SKILL_SURGEON2, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.09)
GM:AddSkillModifier(SKILL_SURGEON3, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.10)
GM:AddSkillModifier(SKILL_SURGEONIV, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.11)

GM:AddSkillModifier(SKILL_BIOLOGYI, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.08)
GM:AddSkillModifier(SKILL_BIOLOGYII, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.09)
GM:AddSkillModifier(SKILL_BIOLOGYIII, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.1)
GM:AddSkillModifier(SKILL_BIOLOGYIV, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.11)

GM:AddSkillModifier(SKILL_HANDY1, SKILLMOD_REPAIRRATE_MUL, 0.04)
GM:AddSkillModifier(SKILL_HANDY2, SKILLMOD_REPAIRRATE_MUL, 0.05)
GM:AddSkillModifier(SKILL_HANDY3, SKILLMOD_REPAIRRATE_MUL, 0.06)
GM:AddSkillModifier(SKILL_HANDY4, SKILLMOD_REPAIRRATE_MUL, 0.07)
GM:AddSkillModifier(SKILL_HANDY5, SKILLMOD_REPAIRRATE_MUL, 0.08)

GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_WORTH, 15)
GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_ENDWAVE_POINTS, 1)
GM:AddSkillModifier(SKILL_D_SLOW, SKILLMOD_SPEED, -33.75)

GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODEATTIME_MUL, 2.0)
GM:AddSkillModifier(SKILL_GOURMET, SKILLMOD_FOODRECOVERY_MUL, 1.0)

GM:AddSkillModifier(SKILL_SUGARRUSH, SKILLMOD_FOODRECOVERY_MUL, -0.35)

GM:AddSkillModifier(SKILL_BATTLER1, SKILLMOD_MELEE_DAMAGE_MUL, 0.04)
GM:AddSkillModifier(SKILL_BATTLER2, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_BATTLER3, SKILLMOD_MELEE_DAMAGE_MUL, 0.05)
GM:AddSkillModifier(SKILL_BATTLER4, SKILLMOD_MELEE_DAMAGE_MUL, 0.06)
GM:AddSkillModifier(SKILL_BATTLER5, SKILLMOD_MELEE_DAMAGE_MUL, 0.07)

GM:AddSkillModifier(SKILL_JOUSTER, SKILLMOD_MELEE_DAMAGE_MUL, 0.1)
GM:AddSkillModifier(SKILL_JOUSTER, SKILLMOD_MELEE_KNOCKBACK_MUL, -1.0)

GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_DEPLOYSPEED_MUL, 0.65)
GM:AddSkillModifier(SKILL_QUICKDRAW, SKILLMOD_RELOADSPEED_MUL, -0.15)

GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_QUICKRELOAD, SKILLMOD_DEPLOYSPEED_MUL, -0.25)

GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_RELOADSPEED_MUL, 0.10)
GM:AddSkillModifier(SKILL_SLEIGHTOFHAND, SKILLMOD_AIMSPREAD_MUL, 0.05)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_RELOADSPEED_MUL, 0.02)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE1, SKILLMOD_DEPLOYSPEED_MUL, 0.02)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_RELOADSPEED_MUL, 0.03)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE2, SKILLMOD_DEPLOYSPEED_MUL, 0.03)

GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_RELOADSPEED_MUL, 0.04)
GM:AddSkillModifier(SKILL_TRIGGER_DISCIPLINE3, SKILLMOD_DEPLOYSPEED_MUL, 0.04)

GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.15)
GM:AddSkillModifier(SKILL_PHASER, SKILLMOD_SIGIL_TELEPORT_MUL, 0.15)

GM:AddSkillModifier(SKILL_DRIFT, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.05)

GM:AddSkillModifier(SKILL_WARP, SKILLMOD_SIGIL_TELEPORT_MUL, -0.05)

GM:AddSkillModifier(SKILL_HAMMERDISCIPLINE, SKILLMOD_HAMMER_SWING_DELAY_MUL, -0.2)
GM:AddSkillModifier(SKILL_BARRICADEEXPERT, SKILLMOD_HAMMER_SWING_DELAY_MUL, 0.3)

GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.4)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_RECOVERY_MUL, -0.5)
GM:AddSkillModifier(SKILL_SAFEFALL, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, 0.4)

GM:AddSkillModifier(SKILL_BACKPEDDLER, SKILLMOD_SPEED, -7)
GM:AddSkillFunction(SKILL_BACKPEDDLER, function(pl, active)
	pl.NoBWSpeedPenalty = active
end)

GM:AddSkillModifier(SKILL_D_CLUMSY, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_CLUMSY, SKILLMOD_POINTS, 5)
GM:AddSkillFunction(SKILL_D_CLUMSY, function(pl, active)
	pl.IsClumsy = active
end)

GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_D_NOODLEARMS, SKILLMOD_SCRAP_START, 1)
GM:AddSkillFunction(SKILL_D_NOODLEARMS, function(pl, active)
	pl.NoObjectPickup = active
end)

GM:AddSkillModifier(SKILL_D_PALSY, SKILLMOD_WORTH, 10)
GM:AddSkillModifier(SKILL_D_PALSY, SKILLMOD_RESUPPLY_DELAY_MUL, -0.03)
GM:AddSkillFunction(SKILL_D_PALSY, function(pl, active)
	pl.HasPalsy = active
end)

GM:AddSkillModifier(SKILL_D_HEMOPHILIA, SKILLMOD_WORTH, 10)
GM:AddSkillModifier(SKILL_D_HEMOPHILIA, SKILLMOD_SCRAP_START, 3)
GM:AddSkillFunction(SKILL_D_HEMOPHILIA, function(pl, active)
	pl.HasHemophilia = active
end)

GM:AddSkillModifier(SKILL_D_LATEBUYER, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_LATEBUYER, SKILLMOD_ARSENAL_DISCOUNT, -0.02)

GM:AddSkillFunction(SKILL_TAUT, function(pl, active)
	pl.BuffTaut = active
end)

GM:AddSkillModifier(SKILL_BLOODARMOR, SKILLMOD_HEALTH, -13)

GM:AddSkillModifier(SKILL_HAEMOSTASIS, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.25)

GM:AddSkillModifier(SKILL_REGENERATOR, SKILLMOD_HEALTH, -6)

GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_WORTH, 15)
GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_ENDWAVE_POINTS, 1)
GM:AddSkillModifier(SKILL_D_WEAKNESS, SKILLMOD_HEALTH, -45)

GM:AddSkillModifier(SKILL_D_WIDELOAD, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_WIDELOAD, SKILLMOD_RESUPPLY_DELAY_MUL, -0.05)
GM:AddSkillFunction(SKILL_D_WIDELOAD, function(pl, active)
	pl.NoGhosting = active
end)

GM:AddSkillFunction(SKILL_WOOISM, function(pl, active)
	pl.Wooism = active
end)

GM:AddSkillFunction(SKILL_ORPHICFOCUS, function(pl, active)
	pl.Orphic = active
end)

GM:AddSkillModifier(SKILL_WORTHINESS1, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS2, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS3, SKILLMOD_WORTH, 5)
GM:AddSkillModifier(SKILL_WORTHINESS4, SKILLMOD_WORTH, 5)

GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.35)
GM:AddSkillModifier(SKILL_KNUCKLEMASTER, SKILLMOD_UNARMED_DAMAGE_MUL, 0.75)

GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_DAMAGE_MUL, -0.25)
GM:AddSkillModifier(SKILL_CRITICALKNUCKLE, SKILLMOD_UNARMED_SWING_DELAY_MUL, 0.25)

GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 0.75)
GM:AddSkillModifier(SKILL_SMARTTARGETING, SKILLMOD_MEDDART_EFFECTIVENESS_MUL, -0.3)

GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, 1.5)
GM:AddSkillModifier(SKILL_RECLAIMSOL, SKILLMOD_MEDGUN_RELOAD_SPEED_MUL, -0.4)

GM:AddSkillModifier(SKILL_LANKY, SKILLMOD_MELEE_DAMAGE_MUL, -0.15)
GM:AddSkillModifier(SKILL_LANKY, SKILLMOD_MELEE_RANGE_MUL, 0.1)

GM:AddSkillModifier(SKILL_LANKYII, SKILLMOD_MELEE_DAMAGE_MUL, -0.15)
GM:AddSkillModifier(SKILL_LANKYII, SKILLMOD_MELEE_RANGE_MUL, 0.1)

GM:AddSkillModifier(SKILL_D_FRAIL, SKILLMOD_WORTH, 20)
GM:AddSkillModifier(SKILL_D_FRAIL, SKILLMOD_POINTS, 5)
GM:AddSkillFunction(SKILL_D_FRAIL, function(pl, active)
	pl:SetDTBool(DT_PLAYER_BOOL_FRAIL, active)
end)

GM:AddSkillModifier(SKILL_MASTERCHEF, SKILLMOD_MELEE_DAMAGE_MUL, -0.10)

GM:AddSkillModifier(SKILL_LIGHTWEIGHT, SKILLMOD_MELEE_DAMAGE_MUL, -0.2)

GM:AddSkillModifier(SKILL_AGILEI, SKILLMOD_JUMPPOWER_MUL, 0.04)
GM:AddSkillModifier(SKILL_AGILEI, SKILLMOD_SPEED, -2)

GM:AddSkillModifier(SKILL_AGILEII, SKILLMOD_JUMPPOWER_MUL, 0.05)
GM:AddSkillModifier(SKILL_AGILEII, SKILLMOD_SPEED, -3)

GM:AddSkillModifier(SKILL_AGILEIII, SKILLMOD_JUMPPOWER_MUL, 0.06)
GM:AddSkillModifier(SKILL_AGILEIII, SKILLMOD_SPEED, -4)

GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_RADIUS, -0.10)
GM:AddSkillModifier(SKILL_SOFTDET, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.4)

GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.25)
GM:AddSkillModifier(SKILL_IRONBLOOD, SKILLMOD_BLOODARMOR_MUL, -0.5)

GM:AddSkillModifier(SKILL_BLOODLETTER, SKILLMOD_BLOODARMOR_GAIN_MUL, 1)

GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SPEED, -4)
GM:AddSkillModifier(SKILL_SURESTEP, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.35)

GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_SPEED, -4)
GM:AddSkillModifier(SKILL_INTREPID, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.35)

GM:AddSkillModifier(SKILL_UNBOUND, SKILLMOD_SPEED, -4)

GM:AddSkillModifier(SKILL_CHEAPKNUCKLE, SKILLMOD_MELEE_RANGE_MUL, -0.1)

GM:AddSkillModifier(SKILL_HEAVYSTRIKES, SKILLMOD_MELEE_KNOCKBACK_MUL, 1)

GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJ_SPEED, -0.25)
GM:AddSkillModifier(SKILL_CANNONBALL, SKILLMOD_PROJECTILE_DAMAGE_MUL, 0.03)

GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_RADIUS, -0.2)
GM:AddSkillModifier(SKILL_CONEFFECT, SKILLMOD_EXP_DAMAGE_MUL, 0.05)

GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_SPEED, -12)
GM:AddSkillModifier(SKILL_CARDIOTONIC, SKILLMOD_BLOODARMOR_DMG_REDUCTION, -0.2)

GM:AddSkillFunction(SKILL_SCOURER, function(pl, active)
	pl.Scourer = active
end)

GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_RADIUS, 0.15)
GM:AddSkillModifier(SKILL_DISPERSION, SKILLMOD_CLOUD_TIME, -0.1)

GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.16)
GM:AddSkillModifier(SKILL_BRASH, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, -15)

GM:AddSkillModifier(SKILL_CIRCULATION, SKILLMOD_BLOODARMOR, 1)

GM:AddSkillModifier(SKILL_SANGUINE, SKILLMOD_BLOODARMOR, 11)
GM:AddSkillModifier(SKILL_SANGUINE, SKILLMOD_HEALTH, -9)

GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_BLOODARMOR_DMG_REDUCTION, 0.05)
GM:AddSkillModifier(SKILL_ANTIGEN, SKILLMOD_HEALTH, -3)

GM:AddSkillModifier(SKILL_INSTRUMENTS, SKILLMOD_TURRET_RANGE_MUL, 0.05)

GM:AddSkillModifier(SKILL_LEVELHEADED, SKILLMOD_AIM_SHAKE_MUL, -0.05)

GM:AddSkillModifier(SKILL_ROBUST, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.06)

GM:AddSkillModifier(SKILL_TAUT, SKILLMOD_PROP_CARRY_SLOW_MUL, 0.4)

GM:AddSkillModifier(SKILL_TURRETOVERLOAD, SKILLMOD_TURRET_RANGE_MUL, -0.3)

GM:AddSkillModifier(SKILL_STOWAGE, SKILLMOD_RESUPPLY_DELAY_MUL, 0.15)
GM:AddSkillFunction(SKILL_STOWAGE, function(pl, active)
	pl.Stowage = active
end)

GM:AddSkillFunction(SKILL_TRUEWOOISM, function(pl, active)
	pl.TrueWooism = active
end)
