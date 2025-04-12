::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_line_breaker", function(q) {
	// Overwrite Reforged because we add the new skills now during onEquip
	q.onAdded = @() function()
	{
		local shield = this.getContainer().getActor().getOffhandItem();
		if (shield != null) this.onEquip(shield);
	}

	// We overwrite the reforged implementation, because we no longer grant shield bash with this perk
	q.onEquip = @() function( _item )
	{
		this.skill.onEquip(_item);
		if (_item.isItemType(::Const.Items.ItemType.Shield))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_line_breaker_skill"));
		}
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

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

	q.onQueryTooltip = @(__original) function( _skill, _tooltip )
	{
		__original(_skill, _tooltip);

		if (_skill.getID() == "actives.knock_back")
		{
			_tooltip.push({
				id = 100,
				type = "text",
				icon = ::Const.Perks.findById(this.getID()).Icon,
				text = ::MSU.Text.colorizeValue(this.m.KnockBackMeleeSkillBonus, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Hitchance|Concept.Hitchance]"),
			});

			_tooltip.push({
				id = 101,
				type = "text",
				icon = ::Const.Perks.findById(this.getID()).Icon,
				text = ::Reforged.Mod.Tooltips.parseString("Will [stagger|Skill+staggered_effect] the target on a hit")
			});
		}
	}

	q.onRemoved = @() function() {}		// We no longer need to manually remove the skill
});
