::Hardened.HooksMod.hook("scripts/skills/perks/perk_inspiring_presence", function(q) {
	q.m.BonusActionPoints <- 3;		// This many Action Points are given to adjacent allies

	q.create = @(__original) function()
	{
		__original();
		this.m.IsHidden = true;	// There is no more additional conditional info to be presented, that's not already on the perk
	}

	q.onNewRound = @(__original) function()
	{
		__original();

		local actor = this.getContainer().getActor();
		local adjacentFactionAllies = ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1, true);
		foreach (ally in adjacentFactionAllies)
		{
			if (ally.getCurrentProperties().getBravery() > actor.getCurrentProperties().getBravery()) continue;
			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
			if (ally.getCurrentProperties().IsStunned) continue;

			local adjacentEnemies = ::Tactical.Entities.getHostileActors(ally.getFaction(), ally.getTile(), 1, true);
			if (adjacentEnemies.len() != 0)	// We found adjacent enemies
			{
				local skill = ::new("scripts/skills/effects/hd_inspiring_presence_buff_effect");
				skill.m.BonusActionPoints = this.m.BonusActionPoints;
				ally.getSkills().add(skill);
				continue;
			}
		}
	}
});
