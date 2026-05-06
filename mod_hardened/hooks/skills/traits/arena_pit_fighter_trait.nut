::Hardened.HooksMod.hook("scripts/skills/traits/arena_pit_fighter_trait", function(q) {
	// Public
	q.m.HD_ArenaBraveryModifierPerWin <- 1;

	q.getDescription = @(__original) function()
	{
		local matches = this.getContainer().getActor().getFlags().getAsInt("ArenaFights");
		local won = this.getContainer().getActor().getFlags().getAsInt("ArenaFightsWon");
		if (won == matches) won = "all";

		local text = "";
		if (matches == 1)
		{
			text = " So far, this character has fought in one match";
			if (won == 1)
			{
				text = text + " and won it.";
			}
			else
			{
				text = text + " but lost it.";
			}
		}
		else
		{

			text = " So far, this character has fought in " + matches + " matches and won " + won + " of them.";
		}

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

		return ret;
	}

	// Revert any changes done to reach
	q.onUpdate = @(__original) function( _properties )
	{
		// We revert any changes done by vanilla, as we want to control ourselves how and when they are changes
		local oldBravery = _properties.Bravery;
		__original(_properties);
		_properties.Bravery = oldBravery;

		_properties.Bravery += this.HD_getBraveryModifier();
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

	q.HD_isInArena <- function()
	{
		return ::Tactical.isActive() && ::Tactical.State.m.StrategicProperties.IsArenaMode;
	}
});
