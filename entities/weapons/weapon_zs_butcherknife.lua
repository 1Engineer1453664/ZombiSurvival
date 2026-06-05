AddCSLuaFile()

SWEP.PrintName = "Нож Мясника"
SWEP.Description = "Мясницкий нож с очень высокой скоростью взмаха, способный быстро искромсать зомби в щепки на ближней дистанции."

-- ================= НАСТРОЙКИ УНИВЕРСАЛЬНОЙ УЛЬТЫ =================
SWEP.IsUltimateWeapon = true                   -- Включает систему шкалы
SWEP.UltimateType = "ULT_TYPE_DAMAGE"
SWEP.UltimateName = "Ярость мясника"          -- Появится КРУПНЫМИ БУКВАМИ над шкалой
SWEP.UltimateReadyText = "НАЖМИТЕ [R]"         -- Эта надпись появится внутри полоски при 100%
SWEP.MaxUltimateDamage = 440                   -- Сколько урона копить

if CLIENT then
    SWEP.ViewModelFOV = 55
    SWEP.ViewModelFlip = false

    SWEP.ShowViewModel = false
    SWEP.ShowWorldModel = false
    SWEP.VElements = {
        ["base"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -1), angle = Angle(90, 0, 0), size = Vector(0.8, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }
    SWEP.WElements = {
        ["base"] = { type = "Model", model = "models/props_lab/cleaver.mdl", bone = "ValveBiped.Bip01_R_Hand", rel = "", pos = Vector(3, 1, -3.182), angle = Angle(90, 0, 0), size = Vector(0.8, 1, 1), color = Color(255, 255, 255, 255), surpresslightning = false, material = "", skin = 0, bodygroup = {} }
    }
end

SWEP.Base = "weapon_zs_basemelee"
SWEP.DamageType = DMG_SLASH

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true
SWEP.NoDroppedWorldModel = true

SWEP.MeleeDamage = 50
SWEP.MeleeRange = 60
SWEP.MeleeSize = 0.875
SWEP.Primary.Delay = 0.4

SWEP.WalkSpeed = SPEED_FAST
SWEP.UseMelee1 = true

SWEP.HitGesture = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
SWEP.MissGesture = SWEP.HitGesture

SWEP.HitDecal = "Manhackcut"
SWEP.HitAnim = ACT_VM_MISSCENTER

SWEP.Tier = 2
SWEP.AllowQualityWeapons = true
SWEP.Culinary = true

GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_FIRE_DELAY, -0.06)

-- ================= СИСТЕМА НАКОПЛЕНИЯ И АКТИВАЦИИ УЛЬТЫ (ИСПРАВЛЕННАЯ) =================

-- Убираем хардкод фиксированных значений урона/скорости.
-- Вместо этого создаем пустые переменные, куда запишем текущие статы в момент прожатия кнопки R.
SWEP.SavedMeleeDamage = nil
SWEP.SavedPrimaryDelay = nil

-- Инициализируем сетевые переменные
function SWEP:SetupDataTables()
    if self.BaseClass.SetupDataTables then self.BaseClass.SetupDataTables(self) end
    
    self:NetworkVar("Float", 30, "UltDamage")  -- Храним нанесенный урон
    self:NetworkVar("Float", 31, "UltEndTime") -- Время окончания баффа
end

-- Функция для интерфейса
function SWEP:GetUltimateCharge()
    return self:GetUltDamage() / self.MaxUltimateDamage
end

-- Проверяем, активна ли сейчас ульта
function SWEP:IsUltActive()
    return CurTime() < self:GetUltEndTime()
end

-- Постоянная проверка состояния (внутренний таймер)
function SWEP:Think()
    if self.BaseClass.Think then self.BaseClass.Think(self) end

    -- Если ульта активна, жестко выставляем баффнутые значения
    if self:IsUltActive() then
        -- Накладываем бафф только если мы уже сохранили исходные статы оружия
        if self.SavedMeleeDamage and self.SavedPrimaryDelay then
            self.MeleeDamage = self.SavedMeleeDamage * 1.5   -- +50% к текущему урону
            self.Primary.Delay = self.SavedPrimaryDelay * 0.5 -- +50% к текущей скорости
        end
    else
        -- Если ульта закончилась, возвращаем именно те настройки ножа, которые были до её активации
        if self.SavedMeleeDamage and self.SavedPrimaryDelay then
            self.MeleeDamage = self.SavedMeleeDamage
            self.Primary.Delay = self.SavedPrimaryDelay
            
            -- Очищаем память, чтобы быть готовым к следующему циклу накопления
            self.SavedMeleeDamage = nil
            self.SavedPrimaryDelay = nil
        end
    end
end

-- Нажатие на кнопку перезарядки (R) активирует Кровавую ярость
function SWEP:Reload()
    -- Проверяем заряд и что ульта ЕЩЕ не активна
    if self:GetUltimateCharge() >= 1 and not self:IsUltActive() then
        if SERVER then
            -- [ВАЖНО]: Прямо в секунду активации смотрим на нынешний урон оружия (со всеми улучшениями) и запоминаем его!
            self.SavedMeleeDamage = self.MeleeDamage
            self.SavedPrimaryDelay = self.Primary.Delay

            self:SetUltEndTime(CurTime() + 10) -- Ярость длится 10 секунд
            self:SetUltDamage(0) -- Сбрасываем шкалу обратно в 0
            
            -- Звук активации
            self:GetOwner():EmitSound("npc/zombie/zombie_alert1.wav", 80, 110)
        end
    end
end

-- Накапливаем заряд при ударе по зомби
function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
    if SERVER and hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD then
        -- Заряд копится только если ульта СЕЙЧАС НЕ горит
        if not self:IsUltActive() then
            -- Берем урон из текущего значения MeleeDamage (оно не перезаписывается во время накопления)
            local dmg_to_add = self.MeleeDamage or 50
            local current = self:GetUltDamage()
            
            self:SetUltDamage(math.min(self.MaxUltimateDamage, current + dmg_to_add))
        end
    end
end
-- =========================================================================
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "Нож Кляки",
"Модификация. Способность копится со временем, а не от ударов.",
function(wept)

    -- Меняем имя ульты для HUD
    wept.UltimateName    = "Тяжелый Раж"
    wept.UltimateReadyText = "РАЖ ГОТОВ [R]"
    wept.UltimateCooldown  = 6   -- секунд зарядки
    wept.UltimateDuration  = 6   -- секунд действия

    -- Слот 30 (UltDamage) переиспользуем как прогресс 0..1
   
    wept.GetUltimateCharge = function(self)
        return self:GetUltDamage()   -- теперь хранит 0..1 вместо урона
    end

    -- Think: зарядка по времени + управление статами
    wept.Think = function(self)
        if self.BaseClass.Think then self.BaseClass.Think(self) end

        -- Зарядка (только сервер, только когда нож в руках)
        if SERVER then
            if self:IsUltActive() then
                self:SetUltDamage(0)  -- блокируем шкалу на 0 во время ража
            elseif self:GetUltDamage() < 1 then
                self:SetUltDamage(math.Clamp(
                    self:GetUltDamage() + FrameTime() / self.UltimateCooldown,
                    0, 1
                ))
            end
        end

        -- Управление статами при ульте
        if self:IsUltActive() then
            if not self.SavedMeleeDamage then
                self.SavedMeleeDamage  = self.MeleeDamage
                self.SavedPrimaryDelay = self.Primary.Delay
                self.MeleeDamage    = self.SavedMeleeDamage  * 2.0
                self.Primary.Delay  = self.SavedPrimaryDelay * 1.5
            end
        else
            if self.SavedMeleeDamage then
                self.MeleeDamage    = self.SavedMeleeDamage
                self.Primary.Delay  = self.SavedPrimaryDelay
                self.SavedMeleeDamage  = nil
                self.SavedPrimaryDelay = nil
            end
        end
    end

    -- Отключаем накопление от ударов — у Кляки зарядка только по времени
    wept.PostOnMeleeHit = function(self, hitent, hitflesh, tr) end

    -- Своя активация под новую логику заряда
    wept.Reload = function(self)
        if self:GetUltimateCharge() >= 1 and not self:IsUltActive() then
            if SERVER then
                self:SetUltEndTime(CurTime() + self.UltimateDuration)
                self:SetUltDamage(0)
                self:GetOwner():EmitSound("ambient/machines/thumper_top.wav", 80, 90)
            end
        end
    end

    -- Кастомные звуки Кляки
    wept.PlaySwingSound = function(self)
        self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav", 72, math.Rand(85, 95))
    end
    wept.PlayHitFleshSound = function(self)
        self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav")
        self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
    end
end)



--звук
function SWEP:PlaySwingSound()
    self:EmitSound("weapons/knife/knife_slash"..math.random(2)..".wav", 72, math.Rand(85, 95))
end

function SWEP:PlayHitSound()
    self:EmitSound("weapons/knife/knife_hitwall1.wav", 72, math.Rand(75, 85))
end

function SWEP:PlayHitFleshSound()
    self:EmitSound("physics/flesh/flesh_squishy_impact_hard"..math.random(4)..".wav")
    self:EmitSound("physics/body/body_medium_break"..math.random(2, 4)..".wav")
end