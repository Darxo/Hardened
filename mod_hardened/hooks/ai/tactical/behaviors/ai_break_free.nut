::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_break_free", function(q) {
	// Overwrite because we fix a vanilla bug and use the opportunity to
	//	- Make Break Free less likely while in ZoC, the lower the chance to break free is
	//	- Make Break Free 1% more likely to be used for every point of Melee Defense above 0
	//	- Fix Vanilla stopping trying to break free, if the break free chance is 30% or less and the character is in zone of control. This causes fleeing characters to stop doing anything in some situations
	q.onEvaluate = @() function( _entity )
	{
		local zero = ::Const.AI.Behavior.Score.Zero;

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return zero;
		if (!_entity.getCurrentProperties().IsRooted) return zero;

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);
		if (this.m.Skill == null) return zero;

		// A player character will ignore this behavior, unless he is fleeing or retreating
		if (_entity.isPlayerControlled() && _entity.getMoraleState() != ::Const.MoraleState.Fleeing && !::Tactical.State.isAutoRetreat()) return zero;

		// A fleeing character will always want to break free
		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return ::Const.AI.Behavior.Score.BreakFree;
		// A retreating player character will always want to break free
		if (_entity.isPlayerControlled() && ::Tactical.State.isAutoRetreat()) return ::Const.AI.Behavior.Score.BreakFree;

		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		scoreMult *= this.getFatigueScoreMult(this.m.Skill);

		// Feat: The current Melee Defense on our character might make it more likely that we want to use break free
		scoreMult *= ::Math.maxf(1.0, (1.0 + _entity.getCurrentProperties().getMeleeDefense() / 100));

		// While in Zone of Control, we are 1% less likely to break free, for each 1% chance to break free below 100%
		// This mirrors the vanilla check, where they fully prevent breaking free at a chance of 30% or below while in zone of control
		if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
		{
			scoreMult *=  ::Math.maxf(0.0, this.m.Skill.getChance() / 100.0);
		}

		return ::Const.AI.Behavior.Score.BreakFree * scoreMult;
	}
});
