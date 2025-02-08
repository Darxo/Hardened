// This hook also removes the natural hitchance bonus from hook but that is exactly what we want
::Hardened.removeTooClosePenalty("scripts/skills/actives/hook");

::Hardened.HooksMod.hook("scripts/skills/actives/hook", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png" && ::String.contains(entry.text, "+10%"))
			{
				ret.remove(index);
				break;
			}
		}

		return ret;
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		return ret && !_targetTile.getEntity().getCurrentProperties().IsImmuneToKnockBackAndGrab;
	}
});
