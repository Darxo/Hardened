::Hardened.HooksMod.hook("scripts/entity/tactical/goblin", function(q) {
	q.onInit = @(__original) function()
	{
		__original();
		this.m.Skills.add(::new("scripts/skills/racial/hd_goblin_racial"));
	}
});
