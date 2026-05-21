INVCAT_TRINKETS = 1
INVCAT_COMPONENTS = 2
INVCAT_CONSUMABLES = 3

GM.ZSInventoryItemData = {}
GM.ZSInventoryCategories = {
	[INVCAT_TRINKETS] = "Trinkets",
	[INVCAT_COMPONENTS] = "Components",
	[INVCAT_CONSUMABLES] = "Consumables"
}
GM.ZSInventoryPrefix = {
	[INVCAT_TRINKETS] = "trin",
	[INVCAT_COMPONENTS] = "comp",
	[INVCAT_CONSUMABLES] = "cons"
}

GM.Assemblies = {}
GM.Breakdowns = {}

function GM:GetInventoryItemType(item)
	for typ, aff in pairs(self.ZSInventoryPrefix) do
		if string.sub(item, 1, 4) == aff then
			return typ
		end
	end

	return -1
end

local index = 1
function GM:AddInventoryItemData(intname, name, description, weles, tier, stocks)
	local datatab = {PrintName = name, DroppedEles = weles, Tier = tier, Description = description, Stocks = stocks, Index = index}
	self.ZSInventoryItemData[intname] = datatab
	self.ZSInventoryItemData[index] = datatab

	index = index + 1
end


function GM:AddWeaponBreakdownRecipe(weapon, result)
	local datatab = {Result = result, Index = index}
	self.Breakdowns[weapon] = datatab
	for i = 1, 3 do
		self.Breakdowns[self:GetWeaponClassOfQuality(weapon, i)] = datatab
		self.Breakdowns[self:GetWeaponClassOfQuality(weapon, i, 1)] = datatab
	end

	self.Breakdowns[#self.Breakdowns + 1] = datatab
end

GM:AddWeaponBreakdownRecipe("weapon_zs_stubber",							"comp_modbarrel")
GM:AddWeaponBreakdownRecipe("weapon_zs_z9000",								"comp_basicecore")
GM:AddWeaponBreakdownRecipe("weapon_zs_blaster",							"comp_pumpaction")
GM:AddWeaponBreakdownRecipe("weapon_zs_novablaster",						"comp_contaecore")
GM:AddWeaponBreakdownRecipe("weapon_zs_waraxe", 							"comp_focusbarrel")
GM:AddWeaponBreakdownRecipe("weapon_zs_innervator",							"comp_gaussframe")
GM:AddWeaponBreakdownRecipe("weapon_zs_swissarmyknife",						"comp_shortblade")
GM:AddWeaponBreakdownRecipe("weapon_zs_owens",								"comp_multibarrel")
GM:AddWeaponBreakdownRecipe("weapon_zs_onyx",								"comp_precision")
GM:AddWeaponBreakdownRecipe("weapon_zs_minelayer",							"comp_launcher")
GM:AddWeaponBreakdownRecipe("weapon_zs_fracture",							"comp_linearactuator")
GM:AddWeaponBreakdownRecipe("weapon_zs_harpoon",							"comp_metalpole")

-- Assemblies (Assembly, Component, Weapon)
GM.Assemblies["weapon_zs_waraxe"] 								= {"comp_modbarrel", 		"weapon_zs_glock3"}
GM.Assemblies["weapon_zs_bust"] 								= {"comp_busthead", 		"weapon_zs_plank"}
GM.Assemblies["weapon_zs_sawhack"] 								= {"comp_sawblade", 		"weapon_zs_axe"}
GM.Assemblies["weapon_zs_manhack_saw"] 							= {"comp_sawblade", 		"weapon_zs_manhack"}
GM.Assemblies["weapon_zs_megamasher"] 							= {"comp_propanecan", 		"weapon_zs_sledgehammer"}
GM.Assemblies["weapon_zs_electrohammer"] 						= {"comp_electrobattery",	"weapon_zs_hammer"}
GM.Assemblies["weapon_zs_novablaster"] 							= {"comp_basicecore",		"weapon_zs_magnum"}
GM.Assemblies["weapon_zs_tithonus"] 							= {"comp_contaecore",		"weapon_zs_oberon"}
GM.Assemblies["weapon_zs_fracture"] 							= {"comp_pumpaction",		"weapon_zs_sawedoff"}
GM.Assemblies["weapon_zs_seditionist"] 							= {"comp_focusbarrel",		"weapon_zs_deagle"}
GM.Assemblies["weapon_zs_molotov"] 								= {"comp_propanecan",		"weapon_zs_glassbottle"}
GM.Assemblies["weapon_zs_blareduct"] 							= {"trinket_ammovestii",	"weapon_zs_pipe"}
GM.Assemblies["weapon_zs_cinderrod"] 							= {"comp_propanecan",		"weapon_zs_blareduct"}
GM.Assemblies["weapon_zs_innervator"] 							= {"comp_electrobattery",	"weapon_zs_jackhammer"}
GM.Assemblies["weapon_zs_hephaestus"] 							= {"comp_gaussframe",		"weapon_zs_tithonus"}
GM.Assemblies["weapon_zs_stabber"] 								= {"comp_shortblade",		"weapon_zs_annabelle"}
GM.Assemblies["weapon_zs_galestorm"] 							= {"comp_multibarrel",		"weapon_zs_uzi"}
GM.Assemblies["weapon_zs_eminence"] 							= {"trinket_ammovestiii",	"weapon_zs_barrage"}
GM.Assemblies["weapon_zs_gladiator"] 							= {"trinket_ammovestiii",	"weapon_zs_sweepershotgun"}
GM.Assemblies["weapon_zs_ripper"]								= {"comp_sawblade",			"weapon_zs_zeus"}
GM.Assemblies["weapon_zs_avelyn"]								= {"trinket_ammovestiii",	"weapon_zs_charon"}
GM.Assemblies["weapon_zs_asmd"]									= {"comp_precision",		"weapon_zs_quasar"}
GM.Assemblies["weapon_zs_enkindler"]							= {"comp_launcher",			"weapon_zs_cinderrod"}
GM.Assemblies["weapon_zs_proliferator"]							= {"comp_linearactuator",	"weapon_zs_galestorm"}
GM.Assemblies["trinket_electromagnet"]							= {"comp_electrobattery",	"trinket_magnet"}
GM.Assemblies["trinket_projguide"]								= {"comp_cpuparts",			"trinket_targetingvisori"}
GM.Assemblies["trinket_projwei"]								= {"comp_busthead",			"trinket_projguide"}
GM.Assemblies["trinket_controlplat"]							= {"comp_cpuparts",			"trinket_mainsuite"}

GM:AddInventoryItemData("comp_modbarrel",		"Modular Barrel",			"A modular barrel suited for pairing up with another gun barrel.",								"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_burstmech",		"Burst Fire Mechanism",		"A mechanism that could be used to make a gun burst fire.",										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_basicecore",		"Basic Energy Core",		"A small energy core. Needs a weapon with a cylinder mechanism to contain the energy output.",	"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_busthead",		"Bust Head",				"A bust head that could be fitted on to something handle shaped.",								"models/props_combine/breenbust.mdl")
GM:AddInventoryItemData("comp_sawblade",		"Saw Blade",				"A sharp saw blade ready to be fitted onto fast moving objects.",								"models/props_junk/sawblade001a.mdl")
GM:AddInventoryItemData("comp_propanecan",		"Propane Canister",			"A propane canister. With the correct setup, has the potential to ignite things.",				"models/props_junk/propane_tank001a.mdl")
GM:AddInventoryItemData("comp_electrobattery",	"Electrobattery",			"An electrobattery. Could be used to improve repairing motions.",								"models/items/car_battery01.mdl")
--GM:AddInventoryItemData("comp_hungrytether",	"Hungry Tether",			"A hungry tether from a devourer that comes from a devourer rib.",								"models/gibs/HGIBS_rib.mdl")]]
GM:AddInventoryItemData("comp_contaecore",		"Contained Energy Core",	"A contained energy core, that has an internal charging mechanism.",							"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pumpaction",		"Pump Action Mechanism",	"A standard pump action mechanism from a blaster shotgun.",										"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_focusbarrel",		"Focused Barrel",			"A large focused barrel made from the barrels of the waraxe. Suitable for a handcannon.",		"models/props_c17/trappropeller_lever.mdl")
GM:AddInventoryItemData("comp_gaussframe",		"Gauss Frame",				"A highly advanced gauss frame. It's almost alien in design, making it hard to use.",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_metalpole",		"Metal Pole",				"Long metal pole that could be used to attack things from a distance.",							"models/props_c17/signpole001.mdl")
GM:AddInventoryItemData("comp_salleather",		"Salvaged Leather",			"Pieces of leather that are hard enough to make a nasty impact.",								"models/props_junk/shoe001.mdl")
GM:AddInventoryItemData("comp_gyroscope",		"Gyroscope",				"A metal gyroscope used to calculate orientation.",												"models/maxofs2d/hover_rings.mdl")
GM:AddInventoryItemData("comp_reciever",		"Reciever",					"A radio reciever. Could be used for automation and communication purposes.",					"models/props_lab/reciever01b.mdl")
GM:AddInventoryItemData("comp_cpuparts",		"CPU Parts",				"Parts from a central processor.",																"models/props_lab/harddrive01.mdl")
GM:AddInventoryItemData("comp_launcher",		"Launching Tube",			"A metal tube made to launch objects.",															"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_launcherh",		"Heavy Launching Tube",		"A heavy metal tube made to launch large objects.",												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_shortblade",		"Short Blade",				"A short metal blade for cutting and stabbing.",												"models/weapons/w_knife_t.mdl")
GM:AddInventoryItemData("comp_multibarrel",		"Multi-Bored Barrel",		"An unusual gun barrel which allows multiple bullets to pass through.",							"models/props_lab/pipesystem03a.mdl")
GM:AddInventoryItemData("comp_holoscope",		"Holographic Scope",		"A holographic weapon sight with magnification.",												{
	["base"] = { type = "Model", model = "models/props_c17/utilityconnecter005.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.273, 1.728, -0.843), angle = Angle(74.583, 180, 0), size = Vector(2.207, 0.105, 0.316), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} },
	["base+"] = { type = "Model", model = "models/props_combine/tprotato1.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0.492, -1.03, 0), angle = Angle(0, -78.715, 90), size = Vector(0.03, 0.02, 0.032), color = Color(50, 50, 66, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal02", skin = 0, bodygroup = {} }
})
GM:AddInventoryItemData("comp_linearactuator",	"Linear Actuator",			"A linear actuator from a shell holder. Requires a heavy base to mount properly.",				"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_pulsespool",		"Pulse Spool",				"Used to inject more pulse power to a system. Could be used to stabilise something.",			"models/Items/combine_rifle_cartridge01.mdl")
GM:AddInventoryItemData("comp_flak",			"Flak Chamber",				"An internal chamber for projecting heated scrap.",												"models/weapons/w_rocket_launcher.mdl")
GM:AddInventoryItemData("comp_precision",		"Precision Chassis",		"A suite setup for rewarding precise shots on moving targets.",									"models/Items/combine_rifle_cartridge01.mdl")

-- Trinkets
local trinket, description, trinketwep
local hpveles = {
	["ammo"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 3.5, 3), angle = Angle(15.194, 80.649, 180), size = Vector(0.6, 0.6, 1.2), color = Color(145, 132, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local hpweles = {
	["ammo"] = { type = "Model", model = "models/healthvial.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 2.5, 3), angle = Angle(15.194, 80.649, 180), size = Vector(0.6, 0.6, 1.2), color = Color(145, 132, 0, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local ammoveles = {
	["ammo"] = { type = "Model", model = "models/props/de_prodigy/ammo_can_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 3, -0.519), angle = Angle(0, 85.324, 101.688), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local ammoweles = {
	["ammo"] = { type = "Model", model = "models/props/de_prodigy/ammo_can_02.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 2, -1.558), angle = Angle(5.843, 82.986, 111.039), size = Vector(0.25, 0.25, 0.25), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local mveles = {
	["band++"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(2.599, 1, 1), angle = Angle(0, -25, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 3, -1), angle = Angle(97.013, 29.221, 0), size = Vector(0.045, 0.045, 0.025), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band+"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(-2.401, -1, 0.5), angle = Angle(0, 155.455, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}
local mweles = {
	["band++"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(2.599, 1, 1), angle = Angle(0, -25, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band+"] = { type = "Model", model = "models/props_junk/harpoon002a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "band", pos = Vector(-2.401, -1, 0.5), angle = Angle(0, 155.455, 0), size = Vector(0.019, 0.15, 0.15), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} },
	["band"] = { type = "Model", model = "models/props_phx/construct/metal_plate_curve360.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4.5, 2, -0.5), angle = Angle(111.039, -92.338, 97.013), size = Vector(0.045, 0.045, 0.025), color = Color(55, 52, 51, 255), surpresslightning = false, material = "models/props_pipes/pipemetal001a", skin = 0, bodygroup = {} }
}
local pveles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.596, 1.557, -2.597), angle = Angle(5.843, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local pweles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_lock01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 0.5, -2), angle = Angle(5, 90, 0), size = Vector(0.25, 0.15, 0.3), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local oveles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2, -1.5), angle = Angle(5, 180, 0), size = Vector(0.05, 0.039, 0.07), color = Color(196, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local oweles = {
	["perf"] = { type = "Model", model = "models/props_combine/combine_generator01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2, -1.5), angle = Angle(5, 180, 0), size = Vector(0.05, 0.039, 0.07), color = Color(196, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local develes = {
	["perf"] = { type = "Model", model = "models/props_lab/blastdoor001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.799, 2.5, -5.715), angle = Angle(5, 180, 0), size = Vector(0.1, 0.039, 0.09), color = Color(168, 155, 0, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} }
}
local deweles = {
	["perf"] = { type = "Model", model = "models/props_lab/blastdoor001b.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 2, -5.715), angle = Angle(0, 180, 0), size = Vector(0.1, 0.039, 0.09), color = Color(168, 155, 0, 255), surpresslightning = false, material = "models/props_pipes/pipeset_metal", skin = 0, bodygroup = {} }
}
local supveles = {
	["perf"] = { type = "Model", model = "models/props_lab/reciever01c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.299, 2.5, -2), angle = Angle(5, 180, 92.337), size = Vector(0.2, 0.699, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}
local supweles = {
	["perf"] = { type = "Model", model = "models/props_lab/reciever01c.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(5, 1.5, -2), angle = Angle(5, 180, 92.337), size = Vector(0.2, 0.699, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}

-- Health Trinkets
trinket, trinketwep = GM:AddTrinket("Медицинский пакет", "vitpackagei", false, hpveles, hpweles, 2, "+20 к максимальному здоровью\n+60% к получаемому лечению")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 20)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.60)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Банк жизненной силы", "vitpackageii", false, hpveles, hpweles, 4, "+40 к максимальному здоровью\n+40% к получаемому лечению")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 40)
GM:AddSkillModifier(trinket, SKILLMOD_HEALING_RECEIVED, 0.40)

trinket, trinketwep = GM:AddTrinket("Пакет переливания крови", "bloodpack", false, hpveles, hpweles, 2, "Дает 20 кровавой брони, если здоровье падает ниже 50%\nУничтожается при активации.", nil, 15)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Кровавый пакет", "cardpackagei", false, hpveles, hpweles, 2, "+30 к максимальной кровавой броне")
GM:AddSkillModifier(trinket, SKILLMOD_BLOODARMOR, 30)
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket("Банк крови", "cardpackageii", false, hpveles, hpweles, 4, "+60 к максимальной кровавой броне"), SKILLMOD_BLOODARMOR, 60)

GM:AddTrinket("Имплант регенерации", "regenimplant", false, hpveles, hpweles, 3, "Восстанавливает 1 единицу здоровья каждые 12 секунд, если вы недавно не получали урон")

trinket, trinketwep = GM:AddTrinket("Био-очиститель", "biocleanser", false, hpveles, hpweles, 2, "Блокирует один негативный эффект каждые 20 секунд")
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket("Набор столовых приборов", "cutlery", false, hpveles, hpweles, nil, "-80% времени на употребление еды"), SKILLMOD_FOODEATTIME_MUL, -0.8)

-- Melee Trinkets

description = "5 ударов кулачным оружием наносят серьезные повреждения рук и ног\n-15% времени до следующего удара без оружия"
trinket = GM:AddTrinket("Учебник по боксу", "boxingtraining", false, mveles, mweles, nil, description)
GM:AddSkillModifier(trinket, SKILLMOD_UNARMED_SWING_DELAY_MUL, -5.15)
GM:AddSkillFunction(trinket, function(pl, active) pl.BoxingTraining = active end)

trinket, trinketwep = GM:AddTrinket("Система импульса I", "momentumsupsysii", false, mveles, mweles, 2, "-13% задержки взмаха ближнего боя\n+10% отбрасывания ближнего боя")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.1)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Система импульса II", "momentumsupsysiii", false, mveles, mweles, 3, "-20% задержки взмаха ближнего боя\n+12% отбрасывания ближнего боя")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.20)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_KNOCKBACK_MUL, 0.12)

GM:AddSkillModifier(GM:AddTrinket("Хемо-адреналиновый конвертер I", "hemoadrenali", false, mveles, mweles, nil, "+2% урона ближнего боя преобразуется в кровавую броню."), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.02)

trinket = GM:AddTrinket("Хемо-адреналиновый усилитель", "hemoadrenalii", false, mveles, mweles, 3, "+3% урона ближнего боя преобразуется в кровавую броню\n+90 к скорости при убийстве в ближнем бою на 10 секунд")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.03)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_MOVEMENTSPEED_ON_KILL, 90)

GM:AddSkillModifier(GM:AddTrinket("Хемо-адреналиновый конвертер II", "hemoadrenaliii", false, mveles, mweles, 4, "+4% урона ближнего боя преобразуется в кровавую броню."), SKILLMOD_MELEE_DAMAGE_TO_BLOODARMOR_MUL, 0.04)

GM:AddSkillModifier(GM:AddTrinket("Силовая перчатка", "powergauntlet", false, mveles, mweles, 3, "Каждый удар увеличивает урон ближнего боя вплоть до +45%\nПромах сбрасывает бонус"), SKILLMOD_MELEE_POWERATTACK_MUL, 0.45)

GM:AddTrinket("Набор филигранности", "sharpkit", false, mveles, mweles, 2, "Наносит до +32% больше урона ближнего боя замедленным зомби")

GM:AddSkillModifier(GM:AddTrinket("Точильный камень", "sharpstone", false, mveles, mweles, 3, "+50% урона ближнего боя"), SKILLMOD_MELEE_DAMAGE_MUL, 0.50)
-- Performance Trinkets
-- Performance Trinkets
GM:AddTrinket("Кислородный баллон", "oxygentank", true, nil, {
    ["base"] = { type = "Model", model = "models/props_c17/canister01a.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 3, -1), angle = Angle(180, 0, 0), size = Vector(0.5, 0.5, 0.5), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, nil, "В 10 раз увеличивает время задержки дыхания под водой.", "oxygentank")

GM:AddSkillModifier(GM:AddTrinket("Акробатический каркас", "acrobatframe", false, pveles, pweles, nil, "+8% к высоте прыжка."), SKILLMOD_JUMPPOWER_MUL, 0.08)

trinket = GM:AddTrinket("Очки ночного видения", "nightvision", true, pveles, pweles, 2, "-50% эффекта слепоты и способность видеть в темноте\n-40% длительности эффектов искажения зрения\n-45% к длительности испуга")
GM:AddSkillModifier(trinket, SKILLMOD_DIMVISION_EFF_MUL, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_FRIGHT_DURATION_MUL, -0.45)
GM:AddSkillModifier(trinket, SKILLMOD_VISION_ALTER_DURATION_MUL, -0.4)
GM:AddSkillFunction(trinket, function(pl, active)
    if CLIENT and pl == MySelf and GAMEMODE.m_NightVision and not active then
        surface.PlaySound("items/nvg_off.wav")
        GAMEMODE.m_NightVision = false
    end
end)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Портативный подсумок", "portablehole", false, pveles, pweles, nil, "+15% к скорости смены оружия\n+3% к скорости перезарядки")
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_RELOADSPEED_MUL, 0.03)

trinket = GM:AddTrinket("Увеличитель ловкости", "pathfinder", false, pveles, pweles, 2, "+40% к скорости перемещения сквозь баррикады\n-45% ко времени телепортации через Сигил\n+13% к высоте прыжка")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.4)
GM:AddSkillModifier(trinket, SKILLMOD_SIGIL_TELEPORT_MUL, -0.45)
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.13)

trinket = GM:AddTrinket("Имплант «Гальванизатор»", "analgestic", false, pveles, pweles, 3, "-50% замедления от низкого здоровья\n-50% уязвимости к эффектам замедления\n-50% времени нахождения в нокдауне\n-66% длительности притягивающих атак зомби\n+25% к скорости смены оружия")
GM:AddSkillModifier(trinket, SKILLMOD_SLOW_EFF_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_KNOCKDOWN_RECOVERY_MUL, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYSPEED_MUL, 0.25)

GM:AddSkillModifier(GM:AddTrinket("Патронный жилет", "ammovestii", false, ammoveles, ammoweles, 2, "+5% к скорости перезарядки"), SKILLMOD_RELOADSPEED_MUL, 0.05)
GM:AddSkillModifier(GM:AddTrinket("Патронный бандольер", "ammovestiii", false, ammoveles, ammoweles, 4, "+12% к速度 перезарядки"), SKILLMOD_RELOADSPEED_MUL, 0.12)

GM:AddTrinket("Автоматический перезарядчик", "autoreload", false, ammoveles, ammoweles, 2, "Автоматически перезаряжает убранное оружие через 4 секунды после переключения с него")

-- Offensive Implants
GM:AddSkillModifier(GM:AddTrinket("Прицельный визор", "targetingvisori", false, oveles, oweles, nil, "+5% к точности (сужению прицела)."), SKILLMOD_AIMSPREAD_MUL, -0.05)

GM:AddSkillModifier(GM:AddTrinket("Унификатор прицеливания", "targetingvisoriii", false, oveles, oweles, 4, "+11% к точности (сужению прицела)."), SKILLMOD_AIMSPREAD_MUL, -0.11)

GM:AddTrinket("Модифицированный прицел", "refinedsub", false, oveles, oweles, 4, "+27% к точности при стрельбе из оружия 3-го тира или ниже")

trinket = GM:AddTrinket("Компенсатор прицеливания", "aimcomp", false, oveles, oweles, 3, "-52% к тряске прицела от отдачи\n+5% к точности (сужению прицела)\nПоказывает индикатор здоровья над зомби, на которых вы смотрите")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.52)
GM:AddSkillFunction(trinket, function(pl, active) pl.TargetLocus = active end)

GM:AddSkillModifier(GM:AddTrinket("Импульсный бустер", "pulseampi", false, oveles, oweles, nil, "+14% к силе замедления от импульсного оружия и шоковых дубинок"), SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.14)

trinket = GM:AddTrinket("Импульсный инфузер", "pulseampii", false, oveles, oweles, 3, "+20% к силе замедления от импульсного оружия и шоковых дубинок\n+7% к радиусу взрывов")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.2)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.07)

trinket = GM:AddTrinket("Устройство каскадного резонанса", "resonance", false, oveles, oweles, 4, "Нанесение большого количества импульсного урона вызывает плазменный взрыв\n-25% к замедлению от импульсного оружия")
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, -0.25)

trinket = GM:AddTrinket("Криогенный индуктор", "cryoindu", false, oveles, oweles, 4, "Замораживающее оружие получает шанс мгновенно расколоть зомби в зависимости от остатка его здоровья")

trinket = GM:AddTrinket("Увеличенный магазин", "extendedmag", false, oveles, oweles, 3, "Увеличивает емкость магазина на +15% для оружия с базовой емкостью от 8 патронов и выше")

trinket = GM:AddTrinket("Модуль импульсного сопротивления", "pulseimpedance", false, oveles, oweles, 5, "Замедление от импульсного оружия и шоковых дубинок также снижает скорость атаки зомби\n+24% к силе импульсного замедления")
GM:AddSkillFunction(trinket, function(pl, active) pl.PulseImpedance = active end)
GM:AddSkillModifier(trinket, SKILLMOD_PULSE_WEAPON_SLOW_MUL, 0.24)

trinket = GM:AddTrinket("Тяжелые берцы «Подавитель»", "curbstompers", false, oveles, oweles, 2, "Мгновенно убивает хедкрабов и наносит 50 урона торсам, если приземлиться на них\nНаносит зомби 500% урона от вашего падения\nВы не получаете урон от падения, если приземляетесь на зомби\n-25% к замедлению при приземлении или падении")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.25)

GM:AddTrinket("Высшая инженерная сборка", "supasm", false, oveles, oweles, 5, "Бонусы к урону оружия от пересборки теперь также ускоряют перезарядку на оружии 2-го тира или ниже")

trinket = GM:AddTrinket("Олимпийский каркас", "olympianframe", false, oveles, oweles, 2, "+100% к силе броска предметов (пропов)\n-25% к замедлению при переноске предметов в руках\n-35% к штрафу скорости перемещения с тяжелым оружием")
GM:AddSkillModifier(trinket, SKILLMOD_PROP_THROW_STRENGTH_MUL, 1)
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.25)
GM:AddSkillModifier(trinket, SKILLMOD_WEAPON_WEIGHT_SLOW_MUL, -0.35)

-- Defensive Trinkets
trinket, trinketwep = GM:AddTrinket("Кевларовая подкладка", "kevlar", false, develes, deweles, 2, "-30% получаемого урона в ближнем бою\n-11% получаемого урона от снарядов")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.30)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.11)
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Шипованная броня", "barbedarmor", false, develes, deweles, 3, "100% полученного урона ближнего боя отражается обратно в нападающего\nДополнительно отражает 14 единиц урона нападающему\nНападающие в ближнем бою получают 14 урона по рукам\n-25% получаемого урона в ближнем бою")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT, 25)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_ATTACKER_DMG_REFLECT_PERCENT, 1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.25)

trinket = GM:AddTrinket("Антитоксичный пакет", "antitoxinpack", false, develes, deweles, 2, "-17% получаемого урона от яда\n-40% к скорости периодического урона от яда")
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.17)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_SPEED_MUL, -0.4)

trinket = GM:AddTrinket("Гемостатический имплант", "hemostasis", false, develes, deweles, 2, "-30% получаемого урона от кровотечения\n-60% к скорости кровотечения.")
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_DAMAGE_TAKEN_MUL, -0.3)
GM:AddSkillModifier(trinket, SKILLMOD_BLEED_SPEED_MUL, -0.6)

trinket = GM:AddTrinket("Костюм сапера (EOD)", "eodvest", false, develes, deweles, 4, "-35% получаемого урона от взрывов\n-50% получаемого урона от огня\n-5% получаемого урона по самому себе")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, -0.35)
GM:AddSkillModifier(trinket, SKILLMOD_FIRE_DAMAGE_TAKEN_MUL, -0.50)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.05)

trinket = GM:AddTrinket("Амортизирующий каркас", "featherfallframe", false, develes, deweles, 3, "-35% получаемого урона от падения\n+30% к порогу высоты безопасного падения\n-65% к замедлению при приземлении или падении")
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_DAMAGE_MUL, -0.35)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_THRESHOLD_MUL, 0.30)
GM:AddSkillModifier(trinket, SKILLMOD_FALLDAMAGE_SLOWDOWN_MUL, -0.65)

local eicev = {
    ["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.339, 2.697, -2.309), angle = Angle(4.558, -34.502, -72.395), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

local eicew = {
    ["base"] = { type = "Model", model = "models/gibs/glass_shard04.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.556, 2.519, -1.468), angle = Angle(0, -5.844, -75.974), size = Vector(0.5, 0.5, 0.5), color = Color(0, 137, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

GM:AddTrinket("Щит ледяного взрыва", "iceburst", false, eicev, eicew, nil, "Вызывает ледяной взрыв при получении удара ближнего боя, замедляя зомби\nПерезаряжается каждые 40 секунд")

GM:AddSkillModifier(GM:AddTrinket("Излучатель гасящего поля", "forcedamp", false, develes, deweles, 2, "-33% получаемого физического урона от предметов\nИммунитет к сбиванию с ног летящими предметами (пропами)\nПолучает обычный физический урон от Теней (Shade)."), SKILLMOD_PHYSICS_DAMAGE_TAKEN_MUL, -0.33)

GM:AddSkillFunction(GM:AddTrinket("Исказитель некротических чувств", "necrosense", false, develes, deweles, 2, "Скрывает вашу ауру от зомби, находящихся в непосредственной близости"), function(pl, active) pl:SetDTBool(DT_PLAYER_BOOL_NECRO, active) end)

trinket, trinketwep = GM:AddTrinket("Реактивная вспышка", "reactiveflasher", false, develes, deweles, 2, "Ослепляет и дезориентирует нападающего в ближнем бою зомби на 2 секунды\nПерезаряжается каждые 75 секунд")
trinketwep.PermitDismantle = true

trinket = GM:AddTrinket("Композитная подкладка", "composite", false, develes, deweles, 4, "-16% получаемого урона в ближнем бою\n-16% получаемого урона от снарядов")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.16)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_TAKEN_MUL, -0.16)

-- Support Trinkets
trinket, trinketwep = GM:AddTrinket("Мобильный арсенал", "arsenalpack", false, {
    ["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, {
    ["base"] = { type = "Model", model = "models/Items/item_item_crate.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, "Позволяет выжившим поблизости закупаться через меню арсенала.", "arsenalpack", 3)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Сумка снабжения", "resupplypack", true, nil, {
    ["base"] = { type = "Model", model = "models/Items/ammocrate_ar2.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, -1), angle = Angle(0, -90, 180), size = Vector(0.35, 0.35, 0.35), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
}, 4, "Позволяет выжившим пополнять патроны у вас\nНажмите ЛКМ со слингом в руке, чтобы пополнить патроны себе.", "resupplypack", 3)
trinketwep.PermitDismantle = true

GM:AddTrinket("Магнит", "magnet", true, supveles, supweles, nil, "Медленно притягивает к вам патроны и оружие\nДолжен быть экипирован, чтобы действовать", "magnet")
GM:AddTrinket("Электромагнит", "electromagnet", true, supveles, supweles, nil, "Быстро притягивает к вам патроны и оружие\nДолжен быть экипирован, чтобы действовать", "magnet_electro")

trinket, trinketwep = GM:AddTrinket("Погрузочный экзоскелет", "loadingex", false, supveles, supweles, 2, "-55% замедления при переноске предметов в руках\n-20% времени развертывания переносных сумок")
GM:AddSkillModifier(trinket, SKILLMOD_PROP_CARRY_SLOW_MUL, -0.55)
GM:AddSkillModifier(trinket, SKILLMOD_DEPLOYABLE_PACKTIME_MUL, -0.2)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Чертежи", "blueprintsi", false, supveles, supweles, 2, "+10% к скорости ремонта")
GM:AddSkillModifier(trinket, SKILLMOD_REPAIRRATE_MUL, 0.1)
trinketwep.PermitDismantle = true

GM:AddSkillModifier(GM:AddTrinket("Улучшенные чертежи", "blueprintsii", false, supveles, supweles, 4, "+20% к скорости ремонта"), SKILLMOD_REPAIRRATE_MUL, 0.2)

trinket, trinketwep = GM:AddTrinket("Медицинский процессор", "processor", false, supveles, supweles, 2, "-5% кулдауна аптечки\n-10% задержки выстрела мед. инструмента\nПерерабатывает еду в медицинские патроны по нажатию ПКМ")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.1)

trinket = GM:AddTrinket("Целебный набор", "curativeii", false, supveles, supweles, 3, "-10% кулдауна аптечки\n-20% задержки выстрела мед. инструмента")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_COOLDOWN_MUL, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MEDGUN_FIRE_DELAY_MUL, -0.2)

trinket = GM:AddTrinket("Исцеляющий бустер", "remedy", false, supveles, supweles, 3, "+8% к эффективности медицинских инструментов")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.08)

trinket = GM:AddTrinket("Комплект обслуживания", "mainsuite", false, supveles, supweles, 2, "+10% к радиусу поля глушилок и ремонта\n-7% к задержке поля глушилок и ремонта\n+10% к радиусу действия турелей")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.1)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.07)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.1)

trinket = GM:AddTrinket("Платформа управления", "controlplat", false, supveles, supweles, 2, "+15% к здоровью управляемой техники\n+15% к скорости управляемой техники\n+20% к урону маньяков (манхаков)")
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_HEALTH_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_CONTROLLABLE_SPEED_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_MANHACK_DAMAGE_MUL, 0.2)

trinket = GM:AddTrinket("Ускоритель снарядов", "projguide", false, supveles, supweles, 2, "+25% к скорости полета снарядов")
GM:AddSkillModifier(trinket, SKILLMOD_PROJ_SPEED, 0.25)

trinket = GM:AddTrinket("Утяжелитель снарядов", "projwei", false, supveles, supweles, 2, "-50% к скорости полета снарядов\n+5% к урону снарядов")
GM:AddSkillModifier(trinket, SKILLMOD_PROJ_SPEED, -0.5)
GM:AddSkillModifier(trinket, SKILLMOD_PROJECTILE_DAMAGE_MUL, 0.05)

local ectov = {
    ["base"] = { type = "Model", model = "models/props_junk/glassjug01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3.381, 2.617, 2.062), angle = Angle(180, 12.243, 0), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
    ["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 4.07), angle = Angle(180, 12.243, 0), size = Vector(0.123, 0.123, 0.085), color = Color(0, 0, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

local ectow = {
    ["base"] = { type = "Model", model = "models/props_junk/glassjug01.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(2.506, 1.82, 1.758), angle = Angle(-164.991, 19.691, 8.255), size = Vector(0.6, 0.6, 0.6), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} },
    ["base+"] = { type = "Model", model = "models/props_c17/oildrum001.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "base", pos = Vector(0, 0, 4.07), angle = Angle(180, 12.243, 0), size = Vector(0.123, 0.123, 0.085), color = Color(0, 0, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}

trinket = GM:AddTrinket("Активные химикаты", "reachem", false, ectov, ectow, 3, "+30% получаемого урона от взрывов\n+10% к радиусу взрывов")
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_TAKEN_MUL, 0.3)
GM:AddSkillModifier(trinket, SKILLMOD_EXP_DAMAGE_RADIUS, 0.1)

trinket = GM:AddTrinket("Матрица операций", "opsmatrix", false, supveles, supweles, 4, "+15% к радиусу поля глушилок и ремонта\n-13% к задержке поля глушилок и ремонта\n+15% к радиусу действия турелей")
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_RANGE_MUL, 0.15)
GM:AddSkillModifier(trinket, SKILLMOD_FIELD_DELAY_MUL, -0.13)
GM:AddSkillModifier(trinket, SKILLMOD_TURRET_RANGE_MUL, 0.15)

GM:AddSkillModifier(GM:AddTrinket("Манифест поставок", "acqmanifest", false, supveles, supweles, 2, "-6% времени ожидания пополнения патронов"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.06)
GM:AddSkillModifier(GM:AddTrinket("Манифест закупок", "promanifest", false, supveles, supweles, 4, "-9% времени ожидания пополнения патронов"), SKILLMOD_RESUPPLY_DELAY_MUL, -0.09)
-- Boss Trinkets

local blcorev = {
    ["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_Spine4", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = true},
    ["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Grenade_body", rel = "", pos = Vector(0, 0.5, -1.701), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(20, 20, 20, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} },
    ["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_Spine4", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = true}
}

local blcorew = {
    ["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = false},
    ["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(0, 0, 0, 255), nocull = false, additive = false, vertexalpha = true, vertexcolor = true, ignorez = false},
    ["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, 0), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(20, 20, 20, 255), surpresslightning = false, material = "models/shiny", skin = 0, bodygroup = {} }
}

GM:AddTrinket("Мрачная душа", "bleaksoul", false, blcorev, blcorew, nil, "Ослепляет и отбрасывает зомби назад, когда вас атакуют\nПерезаряжается каждые 35 секунд")

trinket = GM:AddTrinket("Эссенция духа", "spiritess", false, nil, {
    ["black_core_2"] = { type = "Sprite", sprite = "effects/splashwake3", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 7.697, y = 7.697 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
    ["black_core_2+"] = { type = "Sprite", sprite = "effects/splashwake1", bone = "ValveBiped.Bip01_R_Hand", rel = "black_core", pos = Vector(0, 0.1, -0.201), size = { x = 10, y = 10 }, color = Color(255, 255, 255, 255), nocull = false, additive = true, vertexalpha = true, vertexcolor = true, ignorez = false},
    ["black_core"] = { type = "Model", model = "models/dav0r/hoverball.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(4, 2, 0), angle = Angle(0, 0, 0), size = Vector(0.349, 0.349, 0.349), color = Color(255, 255, 255, 255), surpresslightning = true, material = "models/shiny", skin = 0, bodygroup = {} }
}, nil, "+13% к высоте прыжка.")
GM:AddSkillModifier(trinket, SKILLMOD_JUMPPOWER_MUL, 0.13)
-- Starter Trinkets

trinket, trinketwep = GM:AddTrinket("Нарукавная повязка", "armband", false, mveles, mweles, nil, "-10% задержки взмаха ближнего боя\n-6% получаемого урона в ближнем бою")
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_SWING_DELAY_MUL, -0.1)
GM:AddSkillModifier(trinket, SKILLMOD_MELEE_DAMAGE_TAKEN_MUL, -0.06)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Приправы", "condiments", false, supveles, supweles, nil, "+20% к восстановлению от еды\n-20% времени на употребление еды")
GM:AddSkillModifier(trinket, SKILLMOD_FOODRECOVERY_MUL, 0.20)
GM:AddSkillModifier(trinket, SKILLMOD_FOODEATTIME_MUL, -0.20)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Учебник по побегу", "emanual", false, develes, deweles, nil, "+20% к скорости перемещения сквозь баррикады\n-12% интенсивности замедления от низкого здоровья")
GM:AddSkillModifier(trinket, SKILLMOD_BARRICADE_PHASE_SPEED_MUL, 0.20)
GM:AddSkillModifier(trinket, SKILLMOD_LOW_HEALTH_SLOW_MUL, -0.12)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Помощник прицеливания", "aimaid", false, develes, deweles, nil, "+5% к точности (сужению прицела)\n-7% к тряске прицела от отдачи")
GM:AddSkillModifier(trinket, SKILLMOD_AIMSPREAD_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_AIM_SHAKE_MUL, -0.06)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Капсулы с витаминами", "vitamins", false, hpveles, hpweles, nil, "+5 к максимальному здоровью\n-12% получаемого урона от яда")
GM:AddSkillModifier(trinket, SKILLMOD_HEALTH, 5)
GM:AddSkillModifier(trinket, SKILLMOD_POISON_DAMAGE_TAKEN_MUL, -0.12)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Социальный щит", "welfare", false, hpveles, hpweles, nil, "-5% ко времени ожидания пополнения патронов\n-7% получаемого урона по самому себе")
GM:AddSkillModifier(trinket, SKILLMOD_RESUPPLY_DELAY_MUL, -0.05)
GM:AddSkillModifier(trinket, SKILLMOD_SELF_DAMAGE_MUL, -0.07)
trinketwep.PermitDismantle = true

trinket, trinketwep = GM:AddTrinket("Набор химика", "chemistry", false, hpveles, hpweles, nil, "+6% к эффективности медицинских инструментов\n+12% к времени действия дымовых бомб")
GM:AddSkillModifier(trinket, SKILLMOD_MEDKIT_EFFECTIVENESS_MUL, 0.06)
GM:AddSkillModifier(trinket, SKILLMOD_CLOUD_TIME, 0.12)
trinketwep.PermitDismantle = true