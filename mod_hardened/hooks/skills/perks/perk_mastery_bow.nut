::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_bow", function(q) {
	// Public
	q.m.HD_FatigueCostMult <- ::Hardened.Global.WeaponSpecFatigueMult;
	q.m.HD_RangedAttackMaxRangeModifier <- 1;

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		// Feat: We now implement the fatigue cost discount of masteries within the mastery perk
		if (this.m.HD_FatigueCostMult != 1.0)
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.FatigueCostMult *= this.m.HD_FatigueCostMult;

					if (skill.isAttack() && skill.isRanged())
					{
						// Feat: adjust the shooting range directly from the mastery instead of in the individual skills
						skill.m.MaxRange += this.m.HD_RangedAttackMaxRangeModifier;
					}
				}
			}
		}
	}

	q.onEquip = @(__original) { function onEquip( _item )
	{
		// We gate reforged' arrow to the knee skill addition to only happen on ranged weapons
		if (_item.isItemType(::Const.Items.ItemType.RangedWeapon))
		{
			__original(_item);
		}
	}}.onEquip;

	q.onUpdate = @(__original) function( _properties )
	{
		// We revert the vision change made by Vanilla
		local oldVision = _properties.Vision;
		__original(_properties);
		_properties.Vision = oldVision;

		// We no longer support this flag. Instead we adjust the shooting range of skills directly from within the mastery
		_properties.IsSpecializedInBows = false;
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Bow)) return false;

		return true;
	}
});
