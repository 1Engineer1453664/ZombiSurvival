AddCSLuaFile()

SWEP.PrintName = "Монтировка"
SWEP.Description = "Эффективное холодное оружие с высокой скоростью взмаха. Монтировка также способна мгновенно убивать хедкрабов."

if CLIENT then
    SWEP.ViewModelFOV = 65
end

SWEP.Base = "weapon_zs_basemelee"

SWEP.ViewModel = "models/weapons/c_crowbar.mdl"
SWEP.WorldModel = "models/weapons/w_crowbar.mdl"
SWEP.UseHands = true

SWEP.HoldType = "melee"

SWEP.DamageType = DMG_CLUB

SWEP.MeleeDamage = 60
SWEP.OriginalMeleeDamage = SWEP.MeleeDamage
SWEP.MeleeRange = 70
SWEP.MeleeSize = 1.5
SWEP.MeleeKnockBack = 110

SWEP.Primary.Delay = 0.7

SWEP.SwingTime = 0.4
SWEP.SwingRotation = Angle(30, -30, -30)
SWEP.SwingHoldType = "grenade"

SWEP.AllowQualityWeapons = true

-- Базовый рабочий апгрейд
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MELEE_RANGE, 3)

-- =========================================================================
-- ВТОРАЯ ВЕТКА ПРОКАЧКИ (REMANTLE BRANCH)
-- =========================================================================
GAMEMODE:AddNewRemantleBranch(SWEP, 1, "Монтировка выжившего", "Увеличивает скорость ударов.\nУдары восстанавливают здоровье (10% от урона).\nУбийства зомби дают +5% к защите (эффект суммируется до 40%).", function(wept)
    wept.Primary.Delay = wept.Primary.Delay * 0.75 -- Высокая скорость атаки

    -- 1. ЛОГИКА ВАМПИРИЗМА (При каждом ударе, урон берется динамически)
    wept.PostOnMeleeHit = function(self, hitent, hitflesh, tr)
        local owner = self:GetOwner()
        
        if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and gamemode.Call("PlayerShouldTakeDamage", hitent, owner) then
            local current_damage = self.MeleeDamage
            local heal_amount = math.Round(current_damage * 0.10) -- 10% от текущего урона

            if heal_amount > 0 then
                local current_hp = owner:Health()
                local max_hp = owner:GetMaxHealth()
                
                owner:SetHealth(math.min(max_hp, current_hp + heal_amount))
                
                if SERVER then
                    owner:EmitSound("items/medshot4.wav", 55, 125)
                end
            end
        end
    end

end)
-- =========================================================================
-- БАЗОВЫЕ ФУНКЦИИ И ЗВУКИ
-- =========================================================================
function SWEP:PlaySwingSound()
    self:EmitSound("Weapon_Crowbar.Single")
end

function SWEP:PlayHitSound()
    self:EmitSound("Weapon_Crowbar.Melee_HitWorld")
end

function SWEP:PlayHitFleshSound()
    self:EmitSound("Weapon_Crowbar.Melee_Hit")
end

function SWEP:PostOnMeleeHit(hitent, hitflesh, tr)
    if hitent:IsValid() and hitent:IsPlayer() and hitent:Team() == TEAM_UNDEAD and hitent:IsHeadcrab() and gamemode.Call("PlayerShouldTakeDamage", hitent, self:GetOwner()) then
        hitent:TakeSpecialDamage(hitent:Health(), DMG_DIRECT, self:GetOwner(), self, tr.HitPos)
    end
end