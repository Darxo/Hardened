::Hardened.HooksMod.hook("scripts/factions/actions/build_undead_camp_action", function(q) {
	q.m.HD_SettlementsBase <- 12;	// Vanilla: 15; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsCrisis <- 5;	// Vanilla: 8; This many additional settlements can exist during respective crisis

	// Overwrite, because we want to reduce the maximum settlements spawned by this faction and make those numbers moddable
	q.onUpdate = @() function( _faction )
	{
		local settlementsMax = this.m.HD_SettlementsBase;
		if (::World.FactionManager.isUndeadScourge() && ::World.FactionManager.getGreaterEvilStrength() >= 20.0)
		{
			settlementsMax += this.m.HD_SettlementsCrisis;
		}

		local settlements = _faction.getSettlements();
		if (settlements.len() > settlementsMax) return;

		this.m.Score = 2;
	}

	q.onExecute = @(__original) function( _faction )
	{
		// We want to prevent Vanilla from ever choosing the options
		//	- 1 or 3 as both of those are actually zombie locations and would take away skeleton spawns
		//	- 7, as those are desert exclusive vampire covens which take up too many skeleton positions. there is already a global vampire coven spawn
		//	- Overwrite the spawn of buried castles (r == 5) to make them more common
		local rolledBuriedCastle = false;
		local mockObjectRand;
		mockObjectRand = ::Hardened.mockFunction(::Math, "rand", function(...) {
			if (vargv.len() == 2 && vargv[0] == 1 && vargv[1] == 8)
			{
				// We start at 4 to skip the rolls 1 and 3
				local ret = mockObjectRand.original(4, 8);
				if (ret == 7) ret = 2;	// 7 is the third roll to skip, so we redirect it to become 2
				if (ret == 5)
				{
					ret = 9;	// A roll of a 5 will cause nothing to spawn by vanilla
					rolledBuriedCastle = true;	// Instead, we make note of that to spawn such a location manually later
				}
				return { done = true, value = ret };
			}
		});

		__original(_faction);

		mockObjectRand.cleanup();

		if (!rolledBuriedCastle) return;

		local disallowTerrain = [];
		for (local i = 0; i != ::Const.World.TerrainType.COUNT; ++i)
		{
			// In Vanilla only Snow and Tundra are eligible, resulting in very few buried castles
			if (i == ::Const.World.TerrainType.Snow) continue;
			if (i == ::Const.World.TerrainType.Tundra) continue;
			if (i == ::Const.World.TerrainType.Steppe) continue;
			if (i == ::Const.World.TerrainType.Desert) continue;

			disallowTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowTerrain, 15, 1000);	// In Vanilla the minimum distance is 20
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/undead_buried_castle_location", tile.Coords);
			local banner = this.getAppropriateBanner(camp, _faction.getSettlements(), 15, ::Const.UndeadBanners);
			camp.onSpawned();
			camp.setBanner(banner);
			_faction.addSettlement(camp, false);
		}
	}
});
