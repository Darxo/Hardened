::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/lindwurm_tail", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		// This just causes issues currently, because their properties are so closely coupled
		// this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
	}
});
