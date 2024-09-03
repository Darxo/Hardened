::Hardened.HooksMod.hook("scripts/items/shields/ancient/tower_shield", function(q) {
	q.create = @(__original) function()
	{
		__original();
		recordReforgedCondition();

	// Vanilla Stats
		this.m.MeleeDefense = 20;
		this.m.RangedDefense = 20;
		this.m.StaminaModifier = -20;
		this.m.ConditionMax = 24;

	// Hardened Adjustments
	}
});

/*
Vanilla
	Skeleton Boss
	Skeleton Heavy Bodyguard (Honor Guard)
	Skeleton Heavy (Honor Guard)
	Skeleton Medium (Legionary)

Reforged
	Decanus
	Heavy Lesser (Praetorian)
	Medium Elite (Palatinus)
	Skeleton Medium (Legionary)
	Skeleton Heavy (Honor Guard)
*/
