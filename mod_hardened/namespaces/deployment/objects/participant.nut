// One local member of a combat
// Multiple parties can combine into one participant, merging their troops onto the same region
// The player also translates into a participant but always takes up a full participnat by themselves
::Hardened.Deployment.Participant <- class {
	Faction = null;
	IsAlliedWithPlayer = null;
	IsOwningLocation = null;	// Do we own the location or are allied to the faction who owns the location?
	InCombatAlready = null;
	WorldParty = null;		// Reference to the world party, if it exists
	Parties = null;
	Entities = null;		// Entity References. Mainly relevant for the player, whose units persist outside of combat

	constructor()
	{
		this.Faction = ::Const.Faction.None;
		this.IsAlliedWithPlayer = false;
		this.IsOwningLocation = false;
		this.InCombatAlready = false;
		this.WorldParty = null;
		this.Parties = [];
		this.Entities = [];
	}

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
