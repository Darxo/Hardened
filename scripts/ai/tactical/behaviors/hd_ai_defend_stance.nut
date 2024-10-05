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

		if (_entity.getActionPointsMax() - this.m.Skill.getActionPointCost() < 4) return zero;	// We shouldn't even think about defensive stances if they leave barely any action points for movement (e.g. Zombies)

		// Do I die this turn?
		local dotDamage = 0;
		local effects = _entity.getSkills().getAllSkillsOfType(::Const.SkillType.DamageOverTime);
		foreach (dot in effects)
		{
			dotDamage = dotDamage + dot.getDamage();
		}
		if (dotDamage >= _entity.getHitpoints()) return zero;

		// Start calculating the score
		local score = this.Const.AI.Behavior.Score.HD_Defend_Stance * this.getProperties().BehaviorMult[this.m.ID];
		score *= this.getFatigueScoreMult(this.m.Skill);

		local adjacentTargets = this.queryTargetsInMeleeRange();
		if (adjacentTargets.len() >= 2) return zero;
		if (adjacentTargets.len() == 1) score *= 0.5;	// I don't want to outright prohibit this skill if there is only 1 enemy adjacent

		// We are not engaged in battle
		local opponentMeleeCount = 0;
		local opponentRangedCount = 0;
		foreach (opponent in this.getAgent().getKnownOpponents())
		{
			local actor = opponent.Actor;

			if (actor.isNull()) continue;
			if (actor.isNonCombatant()) continue;

			if (actor.getMoraleState() == ::Const.MoraleState.Fleeing) continue;

			local dist = actor.getTile().getDistanceTo(_entity.getTile());

			// opponent is a ranged unit
			if (actor.getTile().getZoneOfControlCountOtherThan(actor.getAlliedFactions()) == 0 && this.isRangedUnit(actor))
			{
				local rangedInfo = actor.getRangedWeaponInfo();
				if (dist <= rangedInfo.RangeWithLevel)
				{
					++opponentRangedCount;
				}
			}
			else if (dist <= 4)
			{
				++opponentMeleeCount;
			}
		}
		if (opponentMeleeCount == 0) return zero;	// There seem to be no nearby melee targets to prepare for via a Stance

		score *= ::Math.pow(::Const.AI.Behavior.StanceMeleeTargetMult, opponentMeleeCount);
		score *= ::Math.pow(::Const.AI.Behavior.StanceRangedTargetMult, opponentRangedCount);

		score *= _entity.getHitpointsPct();	// If the actor is almost dead, he won't survive to make use of the stance anyways

		// Intentions
		local intentions = this.getAgent().getIntentions();
		if (intentions.IsDefendingPosition) score *= 1.5;	// We have nothing better to do while defending anyways
		if (intentions.IsEngaging) 			score *= 0.8;	// When we decided to engage, it's probably too late to sneak in a stance
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
});
