::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_retreat", function(q) {
	q.m.HD_AttemptsThisTurn <- 0;

	q.onBeforeExecute = @(__original) function( _entity )
	{
		__original(_entity);

		if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()))
		{
			++this.m.HD_AttemptsThisTurn;
		}
	}

	q.onEvaluate = @(__original) function( _entity )	// This function is a generator.
	{
		// Fix: A fleeing actor in zone of control no longer uses ai_flee to navigate

		// Fix: We need to slightly adjust the vanilla ai_retreat behavior, because it looks in a hard coded way for the lindwurm tail
		// 		And in Hardened, the Tail can actually be missing/null, while the head still exists

		if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions()) && _entity.getFaction() != this.Const.Faction.Player)
		{
			// This condition is new, we now use a similar attemts counter as ai_flee
			if (this.m.HD_AttemptsThisTurn < ::Const.AI.Agent.MaxFleeAttemptsPerTurn)
			{
				return ::Const.AI.Behavior.Score.Zero;
			}
		}

		local generator = __original(_entity);	// Get the original generator

		local oldEntityType = _entity.getType();
		// Switcheroo to prevent the lindwurm head from checking its tail when that tail does not exist anymore
		if (_entity.getType() == ::Const.EntityType.Lindwurm && ::MSU.isNull(_entity.getTail()))
		{
			_entity.m.Type = 0;
		}

		// We need to check this outside of the mockFunction because it would otherwise cause an infinite recursion via getFunction calls
		local isInZoneOfControl = _entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions());

		// Our goal is to prevent vanilla from returning Zero, when _entity is in ZoC but not a player
		// The best way to do that is to make getFaction return Player very briefly as that is part of the vanilla check
		local mockObject;
		mockObject = ::Hardened.mockFunction(_entity, "getFaction", function() {
			// We are targeting one particular getFaction call, which is gated behind the following condition, so we need to check for that one first
			if (isInZoneOfControl)
			{
				return { done = true, value = ::Const.Faction.Player };
			}
			return { done = true };
		});

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
		// We hijack the isAtMapBorder function to introduce a new condition
		//	You can no longer retreat, while in zone of control of another character
		if (_entity.getTile().hasZoneOfControlOtherThan(_entity.getAlliedFactions())) return false;

		if (!__original(_entity)) return false;

		return true;
	}
});
