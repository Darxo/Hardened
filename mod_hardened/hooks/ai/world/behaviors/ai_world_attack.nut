::Hardened.HooksMod.hook("scripts/ai/world/behaviors/ai_world_attack", function(q) {
	q.onExecute = @(__original) function( _entity, _hasChanged )
	{
		// Fix: World entities accidentally engaging themselves
		// That is one of the possible causes for ghose fights that have been reported under Hardened
		// This check will prevent those fights from happening, but it does not reveal, what is causing them to attack themselves
		if (_entity.getID() == this.m.Target.getID())
		{
			::logWarning("Hardened: World Entity " + _entity.getName() + " just tried to fight against itself. We prevented that. Please report this");
			return true;
		}

		return __original(_entity, _hasChanged);
	}
});
