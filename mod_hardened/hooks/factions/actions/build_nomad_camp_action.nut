::Hardened.HooksMod.hook("scripts/factions/actions/build_nomad_camp_action", function(q) {
	q.m.HD_SettlementsBase <- 9;	// Vanilla: 9; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsCrisis <- 0;	// Vanilla: -2; This many additional settlements can exist during any crisis

	// Hardened
	q.m.HD_EnableCustomLocationBuilding = true;
	q.m.HD_AlternativeBanners = ::Const.NomadBanners;
	q.m.HD_BannerAssimilationDistance = 10;		// Vanilla: 10

	q.create = @(__original) function()
	{
		__original();

		this.HD_addLocationTicket("scripts/entity/world/locations/nomad_tents_location", {
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/nomad_ruins_location", {
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/nomad_hidden_camp_location", {
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/nomad_tent_city_location", {
			HardMin = 1,	// So the first of these "capitals" is spawned with priority
			RatioMax = 0.4,
		});
	}

// Hardened Functions
	q.HD_findTileForLocation = @(__original) function( _script )
	{
		// We no longer allow Nomad Camps to appear on hills, as we remove the maxY. Otherwise they would appear anywhere on the map
		local defaultDisallowedTerrain = [];
		for (local i = 0; i != ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Desert) continue;
			if (i == ::Const.World.TerrainType.Oasis) continue;
			defaultDisallowedTerrain.push(i);
		}

		switch (_script)
		{
			case "scripts/entity/world/locations/nomad_tents_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, 7, 30);	// Vanilla: 7, 20
			}
			case "scripts/entity/world/locations/nomad_ruins_location":
			{
				// In Vanilla they only appear in the lower 20% of the map on any tiles
				// We choose to instead restrict them to Desert and Steppe tiles, allowing them to appear even further north
				local disallowTerrain = [];
				for (local i = 0; i != ::Const.World.TerrainType.COUNT; ++i)
				{
					if (i == ::Const.World.TerrainType.Desert) continue;
					if (i == ::Const.World.TerrainType.Steppe) continue;
					disallowTerrain.push(i);
				}

				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowTerrain, 7, 30);
			}
			case "scripts/entity/world/locations/nomad_hidden_camp_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, 7, 25);	// Vanilla: 9, 25
			}
			case "scripts/entity/world/locations/nomad_tent_city_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, 15, 35);	// Vanilla: 13, 35
			}
		}
		return __original(_script);
	}

	q.HD_getLocationsMax = @() function()
	{
		local ret = this.m.HD_SettlementsBase;

		if (::World.FactionManager.isGreaterEvil())
		{
			ret += this.m.HD_SettlementsCrisis;
		}

		return ret;
	}
});
