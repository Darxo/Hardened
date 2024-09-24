::Hardened.HooksMod.hook("scripts/skills/actives/rf_sprint_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 1;
	}
});
