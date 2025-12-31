::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_dismantle", function(q) {
	q.m.TargetHealthThreshold <- 1.0;
	q.m.ArmorDamagePct <- 0.40;
	q.m.ShieldDamageMult <- 2.0;

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);
		if (this.isSkillValid(_skill))
		{
			_properties.ShieldDamageMult *= this.m.ShieldDamageMult;
			if (_targetEntity != null && _targetEntity.getHitpointsPct() >= this.m.TargetHealthThreshold)
			{
				_properties.DamageArmorMult += this.m.ArmorDamagePct;
			}
		}
	}

	// Overwrite to remove the effect of Reforged
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;		// We must be the _user
		if (_user.getID() == _target.getID()) return ret;		// _user and _target must not be the same

		if (_skill != null && this.isSkillValid(_skill) && _target.getHitpointsPct() >= this.m.TargetHealthThreshold)
		{
			ret *= 1.2;
		}

		return ret;
	}

// MSU Functions
	q.onGetHitFactors = @(__original) function( _skill, _targetTile, _tooltip )
	{
		if (_targetTile.IsOccupiedByActor && this.isSkillValid(_skill) && _targetTile.getEntity().getHitpointsPct() >= this.m.TargetHealthThreshold)
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
