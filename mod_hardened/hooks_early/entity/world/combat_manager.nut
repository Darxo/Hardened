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

	q.startCombat = @(__original) { function startCombat( _p1, _p2 )
	{
		local oldLength = this.m.Combats.len();
		__original(_p1, _p2);

		if (this.m.Combats.len() > oldLength)
		{
			this.m.Combats[this.m.Combats.len() - 1].HD_skippingFirstTick <- true;
		}

	}}.startCombat;

	q.tickCombat = @(__original) { function tickCombat( _combat )
	{
		// Feat: skip the first tick of every ai world combat to make them last a bit longer
		if (_combat.HD_skippingFirstTick)
		{
			_combat.HD_skippingFirstTick = false;
			return;
		}

		__original(_combat);
	}}.tickCombat;

	q.onDeserialize = @(__original) { function onDeserialize( _in )
	{
		__original(_in);

		foreach (combat in this.m.Combats)
		{
			// We choose the easy way and pretend like any combat from a loaded save already had skipped a tick
			// This is a good enough approximation and saves a lot of additional management
			combat.HD_skippingFirstTick <- false;
		}
	}}.onDeserialize;

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
