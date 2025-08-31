::Hardened.HooksMod.hook("scripts/skills/actives/hyena_bite_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.FatigueCost = 10;	// Vanilla: 6
	}
});
