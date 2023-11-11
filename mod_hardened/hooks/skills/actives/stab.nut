::Hardened.HooksMod.hook("scripts/skills/actives/stab", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost = 3;
	}
});
