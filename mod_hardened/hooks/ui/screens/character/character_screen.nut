::Hardened.HooksMod.hook("scripts/ui/screens/character/character_screen", function(q) {
	q.m.DistributedXPFraction <- 0.5;
	q.m.MaximumXPFractionPerBrother <- 0.05;

	q.onDismissCharacter = @(__original) function( _data )
	{
		local bro = ::Tactical.getEntityByID(_data[0]);
		local payCompensation = _data[1];

		if (bro != null && payCompensation)
		{
			local roster = this.World.getPlayerRoster().getAll();
			local brotherCount = roster.len() - 1;

			local maximumXP = bro.getXP() * this.m.MaximumXPFractionPerBrother;
			local xpPerBrother = ::Math.min(maximumXP, (bro.getXP() * this.m.DistributedXPFraction) / brotherCount);

			foreach (otherBro in roster)
			{
				if (otherBro != bro)
				{
					otherBro.addXP(xpPerBrother, false);	// This xp does not scale with other modifiers. It already scaled with them when it was first acquired
					otherBro.updateLevel();
				}
			}
		}

		__original(_data);
	}
});
