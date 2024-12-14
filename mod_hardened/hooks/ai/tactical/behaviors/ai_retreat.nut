::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_retreat", function(q) {
	q.onEvaluate = @(__original) function( _entity )
	{
		// We need to slightly adjust the vanilla ai_retreat behavior, because it looks in a hard coded way for the lindwurm tail
		// And in Hardened, the Tail can actually be missing/null, while the head still exists

		local generator = __original(_entity);	// Get the original generator

		local oldEntityType = _entity.getType();
		// Switcheroo to prevent the lindwurm head from checking its tail when that tail does not exist anymore
		if (_entity.getType() == ::Const.EntityType.Lindwurm && ::MSU.isNull(_entity.getTail()))
		{
			_entity.m.Type = 0;
		}

		local ret = resume generator;	// Variable to hold the value yielded by the generator

		_entity.m.Type = oldEntityType;

		// Loop to handle the multiple yields of the generator until it finally finished (ret != null)
		while (ret == null)
		{
			yield ret;
			ret = resume generator;
		}

		return ret;
	}
});
