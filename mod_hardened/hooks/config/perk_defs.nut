// This is loaded BEFORE perks_adjusted.nut is loaded

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
	if (_player.getPerkTier() >= 8)
	{
		_tooltip.push({
			id = 20,
			type = "hint",
			icon = "ui/icons/icon_locked.png",
			text = "Locked because this character has already unlocked all perk tiers"
		});

		return false;
	}

	return true;
}
