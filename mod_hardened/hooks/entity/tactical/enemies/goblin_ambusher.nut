::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_ambusher", function(q) {
	q.makeMiniboss = @(__original) function()
	{
		local ret = __original();

		if (ret)
		{
			this.m.Skills.removeByID("perk.rf_target_practice");
			this.getSkills().add(::new("scripts/skills/perks/perk_bullseye"));	// Manually re-add "Bullseye" after it has been removed from Goblin baseclass
		}

		return ret;
	}
});
