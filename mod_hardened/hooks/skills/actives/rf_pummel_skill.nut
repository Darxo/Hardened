::Hardened.HooksMod.hook("scripts/skills/actives/rf_pummel_skill", function(q) {
	// Public
	q.m.OneHandedActionPointCost <- 4;

	q.create = @(__original) function()
	{
		__original();

		this.m.IsAttack = true;		// This skill inherits from line_breaker, which we made into a non-attack. Since this skill is now an actual attack, we need to re-enable it
	}

	q.onAdded = @(__original) function()
	{
		__original();

		if (!::MSU.isNull(this.getItem()) && this.getItem().isItemType(::Const.Items.ItemType.OneHanded))
		{
			this.setBaseValue("ActionPointCost", this.m.OneHandedActionPointCost);
		}
	}
});
