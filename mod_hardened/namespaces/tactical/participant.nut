// One local member of a combat
// Multiple parties can combine into one participant, merging their troops onto the same region
// The player also translates into a participant but always takes up a full participnat by themselves
::Hardened.Tactical.Participant <- {
	Participant = {
		Faction = ::Const.Faction.None,
		IsAlliedWithPlayer = false,
		IsOwningLocation = false,	// Do we own the location or are allied to the faction who owns the location?
		InCombatAlready = false,
		WorldParty = null,		// Reference to the world party, if it exists
		Parties = [],
		// EntityDefs = [],
		Entities = [],		// Entity References. Mainly relevant for the player, whose units persist outside of combat

		function getTroopDefs()
		{
			local ret = [];
			foreach (party in this.Parties)
			{
				foreach (troopDef in party.getTroops())
				{
					// troopDef.Faction <- party.getFaction();
					// troopDef.Party <- ::WeakTableRef(party);
					ret.push(troopDef);
				}
			}
			return ret;
		}
	}

	function create()
	{
		local ret = clone this.Participant;
		ret.Parties = [];
		// ret.EntityDefs = [];
		ret.Entities = [];
		return ret;
	}
}
