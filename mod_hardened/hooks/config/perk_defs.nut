// This is loaded BEFORE perks_adjusted.nut is loaded
// New Hardened Perk Defs
::DynamicPerks.Perks.addPerks([
	{
		ID = "perk.hd_hybridization",
		Script = "scripts/skills/perks/perk_hd_hybridization",
		Name = ::Const.Strings.PerkName.HD_Hybridization,
		Tooltip = ::Const.Strings.PerkDescription.HD_Hybridization,
		Icon = "ui/perks/perk_rf_hybridization.png",
		IconDisabled = "ui/perks/perk_rf_hybridization_sw.png",
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
]);

::Const.Perks.findById("perk.rf_dismantle").Icon = "ui/perks/perk_13.png";
::Const.Perks.findById("perk.rf_dismantle").IconDisabled = "ui/perks/perk_13_sw.png";

::Const.Perks.findById("perk.rf_poise").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Perks.findById("perk.battle_forged").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Perks.findById("perk.nimble").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}
