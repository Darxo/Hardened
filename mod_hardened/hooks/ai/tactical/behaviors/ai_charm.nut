::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_charm", function(q) {
	// Overwrite, because there is no way to otherwise the usage of queryTargetValue
	q.findBestTarget = @() function( _entity, _targets )	// Function is a generator.
	{
		local myTile = _entity.getTile();
		local bestScore = 0.0;
		local bestTarget;
		local time = ::Time.getExactTime();

		foreach (opponent in _targets)
		{
			if (this.isAllottedTimeReached(time))
			{
				yield null;
				time = ::Time.getExactTime();
			}

			local target = opponent.Actor;
			local opponentTile = opponent.Actor.getTile();
			if (!this.m.Skill.isUsableOn(opponentTile)) continue;

			if (target.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
			if (target.getCurrentProperties().IsStunned) continue;
			if (!target.getCurrentProperties().IsAbleToUseWeaponSkills) continue;
			if (target.getSkills().hasSkill("effects.charmed")) continue;

			local score = 100.0;
			score += target.getLevel() * ::Const.AI.Behavior.CharmLevelMult;

			local isRangedOpponent = this.isRangedUnit(target);
			if (isRangedOpponent)
			{
				score += target.getCurrentProperties().getRangedSkill() * ::Const.AI.Behavior.CharmSkillMult;
			}
			else
			{
				score += target.getCurrentProperties().getMeleeSkill() * ::Const.AI.Behavior.CharmSkillMult;
			}

			score += target.getCurrentProperties().getMeleeDefense() * ::Const.AI.Behavior.CharmDefenseSkillMult;
			local distanceToTarget = myTile.getDistanceTo(opponentTile);
			score -= distanceToTarget * ::Const.AI.Behavior.CharmDistanceMult;

			{	// Can we help out some important ally with our charm?
				local targets = 0;
				foreach (t in this.queryEnemiesInMeleeRange(1, target.getIdealRange(), target))
				{
					if (t.getID() != _entity.getID() && t.getCurrentProperties().TargetAttractionMult > 1.0)
					{
						++targets;
					}
				}
				score += targets * ::Const.AI.Behavior.CharmHelpOther;
			}

			score *= ::Math.maxf(0.2, 1.0 - ::Const.AI.Behavior.CharmBraveryMult * target.getBravery() * target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] * 0.01);

			if (target.getCurrentProperties().IsRooted && opponentTile.getZoneOfOccupationCount(target.getFaction()) == 0 && !target.isArmedWithRangedWeapon())
			{
				score *= ::Const.AI.Behavior.CharmRootedMult;
			}

			if (target.isArmedWithRangedWeapon() && opponentTile.getZoneOfOccupationCount(target.getFaction()) != 0)
			{
				score *= ::Const.AI.Behavior.CharmRangedWouldBeInZOCMult;
			}

			if (distanceToTarget <= target.getIdealRange())
			{
				score *= ::Const.AI.Behavior.CharmMeleeDangerMult;
			}

			if (this.m.Danger.Danger <= 2 && this.m.Danger.PotentialDanger.find(target.getID()) != 0)
			{
				score *= ::Const.AI.Behavior.CharmRemoveDangerMult;
			}

			if (target.getType() == ::Const.EntityType.Wardog || target.getType() == ::Const.EntityType.Warhound)
			{
				score *= ::Const.AI.Behavior.CharmWardogMult;
			}

			if (target.getCurrentProperties().MoraleCheckBraveryMult[::Const.MoraleCheckType.MentalAttack] >= 1000.0)
			{
				score *= ::Const.AI.Behavior.CharmImmuneMult;
			}

			if (!isRangedOpponent)
			{
				local targetsScore = 1.0;
				local targets = 0;
				local targetsNotLockedDown = 0;
				foreach (t in this.queryAlliesInMeleeRange(1, target.getIdealRange(), target))
				{
					local s = this.queryTargetValue(target, t);
					targetsScore = targetsScore + s;
					++targets;

					if (t.getTile().getZoneOfControlCountOtherThan(t.getAlliedFactions()) == 0)
					{
						++targetsNotLockedDown;
					}
				}

				score *= (1.0 + (targetsScore + targetsNotLockedDown * ::Const.AI.Behavior.CharmTargetLockdownMult) * ::Const.AI.Behavior.CharmTargetsMult);

				if (targets > 1 && target.isArmedWithMeleeWeapon() && target.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).isAoE())
				{
					score *= ::Const.AI.Behavior.CharmAoEMult;
				}
			}
			else
			{
				score *= ::Const.AI.Behavior.CharmRangedTargetMult;
			}

			local currentZOC = opponentTile.getZoneOfControlCountOtherThan(target.getAlliedFactions());
			if (currentZOC >= 3 || currentZOC >= 2 && target.getHitpointsPct() <= 0.25)
			{
				score *= ::Const.AI.Behavior.CharmEasierToKillMult;
			}

			if (target.isAbleToWait() && !target.isTurnDone())
			{
				score *= ::Const.AI.Behavior.CharmStillToActMult;
			}
			else if (!target.isAbleToWait() && target.getActionPoints() < target.getActionPointsMax())
			{
				score *= ::Const.AI.Behavior.CharmAlreadyWaitedMult;
			}

			if (!target.isArmed() && target.getTile().Items.len() == 0)
			{
				score *= ::Const.AI.Behavior.CharmTargetUnarmedMult;
			}

			if (target.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand) != null && target.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getID() == "weapon.wooden_stick")
			{
				if (!target.getSkills().hasSkill("perk.quick_hands"))
				{
					score *= ::Const.AI.Behavior.CharmTargetWoodenClubRightNowMult;
				}

				local items = target.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
				local hasWeapon = false;

				foreach( item in items )
				{
					if (item.isItemType(::Const.Items.ItemType.Weapon) && item.getID() != "weapon.wooden_stick")
					{
						hasWeapon = true;
						break;
					}
				}

				if (!hasWeapon)
				{
					score *= ::Const.AI.Behavior.CharmTargetWoodenClubOnlyMult;
				}
			}

			// Feat: We now call queryTargetValue instead of just multiplying with TargetAttractionMult
			score *= this.queryTargetValue(_entity, target, this.m.Skill);

			if (target.getCurrentProperties().NegativeStatusEffectDuration < 0)
			{
				score *= ::Const.AI.Behavior.CharmLowerDurationMult;
			}

			if (score > bestScore)
			{
				bestScore = score;
				bestTarget = target;
			}
		}

		if (bestTarget != null)
		{
			this.m.TargetTile = bestTarget.getTile();
			this.m.ScoreBonus = bestScore * 0.1;
		}

		return true;
	}
});
