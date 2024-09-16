::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/schrat_small", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.steel_brow");
		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
	}
});
