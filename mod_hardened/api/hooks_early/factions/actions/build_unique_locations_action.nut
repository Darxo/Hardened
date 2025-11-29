::Hardened.HooksMod.hook("scripts/factions/actions/build_unique_locations_action", function(q) {
	// Public
	q.m.HD_DistanceToOthers <- 15;	// In Vanilla this exists only as a local variable inside of the onExecute function. This variable does not yet supportall legendary locations

	// Feat: We vastly improve performance of world creation by limiting the Y axis for various legendary locations to where their allows tile types exist in
	// see worldmap_generator.nut for where these Y limits come from
	q.m.HD_AncientCityY <- [0.1, 0.2];			// In Vanilla the Ancient City only spawns in Desert, so we limit the maxY to 0.2. Since Vanilla already limits the minY to 0.1, we keep that
	q.m.HD_AncientStatueY <- [0.0, 1.0];		// In Vanilla the Ancient Statue can spawn almost anywhere, so we don't limit the Y of it
	q.m.HD_AncientTempleY <- [0.0, 1.0];		// In Vanilla the Ancient Temple can spawn almost anywhere, so we don't limit the Y of it
	q.m.HD_AncientWatchtowerY <- [0.15, 1.0];	// In Vanilla the Ancient Watchtower can spawn almost anywhere, so we don't limit the Y of it
	q.m.HD_BlackMonolithY <- [0.0, 1.0];		// In Vanilla the Black Monolith can spawn almost anywhere, so we don't limit the Y of it
	q.m.HD_FountainOfYouthY <- [0.2, 0.75];		// In Vanilla the Fountain of Youth only spawns in Forest, LeaveForest or AutumnForest, so we limit the Y axis between 0.2 and 0.75 to save performance
	q.m.HD_GolemLocation1Y <- [0.2, 0.9];		// In Vanilla the Abandoned Village only spawns in the Plains and Tundra, so we limit the Y axis between 0.2 and 0.9 to save performance
	q.m.HD_GolemLocation2Y <- [0.2, 0.9];		// In Vanilla the Ancient Reliquary only spawns in the Plains, Steppe and Tundra, so we limit the Y axis between 0.2 and 0.9 to save performance
	q.m.HD_GoblinCityY <- [0.0, 1.0];			// In Vanilla the Goblin City can spawn almost anywhere, so we don't limit the Y of it
	q.m.HD_HuntingGroundY <- [0.7, 1.0];		// In Vanilla the Hunting Grounds only spawns in the Tundra, so we limit the Y axis between 0.7 and 1.0 to save performance
	q.m.HD_IcyCaveY <- [0.8, 1.0];				// In Vanilla the Icy Cave only spawns in the Snow, so we limit the Y axis between 0.8 and 1.0 to save performance
	q.m.HD_KrakenCultY <- [0.3, 0.8];			// In Vanilla the Kraken Cult only spawns in Swamp, so we limit the Y axis between 0.3 and 0.8 to save performance
	q.m.HD_LandShipY <- [0.0, 1.0];				// In Vanilla the Land Ship can spawn almost anywhere, so we don't limit the Y of it
	q.m.HD_MeteoriteY <- [0.1, 0.35];			// In Vanilla the Meteorite Y Limit is already sufficient so we don't change it at all
	q.m.HD_OracleY <- [0.0, 0.6];				// In Vanilla the Oracle only spawns in Desert or Steppe, so we limit the minY to 0.0 and maxY to 0.6
	q.m.HD_SunkenLibraryY <- [0.0, 0.2];		// In Vanilla the Sunken Library only spawns in Desert, so we limit the minY to 0.0 and maxY to 0.2
	q.m.HD_UnholdGraveyardY <- [0.6, 1.0];		// In Vanilla the Unhold Graveyard only spawns in Tundra or Snow area, so we limit the minY to 0.6, as Tundra starts generating at 0.7+
	q.m.HD_WaterWheelY <- [0.2, 0.8];			// In Vanilla the Waterwheel only spawns in Plains, so we limit the Y axis between 0.2 and 0.8 to save performance
	q.m.HD_WitchHutY <- [0.2, 0.75];			// In Vanilla the Witch Hut only spawns in Forest, LeaveForest or AutumnForest, so we limit the Y axis between 0.2 and 0.75 to save performance

	// Feat: make the preferred Y axis of various Legendary Locations moddable
	q.onExecute = @(__original) function( _faction )
	{
		if (this.m.BuildBlackMonolith) return this.HD_TryBuildBlackMonolith();
		if (this.m.BuildGoblinCity) return this.HD_TryBuildGoblinCity();
		if (this.m.BuildUnholdGraveyard) return this.HD_TryBuildUnholdGraveyard();
		if (this.m.BuildFountainOfYouth) return this.HD_TryBuildFountainOfYouth();
		if (this.m.BuildWitchHut) return this.HD_TryBuildWitchHut();
		if (this.m.BuildWaterWheel) return this.HD_TryBuildWaterWheel();
		if (this.m.BuildKrakenCult) return this.HD_TryBuildKrakenCult();
		if (this.m.BuildIcyCave) return this.HD_TryBuildIcyCave();
		if (this.m.BuildHuntingGround) return this.HD_TryBuildHuntingGround();
		if (this.m.BuildAncientWatchTower) return this.HD_TryBuildAncientWatchTower();
		if (this.m.BuildLandShip) return this.HD_TryBuildLandShip();
		if (this.m.BuildAncientStatue) return this.HD_TryBuildAncientStatue();
		if (this.m.BuildAncientTemple) return this.HD_TryBuildAncientTemple();
		if (this.m.BuildSunkenLibrary) return this.HD_TryBuildSunkenLibrary();
		if (this.m.BuildHolySite1) return this.HD_TryBuildMeteorite();
		if (this.m.BuildHolySite2) return this.HD_TryBuildOracle();
		if (this.m.BuildHolySite3) return this.HD_TryBuildAncientCity();
		if (this.m.BuildGolemLocation1) return this.HD_TryBuildGolemLocation1();
		if (this.m.BuildGolemLocation2) return this.HD_TryBuildGolemLocation2();

		return __original(_faction);
	}

// New Functions
	q.HD_TryBuildAncientCity <- function()
	{
		local minY = this.m.HD_AncientCityY[0];	// Vanilla: 0.1
		local maxY = this.m.HD_AncientCityY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Desert) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 8, 25, 1001, 8, 8, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/vulcano_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildAncientStatue <- function()
	{
		local minY = this.m.HD_AncientStatueY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_AncientStatueY[1];	// Vanilla: 1.0

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100,
			[::Const.World.TerrainType.Mountains, ::Const.World.TerrainType.Snow, ::Const.World.TerrainType.SnowyForest, ::Const.World.TerrainType.Forest],
			20, 35, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);

		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/ancient_statue_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildAncientTemple <- function()
	{
		local minY = this.m.HD_AncientTempleY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_AncientTempleY[1];	// Vanilla: 1.0

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100,
			[::Const.World.TerrainType.Mountains, ::Const.World.TerrainType.Snow, ::Const.World.TerrainType.SnowyForest, ::Const.World.TerrainType.Desert],
			25, 60, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);

		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/ancient_temple_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildAncientWatchTower <- function()
	{
		local minY = this.m.HD_AncientWatchtowerY[0];	// Vanilla: 0.15
		local maxY = this.m.HD_AncientWatchtowerY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Mountains || i == ::Const.World.TerrainType.Hills) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 25, 60, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/ancient_watchtower_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildBlackMonolith <- function()
	{
		local minY = this.m.HD_BlackMonolithY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_BlackMonolithY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Hills || i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Tundra || i == ::Const.World.TerrainType.Plains) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 45, 1000, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/black_monolith_location", tile.Coords);
			if (camp != null)
			{
				tile.TacticalType = ::Const.World.TerrainTacticalType.Quarry;
				camp.onSpawned();
			}
		}
	}

	q.HD_TryBuildFountainOfYouth <- function()
	{
		local minY = this.m.HD_FountainOfYouthY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_FountainOfYouthY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Forest || i == ::Const.World.TerrainType.LeaveForest || i == ::Const.World.TerrainType.AutumnForest)
				continue;

			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 40, 1000, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/fountain_of_youth_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildGoblinCity <- function()
	{
		local minY = this.m.HD_GoblinCityY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_GoblinCityY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Hills || i == ::Const.World.TerrainType.Mountains) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 30, 1000, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/unique_goblin_city_location", tile.Coords);
			if (camp != null)
			{
				local goblins = World.FactionManager.getFactionOfType(Const.FactionType.Goblins);
				local banner = getAppropriateBanner(camp, goblins.getSettlements(), 15, Const.GoblinBanners);
				camp.onSpawned();
				camp.setBanner(banner);
				goblins.addSettlement(camp, false);
			}
		}
	}

	q.HD_TryBuildGolemLocation1 <- function()
	{
		local minY = this.m.HD_GolemLocation1Y[0];	// Vanilla: 0.0
		local maxY = this.m.HD_GolemLocation1Y[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Plains || i == ::Const.World.TerrainType.Tundra) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 8, 21, 1001, 8, 8, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/abandoned_village_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildGolemLocation2 <- function()
	{
		local minY = this.m.HD_GolemLocation2Y[0];	// Vanilla: 0.0
		local maxY = this.m.HD_GolemLocation2Y[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Plains || i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Tundra) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 12, 25, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/artifact_reliquary_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildHuntingGround <- function()
	{
		local minY = this.m.HD_HuntingGroundY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_HuntingGroundY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Tundra)
				continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 15, 99, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/tundra_elk_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildIcyCave <- function()
	{
		local minY = this.m.HD_IcyCaveY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_IcyCaveY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Snow || i == ::Const.World.TerrainType.SnowyForest)
				continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 10, 35, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/icy_cave_location", tile.Coords);
			if (camp != null)
			{
				::World.Flags.set("IjirokStage", 0);
				tile.TacticalType = ::Const.World.TerrainTacticalType.Snow;
				camp.onSpawned();
			}
		}
	}

	q.HD_TryBuildKrakenCult <- function()
	{
		local minY = this.m.HD_KrakenCultY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_KrakenCultY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Swamp) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 25, 1000, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/kraken_cult_location", tile.Coords);
			if (camp != null)
			{
				camp.onSpawned();
			}
		}
	}

	q.HD_TryBuildLandShip <- function()
	{
		local minY = this.m.HD_LandShipY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_LandShipY[1];	// Vanilla: 1.0

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, [::Const.World.TerrainType.Mountains], 15, 30, 1000, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/land_ship_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildMeteorite <- function()
	{
		local minY = this.m.HD_MeteoriteY[0];	// Vanilla: 0.1
		local maxY = this.m.HD_MeteoriteY[1];	// Vanilla: 0.35

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Steppe || i == ::Const.World.TerrainType.Plains) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 8, 25, 1001, 8, 8, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/meteorite_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildOracle <- function()
	{
		local minY = this.m.HD_OracleY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_OracleY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Desert || i == ::Const.World.TerrainType.Steppe) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 8, 25, 1001, 8, 8, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/oracle_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildSunkenLibrary <- function()
	{
		local minY = this.m.HD_SunkenLibraryY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_SunkenLibraryY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Desert) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 18, 50, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/sunken_library_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildUnholdGraveyard <- function()
	{
		local minY = this.m.HD_UnholdGraveyardY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_UnholdGraveyardY[1];	// Vanilla: 1.0

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100,
			[::Const.World.TerrainType.Hills, ::Const.World.TerrainType.Mountains, ::Const.World.TerrainType.Plains, ::Const.World.TerrainType.Steppe, ::Const.World.TerrainType.Desert, ::Const.World.TerrainType.Oasis, ::Const.World.TerrainType.SnowyForest, ::Const.World.TerrainType.Forest, ::Const.World.TerrainType.LeaveForest, ::Const.World.TerrainType.AutumnForest ],
			25, 1000, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);

		if (tile != null)
		{
			local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/unhold_graveyard_location", tile.Coords);
			if (camp != null) camp.onSpawned();
		}
	}

	q.HD_TryBuildWaterWheel <- function()
	{
		local minY = this.m.HD_WaterWheelY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_WaterWheelY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Plains) continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 15, 30, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
	 		local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/waterwheel_location", tile.Coords);
			if (camp != null)
			{
		 		camp.onSpawned();
			}
		}
	}

	q.HD_TryBuildWitchHut <- function()
	{
		local minY = this.m.HD_WitchHutY[0];	// Vanilla: 0.0
		local maxY = this.m.HD_WitchHutY[1];	// Vanilla: 1.0

		local disallowedTerrain = [];
		for (local i = 0; i < ::Const.World.TerrainType.COUNT; ++i)
		{
			if (i == ::Const.World.TerrainType.Forest || i == ::Const.World.TerrainType.LeaveForest || i == ::Const.World.TerrainType.AutumnForest)
				continue;
			disallowedTerrain.push(i);
		}

		local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries * 100, disallowedTerrain, 15, 25, 1001, this.m.HD_DistanceToOthers, this.m.HD_DistanceToOthers, null, minY, maxY);
		if (tile != null)
		{
	 		local camp = ::World.spawnLocation("scripts/entity/world/locations/legendary/witch_hut_location", tile.Coords);
			if (camp != null)
			{
				tile.TacticalType = ::Const.World.TerrainTacticalType.Plains;
		 		camp.onSpawned();
			}
		}
	}
});
