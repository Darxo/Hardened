::Hardened.HooksMod.hook("scripts/skills/actives/raise_undead", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueCost = 15;	// This nerf is a result of double grip reducing the cost of non-attacks
	}
});
