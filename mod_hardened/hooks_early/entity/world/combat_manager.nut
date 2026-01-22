::Hardened.HooksMod.hook("scripts/entity/world/combat_manager", function(q) {
	q.joinCombat = @(__original) function(_combat, _party)
	{
		if (::MSU.isNull(_party)) return;

		// Vanilla Fix: Vanilla allows parties to join a combat multiple times
		// The root cause of this is unclear (though this does not seem the cause for parties attacking themselves)
		if (this.isInCombat(_combat, _party))
		{
			if (!::MSU.Serialization.IsLoading)
			{
				::logWarning("Hardened: World Entity " + _entity.getName() + " just tried to join the same fight multiple times. We prevented that. Please report this");
			}
			return;
		}

		__original(_combat, _party);
	}

// New Functions
	// Return true, if _party is already in _combat; false otherwise
	q.isInCombat <- function( _combat, _party )
	{
		foreach (existingParty in _combat.Factions[_party.getFaction()])
		{
			if (::MSU.isNull(existingParty)) continue;

			if (existingParty.getID() == _party.getID()) return true;
		}

		return false;
	}
});
