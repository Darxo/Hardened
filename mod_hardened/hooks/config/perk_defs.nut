// New Hardened Perk Defs
::DynamicPerks.Perks.addPerks([
	{
		ID = "perk.hd_anchor",
		Script = "scripts/skills/perks/perk_hd_anchor",
		Name = ::Const.Strings.PerkName.HD_Anchor,
		Tooltip = ::Const.Strings.PerkDescription.HD_Anchor,
		Icon = "ui/perks/perk_hd_anchor.png",
		IconDisabled = "ui/perks/perk_hd_anchor_sw.png",
	},
	{
		ID = "perk.hd_brace_for_impact",
		Script = "scripts/skills/perks/perk_hd_brace_for_impact",
		Name = ::Const.Strings.PerkName.HD_BraceForImpact,
		Tooltip = ::Const.Strings.PerkDescription.HD_BraceForImpact,
		Icon = "ui/perks/perk_hd_brace_for_impact.png",		// Existing unused vanilla art, that we just renamed
		IconDisabled = "ui/perks/perk_hd_brace_for_impact_sw.png",		// Edited (desatured) version of existing unused vanilla art
	},
	{
		ID = "perk.hd_hybridization",
		Script = "scripts/skills/perks/perk_hd_hybridization",
		Name = ::Const.Strings.PerkName.HD_Hybridization,
		Tooltip = ::Const.Strings.PerkDescription.HD_Hybridization,
		Icon = "ui/perks/perk_rf_hybridization.png",
		IconDisabled = "ui/perks/perk_rf_hybridization_sw.png",
	},
	{
		ID = "perk.hd_one_with_the_shield",
		Script = "scripts/skills/perks/perk_hd_one_with_the_shield",
		Name = ::Const.Strings.PerkName.HD_OneWithTheShield,
		Tooltip = ::Const.Strings.PerkDescription.HD_OneWithTheShield,
		Icon = "ui/perks/perk_02.png",	// Unused vanilla art of a shield deflecting a flail attack
		IconDisabled = "ui/perks/perk_02_sw.png",
	},
	{
		ID = "perk.hd_parry",
		Script = "scripts/skills/perks/perk_hd_parry",
		Name = ::Const.Strings.PerkName.HD_Parry,
		Tooltip = ::Const.Strings.PerkDescription.HD_Parry,
		Icon = "ui/perks/perk_hd_parry.png",
		IconDisabled = "ui/perks/perk_hd_parry_sw.png",
	},
	{
		ID = "perk.hd_scout",
		Script = "scripts/skills/perks/perk_hd_scout",
		Name = ::Const.Strings.PerkName.HD_Scout,
		Tooltip = ::Const.Strings.PerkDescription.HD_Scout,
		Icon = "ui/perks/perk_hd_scout.png",
		IconDisabled = "ui/perks/perk_hd_scout_sw.png",
	},
	{
		ID = "perk.hd_elusive",
		Script = "scripts/skills/perks/perk_hd_elusive",
		Name = ::Const.Strings.PerkName.HD_Elusive,
		Tooltip = ::Const.Strings.PerkDescription.HD_Elusive,
		Icon = "ui/perks/perk_rf_trip_artist.png",
		IconDisabled = "ui/perks/perk_rf_trip_artist_sw.png",
	},
	{
		ID = "perk.hd_forestbond",
		Script = "scripts/skills/perks/perk_hd_forestbond",
		Name = ::Const.Strings.PerkName.HD_Forestbond,
		Tooltip = ::Const.Strings.PerkDescription.HD_Forestbond,
		Icon = "skills/terrain_icon_06.png",	// Unused Vanilla art showing a lot of forest leaves
		IconDisabled = "skills/terrain_icon_06.png",
	},
]);

// Reforged Fix: Add missing Vanilla Perk Defs, so that they display tooltips correctly
::DynamicPerks.Perks.addPerks([
	{
		ID = "perk.captain",
		Script = "scripts/skills/perks/perk_captain",
		Name = ::Const.Strings.PerkName.Captain,
		Tooltip = ::Const.Strings.PerkDescription.Captain,
		Icon = "ui/perks/perk_28.png",
		IconDisabled = "ui/perks/perk_28_sw.png",
	},
]);

// Adjusted Perk Defs
::Const.Strings.PerkName.RF_BestialVigor = "Backup Plan";
::Const.Perks.findById("perk.rf_bestial_vigor").Name = ::Const.Strings.PerkName.RF_BestialVigor;

::Const.Strings.PerkName.RF_ConcussiveStrikes = "Shockwave";
::Const.Perks.findById("perk.rf_concussive_strikes").Name = ::Const.Strings.PerkName.RF_ConcussiveStrikes;

::Const.Strings.PerkName.RF_DeepImpact = "Breakthrough";
::Const.Perks.findById("perk.rf_deep_impact").Name = ::Const.Strings.PerkName.RF_DeepImpact;

::Const.Strings.PerkName.RF_Hybridization = "Toolbox";
local hybridizationPerkDef = ::Const.Perks.findById("perk.rf_hybridization");
hybridizationPerkDef.Name = ::Const.Strings.PerkName.RF_Hybridization;
hybridizationPerkDef.Icon = "ui/perks/perk_hd_toolbox.png";	// Give Toolbox a new perk icon, so we can reuse the hybridization art
hybridizationPerkDef.IconDisabled = "ui/perks/perk_hd_toolbox_sw.png";	// Give Toolbox a new perk icon, so we can reuse the hybridization art

::Const.Strings.PerkName.RF_Poise = "Flexible";
::Const.Perks.findById("perk.rf_poise").Name = ::Const.Strings.PerkName.RF_Poise;
::Const.Perks.findById("perk.rf_poise").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Strings.PerkName.RF_KingOfAllWeapons = "Spear Flurry";
::Const.Perks.findById("perk.rf_king_of_all_weapons").Name = ::Const.Strings.PerkName.RF_KingOfAllWeapons;

::Const.Strings.PerkName.RF_Rattle = "Full Force";
::Const.Perks.findById("perk.rf_rattle").Name = ::Const.Strings.PerkName.RF_Rattle;

::Const.Strings.PerkName.RF_SteadyBrace = "Ready to go";
::Const.Perks.findById("perk.rf_steady_brace").Name = ::Const.Strings.PerkName.RF_SteadyBrace;

::Const.Strings.PerkName.RF_SwiftStabs = "Hit and Run";
::Const.Perks.findById("perk.rf_swift_stabs").Name = ::Const.Strings.PerkName.RF_SwiftStabs;

::Const.Perks.findById("perk.rf_dismantle").Icon = "ui/perks/perk_13.png";		// Unused vanilla shield-destroy icon
::Const.Perks.findById("perk.rf_dismantle").IconDisabled = "ui/perks/perk_13_sw.png";
::Const.Perks.findById("perk.rf_sanguinary").Icon = "ui/perks/perk_rf_mauler.png";
::Const.Perks.findById("perk.rf_sanguinary").IconDisabled = "ui/perks/perk_rf_mauler_sw.png";
::Const.Perks.findById("perk.rf_mauler").Icon = "ui/perks/perk_rf_sanguinary.png";
::Const.Perks.findById("perk.rf_mauler").IconDisabled = "ui/perks/perk_rf_sanguinary_sw.png";

::Const.Perks.findById("perk.battle_forged").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Perks.findById("perk.nimble").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}
