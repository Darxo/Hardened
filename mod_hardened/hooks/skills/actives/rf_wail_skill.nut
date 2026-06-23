::Hardened.HooksMod.hook("scripts/skills/actives/rf_wail_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ActionPointCost = 5;		// Reforged: 6
	}
});
