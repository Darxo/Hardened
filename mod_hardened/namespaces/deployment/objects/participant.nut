// One local member of a combat
// Multiple parties can combine into one participant, merging their troops onto the same region
// The player also translates into a participant but always takes up a full participnat by themselves
::Hardened.Deployment.Participant <- class {
	Faction = null;
	IsAlliedWithPlayer = null;
	IsOwningLocation = null;	// Do we own the location or are allied to the faction who owns the location?
	InCombatAlready = null;
	WorldParty = null;		// Reference to the world party, if it exists
	Parties = null;		// World parties belonging to this participant
	HomelessTroopDefs = [];		// TroopDefs not belonging to any world party
	Entities = null;		// Entity References. Mainly relevant for the player, whose units persist outside of combat

	constructor()
	{
		this.Faction = ::Const.Faction.None;
		this.IsAlliedWithPlayer = false;
		this.IsOwningLocation = false;
		this.InCombatAlready = false;
		this.WorldParty = null;
		this.Parties = [];
		this.HomelessTroopDefs = [];
		this.Entities = [];
	}

	function getTroopDefs()
	{
		local ret = [];

		foreach (party in this.Parties)
		{
			foreach (troopDef in party.getTroops())
			{
				ret.push(troopDef);
			}
		}

		foreach (troopDef in this.HomelessTroopDefs)
		{
			ret.push(troopDef);
		}

		return ret;
	}

	// Register a troopdef into this participant
	// If it belongs to a world party, we instead add that world party to our list
	// If its party already exists, we wkip this troopDef
	// Otherwise we add it to the homless troopdefs
	function addTroopDef( _troopDef )
	{
		if ("Party" in _troopDef)	// belongs to world party
		{
			foreach (party in this.Parties)
			{
				if (::MSU.isEqual(_troopDef.Party, party))
				{
					return;	// party already counted
				}
			}
			this.Parties.push(_troopDef.Party)
		}
		else
		{
			this.HomelessTroopDefs.push(_troopDef);
		}
	}
}
