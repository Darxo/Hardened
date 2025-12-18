::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_bow", function(q) {
	// Overwrite, because we rewrite the whole function improving readability and fixing bugs
	// Vanilla does not account for queryTargetValue, when trying to select the best target.
	// As a result, the best target is solely decided by scatter bonus. And if scatter bonus is disabled, then the first target in _targets is always chosen
	// Our Changes:
	//	- BestTarget is now decided by the chosen skill
	//	- Rewrite the whole function iterating skills first and targets inside those
	//	- Support ::Const.AI.VerboseMode for more granular debugging logs
	//	- We restrict AttackLineOfFireBlockedMult multiplier to only apply if the blocked tile contains an ally; but apply once for each blocking ally
	q.selectBestTargetAndSkill= @() function( _entity, _targets, _skills )
	{
		if (_skills.len() == 0) return 0.0;	// No skill found

		local bestChoice = {
			Skill = null,
			BestTarget = null,
			Score = -9000.0,
		}

		if (::Const.AI.VerboseMode) ::logWarning("Hardened: selectBestTargetAndSkill for " + _entity.getName());

		local myTile = _entity.getTile();
		foreach (skill in _skills)
		{
			local skillData = {
				Skill = skill,
				BestTarget = null,
				Score = 0.0,
			}

			if (::Const.AI.VerboseMode) ::logInfo("Hardened: calculating score for skill " + skill.getName());
			foreach (target in _targets)
			{
				if (::MSU.isNull(target.Actor)) continue;

				local targetTile = target.Actor.getTile();
				if(!targetTile.IsVisibleForEntity) continue;
				if (!skill.isInRange(targetTile)) continue;
				if (!skill.onVerifyTarget(_entity.getTile(), targetTile)) continue;

				if (::Const.AI.VerboseMode) ::logInfo("Hardened: calculating score against " + target.Actor.getName());
				local targetScore = 0.0;
				local tilesAffected = skill.getAffectedTiles(targetTile);
				foreach (tile in tilesAffected)
				{
					if(!tile.IsOccupiedByActor) continue;

					local affectedTarget = tile.getEntity();
					if(_entity.isAlliedWith(affectedTarget))
					{
						if (this.getProperties().TargetPriorityHittingAlliesMult >= 1.0) continue;

						targetScore -= (1.0 / 6.0) * 4.0 * (1.0 - this.getProperties().TargetPriorityHittingAlliesMult) * affectedTarget.getCurrentProperties().TargetAttractionMult;
					}
					else
					{
						targetScore += queryTargetValue(_entity, affectedTarget, skill);
					}
				}
				if (::Const.AI.VerboseMode) ::logInfo("Hardened: score after queryTargetValue: " + targetScore);

				local blockedTiles = ::Const.Tactical.Common.getBlockedTiles(myTile, targetTile, _entity.getFaction());
				foreach (tile in blockedTiles)
				{
					if (!tile.IsOccupiedByActor) continue;
					if (!tile.getEntity().isAlliedWith(_entity)) continue;

					targetScore *= ::Const.AI.Behavior.AttackLineOfFireBlockedMult;

					// With only one possible diversion target, we have the same chance of hitting an ally as if there were two diversion targets, which were both our allies
					// So we need to apply the AttackLineOfFireBlockedMult twice in this case
					if (blockedTiles.len() == 1) targetScore *= ::Const.AI.Behavior.AttackLineOfFireBlockedMult;
				}
				if (::Const.AI.VerboseMode) ::logInfo("Hardened: score after lineOfFire: " + targetScore);

				if (myTile.getDistanceTo(targetTile) > 2) // divert only at >2 tiles, see skill!
				{
					for (local i = 0; i < ::Const.Direction.COUNT; ++i)
					{
						if (!targetTile.hasNextTile(i)) continue;

						local tile = targetTile.getNextTile(i);
						if (tile.IsEmpty) continue;
						if (!tile.IsOccupiedByActor) continue;

						if(tile.getEntity().isAlliedWith(_entity))
						{
							if (this.getProperties().TargetPriorityHittingAlliesMult >= 1.0) continue;

							targetScore -= (1.0/6.0) * 4.0 * (1.0 - this.getProperties().TargetPriorityHittingAlliesMult) * tile.getEntity().getCurrentProperties().TargetAttractionMult;
						}
						else if (::Const.AI.Behavior.AttackRangedHitBystandersMult != 0.0)	// Optimization to prevent needless queryTargetValue calculations
						{
							targetScore += (1.0/6.0) * queryTargetValue(_entity, tile.getEntity(), null) * ::Const.AI.Behavior.AttackRangedHitBystandersMult;
						}
					}
				}
				if (::Const.AI.VerboseMode) ::logInfo("Hardened: score after divertCalculation: " + targetScore);

				// prioritize danger
				if (targetTile.getZoneOfControlCount(_entity.getFaction()) < ::Const.AI.Behavior.RangedEngageIgnoreDangerMinZones)
				{
					targetScore *= 1.0 + (1.0 - Math.minf(1.0, queryActorTurnsNearTarget(target.Actor, myTile, _entity).Turns)) * ::Const.AI.Behavior.AttackDangerMult;
				}

				if (targetScore > skillData.Score)
				{
					if (::Const.AI.VerboseMode) logInfo("Hardened: new best score for " + skillData.Skill.getName() + " and target " + target.Actor.getName() + ": " + targetScore);
					skillData.Score = targetScore;
					skillData.BestTarget = target;
				}
			}

			if (skillData.Score > bestChoice.Score)
			{
				bestChoice.Skill = skillData.Skill;
				bestChoice.BestTarget = skillData.BestTarget;
				bestChoice.Score = skillData.Score;
			}
		}

		if (bestChoice.BestTarget == null) return 0.0;

		this.m.TargetTile = bestChoice.BestTarget.Actor.getTile();
		this.m.SelectedSkill = bestChoice.Skill;

		if (::Const.AI.VerboseMode) ::logInfo("Hardened: BestTarget " + bestChoice.BestTarget.Actor.getName() + " BestScore " + bestChoice.Score);

		return Math.maxf(0.1, bestChoice.Score);
	}
});
