::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/sand_golem", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.bullseye");
		this.getSkills().removeByID("perk.steel_brow");
		this.getSkills().add(::new("scripts/skills/effects/hd_headless_effect"));
	}
});
