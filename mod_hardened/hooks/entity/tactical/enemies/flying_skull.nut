::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/flying_skull", function(q) {
	q.onInit = @(__original) { function onInit()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/special/hd_unworthy_effect"));
		this.getSkills().add(::new("scripts/skills/effects/hd_explosive_effect"));
		this.getSkills().add(::new("scripts/skills/racial/skeleton_racial"));
	}}.onInit;

	// Overwrite, because we disable the native explosion triggered by vanilla. Instead we handle that with a new hd_explosive_effect
	q.onDeath = @() { function onDeath( _killer, _skill, _tile, _fatalityType )
	{
	}}.onDeath;
});
