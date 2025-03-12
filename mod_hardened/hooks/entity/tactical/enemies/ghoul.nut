::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/ghoul", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();

		this.getSkills().removeByID("perk.rf_deep_cuts");

		if (this.getSize() == 1)
		{
			this.getSkills().add(::new("scripts/skills/perks/perk_rf_ghostlike"));
		}
	}

	q.grow = @(__original) function( _instant = false )
	{
		this.getSkills().removeByID("perk.rf_ghostlike");

		__original(_instant);
	}
});
