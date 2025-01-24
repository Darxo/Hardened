::Hardened.HooksMod.hook("scripts/skills/actives/throw_spear_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.MinRange = 1;	// In Vanilla this is 2
		this.m.AdditionalAccuracy -= this.m.AdditionalHitChance;	// As a result of reducing the minimum range the "this.m.AdditionalHitChance" kicks in one tile earlier. We fix that issue with this line

	// Reforged Values
		this.m.FatigueDamage = 0;	// In Reforged this is 40
	}
});
