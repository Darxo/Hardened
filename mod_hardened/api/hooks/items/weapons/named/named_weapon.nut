::Hardened.HooksMod.hook("scripts/items/weapons/named/named_weapon", function(q) {
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
