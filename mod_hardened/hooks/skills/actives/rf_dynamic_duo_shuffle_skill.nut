::Hardened.HooksMod.hook("scripts/skills/actives/rf_dynamic_duo_shuffle_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 11)
			{
				ret.text = "Swap places with your partner";
				break;
			}
		}

		return ret;
	}

	// Overwrite because we dont move the target to the front of the turn sequence bar
	q.onUse = @() function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();
		::Tactical.getNavigator().switchEntities(_user, target, null, null, 1.0);
		this.m.IsSpent = true;
		return true;
	}
});
