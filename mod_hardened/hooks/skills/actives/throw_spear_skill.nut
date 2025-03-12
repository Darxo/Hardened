::Hardened.HooksMod.hook("scripts/skills/actives/throw_spear_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.MinRange = 1;	// In Vanilla this is 2
		this.m.AdditionalAccuracy -= this.m.AdditionalHitChance;	// As a result of reducing the minimum range the "this.m.AdditionalHitChance" kicks in one tile earlier. We fix that issue with this line

	// Reforged Values
		this.m.FatigueDamage = 0;	// In Reforged this is 40
	}

// Hardened Functions
	q.getQueryTargetMultAsUser = @(__original) function( _target, _usedSkill = null )
	{
		local ret = __original(_target, _usedSkill);

		local targetShield = _target.getOffhandItem();
		if (targetShield == null) return ret;
		if (!targetShield.isItemType(::Const.Items.ItemType.Shield)) return ret;

		if (::MSU.isNull(this.getItem())) return ret;
		local expectedShieldDamage = this.getItem().getShieldDamage() * this.getExpectedShieldDamageMult(_target);

		ret *= 1.2;		// We slightly prefer targetting enemies with shields over those without shield

		if (expectedShieldDamage > targetShield.getCondition())
		{
			ret *= 1.5;		// We strongly prefer targetting shields, that will die instantly, over those, which survive the impact
		}

		return ret;
	}
});
