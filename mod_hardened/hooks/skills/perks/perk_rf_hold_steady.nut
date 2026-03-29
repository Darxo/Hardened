::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_hold_steady", function(q) {
	// Overwrite, because the player hold steady perk, now adds a different skill, compared to the enemy-only version
	q.onAdded = @() function()
	{
		this.getContainer().add(::new("scripts/skills/actives/hd_hold_steady_skill"));
	}

	// Overwrite, because the player hold steady perk, now adds a different skill, compared to the enemy-only version
	q.onRemoved = @() function()
	{
		this.getContainer().removeByID("actives.hd_hold_steady");
	}
});
