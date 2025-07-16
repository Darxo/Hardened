::Hardened.HooksMod.hook("scripts/skills/special/morale_check", function(q) {
	// Public
	q.m.FleeingActionPointModifier <- 1;
	q.m.AutoRetreatActionPointModifier <- 1;
	q.m.DamageReceivedRegularMultWhileFleeing <- 2.0;	// If this character is fleeing, fully surrounded and its faction has given up, they take this much more hitpoint damage

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		if (this.getFleeingActionPointModifier() != 0)
		{
			ret.push({
				id = 16,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::MSU.Text.colorizeValue(this.getFleeingActionPointModifier(), {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Action Point(s)|Concept.ActionPoints]"),
			});
		}

		if (this.isValidForFleeDamageMult())
		{
			if (this.getDamageReceivedRegularMult() != 1.0)
			{
				ret.push({
					id = 18,
					type = "text",
					icon = "ui/icons/special.png",
					text =  "Take " + ::MSU.Text.colorizeMultWithText(this.getDamageReceivedRegularMult(), {InvertColor = true}) + " Damage to Hitpoints",
				});
			}
			else
			{
				ret.push({
					id = 18,
					type = "text",
					icon = "ui/icons/special.png",
					text =  "Take " + ::MSU.Text.colorizeMultWithText(this.m.DamageReceivedRegularMultWhileFleeing, {InvertColor = true}) + " Damage to Hitpoints, while fully surrounded, after the player has won",
				});
			}
		}

		return ret;
	}

	q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitInfo, _properties )
	{
		__original(_attacker, _skill, _hitInfo, _properties);

		// Feat: Fleeing, fully surrounded enemies take more hitpoint damage, if the player has already won the battle
		_properties.DamageReceivedRegularMult *= this.getDamageReceivedRegularMult();
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// Give all actors additional Action Points while fleeing
		_properties.ActionPoints += this.getFleeingActionPointModifier();

		// Give player entities +1 maximum Action Point while autoretreat is on
		// This has not directly to do with morale, but this is still a fine place
		_properties.ActionPoints += this.getAutoRetreatActionPointModifier();
	}

// New Functions
	q.getFleeingActionPointModifier <- function()
	{
		if (this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			return this.m.FleeingActionPointModifier;
		}

		return 0;
	}

	q.getAutoRetreatActionPointModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap() && actor.getFaction() == ::Const.Faction.Player && ::Tactical.State.isAutoRetreat())
		{
			return this.m.AutoRetreatActionPointModifier;
		}

		return 0;
	}

	q.isValidForFleeDamageMult <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;
		if (actor.isAlliedWithPlayer()) return false;
		if (actor.getMoraleState() != ::Const.MoraleState.Fleeing) return false;

		return true;
	}

	q.getDamageReceivedRegularMult <- function()
	{
		if (!this.isValidForFleeDamageMult()) return 1.0;
		if (!::Tactical.Entities.isEnemyRetreating()) return 1.0;

		foreach (nextTile in ::MSU.Tile.getNeighbors(this.getContainer().getActor().getTile()))
		{
			if (nextTile.IsEmpty) return 1.0;
		}

		return this.m.DamageReceivedRegularMultWhileFleeing;
	}
});
