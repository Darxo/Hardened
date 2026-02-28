::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_flail", function(q) {
	// Public
	q.m.HD_FatigueCostMult <- 0.75;
	q.m.HD_HeadshotStunChanceAdd <- 50;

	// We overwrite these functions because flail mastery no longer adds the perk_rf_from_all_sides
	q.onAdded = @() function() {}
	q.onRemoved = @() function() {}

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

					// Feat: Mastery now grands Pound an additional chance to stun on a headshot
					if (skill.getID() == "actives.pound")
					{
						skill.m.HD_HeadshotStunChance += this.m.HD_HeadshotStunChanceAdd;
					}
				}
			}
		}
	}

// Hardened Functions
	q.onReallyAfterSkillExecuted = @(__original) function( _skill, _targetTile, _success )
	{
		__original(_skill, _targetTile, _success);

		if (this.isSkillValid(_skill))
		{
			this.getContainer().add(::new("scripts/skills/effects/rf_from_all_sides_effect"));
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Flail)) return false;

		return true;
	}
});
