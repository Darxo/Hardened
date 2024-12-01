::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_dismantle", function(q) {
	q.m.TargetHealthThreshold <- 1.0;
	q.m.ArmorDamagePct <- 0.40;
	q.m.ShieldDamageMult <- 2.0;

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (this.isSkillValid(_skill) && _targetEntity != null && _targetEntity.getHitpointsPct() >= this.m.TargetHealthThreshold)
		{
			_properties.DamageArmorMult += this.m.ArmorDamagePct;
			_properties.ShieldDamageMult *= this.m.ShieldDamageMult;
		}
	}

	// Overwrite to remove the effect of Reforged
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {}

// Hardened Functions
	// If we are evaluating _target, potentially targeting them with _usedSkill, how would that change the targets perceived value?
	q.getQueryTargetMultAsUser = @(__original) function( _target, _usedSkill = null )	// Const
	{
		local ret = __original(_target, _usedSkill);
		if (_usedSkill == null) return ret;

		if (this.isSkillValid(_usedSkill) && _target.getHitpointsPct() >= this.m.TargetHealthThreshold)
		{
			ret *= 1.2;
		}

		return ret;
	}

// MSU Functions
	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		if (this.isSkillValid(_skill) && _targetTile.IsOccupiedByActor && _targetTile.getEntity().getHitpointsPct() >= this.m.TargetHealthThreshold)
		{
			_tooltip.push({
				icon = "ui/tooltips/positive.png",
				text = ::MSU.Text.colorPositive(this.getName()),
			});
		}
	}

// Reforged Functions
	q.isSkillValid = @(__original) function( _skill )
	{
		if (_skill.isRanged() || !_skill.isAttack())
			return false;

		if (this.m.RequiredWeaponType == null)
			return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
