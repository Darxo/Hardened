 ::Hardened.Deployment.ParticipantCollection <- class {
	Player = null;
	Defender = null;	// Party belonging to the location that the player attacks or defends
	EngagedEnemies = null;
	EngagedAllies = null;
	Enemies = null;
	Allies = null;

	constructor()
	{
		this.Player = [];
		this.Defender = null;
		this.EngagedAllies = [];
		this.EngagedEnemies = [];
		this.Allies = [];
		this.Enemies = [];
	}

	/// Sort a given _participant into the this.ParticipantCollection.m Table, depending on its characteristics
	function registerParticipant( _participant )
	{
		if (_participant.getTroopDefs().len() == 0)
		{
			::logWarning("Hardened: registerParticipant, but no troopDef is in _participant " + _participant.Parties[0].getName());
		}

		if (_participant.IsLocationDefender)
		{
			this.Defender = _participant;
			return;
		}

		if (_participant.InCombatAlready)
		{
			if (_participant.IsAlliedWithPlayer)
			{
				this.EngagedAllies.push(_participant);
			}
			else
			{
				this.EngagedEnemies.push(_participant);
			}
		}
		else
		{
			if (_participant.IsAlliedWithPlayer)
			{
				this.Allies.push(_participant);
			}
			else
			{
				this.Enemies.push(_participant);
			}
		}
	}

	function npcParticipantCount()
	{
		local count = 0;
		if (this.Defender != null) ++count;
		count += this.EngagedAllies.len();
		count += this.EngagedEnemies.len();
		count += this.Allies.len();
		count += this.Enemies.len();
		return count;
	}

	function sort()
	{
		this.EngagedAllies.sort(this.onParticipantCompare);
		this.EngagedEnemies.sort(this.onParticipantCompare);
		this.Allies.sort(this.onParticipantCompare);
		this.Enemies.sort(this.onParticipantCompare);
	}

	function getAll()
	{
		local allParticipants = [];
		foreach (participants in this.m)
		{
			allParticipants.extend(participants)
		}
		return allParticipants;
	}

	// Sort Participants so that the "strongest" one comes first. For know we determine this by party size
	function onParticipantCompare( _p1, _p2 )
	{
		// Particiapnt escorted by the player is always sorted to the front so it always takes the position by the player
		foreach (party in _p1.Parties)
		{
			if (::MSU.isEqual(party, ::World.State.getEscortedEntity()))
			{
				return -1;
			}
		}

		if (_p1.getTroopDefs().len() > _p2.getTroopDefs().len())
		{
			return -1;
		}
		else if (_p1.getTroopDefs().len() < _p2.getTroopDefs().len())
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
}
