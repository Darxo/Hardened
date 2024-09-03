::Hardened.HooksMod.hook("scripts/items/shields/ancient/coffin_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -12;
		this.m.ConditionMax = 20;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Skeleton Medium (Legionary)

Reforged
	Skeleton Medium (Legionary)
	Skeleton Light Elite (Miles)
*/
