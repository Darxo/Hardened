::Hardened.HooksMod.hook("scripts/skills/traits/arena_veteran_trait", function(q) {
	// Public
	q.m.HD_ArenaBraveryModifierPerWin <- 1;
	q.m.HD_BraveryModifier <- 15;	// Vanilla: 10
	q.m.HD_SurviveWithInjuryChanceMult <- 1.5;

	// Private
	q.m.HD_IconVeteran <- "ui/traits/trait_icon_74.png";
	q.m.HD_LastKnownArenaWins <- 0;		// Used, so that we don't globaly check for Arena Champion too often
	q.m.HD_MostWonFlag <- "HD_WorldFlagMostArenaFightsWon";

	q.getIcon = @(__original) function()
	{
		if (this.HD_isArenaChampion())
		{
			return __original();
		}
		else
		{
			return this.m.HD_IconVeteran;
		}
	}

	q.getIconColored = @() function()
	{
		return this.getIcon();
	}

	q.getName = @(__original) function()
	{
		if (this.HD_isArenaChampion()) return "Arena Champion";

		return __original();
	}

	q.getDescription = @(__original) function()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
		return __original() + " So far, this character has fought in " + ::MSU.Text.colorPositive(matches) + " matches and won " + ::MSU.Text.colorPositive(won) + " of them.";
	}

	// Overwrite, because our trait works completely different
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		if (this.HD_getChampionBraveryModifier() > 0)
		{
			if (this.HD_isArenaChampion())
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/ambition.png",
					text = "You are the " + ::MSU.Text.colorPositive("Arena Champion") + ", because you have won the most matches out of all " + ::MSU.Text.colorPositive("Arena Veterans") + " from your company!",
					children = [{
						id = 10,
						type = "text",
						icon = "ui/icons/bravery.png",
						text = ::MSU.Text.colorizeValue(this.HD_getChampionBraveryModifier(), {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Resolve|Concept.Bravery]"),
					}],
				});
			}
			else
			{
				ret.push({
					id = 10,
					type = "text",
					icon = "ui/icons/ambition_sw.png",
					text = "Gain " + ::MSU.Text.colorizeValue(this.HD_getChampionBraveryModifier(), {AddSign = true}) + " while you have won the most matches out of all " + ::MSU.Text.colorPositive("Arena Veterans") + " from your company!",
				});
			}
		}

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

	q.onDismiss = @(__original) function()
	{
		__original();

		this.HD_CalculateMostWon(true);
	}

	q.onAdded = @(__original) function()
	{
		__original();
		this.HD_CalculateMostWon(false);	// This covers deserialization
	}

// MSU Functions
	q.onUnequip = @(__original) function( _item )
	{
		__original(_item);
		if (_item.getID() == "accessory.arena_collar")
		{
			this.HD_CalculateMostWon(false);
		}
	}

// New Functions
	// Check all brothers to determine, which of them is the Arena Champion
	/// @param _ignoreSelf if true, then ignore ourself. This is useful during onRemoved event
	q.HD_CalculateMostWon <- function( _ignoreSelf )
	{
		local actor = this.getContainer().getActor();
		local mostWon = 0;
		local tie = false;		// Do multiple brothers have the highest amount of wins?
		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			if (_ignoreSelf && bro.getID() == actor.getID()) continue;

			local broWins = bro.getFlags().getAsInt("ArenaFightsWon");
			if (broWins > mostWon)
			{
				tie = false;
				mostWon = broWins;
			}
			else if (!tie && broWins == mostWon)
			{
				tie = true;
			}
		}

		// Hacky: A tie means that neither one is a champion. We implement this is a dirty way by pretending like the mostWon is 1 higher than it actually is
		if (tie) ++mostWon;

		::World.Flags.set(this.m.HD_MostWonFlag, mostWon);
	}

	q.HD_getBraveryModifier <- function()
	{
		local resolve = 0;

		if (this.HD_isInArena())
		{
			resolve += this.HD_getArenaBraveryModifier();
		}

		if (this.HD_isArenaChampion())
		{
			resolve += this.HD_getChampionBraveryModifier();
		}

		return resolve;
	}

	q.HD_getSurviveWithInjuryChanceMult <- function()
	{
		if (this.HD_isInArena())
		{
			return this.HD_getArenaSurviveWithInjuryChanceMult();
		}

		return 1.0;
	}

	q.HD_getChampionBraveryModifier <- function()
	{
		return this.m.HD_BraveryModifier;
	}

	q.HD_getArenaBraveryModifier <- function()
	{
		return this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
	}

	q.HD_getArenaSurviveWithInjuryChanceMult <- function()
	{
		return this.m.HD_SurviveWithInjuryChanceMult;
	}

	q.HD_isArenaChampion <- function()
	{
		return this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon") >= ::World.Flags.getAsInt(this.m.HD_MostWonFlag);
	}

	q.HD_isInArena <- function()
	{
		return ::Tactical.isActive() && ::Tactical.State.m.StrategicProperties.IsArenaMode;
	}
});
