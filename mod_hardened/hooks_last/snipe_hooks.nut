// Prevent a tooltip about the now deleted skill "Hook Shield" from being added
// Prevent onTurnStart logic related to shield sergeant perk
::Hardened.snipeHook("scripts/skills/effects/shieldwall_effect", "mod_reforged");

// Remove reforged shield sergeant effects
// Prevent a tooltip about the now deleted skill "Hook Shield" from being added
// Prevent a tooltip about the fatigue mechanic from being added
::Hardened.snipeHook("scripts/skills/actives/shieldwall", "mod_reforged");

// Completely Revert Reforged Double Grip rework
::Hardened.snipeHook("scripts/skills/special/double_grip", "mod_reforged");

// Perks
{
	// Completely Revert Reforged Quickhands nerf
	::Hardened.snipeHook("scripts/skills/perks/perk_quick_hands", "mod_reforged");

	// Completely Revert Reforged Hammer Mastery additions
	::Hardened.snipeHook("scripts/skills/perks/perk_mastery_hammer", "mod_reforged");

	// Completely Revert Reforged Footwork additions (sprint skill)
	::Hardened.snipeHook("scripts/skills/perks/perk_footwork", "mod_reforged");
}
