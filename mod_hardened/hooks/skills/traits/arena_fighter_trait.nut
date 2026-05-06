::Hardened.HooksMod.hook("scripts/skills/traits/arena_fighter_trait", function(q) {
	// Public
	q.m.HD_ArenaBraveryModifierPerWin <- 1;
	q.m.HD_SurviveWithInjuryChanceMult <- 1.5;

	q.create = @(__original) function()
	{
		__original();

		// In order to free up an icon, we use the same one for the two lower arena traits
		this.m.Icon = "ui/traits/trait_icon_73.png";
	}

	q.getDescription = @(__original) function()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
		if (won == matches) won = "all";

		return __original() + " So far, this character has fought in " + ::MSU.Text.colorPositive(matches) + " matches and won " + ::MSU.Text.colorPositive(won) + " of them.";
	}

	// Overwrite, because our trait works differently
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		if (this.HD_getArenaBraveryModifier() > 0)
		{
			if (this.HD_isInArena())
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = ::MSU.Text.colorizeValue(this.HD_getArenaBraveryModifier(), {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]"),
				});
			}
			else
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/bravery.png",
					text = ::MSU.Text.colorizeValue(this.HD_getArenaBraveryModifier(), {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery] while fighting in the Arena"),
				});
			}
		}

		if (this.HD_getArenaSurviveWithInjuryChanceMult() != 1.0)
		{
			if (this.HD_isInArena())
			{
				ret.push({
					id = 12,
					type = "text",
					icon = "ui/icons/asset_medicine.png",
					text = ::MSU.Text.colorizeMultWithText(this.HD_getArenaSurviveWithInjuryChanceMult()) + ::Reforged.Mod.Tooltips.parseString(" chance to survive, if struck down"),
				});
			}
			else
			{
				ret.push({
					id = 12,
					type = "text",
					icon = "ui/icons/asset_medicine.png",
					text = ::MSU.Text.colorizeMultWithText(this.HD_getArenaSurviveWithInjuryChanceMult()) + ::Reforged.Mod.Tooltips.parseString(" chance to survive, if struck down while fighting in the Arena"),
				});
			}
		}

		return ret;
	}

	// Revert any changes done to reach
	q.onUpdate = @(__original) function( _properties )
	{
		// We revert any changes done by vanilla, as we want to control ourselves how and when they are changes
		local oldBravery = _properties.Bravery;
		local oldSurviveWithInjuryChanceMult = _properties.SurviveWithInjuryChanceMult;
		__original(_properties);
		_properties.Bravery = oldBravery;
		_properties.SurviveWithInjuryChanceMult = oldSurviveWithInjuryChanceMult;

		_properties.Bravery += this.HD_getBraveryModifier();
		_properties.SurviveWithInjuryChanceMult *= this.HD_getSurviveWithInjuryChanceMult();
	}

// New Functions
	q.HD_getBraveryModifier <- function()
	{
		local resolve = 0;

		if (this.HD_isInArena())
		{
			resolve += this.HD_getArenaBraveryModifier();;
		}

		return resolve;
	}

	q.HD_getArenaBraveryModifier <- function()
	{
		return this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
	}

	q.HD_getSurviveWithInjuryChanceMult <- function()
	{
		if (this.HD_isInArena())
		{
			return this.HD_getArenaSurviveWithInjuryChanceMult();
		}

		return 1.0;
	}

	q.HD_getArenaSurviveWithInjuryChanceMult <- function()
	{
		return this.m.HD_SurviveWithInjuryChanceMult;
	}

	q.HD_isInArena <- function()
	{
		return ::Tactical.isActive() && ::Tactical.State.m.StrategicProperties.IsArenaMode;
	}
});
