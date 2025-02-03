::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_phalanx", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 11 && entry.icon == "ui/icons/special.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("[Shieldwall|Skill+shieldwall_effect] will not expire at the start of your [turn|Concept.Turn] as you are next to an ally with [Shieldwall|Skill+shieldwall_effect]");
				break;
			}
		}

		return ret;
	}

	// Overwrite because we don't want to display the reforged specific tooltip
	q.onQueryTooltip = @() function( _skill, _tooltip )
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

	q.onTurnStart = @(__original) function()
	{
		__original();
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

	q.onAfterUpdate = @() function( _properties ) {}	// We no longer grant a discount to shieldwall
	// No longer display any hitfactor tooltips
	q.onGetHitFactors = @() function(_skill, _targetTile, _tooltip) {}
	q.onGetHitFactorsAsTarget = @() function(_skill, _targetTile, _tooltip) {}

// Reforged Functions
	// Overwrite of Reforged: Buckler no longer set the count to 0 or are ignored when counting.
	q.getCount = @() function()
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

// Hardened Functions
	// If _user is evaluating our value, potentially targeting us with _usedSkill, how would that change our perceived value for them?
	q.getQueryTargetMultAsTarget = @(__original) function( _user, _usedSkill = null )
	{
		local ret = __original(_user, _usedSkill);
		if (_usedSkill == null) return ret;

		if (_usedSkill.getID() == "actives.split_shield" || _usedSkill.getID() == "actives.throw_spear")
		{
			ret *= 1.2;	// _user wants to destroy this guys shield to prevent situations of perma-shieldwall
		}

		return ret;
	}
});
