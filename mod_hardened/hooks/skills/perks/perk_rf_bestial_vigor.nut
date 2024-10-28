::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bestial_vigor", function(q) {
	q.onAdded = @() function()
	{
		this.getContainer().add(::new("scripts/skills/actives/hd_backup_plan_skill"));
	}

	q.onRemoved = @() function()
	{
		this.getContainer().removeByID("actives.hd_backup_plan");
	}
});
