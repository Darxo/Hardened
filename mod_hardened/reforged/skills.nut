
// We Overwrite this with one that's doing nothing, because we no longer want to use this way of applying perks
// And we want to kill all Reforged attempts of adding perks this way
::Reforged.Skills.addPerkGroupOfEquippedWeapon = function ( _entity, _maxTier = 7 ) {}	// Todo: Add some logging and then go hunt down all remaining causes one-by-one
