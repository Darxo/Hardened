::Hardened.HooksMod.hook("scripts/skills/actives/flesh_pull_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We turn off attack flag to make this skill produce a combat log on-use
		this.m.IsAttack = false;
	}
});
