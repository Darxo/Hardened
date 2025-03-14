::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_flail", function(q) {
	// We overwrite these functions because flail mastery no longer adds the perk_rf_from_all_sides
	q.onAdded = @() function() {}
	q.onRemoved = @() function() {}

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

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Flail)) return false;

		return true;
	}
});
