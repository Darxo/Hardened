::Hardened.HooksMod.hook("scripts/skills/actives/throw_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueCost = 15;	// In Vanilla this is 15; In Reforged this is 10
		this.m.MinRange = 1;	// In Vanilla this is 2
		this.m.AdditionalAccuracy -= this.m.AdditionalHitChance;	// As a result of reducing the minimum range the "this.m.AdditionalHitChance" kicks in one tile earlier. We fix that issue with this line
		this.m.ChanceDecapitate = 50;
		this.m.ChanceDisembowel = 25;
	}
});
