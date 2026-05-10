::Hardened.HooksMod.hook("scripts/factions/actions/rf_build_draugr_camp_action", function(q) {
	// Public
	q.m.HD_SettlementsBase <- 5;		// Reforged: 5; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsScourge <- 0;		// Reforged: 3; This many additional settlements can exist during Undead Scourge

	// Hardened
	q.m.HD_EnableCustomLocationBuilding = true;
	q.m.HD_AlternativeBanners = ::Const.RF_DraugrBanners;
	q.m.HD_BannerAssimilationDistance = 15;		// Reforged: 15

	q.create = @(__original) function()
	{
		__original();

		this.HD_addLocationTicket("scripts/entity/world/locations/rf_draugr_barrows_location", {
			RatioMax = 0.6,
		});

		this.HD_addLocationTicket("scripts/entity/world/locations/rf_draugr_crypt_location", {
			RatioMax = 0.6,
		});

		this.HD_addLocationTicket("scripts/entity/world/locations/rf_draugr_fane_location", {
			HardMin = 1,
			RatioMax = 0.4,
			getHardMax = function() {
				return ::Math.ceil(::World.getTime().Days / 50.0);	// No more than 1 of these per started 50 days can exist at the same time
			},
		});
	}

// Hardened Functions
	q.HD_findTileForLocation = @(__original) function( _script )
	{
		local minY = 0.8;
		switch (_script)
		{
			case "scripts/entity/world/locations/rf_draugr_barrows_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
				], 15, 30, 1000, 7, 7, null, minY);
				return tile;
			}
			case "scripts/entity/world/locations/rf_draugr_crypt_location":
			{
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
				], 20, 1000, 1000, 7, 7, null, minY);
			}
			case "scripts/entity/world/locations/rf_draugr_fane_location":
			{
				local excludedTerrain = clone ::Const.World.TerrainType;
				delete excludedTerrain.Mountains;
				delete excludedTerrain.COUNT;
				excludedTerrain = ::MSU.Table.values(excludedTerrain);
				return this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, excludedTerrain, 20, 1000, 1000, 7, 7, null, minY);
			}
		}
		return __original(_script);
	}

	q.HD_getLocationsMax = @() function()
	{
		local ret = this.m.HD_SettlementsBase;

		if (::World.FactionManager.isUndeadScourge() && ::World.FactionManager.getGreaterEvilStrength() >= 20.0)
		{
			ret += this.m.HD_SettlementsScourge;
		}

		return ret;
	}
});
