::Hardened.HooksMod.hook("scripts/skills/actives/deathblow_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.FatigueCost = 15;		// Vanilla: 10
	}
});
