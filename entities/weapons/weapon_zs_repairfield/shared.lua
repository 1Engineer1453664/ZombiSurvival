SWEP.PrintName = "'Ремонтное поле"
SWEP.Description = "Ремонтное поле, которое медленно чинит все пропы в радиусе своего действия энергетическим импульсом. Расходует импульсные патроны.\nНажмите левую кнопкуц мыши , чтобы развернуть ремонтное поле.\nНажмите правую кнопку мыши и нажмите перезарядку, чтобы повернуть ремонтное поле."

SWEP.ViewModel = "models/weapons/v_pistol.mdl"
SWEP.WorldModel = Model("models/props/de_nuke/smokestack01.mdl")

SWEP.AmmoIfHas = true

SWEP.Primary.ClipSize = 1
SWEP.Primary.DefaultClip = 1
SWEP.Primary.Ammo = "repairfield"
SWEP.Primary.Delay = 1
SWEP.Primary.Automatic = true

SWEP.Secondary.ClipSize = 1
SWEP.Secondary.DefaultClip = 1
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = "dummy"

SWEP.ModelScale = 0.40

SWEP.MaxStock = 5

SWEP.Repair = 10
SWEP.MaxDistance = 120

SWEP.WalkSpeed = SPEED_NORMAL
SWEP.FullWalkSpeed = SPEED_SLOWEST

SWEP.ResupplyAmmoType = "pulse"

SWEP.GhostStatus = "ghost_repairfield"
SWEP.DeployClass = "prop_repairfield"

SWEP.NoDeploySpeedChange = true
SWEP.AllowQualityWeapons = true

GAMEMODE:SetPrimaryWeaponModifier(SWEP, WEAPON_MODIFIER_REPAIR, 2)
GAMEMODE:AttachWeaponModifier(SWEP, WEAPON_MODIFIER_MAX_DISTANCE, 10)

function SWEP:Initialize()
	self:SetWeaponHoldType("slam")
	self:SetDeploySpeed(1.1)
	self:HideViewAndWorldModel()
end

function SWEP:SetReplicatedAmmo(count)
	self:SetDTInt(0, count)
end

function SWEP:GetReplicatedAmmo()
	return self:GetDTInt(0)
end

function SWEP:GetWalkSpeed()
	if self:GetPrimaryAmmoCount() > 0 then
		return self.FullWalkSpeed
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Reload()
end

function SWEP:CanPrimaryAttack()
	if self:GetOwner():IsHolding() or self:GetOwner():GetBarricadeGhosting() then return false end

	if self:GetPrimaryAmmoCount() <= 0 then
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		return false
	end

	return true
end

function SWEP:Holster()
	return true
end
