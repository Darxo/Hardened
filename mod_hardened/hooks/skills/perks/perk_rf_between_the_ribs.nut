::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_between_the_ribs", function(q) {
	q.m.HeadShotChancePerSurround <- -10;

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (_targetEntity != null && !_targetEntity.getCurrentProperties().IsImmuneToSurrounding && this.isSkillValid(_skill))
		{
			_properties.HitChance[::Const.BodyPart.Head] += _targetEntity.getSurroundedCount() * this.m.HeadShotChancePerSurround;
		}
	}

	// Overwrite to remove the condition about needing to be a piercing attack
	q.isSkillValid = @() function( _skill )
	{
		if (!_skill.isAttack() || _skill.isRanged())
			return false;

		if (this.m.RequiredWeaponType == null)
			return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
