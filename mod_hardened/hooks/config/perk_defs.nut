::Const.Perks.findById("perk.rf_discovered_talent").verifyPrerequisites <- function( _player, _tooltip )
{
	if (_player.getLevelUps() > 0)
	{
		_tooltip.push({
			id = 3,
			type = "hint",
			icon = "ui/icons/icon_locked.png",
			text = "Locked because this character must first spend all current attribute rolls"
		});
		return false;
	}

	return true;
}
