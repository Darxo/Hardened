::Hardened.HooksMod.hook("scripts/entity/tactical/humans/mercenary_ranged", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();

		// The Perk "Through the Ranks" has been hijacked into another perk, so we replace it on enemies with a new similar effect
		this.getSkills().removeByID("perk.rf_through_the_ranks");
		this.getSkills().add(::new("scripts/skills/effects/hd_through_the_ranks"));
	}
});
