::Hardened.HooksMod.hook("scripts/skills/actives/break_ally_free_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ActionPointCost = 3;		// Vanilla: 4
	}
});
