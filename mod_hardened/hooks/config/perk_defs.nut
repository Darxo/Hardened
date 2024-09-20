// This is loaded BEFORE perks_adjusted.nut is loaded

::Const.Perks.findById("perk.rf_dismantle").Icon = "ui/perks/perk_13.png";
::Const.Perks.findById("perk.rf_dismantle").IconDisabled = "ui/perks/perk_13_sw.png";

::Const.Perks.findById("perk.rf_poise").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Perks.findById("perk.nimble").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Perks.findById("perk.student").verifyPrerequisites <- function( _player, _tooltip )
{
	if (_player.getLevel() >= 8)
	{
		_tooltip.push({
			id = 20,
			type = "hint",
			icon = "ui/icons/icon_locked.png",
			text = "Locked because this character is already level 8"
		});

		return false;
	}

	return true;
}
