::Hardened.HooksMod.hook("scripts/skills/actives/rf_flaming_arrows_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.InjuriesOnBody = ::Const.Injury.BurningBody;		// Reforged: BurningAndPiercingBody
		this.m.InjuriesOnHead = ::Const.Injury.BurningHead;		// Reforged: BurningAndPiercingHead
	}

	// Overwrite Reforged function to remove the morale check on the main target
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		this.aimed_shot.onTargetHit(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		if (this.m.TargetTile == null || _skill != this) return;

		foreach (nextTile in ::MSU.Tile.getNeighbors(this.m.TargetTile))
		{
			if (!nextTile.IsOccupiedByActor) continue;

			local adjacentEntity = nextTile.getEntity();
			if (!adjacentEntity.isAlliedWith(this.getContainer().getActor()) && adjacentEntity.getMoraleState() != ::Const.MoraleState.Ignore)
			{
				adjacentEntity.checkMorale(-1, ::Const.Morale.OnHitBaseDifficulty * (1.0 - adjacentEntity.getHitpoints() / adjacentEntity.getHitpointsMax()));
			}
		}

		::Time.scheduleEvent(::TimeUnit.Real, 50, this.onApply.bindenv(this), {
			Skill = this,
			User = this.getContainer().getActor(),
			TargetTile = this.m.TargetTile
		});
	}

// MSU Functions
	q.onQueryTooltip = @(__original) function( _skill, _tooltip )
	{
		__original(_skill, _tooltip);

		if (_skill.getID() == "actives.aimed_shot")
		{
			_tooltip.push({
				id = 102,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Burns away any [rooted|Concept.Rooted] effects on the target"),
			});

			foreach (entry in _tooltip)
			{
				if (entry.id == 100)
				{
					entry.text = ::Reforged.Mod.Tooltips.parseString("A hit will trigger a negative [morale check|Concept.MoraleCheck] for all adjacent enemies")
					break;
				}
			}
		}
	}
});
