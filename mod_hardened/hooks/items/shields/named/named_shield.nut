::Hardened.HooksMod.hook("scripts/items/shields/named/named_shield", function(q) {
	// Overwrite, because we re-enable the ability to roll condition for named shields (removed by Reforged)
	q.randomizeValues = @() function()
	{
		if (this.m.BaseItemScript != null)
		{
			// In Hardened the vanilla shields no longer all have the same two skills. This way all named variants will mirror their base version
			// This adjustment even works after loading, because randomizeValues is always called for named items, just that its result is usually overwritten during deserialize
			this.onEquip = ::new(this.m.BaseItemScript).onEquip;
		}

		// This is an exact copy of Vanillas implementation of randomizeValues
		local available = [];
		available.push(function ( _i )
		{
			_i.m.MeleeDefense = ::Math.round(_i.m.MeleeDefense * ::Math.rand(120, 140) * 0.01);
		});
		available.push(function ( _i )
		{
			_i.m.RangedDefense = ::Math.round(_i.m.RangedDefense * ::Math.rand(120, 140) * 0.01);
		});
		available.push(function ( _i )
		{
			_i.m.FatigueOnSkillUse = _i.m.FatigueOnSkillUse - ::Math.rand(1, 3);
		});
		available.push(function ( _i )
		{
			_i.m.Condition = ::Math.round(_i.m.Condition * ::Math.rand(120, 160) * 0.01) * 1.0;
			_i.m.ConditionMax = _i.m.Condition;
		});
		available.push(function ( _i )
		{
			_i.m.StaminaModifier = ::Math.round(_i.m.StaminaModifier * ::Math.rand(70, 90) * 0.01);
		});

		for( local n = 2; n != 0 && available.len() != 0; n = --n )
		{
			local r = ::Math.rand(0, available.len() - 1);
			available[r](this);
			available.remove(r);
		}
	}
});
