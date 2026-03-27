::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_zombie_orc_young_bodyguard", function(q) {
	// Overwrite, because we dont want to add extra perks in this base function
	q.onInit = @() function()
	{
		this.rf_zombie_orc_young.onInit();
	}

// New Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		this.getSkills().add(::new("scripts/skills/perks/perk_shield_expert"));
	}
});
