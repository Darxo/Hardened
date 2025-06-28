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
	// Completely Revert Reforged Footwork additions (sprint skill)
	::Hardened.snipeHook("scripts/skills/perks/perk_footwork", "mod_reforged");

	// Completely Revert Reforged Quickhands nerf
	::Hardened.snipeHook("scripts/skills/perks/perk_quick_hands", "mod_reforged");

	// Completely Revert Reforged Cleaver Mastery Hook: Remove bloodlust perk, remove extra bleed stack
	::Hardened.snipeHook("scripts/skills/perks/perk_mastery_cleaver", "mod_reforged");

	// Completely Revert Reforged Hammer Mastery Hook: Remove dented armor effect, remove pummel skill
	::Hardened.snipeHook("scripts/skills/perks/perk_mastery_hammer", "mod_reforged");

	// Completely Revert Reforged Spear Mastery Hook: Remove free spear attack
	::Hardened.snipeHook("scripts/skills/perks/perk_mastery_spear", "mod_reforged");

	// Completely Revert Reforged damage bonus and special hit effects for throwing attacks
	::Hardened.snipeHook("scripts/skills/perks/perk_mastery_throwing", "mod_reforged");
}
