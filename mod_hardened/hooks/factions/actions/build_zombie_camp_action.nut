::Hardened.HooksMod.hook("scripts/factions/actions/build_zombie_camp_action", function(q) {
	q.m.HD_SettlementsBase <- 12;	// Vanilla: 12; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsCrisis <- 6;	// Vanilla: 8; This many additional settlements can exist during undead crisis

	// Hardened
	q.m.HD_EnableCustomLocationBuilding = true;
	q.m.HD_AlternativeBanners = ::Const.ZombieBanners;
	q.m.HD_BannerAssimilationDistance = 15;		// Vanilla: 15

	q.create = @(__original) function()
	{
		__original();

		this.HD_addLocationTicket("scripts/entity/world/locations/undead_hideout_location", {
			function getRatioMax() {
				return ::World.FactionManager.isUndeadScourge() ? 0.0 : 0.4;
			},
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/undead_graveyard_location", {
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/undead_ruins_location", {
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/undead_crypt_location", {
			RatioMax = 0.4,
		});
		this.HD_addLocationTicket("scripts/entity/world/locations/undead_necromancers_lair_location", {
			HardMin = 1,
			function getRatioMax() {
				return ::World.FactionManager.isUndeadScourge() ? 0.0 : 0.3;
			},
		});
	}

// Hardened Functions
	q.HD_findTileForLocation = @(__original) function( _script )
	{
		local defaultDisallowedTerrain = [::Const.World.TerrainType.Mountains, ::Const.World.TerrainType.Desert, ::Const.World.TerrainType.Oasis];
		local minY = 0.2;	// Vanilla: 0.2
		local minDistToSettlements = ::World.FactionManager.isUndeadScourge() ? 5 : 10;
		local minDistToEnemies = ::World.FactionManager.isUndeadScourge() ? 5 : 7;	// Increases likelyhood of them finding space to expand

		switch (_script)
		{
			case "scripts/entity/world/locations/undead_hideout_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, 7, 15, 1000, 7, 7, null, minY);
			}
			case "scripts/entity/world/locations/undead_graveyard_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, minDistToSettlements, 20, 1000, minDistToEnemies, 7, null, minY);
			}
			case "scripts/entity/world/locations/undead_ruins_location":
			{
				defaultDisallowedTerrain.push(::Const.World.TerrainType.Steppe);	// We must ignore Steppe tiles, as those turn the spawnlist into Skeletons and it's not our job to spawn locations for them
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, 10, 25, 1000, minDistToEnemies, 7, null, minY);
			}
			case "scripts/entity/world/locations/undead_crypt_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, minDistToSettlements + 5, 25, 1000, minDistToEnemies, 7, null, minY);
			}
			case "scripts/entity/world/locations/undead_necromancers_lair_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, defaultDisallowedTerrain, 20, 30, 1000, 7, 7, null, minY);
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
