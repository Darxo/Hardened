::Reforged.HooksMod.hook("scripts/skills/perks/perk_student", function(q) {
	// Config
	q.m.LevelsRequiredForPerk <- 3;		// A character needs to gain this many levels in order to reimburse Student

	// Private
	q.m.StudentStartLevelFlag <- "HD_StudentStartLevel";	// The level at which a brother picked up this perk will be saved under this Flag

	q.onUpdate = @() function( _properties )	// Overwrite. This perk no longer grants experience
	{
	}

	q.onAdded = @(__original) function()
	{
		local actor = this.getContainer().getActor();
		if (this.m.IsNew)
		{
			actor.getFlags().set(this.m.StudentStartLevelFlag, actor.getLevel());
		}
	}

	q.onUpdateLevel = @() function()
	{
		local actor = this.getContainer().getActor();
		actor.getFlags().get(this.m.StudentStartLevelFlag);
		if (actor.getLevel() == actor.getFlags().get(this.m.StudentStartLevelFlag) + this.m.LevelsRequiredForPerk)
		{
			actor.m.PerkPoints += 1;
		}

		// Revert the vanilla student effect
		if (actor.m.Level == 11)
		{
			actor.m.PerkPoints -= 1;
		}
	}
});
