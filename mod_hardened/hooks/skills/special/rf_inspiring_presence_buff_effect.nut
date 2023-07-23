::mods_hookExactClass("skills/special/rf_inspiring_presence_buff_effect", function (o) {

	// Complete rewrite of the reforged function even though we only change two lines because that original function is too large
	o.onTurnStart = function()
	{
		local actorHasAdjacentEnemy = function( _actor )
		{
			local adjacentEnemies = ::Tactical.Entities.getHostileActors(_actor.getFaction(), _actor.getTile(), 1, true);
			return adjacentEnemies.len() > 0;
		}

		local actor = this.getContainer().getActor();
		local allies = ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1, true);
		local hasAdjacentEnemy = actorHasAdjacentEnemy(actor);
		local hasInspirer = false;

		foreach (ally in allies)
		{
			if (!hasInspirer)
			{
				local inspiringPresence = ally.getSkills().getSkillByID("perk.inspiring_presence");
				if (inspiringPresence != null && inspiringPresence.isEnabled() && ally.getCurrentProperties().getBravery() > actor.getCurrentProperties().getBravery())	// this line is changed
				{
					hasInspirer = true;
					this.m.BonusActionPoints = inspiringPresence.m.BonusActionPoints;	// this line is new
				}
			}

			if (!hasAdjacentEnemy && actorHasAdjacentEnemy(ally))
			{
				hasAdjacentEnemy = true;
			}
		}

		if (hasInspirer && hasAdjacentEnemy)
		{
			this.m.IsInEffect = true;
			this.m.IsStartingTurn = true;
			this.spawnIcon("rf_inspiring_presence_buff_effect", actor.getTile());
			::Sound.play(this.m.SoundOnUse[this.Math.rand(0, this.m.SoundOnUse.len() - 1)], ::Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos());
		}
	}
});
