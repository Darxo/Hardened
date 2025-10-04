::Hardened.HooksMod.hook("scripts/skills/actives/drums_of_war_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.FatigueCost = 30;	// Vanilla: 15
	}
});
