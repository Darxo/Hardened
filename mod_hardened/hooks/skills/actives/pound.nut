::Hardened.HooksMod.hook("scripts/skills/actives/pound", function(q) {
	// Public
	q.m.HD_HeadshotStunChance <- 0;		// Chance to inflict a stun on a hit to the head

	q.create = @(__original) function()
	{
		__original();
		this.m.StunChance = 0;		// Vanilla: 30
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];
			// We delete the Vanilla entry about the extra Armor Penetration on a head shot. This skill no longer naturally grants it. And the flail mastery produces its own tooltip
			if (entry.id == 5 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);
			}
			else if (this.m.StunChance == 0 && entry.id == 7 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);
			}
		}

		if (this.m.HD_HeadshotStunChance > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Has a " + ::MSU.Text.colorPositive(this.m.HD_HeadshotStunChance + "%") + " chance to [stun|Skill+stunned_effect] on [hit to the head|Concept.ChanceToHitHead]"),
			});
		}

		return ret;
	}

	// Overwrite, because we disable the increased Armor Penetration on a hit to the head
	q.onBeforeTargetHit = @() function( _skill, _targetEntity, _hitInfo )
	{
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		if (_skill != this)

		if (!_targetEntity.isAlive()) return;
		if (_targetEntity.getCurrentProperties().IsImmuneToStun) return;
		if (_targetEntity.getSkills().hasSkill("effects.stunned")) return;

		// Feat: Instead of a global chance to stun, this skill now has a chance to stun on a headshot
		if (_bodyPart != ::Const.BodyPart.Head) return;
		if (::Math.rand(1, 100) > this.m.HD_HeadshotStunChance) return;

		local stun = ::new("scripts/skills/effects/stunned_effect");
		_targetEntity.getSkills().add(stun);

		if (_targetEntity.getTile().IsVisibleForPlayer)
		{
			::Tactical.EventLog.log(stun.getLogEntryOnAdded(::Const.UI.getColorizedEntityName(this.getContainer().getActor()), ::Const.UI.getColorizedEntityName(_targetEntity)));
		}
	}

// MSU Functions
	q.softReset = @(__original) function()
	{
		__original();
		this.m.HD_HeadshotStunChance = this.b.HD_HeadshotStunChance;
	}
});
