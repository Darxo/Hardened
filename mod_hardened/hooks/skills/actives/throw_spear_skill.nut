::Hardened.HooksMod.hook("scripts/skills/actives/throw_spear_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.MinRange = 1;	// In Vanilla this is 2
		this.m.AdditionalAccuracy -= this.m.AdditionalHitChance;	// As a result of reducing the minimum range the "this.m.AdditionalHitChance" kicks in one tile earlier. We fix that issue with this line

	// Reforged Values
		this.m.FatigueDamage = 0;	// In Reforged this is 40
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;	// We must be the user

		local targetShield = _target.getOffhandItem();	// The skill must be targeting a shield user
		if (targetShield == null) return ret;
		if (!targetShield.isItemType(::Const.Items.ItemType.Shield)) return ret;

		if (::MSU.isNull(this.getItem())) return ret;

		ret *= 1.2;		// We slightly prefer targetting enemies with shields over those without shield

		local expectedShieldDamage = this.getItem().getShieldDamage() * this.getExpectedShieldDamageMult(_target);
		if (expectedShieldDamage > targetShield.getCondition())
		{
			ret *= 1.5;		// We strongly prefer targetting shields, that will die instantly, over those, which survive the impact
		}

		return ret;
	}
});
