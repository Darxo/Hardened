::Hardened.HooksMod.hook("scripts/factions/contracts/discover_location_action", function(q) {
	// Public
	q.m.HD_ScoutableFactions <- [	// These are the faction, which this action can pick as a scouting target. This does not include zombies, because V
		::Const.FactionType.Bandits,
		::Const.FactionType.Barbarians,
		::Const.FactionType.Beasts,
		::Const.FactionType.Goblins,
		::Const.FactionType.Orcs,
		::Const.FactionType.OrientalBandits,
		::Const.FactionType.Undead,
		::Const.FactionType.Zombies,
	];
	q.m.HD_MaximumDistance <- 20;	// Vanilla: 19
	q.m.HD_ScoreOverwrite = 12;		// Lower score, because we allow way more targeted locations

	// Overwrite, because we change too many things from the original function:
	//	- This contract is no longer restricted to Undead and Zombie locations
	//	- We adjust the chance for this contract depend on player renown instead of day number
	//	- You no longer need to have the region discovered in which that location is located
	q.onUpdate = @() function( _faction )
	{
		if (::World.State.getRegions().len() == 0) return;
		if (!_faction.isReadyForContract()) return;
		if (!this.HD_rollContractChance()) return;

		local possibleLocations = [];
		foreach (factionType in this.m.HD_ScoutableFactions)
		{
			possibleLocations.extend(::World.FactionManager.getFactionOfType(factionType).getSettlements());
		}

		local myTile = _faction.getSettlements()[0].getTile();
		foreach (location in possibleLocations)
		{
			if (location.isDiscovered()) continue;
			if (location.isLocationType(::Const.World.LocationType.Unique)) continue;
			if (myTile.getDistanceTo(location.getTile()) > this.m.HD_MaximumDistance) continue;

			this.m.Score = this.m.HD_ScoreOverwrite;
		}
	}

// New Functions
	q.HD_rollContractChance <- function()
	{
		// Vanilla: 80% on day 1-3 and 10% chance after than
		if (::Math.rand(1, 1000) > ::World.Assets.getBusinessReputation()) return true;

		return ::Math.rand(1, 10) == 1;
	}
});
