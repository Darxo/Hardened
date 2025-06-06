::Hardened.wipeClass("scripts/skills/perks/perk_rf_phalanx", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_phalanx", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.BeforeLast;	// Important so we act after shieldwall effect and prevent its garbage removal
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		local reachModifier = this.getReachModifier();
		if (reachModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/rf_reach.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(reachModifier, {AddSign = true}) + " [Reach|Concept.Reach]"),
			});
		}

		if (this.hasAdjacentShieldwall())
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("[Shieldwall|Skill+shieldwall_effect] will not expire at the start of your [turn|Concept.Turn] as you are next to an ally with [Shieldwall|Skill+shieldwall_effect]"),
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return this.getReachModifier() == 0;
	}

	q.onUpdate <- function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this effect grants Reach depending on adjacent allies
		_properties.Reach += this.getReachModifier();
	}

	q.onQueryTooltip <- function( _skill, _tooltip )
	{
		if (_skill.getID() == "actives.shieldwall" && this.hasAdjacentShieldwall())
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Will not expire as you have [Phalanx|Perk+perk_rf_phalanx] and are next to an ally with [Shieldwall|Skill+shieldwall_effect]"),
			});
		}
	}

	q.onTurnStart <- function()
	{
		if (this.hasAdjacentShieldwall())
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (skill.getID() == "effects.shieldwall")
				{
					skill.m.IsGarbage = false; // Phalanx skill order is after Shieldwall effect, so we retroactively set it to not be garbage
					return;
				}
			}
		}
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (_target.getID() == this.getContainer().getActor().getID() && _user.getID() != _target.getID())	// We must be the _target
		{
			if (_skill == null) return ret;

			if (_skill.getID() == "actives.split_shield" || _skill.getID() == "actives.throw_spear")
			{
				ret *= 1.2;	// _user wants to destroy this guys shield to prevent situations of perma-shieldwall
			}
		}

		return ret;
	}

// New Functions
	q.getReachModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 0;

		local count = 0;
		foreach (ally in ::Tactical.Entities.getAlliedActors(actor.getFaction(), actor.getTile(), 1))
		{
			if (ally.isArmedWithShield() && ally.getID() != actor.getID())
			{
				count += 1;
			}
		}
		return count;
	}

	// @return true, if there is an adjacent ally who has the shieldwall effect, or false otherwise
	q.hasAdjacentShieldwall <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;

		foreach (nextTile in ::MSU.Tile.getNeighbors(actor.getTile()))
		{
			if (nextTile.IsOccupiedByActor && nextTile.getEntity().isAlliedWith(actor) && nextTile.getEntity().getSkills().hasSkill("effects.shieldwall"))
			{
				return true;
			}
		}

		return false;
	}
});
