::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_hex", function(q) {
	// Overwrite, because there is no way to otherwise the usage of queryTargetValue
	q.findBestTarget = @() function( _entity, _targets )
	{
		local myTile = _entity.getTile();
		local knownAllies = this.getAgent().getKnownAllies();
		local bestScore = 0.0;
		local bestTarget;
		local dotDamage = 0;

		foreach (dot in _entity.getSkills().getAllSkillsOfType(::Const.SkillType.DamageOverTime))
		{
			dotDamage += dot.getDamage();
		}

		foreach (opponent in _targets)
		{
			local target = opponent.Actor;
			local opponentTile = target.getTile();
			if (!this.m.Skill.isUsableOn(opponentTile)) continue;

			if (target.getSkills().hasSkill("effects.hex")) continue;

			local score = 10.0;
			score *= (target.getHitpointsPct() * (100.0 / target.getHitpoints()));
			score *= (1.0 + target.getLevel() * ::Const.AI.Behavior.HexCharacterLevelMult);

			if (target.getHitpoints() <= dotDamage) score *= ::Const.AI.Behavior.HexDOTCanKillMult;

			if (target.isPlayerControlled())
			{
				if (target.getLevel() <= 2 && this.getStrategy().getAveragePlayerLevel() >= 6 && target.getArmorMax(::Const.BodyPart.Body) + target.getArmorMax(::Const.BodyPart.Head) <= this.getStrategy().getAveragePlayerArmor() * 0.4)
				{
					score *= ::Const.AI.Behavior.LikelyPlayerBaitMult;
				}
			}

			if (this.getAgent().getForcedOpponent() != null && this.getAgent().getForcedOpponent().getID() == target.getID())
			{
				score *= 100.0;
			}

			if (target.getSkills().hasSkill("actives.indomitable"))
			{
				score *= ::Const.AI.Behavior.HexAgainstIndomitable;
			}

			if (this.isKindOf(target, "player") || this.isKindOf(target, "firstborn") || this.isKindOf(target, "envoy"))
			{
				score *= ::Const.AI.Behavior.HexPreferPlayerMult;
			}

			if (target.getSkills().hasSkill("effects.charmed") && !this.isKindOf(target, "player"))
			{
				score *= ::Const.AI.Behavior.HexNotAGoodTargetMult;
			}

			// Feat: We now call queryTargetValue instead of just multiplying with TargetAttractionMult
			score *= this.queryTargetValue(_entity, target, this.m.Skill);

			if (score > bestScore)
			{
				bestScore = score;
				bestTarget = target;
			}
		}

		return {
			Target = bestTarget,
			Score = bestScore * 0.1,
		};

		return __original(_entity, _targets);
	}
});
