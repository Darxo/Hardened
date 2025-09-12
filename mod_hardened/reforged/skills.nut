
// We Overwrite this with one that's doing nothing, because we no longer want to use this way of applying perks
// And we want to kill all Reforged attempts of adding perks this way
::Reforged.Skills.addPerkGroupOfEquippedWeapon = function ( _entity, _maxTier = 7 ) {}	// Todo: Add some logging and then go hunt down all remaining causes one-by-one

// Overwrite, because this function now only ever adds one mastery per weapon (alphabetically first), instead of all of them
::Reforged.Skills.addMasteryOfWeapon = function( _entity, _weapon) {
	if (_weapon.isWeaponType(::Const.Items.WeaponType.Axe))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_axe"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Bow))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_bow"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Cleaver))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_cleaver"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Crossbow) || _weapon.isWeaponType(::Const.Items.WeaponType.Firearm))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_crossbow"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_dagger"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Flail))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_flail"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_hammer"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Mace))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_mace"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Polearm))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_polearm"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Spear))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_spear"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Sword))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_sword"));
	}
	else if (_weapon.isWeaponType(::Const.Items.WeaponType.Throwing))
	{
		_entity.getSkills().add(::new("scripts/skills/perks/perk_mastery_throwing"));
	}
}
