::Hardened.HooksMod.hook("scripts/factions/actions/build_goblin_camp_action", function(q) {
	q.m.HD_SettlementsBase <- 12;	// Vanilla: 13; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsCrisis <- 6;	// Vanilla: 8; This many additional settlements can exist during greenskin crisis

	// Hardened
	q.m.HD_EnableCustomLocationBuilding = true;
	q.m.HD_AlternativeBanners = ::Const.GoblinBanners;
	q.m.HD_BannerAssimilationDistance = 15;		// Vanilla: 15

	q.create = @(__original) function()
	{
		__original();

		this.HD_addLocationTicket("scripts/entity/world/locations/goblin_hideout_location", {
			function getRatioMax() {
				return ::World.FactionManager.isGreenskinInvasion() ? 0.0 : 0.4;
			},
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/goblin_camp_location", {
			Weight = 8,		// Goblin Camps spawn 33% less often, because Goblins have 2x T2 locations
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/goblin_ruins_location", {
			Weight = 8,		// Goblin Ruins spawn 33% less often, because Goblins have 2x T2 locations
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/goblin_outpost_location", {
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/goblin_settlement_location", {
			HardMin = 1,	// So the first of these "capitals" is spawned with priority
			function getRatioMax() {
				return ::World.FactionManager.isGreenskinInvasion() ? 0.0 : 0.4;
			},
		});
	}

// Hardened Functions
	q.HD_findTileForLocation = @(__original) function( _script )
	{
		local defaultDisallowedTerrain = [::Const.World.TerrainType.Mountains];
		local minDistToSettlements = ::World.FactionManager.isGreenskinInvasion() ? 7 : 15;
		local maxDistToSettlements = ::World.FactionManager.isGreenskinInvasion() ? 20 : 1000;
		local minDistToEnemies = ::World.FactionManager.isGreenskinInvasion() ? 5 : 7;	// Increases likelyhood of them finding space to expand

		local minY = 0.2;	// Vanilla: 0.2
		local maxY = 0.85;	// Vanilla: 1.0; We prevent goblins from spawning in the deep snow to make room for draugr
		{	// Decide Hemisphere
			// Feat: Goblins now only occupy one hemisphere. Either the northern or southern one
			if (::World.Flags.get("HD_OrcHemisphere") == "Top")
			{
				maxY = 0.5;
			}
			else if (::World.Flags.get("HD_OrcHemisphere") == "Bottom")
			{
				minY = 0.5;
			}
		}

		local minX = 0.0;
		local maxX = 1.0;
		{	// Decide Timezone
			// Feat: Goblins now only occupy the timezone, that the settlements do not occupy
			if (::World.Flags.get("HD_SettlementTimezone") == "Left")
			{
				minX = 0.4;
			}
			else if (::World.Flags.get("HD_SettlementTimezone") == "Right")
			{
				maxX = 0.6;
			}
		}

		switch (_script)
		{
			case "scripts/entity/world/locations/goblin_hideout_location":
			{
				return this.HD_getTileToSpawnLocation({
					notOnTerrain = defaultDisallowedTerrain,
					minDistToSettlements = 10,
					maxDistToSettlements = 20,
					maxDistToAllies = 30,
					minX = minX,
					maxX = maxX,
					minY = minY,
					maxY = maxY,
				});
			}
			case "scripts/entity/world/locations/goblin_camp_location":
			{
				return this.HD_getTileToSpawnLocation({
					notOnTerrain = defaultDisallowedTerrain,
					minDistToSettlements = minDistToSettlements,
					maxDistToSettlements = maxDistToSettlements,
					maxDistToAllies = 20,
					minDistToEnemies = minDistToEnemies,
					minX = minX,
					maxX = maxX,
					minY = minY,
					maxY = maxY,
				});
			}
			case "scripts/entity/world/locations/goblin_ruins_location":
			{
				return this.HD_getTileToSpawnLocation({
					notOnTerrain = defaultDisallowedTerrain,
					minDistToSettlements = minDistToSettlements,
					maxDistToSettlements = 30,
					maxDistToAllies = 20,
					minDistToEnemies = minDistToEnemies,
					minX = minX,
					maxX = maxX,
					minY = minY,
					maxY = maxY,
				});
			}
			case "scripts/entity/world/locations/goblin_outpost_location":
			{
				return this.HD_getTileToSpawnLocation({
					notOnTerrain = defaultDisallowedTerrain,
					minDistToSettlements = minDistToSettlements + 5,
					maxDistToSettlements = maxDistToSettlements + 5,
					maxDistToAllies = 20,
					minDistToEnemies = minDistToEnemies,
					minX = minX,
					maxX = maxX,
					minY = minY,
					maxY = maxY,
				});
			}
			case "scripts/entity/world/locations/goblin_settlement_location":
			{
				// Vanilla Fix: settlements disrespecting distance to other locations due to wrong order/number of passed arguments
				return this.HD_getTileToSpawnLocation({
					notOnTerrain = defaultDisallowedTerrain,
					minDistToSettlements = 25,
					maxDistToAllies = 20,
					minDistToEnemies = 12,
					minX = minX,
					maxX = maxX,
					minY = minY,
					maxY = maxY,
				});
			}
		}
		return __original(_script);
	}

	q.HD_getLocationsMax = @() function()
	{
		local ret = this.m.HD_SettlementsBase;

		if (::World.FactionManager.isGreenskinInvasion())
		{
			ret += this.m.HD_SettlementsCrisis;
		}

		return ret;
	}
});
