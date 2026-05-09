::Hardened.HooksMod.hook("scripts/factions/actions/build_bandit_camp_action", function(q) {
	// Public
	q.m.HD_SettlementsBase <- 12;			// Vanilla: 9; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsNobleCrisis <- 3;		// Vanilla: 3; This many additional settlements can exist during noble crisis
	q.m.HD_SettlementsOtherCrisis <- -3;	// Vanilla: -3; This many additional settlements can exist during any other crisis

	// Hardened
	q.m.HD_EnableCustomLocationBuilding = true;
	q.m.HD_AlternativeBanners = ::Const.BanditBanners;
	q.m.HD_BannerAssimilationDistance = 15;		// Vanilla: 15

	q.create = @(__original) function()
	{
		__original();

		this.HD_addLocationTicket("scripts/entity/world/locations/bandit_hideout_location", {
			RatioMax = 0.4,
		});

		this.HD_addLocationTicket("scripts/entity/world/locations/bandit_ruins_location", {
			RatioMax = 0.4,
		});

		this.HD_addLocationTicket("scripts/entity/world/locations/bandit_camp_location", {
			RatioMax = 0.4,
		});

		this.HD_addLocationTicket("scripts/entity/world/locations/rf_bandit_fort_location", {
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
		local minY = 0.2;
		local maxY = 0.75;
		switch (_script)
		{
			case "scripts/entity/world/locations/bandit_hideout_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
					::Const.World.TerrainType.Snow
				], 6, 12, 1000, 7, 7, null, minY, maxY);
				return tile;
			}
			case "scripts/entity/world/locations/bandit_camp_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
					::Const.World.TerrainType.Snow
				], 7, 16, 1000, 7, 7, null, minY, maxY);
				return tile;
			}
			case "scripts/entity/world/locations/bandit_ruins_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
					::Const.World.TerrainType.Snow
				], 10, 20, 1000, 7, 7, null, minY, maxY);
				return tile;
			}
			case "scripts/entity/world/locations/rf_bandit_fort_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
					::Const.World.TerrainType.Snow
				], 10, 25, 1000, 7, 7, null, minY, maxY);
				return tile;
			}
		}
		return __original(_script);
	}

	q.HD_getLocationsMax = @() function()
	{
		local ret = this.m.HD_SettlementsBase;

		if (this.World.FactionManager.isCivilWar() && this.World.FactionManager.getGreaterEvilStrength() >= 20.0)
		{
			ret += this.m.HD_SettlementsNobleCrisis;
		}
		else if (this.World.FactionManager.isGreaterEvil())
		{
			ret += this.m.HD_SettlementsOtherCrisis;
		}

		return ret;
	}
});
