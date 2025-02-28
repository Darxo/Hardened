// This is loaded BEFORE perks_adjusted.nut is loaded
// New Hardened Perk Defs
::DynamicPerks.Perks.addPerks([{
	ID = "perk.hd_hybridization",
	Script = "scripts/skills/perks/perk_hd_hybridization",
	Name = ::Const.Strings.PerkName.HD_Hybridization,
	Tooltip = ::Const.Strings.PerkDescription.HD_Hybridization,
	Icon = "ui/perks/perk_rf_hybridization.png",
	IconDisabled = "ui/perks/perk_rf_hybridization_sw.png",
}]);

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
