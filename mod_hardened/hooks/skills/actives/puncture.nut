::mods_hookExactClass("skills/actives/puncture", function(o) {

	local oldGetTooltip = o.getTooltip;
	o.getTooltip = function()
	{
		local ret = oldGetTooltip();

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "Target must be surrounded by atleast two enemies"
		})

		return ret;
	}

	o.onVerifyTarget <- function( _originTile, _targetTile )
	{
		local ret = o.skill.onVerifyTarget(_originTile, _targetTile);
		if (ret == false) return false;

		return (_targetTile.getEntity().m.MaxEnemiesThisTurn >= 2);
	}
});
