::Hardened.wipeClass("scripts/skills/perks/perk_rf_through_the_gaps");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_through_the_gaps", function(q) {
	// Public
	q.m.DirectDamageModifier <- -0.1;

	q.create <- function()
	{
		this.m.ID = "perk.rf_through_the_gaps";
		this.m.Name = ::Const.Strings.PerkName.RF_ThroughTheGaps;
		this.m.Description = ::Const.Strings.PerkDescription.RF_ThroughTheGaps;
		this.m.Icon = "ui/perks/perk_rf_through_the_gaps.png";
		this.m.Type = ::Const.SkillType.Perk;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	// Copy of reforged old through the gaps implementation
	q.onAnySkillUsed <- function( _skill, _targetEntity, _properties )
	{
		if (!this.isSkillValid(_skill)) return;

		_properties.DamageDirectAdd += this.m.DirectDamageModifier;

		if (_targetEntity != null)
		{
			local headArmor = _targetEntity.getArmor(::Const.BodyPart.Head);
			local bodyArmor = _targetEntity.getArmor(::Const.BodyPart.Body);
			if (headArmor < bodyArmor)
			{
				_properties.HitChance[::Const.BodyPart.Head] = 100.0;
				_properties.HitChanceMult[::Const.BodyPart.Body] = 0.0;
			}
			else if (bodyArmor < headArmor)
			{
				_properties.HitChance[::Const.BodyPart.Body] = 100.0;
				_properties.HitChanceMult[::Const.BodyPart.Head] = 0.0;
			}
		}
	}

// New Functions
	// Copy of reforged isSkillValid implementation
	q.isSkillValid <- function( _skill )
	{
		if (_skill.isRanged() || !_skill.isAttack() || (this.m.RequiredDamageType != null && !_skill.getDamageType().contains(this.m.RequiredDamageType)))
			return false;

		if (this.m.RequiredWeaponType == null)
			return true;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}
});
