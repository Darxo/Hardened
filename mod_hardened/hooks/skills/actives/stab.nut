::Hardened.HooksMod.hook("scripts/skills/actives/stab", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 3;
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		// Add an action point to counter act the discount that is given out by modular_vanilla mod
		if (_properties.IsSpecializedInDaggers)
		{
			if (this.m.ActionPointCost > 0)
			{
				this.m.ActionPointCost += 1;
			}
		}

		__original(_properties);
	}
});
