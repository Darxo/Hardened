::Hardened.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
	// Public
	q.m.HD_BaseItemValueMult <- 2.0;		// Base value for named items is this much compared to their base item
	q.m.HD_ConditionMultMin <- 0.9;
	q.m.HD_ConditionMultMax <- 1.4;

	q.randomizeValues = @(__original) function()
	{
		local oldCondition = this.m.Condition;
		__original();

		if (this.m.ConditionMax > 1)	// Same condition as Vanilla
		{
			// Feat: we make the minimum and maximum possible condition multiplier moddable and change the minimum value
			this.m.Condition = ::Math.round(oldCondition * ::MSU.Math.randf(this.m.HD_ConditionMultMin, this.m.HD_ConditionMultMax)) * 1.0;
			this.m.ConditionMax = this.m.Condition;
		}

	}
});

::Hardened.HooksMod.hookTree("scripts/items/weapons/named/named_weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Feat: Generate value for named items dynamically depending on the value if their base item
		// In Vanilla this is done in a hard-coded way but the rule of thumb they use is that value is always doubled
		// We need to do that as hookTree, because usually the base script is only set after the base class create() has long run through
		//	and we also want to catch modded base item scripts
		if (this.m.BaseItemScript != null)
		{
			local baseItem = ::new(this.m.BaseItemScript);
			this.m.Value = baseItem.m.Value * this.m.HD_BaseItemValueMult;
		}
	}
});
