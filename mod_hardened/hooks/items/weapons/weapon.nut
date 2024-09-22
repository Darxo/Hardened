::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	q.lowerCondition = @(__original) function(_value = ::Const.Combat.WeaponDurabilityLossOnHit)
	{
		// In vanilla it is assumed that this weapon is already equipped to someone when this function is called
		local scaledValue = _value * this.getContainer().getActor().getCurrentProperties().WeaponDurabilityLossMult;
		__original(scaledValue);
	}

// New Function
	q.isHybridWeapon <- function()
	{
		return ((this.m.WeaponType & (this.m.WeaponType - 1)) != 0);
	}
});
