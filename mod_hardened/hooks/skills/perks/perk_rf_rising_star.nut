::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_rising_star", function(q) {
	// Public
	q.m.ExperienceMult <- 1.2;	// This much experience is gained while below the LevelThreshold
	q.m.LevelThreshold <- 12;	// At this level you gain +2 Perk Points and lose the experience bonus

	q.isHidden = @() function()
	{
		return this.getContainer().getActor().getLevel() >= this.m.LevelThreshold;
	}

	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		local xpMult = this.getExperienceMult();
		if (xpMult != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/xp_received.png",
				text = "Gain " + ::MSU.Text.colorizeMultWithText(this.m.ExperienceMult) + ::Reforged.Mod.Tooltips.parseString(" [Experience|Concept.Experience]"),
			});
		}

		if (this.getContainer().getActor().getLevel() < this.m.LevelThreshold)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Will gain " + ::MSU.Text.colorPositive(this.m.PerkPointsToGain) + " [perk points|Concept.Perk] at [Level|Concept.Level] " + this.m.LevelThreshold),
			});
		}

		return ret;
	}

	// Overwrite, because we hand out experience differently
	q.onUpdate = @() function( _properties )
	{
		_properties.XPGainMult *= this.getExperienceMult();
	}

	// Overwrite, because we set a different start-level
	q.onAdded = @() function()
	{
		// We only set this to be backwards compatible with Reforged when a player changes back
		this.m.StartLevel = this.m.LevelThreshold - this.m.LevelsRequiredForPerk;

		// If a character learns this perk at a later point, they still gain the perk point
		local actor = this.getContainer().getActor();
		if (this.m.IsNew && actor.getLevel() >= this.m.LevelThreshold)
		{
			actor.m.PerkPoints += this.m.PerkPointsToGain;
		}
	}

	// Overwrite, because we make this more moddable and make it work directly off of the LevelThreshold we defined
	q.onUpdateLevel = @() function()
	{
		if (this.getContainer().getActor().getLevel() == this.m.LevelThreshold)
		{
			this.getContainer().getActor().m.PerkPoints += this.m.PerkPointsToGain;
		}
	}

// New Functions
	q.getExperienceMult <- function()
	{
		if (this.getContainer().getActor().getLevel() < this.m.LevelThreshold)
		{
			return this.m.ExperienceMult;
		}

		return 1.0;
	}
});
