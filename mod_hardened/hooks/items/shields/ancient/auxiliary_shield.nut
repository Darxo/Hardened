::Hardened.HooksMod.hook("scripts/items/shields/ancient/auxiliary_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 15;
		this.m.RangedDefense = 15;
		this.m.StaminaModifier = -10;
		this.m.ConditionMax = 16;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Skeleton Light (Auxiliary)

Reforged
	Skeleton Light (Auxiliary)
	Skeleton Light Elite (Miles)
*/
