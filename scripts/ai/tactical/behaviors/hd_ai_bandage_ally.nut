this.hd_ai_bandage_ally <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		// Public
		PossibleSkills = [
			"actives.bandage_ally",
		],

		// Private
		SelectedSkill = null,
		Target = null,
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.HD_Bandage_Ally;
		this.m.Order = ::Const.AI.Behavior.Order.HD_Bandage_Ally;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		this.m.SelectedSkill = null;
		this.m.Target = null;

		local zeroScore = ::Const.AI.Behavior.Score.Zero;

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return zeroScore;	// Todo: What does this even do?

		this.m.SelectedSkill = this.selectSkill(this.m.PossibleSkills);
		if (this.m.SelectedSkill == null) return zeroScore;

		local potentialTargets = [];
		foreach (ally in this.getAgent().getKnownAllies())
		{
			if (!ally.isPlacedOnMap()) continue;
			if (!this.m.SelectedSkill.verifyTargetAndRange(ally.getTile())) continue;

			potentialTargets.push(ally);
		}
		if (potentialTargets.len() == 0) return zeroScore;

		local scoreMult = this.selectBestTarget(potentialTargets);

		scoreMult *= this.getProperties().BehaviorMult[this.getID()];

		scoreMult *= this.getFatigueScoreMult(this.m.SelectedSkill);

		scoreMult *= this.HD_queryTargetSkillMult(_entity, this.m.Target, this.m.SelectedSkill);

		return ::Const.AI.Behavior.Score.HD_Bandage_Ally * scoreMult;
	}

	function onExecute( _entity )
	{
		if (::Const.AI.VerboseMode)
		{
			this.logInfo("* " + _entity.getName() + ": Using " + this.m.SelectedSkill.getName() + " on " + this.m.Target.getName() + "!");
		}

		this.m.SelectedSkill.use(this.m.Target.getTile());

		if (!_entity.isHiddenToPlayer())
		{
			this.getAgent().declareAction();
		}

		this.m.SelectedSkill = null;
		this.m.Target = null;
		return true;
	}

// New Functions
	// Given an array of potential targets, we try to choose the one, which needs a bandage the most
	// The best target is written into this.m.Target
	// @param _potentialTargets is an array of actors and must contain at least 1 actor
	// @return bestScoreMult of the chosen target
	function selectBestTarget( _potentialTargets )
	{
		local bestScoreMult = 1.0;
		local bestTarget = _potentialTargets[0];

		foreach (target in _potentialTargets)
		{
			local scoreMult = 1.0;

			foreach (inj in target.getSkills().query(::Const.SkillType.TemporaryInjury))
			{
				if (!inj.isTreatable()) continue;
				if (inj.isTreated()) continue;
				scoreMult *= 1.1;		// For enemies, treating wounds doesnt make much sense they are magically healed after battle for them
			}

			local bleedEffect = target.getSkills().getSkillByID("effects.bleeding");
			if (bleedEffect != null)
			{
				scoreMult *= (1.0 + (0.2 * bleedEffect.m.Stacks));

				scoreMult *= (2.0 - target.getHitpointsPct());	// We are 1% more likely to choose someone for each 1% of hitpoints they are missing
			}

			if (target.isPlayerControlled()) scoreMult *= 3.0;	// AI is artifically much more likely to help out the player

			if (scoreMult > bestScoreMult)
			{
				bestScoreMult = scoreMult;
				bestTarget = target;
			}
		}

		this.m.Target = bestTarget;

		return bestScoreMult;
	}
});
