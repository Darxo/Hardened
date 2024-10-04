::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_flaming_arrows", function(q) {
	// Overwrite Reforged function to remove the morale check on the main target
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (this.m.TargetTile == null) return;

		for (local i = 0; i < 6; ++i)
		{
			if (this.m.TargetTile.hasNextTile(i))
			{
				local nextTile = this.m.TargetTile.getNextTile(i);
				if (nextTile.IsOccupiedByActor)
				{
					local adjacentEntity = nextTile.getEntity();
					if (!adjacentEntity.isAlliedWith(this.getContainer().getActor()) && adjacentEntity.getMoraleState() != ::Const.MoraleState.Ignore)
					{
						adjacentEntity.checkMorale(-1, ::Const.Morale.OnHitBaseDifficulty * (1.0 - adjacentEntity.getHitpoints() / adjacentEntity.getHitpointsMax()));
					}
				}
			}
		}

		::Time.scheduleEvent(::TimeUnit.Real, 50, this.onApply.bindenv(this), {
			Skill = this,
			User = this.getContainer().getActor(),
			TargetTile = this.m.TargetTile
		});
	}

	q.onQueryTooltip = @(__original) function( _skill, _tooltip )
	{
		local ret = __original(_skill, _tooltip);

		if (_skill.getID() == "actives.aimed_shot")
		{
			ret.push({
				id = 102,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Burns away any [rooted|Rooted.StatusEffect] effects on the target"),
			});
		}

		foreach (index, entry in ret)
		{
			if (entry.id == 100)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("A hit will trigger a negative [morale check|Concept.MoraleCheck] for all adjacent enemies")
				break;
			}
		}


		return ret;
	}
});
