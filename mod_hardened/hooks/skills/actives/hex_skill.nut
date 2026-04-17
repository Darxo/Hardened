::Hardened.HooksMod.hook("scripts/skills/actives/hex_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueCost = 20;	// Vanilla: 5
	}
});
