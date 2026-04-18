::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_retreat", function(q) {
	q.m.HD_AttemptsThisTurn <- 0;

	q.onBeforeExecute = @(__original) function( _entity )
	{
		__original(_entity);

		if (::Hardened.util.willBeAttackedLeavingZoneOfControl(_entity))
		{
			++this.m.HD_AttemptsThisTurn;
		}
	}

	q.onEvaluate = @(__original) function( _entity )	// This function is a generator.
	{
		// Fix: We need to slightly adjust the vanilla ai_retreat behavior, because it looks in a hard coded way for the lindwurm tail
		// 		And in Hardened, the Tail can actually be missing/null, while the head still exists
		local oldEntityType = _entity.getType();
		// Switcheroo to prevent the lindwurm head from checking its tail when that tail does not exist anymore
		if (_entity.getType() == ::Const.EntityType.Lindwurm && ::MSU.isNull(_entity.getTail()))
		{
			_entity.m.Type = 0;
		}

		// If the entity is not in a Zone of Control or is not fleeing, then the vanilla behavior will be used
		local isInZoneOfControl = _entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions());
		if (!isInZoneOfControl || _entity.getMoraleState() != ::Const.MoraleState.Fleeing)
		{
			local generator = __original(_entity);	// Get the original generator
			local ret = resume generator;	// Variable to hold the value yielded by the generator
			_entity.m.Type = oldEntityType;	// The Lindwurm type handling happens during the first loop

			// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
			while (ret == null)
			{
				yield ret;
				ret = resume generator;
			}
			return ret;
		}

		// Feat: We stop NPCs trying to retreat out of zone of control, after a few tries
		if (_entity.getFaction() != ::Const.Faction.Player)
		{
			// This condition is new, we now use a similar attemts counter as ai_flee
			if (this.m.HD_AttemptsThisTurn >= ::Const.AI.Agent.MaxFleeAttemptsPerTurn) return ::Const.AI.Behavior.Score.Zero;

			// We call this copy of a vanilla check early, because it can otherwise interfere with our mockObject, triggering it early
			if (::Const.AI.NoRetreatMode) return ::Const.AI.Behavior.Score.Zero;
			if (::Tactical.State.getStrategicProperties() != null && ::Tactical.State.getStrategicProperties().IsArenaMode) return ::Const.AI.Behavior.Score.Zero;
		}

		// Vanilla Fix: A fleeing actor will skip zone of control checks, so that they are able to escape when close to the border
		// Our goal is to prevent vanilla from returning Zero, when _entity is in ZoC (guaranteed at this point in the code)
		// The best way to do that is to make getFaction return "Player" very briefly as that is part of the vanilla check
		// That function is called multiple times in __orignal. We target the second time it appears
		// The first time, `getFaction` is called, is filtered out further up
		// The second time `getFaction` is called, happens only, while we are in a zone of control (guaranteed at this point in the code)
		local mockObject = ::Hardened.mockFunction(_entity, "getFaction", function() {
			return { done = true, value = ::Const.Faction.Player };
		});

		local generator = __original(_entity);	// Get the original generator
		local ret = resume generator;	// Variable to hold the value yielded by the generator

		mockObject.cleanup();			// The getFaction check happens during the first loop
		_entity.m.Type = oldEntityType;	// The Lindwurm type handling happens during the first loop

		// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}

		return ret;
	}

	q.onTurnStarted = @(__original) function()
	{
		__original();
		this.m.HD_AttemptsThisTurn = 0;
	}

	q.isAtMapBorder = @(__original) function( _entity )
	{
		// We hijack the isAtMapBorder function to introduce a new condition:
		//	You can no longer retreat, while in zone of control of another character
		if (::Hardened.util.willBeAttackedLeavingZoneOfControl(_entity)) return false;

		if (!__original(_entity)) return false;

		return true;
	}
});
