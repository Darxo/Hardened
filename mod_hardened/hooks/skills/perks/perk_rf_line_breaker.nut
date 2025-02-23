::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_line_breaker", function(q) {
	// Overwrite Reforged lose adding of line breaker skill
	q.onAdded = @() function()
	{
		local shield = this.getContainer().getActor().getOffhandItem();
		if (shield != null) this.onEquip(shield);
	}

	q.onEquip = @(__original) function( _item )
	{
		__original(_item);
		if (_item.isItemType(::Const.Items.ItemType.Shield))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_line_breaker_skill"));
		}
	}

	q.onRemoved = @() function() {}		// We no longer need to manually remove the skill

	// Reforged Fix: Overwrite, because we fix some wrong variable names
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		if (_skill.getID() == "actives.knock_back" && _targetEntity.isAlive() && !_targetEntity.isDying())
		{
			local effect = ::new("scripts/skills/effects/staggered_effect");
			_targetEntity.getSkills().add(effect);
			local actor = this.getContainer().getActor();
			if (!actor.isHiddenToPlayer() && _targetEntity.getTile().IsVisibleForPlayer)
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " has staggered " + ::Const.UI.getColorizedEntityName(_targetEntity) + " for " + effect.m.TurnsLeft + " turns");
			}
		}
	}
});
