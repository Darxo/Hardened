::Hardened.HooksMod.hook("scripts/factions/actions/build_undead_camp_action", function(q) {
	q.m.HD_SettlementsBase <- 12;	// Vanilla: 16; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsCrisis <- 6;	// Vanilla: 8; This many additional settlements can exist during undead crisis

	// Hardened
	q.m.HD_EnableCustomLocationBuilding = true;
	q.m.HD_AlternativeBanners = ::Const.UndeadBanners;
	q.m.HD_BannerAssimilationDistance = 15;		// Vanilla: 15

	q.create = @(__original) function()
	{
		__original();

		this.HD_addLocationTicket("scripts/entity/world/locations/undead_ruins_location", {
			RatioMax = 0.3,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/undead_mass_grave_location", {
			RatioMax = 0.5,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/undead_vampire_coven_location", {
			RatioMax = 0.3,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/undead_buried_castle_location", {
			RatioMax = 0.4,
		});
	}

// Hardened Functions
	q.HD_findTileForLocation = @(__original) function( _script )
	{
		// Todo: implement crisis handling, like zombies, orcs, goblins do?

		switch (_script)
		{
			case "scripts/entity/world/locations/undead_ruins_location":
			{
				// Only Undead Ruins on Desert or Steppe contain Skeleton Spawnlists
				// Unlike Vanilla, we now also allow those to appear on Steppe Tiles
				local disallowTerrain = [];
				for (local i = 0; i != ::Const.World.TerrainType.COUNT; ++i)
				{
					if (i == ::Const.World.TerrainType.Desert) continue;
					if (i == ::Const.World.TerrainType.Steppe) continue;
					disallowTerrain.push(i);
				}

				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowTerrain, 7, 30);
			}
			case "scripts/entity/world/locations/undead_mass_grave_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
				], 12);
			}
			case "scripts/entity/world/locations/undead_vampire_coven_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
				], 15, 25);
			}
			case "scripts/entity/world/locations/undead_buried_castle_location":
			{
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

				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, disallowTerrain, 15, 1000);
			}
		}
		return __original(_script);
	}

	q.HD_getLocationsMax = @() function()
	{
		local ret = this.m.HD_SettlementsBase;

		if (::World.FactionManager.isUndeadScourge() && ::World.FactionManager.getGreaterEvilStrength() >= 20.0)
		{
			ret += this.m.HD_SettlementsCrisis;
		}

		return ret;
	}
});
