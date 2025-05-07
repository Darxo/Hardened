::Hardened.HooksMod.hook("scripts/skills/actives/rf_lash_pole_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ActionPointCost = 6;	// In Reforged this is 5
	}
});
