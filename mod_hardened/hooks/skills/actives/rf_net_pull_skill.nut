::Hardened.HooksMod.hook("scripts/skills/actives/rf_net_pull_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsAttack = false;	// In Vanilla this is true
		this.m.MaxRange = 3;	// In Reforged this is 2
	}

	q.getTooltip = @(__original) function()	// This will be redundant with the next Reforged update and must be removed then
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/vision.png")
			{
				entry.text = ::MSU.String.replace(entry.text, "]2[", "]3[", true);	// Adjust the range description to match the new range of net pull
				break;
			}
		}

		return ret;
	}

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		local ret = __original(_originTile, _targetTile);

		// This skill is no longer an attack, so we need to manually make sure you can't use it on allies
		if (ret && this.getContainer().getActor().isAlliedWith(_targetTile.getEntity())) ret = false;

		return ret;
	}
});
