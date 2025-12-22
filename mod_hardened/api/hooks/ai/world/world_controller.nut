::Hardened.HooksMod.hook("scripts/ai/world/world_controller", function(q) {
	q.onOpponentSighted = @(__original) function( _entity )
	{
		if (_entity.isLocation()) return __original(_entity);

		// Fix: World entities adding themselves as a KnownOpponent
		if (this.getEntity().getID() == _entity.getID())
		{
			// onOpponentSighted should never be called for ourselves, but we assume that this still happens and is a cause for funky world party behavior down the line
			::logWarning("Hardened: world_controller::onOpponentSighted - prevented " + this.getEntity().getName() + " from adding itself as a knownOpponent. Please report this.");
			return;
		}

		__original(_entity);
	}
});
