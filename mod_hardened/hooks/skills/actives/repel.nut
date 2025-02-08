// This hook also removes the natural hitchance bonus from repel but that is ok, because we want that removed anyways
::Hardened.removeTooClosePenalty("scripts/skills/actives/repel");

::Hardened.HooksMod.hook("scripts/skills/actives/repel", function(q) {
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
