::Hardened.HooksMod.hook("scripts/skills/actives/puncture", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/warning.png",
			text = "Target must be surrounded by atleast two enemies",
		})

		return ret;
	}

	q.onVerifyTarget <- function( _originTile, _targetTile )
	{
		local ret = this.skill.onVerifyTarget(_originTile, _targetTile);
		if (ret == false) return false;

		return (_targetTile.getEntity().getSurroundedCount() >= 1);		// 1 means that 2 enemies are around that target
	}
});
