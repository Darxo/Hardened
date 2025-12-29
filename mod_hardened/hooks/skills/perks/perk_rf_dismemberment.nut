::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_dismemberment", function(q) {
	q.m.BodyPartHitChanceModifier <- 20;

	// Overwrite because we no longer inflict morale checks
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) { }

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_targetEntity == null) return;
		if (!this.isSkillValid(_skill)) return;

		local bodyPartCounter = 0;
		foreach (tempInjury in _targetEntity.getSkills().getAllSkillsOfType(::Const.SkillType.TemporaryInjury))
		{
			if (tempInjury.m.AffectedBodyPart == ::Const.BodyPart.Head) ++bodyPartCounter;
			if (tempInjury.m.AffectedBodyPart == ::Const.BodyPart.Body) --bodyPartCounter;
		}

		if (bodyPartCounter > 0)
		{
			_properties.HitChance[::Const.BodyPart.Head] += this.m.BodyPartHitChanceModifier
		}
		else if (bodyPartCounter < 0)
		{
			_properties.HitChance[::Const.BodyPart.Head] -= this.m.BodyPartHitChanceModifier
		}
	}

// Reforged Functions
	// Overwrite, because we remove the checks for isRanged and for the damage type
	q.isSkillValid = @() function( _skill )
	{
		if (!_skill.isAttack()) return false;

		if (this.m.RequiredWeaponType == null) return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
