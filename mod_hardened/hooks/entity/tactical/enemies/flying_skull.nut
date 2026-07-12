::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/flying_skull", function(q) {
	q.onInit = @(__original) { function onInit()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/special/hd_unworthy_effect"));
	}}.onInit;
});
