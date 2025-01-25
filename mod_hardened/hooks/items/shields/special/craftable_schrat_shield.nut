::Hardened.HooksMod.hook("scripts/items/shields/special/craftable_schrat_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 17;
		this.m.StaminaModifier = -12;
		this.m.ConditionMax = 40;

	// Hardened Adjustments
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);	// Remove tooltip line about spawning saplings
				break;
			}
		}

		return ret;
	}

	// Overwrite, because we remove the effect which spawns saplings
	q.onShieldHit = @() function( _attacker, _skill ) {}
});
