/*
Stances share in common that you wanna use them as preparation for action
- there are a lot of potential melee targets
- you have nothing better to do (defending, hiding)

It's a bad idea to use a stance skill when
- it costs equal or more than your maximum actionpoints -4 (e.g. Zombies)
- you are engaged in battle
- there are a lot of enemy ranged troops nearby that need to be engaged asap
- you are almost dead
*/
this.hd_ai_defend_stance <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		PossibleSkills = [
			"actives.hd_whirling_death",
		],
		Skill = null,
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.HD_Defend_Stance;
		this.m.Order = ::Const.AI.Behavior.Order.HD_Defend_Stance;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.Skill = null;
		local zero = ::Const.AI.Behavior.Score.Zero;

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return zero;	// Todo: What does this even do?

		// Generic Rules
		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return zero;
		if (!this.getAgent().hasKnownOpponent()) return zero;
		if (::Tactical.State.isAutoRetreat()) return zero;

		// Pick a Skill
		this.m.Skill = this.selectSkill(this.m.PossibleSkills);
		if (this.m.Skill == null) return zero;

		if (_entity.getActionPointsMax() < 9) return zero;	// We shouldn't even think about defensive stances if they leave barely any action points for movement (e.g. Zombies)

		// Do I die this turn?
		local dotDamage = 0;
		local effects = _entity.getSkills().getAllSkillsOfType(::Const.SkillType.DamageOverTime);
		foreach (dot in effects)
		{
			dotDamage = dotDamage + dot.getDamage();
		}
		if (dotDamage >= _entity.getHitpoints()) return zero;

		// Start calculating the score
		local score = ::Const.AI.Behavior.Score.HD_Defend_Stance * this.getProperties().BehaviorMult[this.m.ID];
		score *= this.getFatigueScoreMult(this.m.Skill);

		if (!this.getStrategy().isDefending()) score *= 0.66;	// While on the offensive, we are less likely to consider this skill

		score *= this.HD_getSkillScoreMult(_entity, this.m.Skill);

		local adjacentTargets = this.queryTargetsInMeleeRange();
		if (adjacentTargets.len() >= 2) score *= 0.2;	// There is a small change, that we have some leftover Action Points and cant do anything else anyways, after we moved up
		if (adjacentTargets.len() == 1) score *= 0.5;	// We don't want to outright prohibit this skill if there is only 1 enemy adjacent

		if (adjacentTargets.len() == 0)	// We are not engaged in battle
		{
			local opponentRangedCount = 0;	// Ranged Enemies make it less likely, that we use a stance
			local opponentsWeCouldHit = 0;	// Enemies, that we could hit right now make it less likely, that we use a stance instead
			local opponentMeleeCount = 0;	// Remaining nearby enemies make it more likely, that we use a stance

			foreach (opponent in this.getAgent().getKnownOpponents())
			{
				local actor = opponent.Actor;

				if (actor.isNull()) continue;
				if (actor.isNonCombatant()) continue;

				if (actor.getMoraleState() == ::Const.MoraleState.Fleeing) continue;

				local dist = actor.getTile().getDistanceTo(_entity.getTile());

				// opponent is a ranged unit
				if (this.isRangedUnit(actor))
				{
					local rangedInfo = actor.getRangedWeaponInfo();
					if (dist <= rangedInfo.RangeWithLevel)
					{
						++opponentRangedCount;
					}
				}
				else if (dist <= 5)
				{
					local turnData = this.queryActorTurnsNearTarget(_entity, actor.getTile(), actor);
					if (turnData.TurnsWithAttack <= 1.0)	// Can we attack opponent this turn? Then we should probably not use the stance
					{
						++opponentsWeCouldHit;
					}
					else
					{
						++opponentMeleeCount;
					}
				}
			}
			if (opponentMeleeCount == 0) return zero;	// There seem to be no nearby melee targets to prepare for via a Stance

			score *= ::Math.pow(::Const.AI.Behavior.StanceRangedTargetMult, opponentRangedCount);
			score *= ::Math.pow(::Const.AI.Behavior.StanceRangedTargetMult, opponentsWeCouldHit);	// We just use the ranged multiplier here as it's similar to what we wanna achieve
			score *= ::Math.pow(::Const.AI.Behavior.StanceMeleeTargetMult, opponentMeleeCount);
		}

		score *= _entity.getHitpointsPct();	// If the actor is almost dead, he won't survive to make use of the stance anyways

		// Intentions
		local intentions = this.getAgent().getIntentions();
		if (intentions.IsDefendingPosition) score *= 1.5;	// We have nothing better to do while defending anyways
		if (intentions.IsEngaging) 			score *= 0.5;	// When we decided to engage, it's probably too late to sneak in a stance
		if (intentions.IsHiding) 			score *= 1.5;	// We have nothing better to do while hiding anyways
		if (intentions.IsKnockingBack) 		score *= 1.5;	// In preparation of that enemy engaging again, we probably wanna use a stance

		return score;
	}

	function onExecute( _entity )
	{
		if (::Const.AI.VerboseMode)
		{
			::logInfo("* " + _entity.getName() + ": Using Stance!");
		}

		this.m.Skill.use(_entity.getTile());

		if (!_entity.isHiddenToPlayer())
		{
			this.getAgent().declareAction();
		}

		this.m.Skill = null;
		return true;
	}

// New Functions
	// @param _skill is the chosen possible active skill, we consider to execute. It must not be null
	function HD_getSkillScoreMult( _entity, _skill )
	{
		if (_skill.getID() == "hd_whirling_death_skill")
		{
			local whirlingDeathEffect = _entity.getSkills().getSkillByID("hd_whirling_death_effect");
			if (whirlingDeathEffect != null)
			{
				if (whirlingDeathEffect.m.HD_LastsForTurns == 1)
				{
					return 1.2;	// The effect is almost gone! Better keep it alive, while it is cheap
				}
				else
				{
					return 0.5;	// The effect still lasts some time, we can just wait
				}
			}
		}

		return 1.0;
	}
});
