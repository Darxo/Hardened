::Hardened.HooksMod.hook("scripts/skills/actives/web_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.FatigueCost = 50;	// Vanilla: 25
	}
});
