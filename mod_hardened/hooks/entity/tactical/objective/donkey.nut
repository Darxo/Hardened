::Hardened.HooksMod.hook("scripts/entity/tactical/objective/donkey", function(q) {
// Reforged Functions
	q.onInit = @(__original) function()
	{
		__original();
		local b = this.m.BaseProperties;
		b.IsImmuneToRoot = false;
		b.IsImmuneToBleeding = false;	// Vanilla: true
		b.IsImmuneToPoison = false;		// Vanilla: true
		b.IsAffectedByInjuries = true;	// Vanilla: false
	}
});
