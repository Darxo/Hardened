::Hardened.HooksMod.hook("scripts/skills/actives/throw_smoke_bomb_skill", function(q) {
	q.m.SmokeDuration <- 2;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 5 && entry.icon == "ui/icons/special.png")
			{
				local roundInfo = ::MSU.Text.colorizeValue(this.m.SmokeDuration) + " round(s)";
				entry.text = ::MSU.String.replace(entry.text, "one round", roundInfo);
			}
		}

		return ret;
	}

	q.onApply = @(__original) function( _data )
	{
		__original(_data);

		local targets = [];
		targets.push(_data.TargetTile);

		for (local i = 0; i <= 5; ++i)
		{
			if (_data.TargetTile.hasNextTile(i))
			{
				targets.push(_data.TargetTile.getNextTile(i));
			}
		}

		// We check all 7 tiles around the impact for smoke effects, presumably caused by the vanilla onApply function
		// Then we raise the duration to at least the one defined in this file
		foreach (tile in targets)
		{
			if (tile.Properties.Effect != null && tile.Properties.Effect.Type == "smoke" && tile.Properties.Effect.Timeout)
			{
				local newTimeout = ::Time.getRound() + this.m.SmokeDuration;
				if (tile.Properties.Effect.Timeout < newTimeout)
				{
					tile.Properties.Effect.Timeout = newTimeout;
				}
			}
		}
	}
});
