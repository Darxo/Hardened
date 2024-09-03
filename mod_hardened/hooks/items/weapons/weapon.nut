::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	q.lowerCondition = @(__original) function(_value = ::Const.Combat.WeaponDurabilityLossOnHit)
	{
		// In vanilla it is assumed that this weapon is already equipped to someone when this function is called
		local scaledValue = _value * this.getContainer().getActor().getCurrentProperties().WeaponDurabilityLossMult;
		__original(scaledValue);
	}

	// Shiel Damage can now optionally be retrieved scaled
	q.getShieldDamage = @(__original) function( _skill = null, _targetEntity = null )
	{
		local ret = __original();

		if (_skill != null && _targetEntity != null && this.getContainer() != null && this.getContainer().getActor() != null)
		{
			local properties = this.getContainer().getActor().getSkills().buildPropertiesForUse(_skill, _targetEntity);
			ret *= properties.ShieldDamageMult;
		}

		return ret;
	}
});
