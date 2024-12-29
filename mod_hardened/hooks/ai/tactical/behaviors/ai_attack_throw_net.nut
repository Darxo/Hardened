::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_attack_throw_net", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		local generator = __original(_entity);	// Get the original generator

		local ret = resume generator;	// Variable to hold the value yielded by the generator

		// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}

		if (ret != ::Const.AI.Behavior.Score.Zero)	// We need the ret != null check because onEvaluate is a generator
		{
			if (this.getStrategy().isDefending())
			{
				return ::Const.AI.Behavior.Score.Zero;	// Never throw net prematurely while your faction is still defending
			}

			foreach (opponent in this.getStrategy().getKnownOpponents())
			{
				local targetDistance = _entity.getTile().getDistanceTo(opponent.Actor.getTile());
				if (targetDistance == 1)
				{
					ret *= ::Const.AI.Behavior.OffhandDiscardDoubleGripMult;
					break;
				}
			}
		}

		return ret;
	}

	// Overwrite to split vanilla function into two
	q.findBestTarget = @() function( _entity, _targets, _bestTarget )	// Function is a generator.
	{
		local bestTarget;
		local bestScore = -9000.0;
		local knownAllies = this.getAgent().getKnownAllies();
		local knownOpponents = this.getStrategy().getKnownOpponents();
		local time = ::Time.getExactTime();
		local currentScore;

		foreach (target in _targets)
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = this.Time.getExactTime();
			}

			currentScore = this.evaluateTargetScore(target, knownAllies, knownOpponents);

			if (currentScore != null && currentScore > bestScore)
			{
				bestScore = currentScore;
				bestTarget = target;

			}
		}

		_bestTarget.Target = bestTarget;
		_bestTarget.Score = bestScore;
		return true;
	}

// New Functions
	/*
	 * Removed from Vanilla:
	 * - Remove support for ThrowNetVSWardogsMult. The score for those is already super low because of their TargetAttractionMult
	 * - Remove support for ThrowNetToSetupDeathblowMult. It's a cool idea but way too hard-coded. Its not realistic to support that moving forward for other skills
	 * - Remove support for ThrowNetVSAdrenalineMult. I don't quite understand it and it's too hard-coded anyways
	 * - Rooted/Immune to Rooted checks are removed. Those should be done by the skill anyways
	 *
	 * Changes compared to Vanilla:
	 * - Score now starts at 0 (down from 1).
	 * - Melee Defense now counts for the score
	 *
	 * Additions:
	 * - Presence of nearby allies of the target are taken into account
	 * - Presence of nearby hostiles of the target are taken into account
	 */
	q.evaluateTargetScore <- function( _target, _knownAllies, _knownOpponents )
	{
	// Potential skips
		if (_target.getHitpoints() <= ::Const.AI.Behavior.ThrowNetMinHitpoints) return null;
		if (_target.getCurrentProperties().TargetAttractionMult < ::Const.AI.Behavior.ThrowNetMinAttaction) return null;

		local targetTile = _target.getTile();
		if (!this.m.Skill.isUsableOn(targetTile)) return null;

	// Score Modifier / Reasons to net in the first place
		local score = _target.getCurrentProperties().getMeleeDefense() * ::Const.AI.Behavior.ThrowNetMeleeDefenseMult;
		// score += _target.getCurrentProperties().getInitiative() * ::Const.AI.Behavior.ThrowNetInitiativeMult;

		score = score - targetTile.TVTotal * ::Const.AI.Behavior.ThrowNetTVMult;

		if (targetTile.IsBadTerrain)
		{
			score += ::Const.AI.Behavior.ThrowNetBadTerrainBonus;
		}

		if (this.hasNegativeTileEffect(targetTile, _target))
		{
			score += ::Const.AI.Behavior.ThrowNetBadTerrainBonus;
		}

		if (!_target.hasRangedWeapon())
		{
			score += ::Const.AI.Behavior.ThrowNetNoRangedWeaponBonus;
		}

		// Can my net protect an allied ranged unit from that enemy?
		if (targetTile.getZoneOfControlCountOtherThan(_target.getAlliedFactions()) == 0)
		{
			foreach( ally in _knownAllies )
			{
				if (ally.getCurrentProperties().TargetAttractionMult <= 1.0 && !this.isRangedUnit(ally))
				{
					continue;
				}

				local d = this.queryActorTurnsNearTarget(_target, ally.getTile(), _target);

				if (d.Turns <= 1.0)
				{
					score += ::Const.AI.Behavior.ThrowNetProtectPriorityTargetBonus;
				}
			}
		}

		{	// If the _target can't currently hit any ally then we wanna keep it that way with a net
			local canHit = false;	// Can that _target hit any of my allies?
			local targetIdealRange = _target.getIdealRange();
			foreach (ally in _knownAllies)
			{
				if (targetTile.getDistanceTo(ally.getTile()) <= targetIdealRange)
				{
					canHit = true;
					break;
				}
			}
			if (!canHit) score += ::Const.AI.Behavior.ThrowNetCantAttackAnyoneBonus;
		}

	// Score Multiplier / Reasons to amplify the reasons above
		score *= _target.getCurrentProperties().TargetAttractionMult;

		foreach (ally in _knownAllies)
		{
			local targetDistance = targetTile.getDistanceTo(ally.getTile());
			if (targetDistance <= 3)
			{
				// Every nearby hostile of the _target (which all our allies are) changes the score. The closer the more
				score *= ::Math.pow(::Const.AI.Behavior.ThrowNetTargetHostileHeatMult, 3 - targetDistance);
			}
		}

		foreach (opponent in _knownOpponents)
		{
			if (opponent.Actor.getID() == _target.getID())
			{
				continue;
			}

			local targetDistance = targetTile.getDistanceTo(opponent.Actor.getTile());
			if (targetDistance <= 3)
			{
				if (_target.isAlliedWith(opponent.Actor))	// Every nearby hostile of the _target changes the score. The closer the more
				{
					score *= ::Math.pow(::Const.AI.Behavior.ThrowNetTargetHostileHeatMult, 3 - targetDistance);
				}
				else	// Every nearby hostile of the _target changes the score. The closer the more
				{
					score *= ::Math.pow(::Const.AI.Behavior.ThrowNetTargetAllyHeatMult, 3 - targetDistance);
				}
			}
		}

		return score;
	}
});
