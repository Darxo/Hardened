::Hardened.HooksMod.hook("scripts/factions/actions/build_barbarian_camp_action", function(q) {
	// Public
	q.m.HD_SettlementsBase <- 9;			// Vanilla: 8; By default, this many settlements can exist at the same time
	q.m.HD_SettlementsAnyCrisis <- -3;		// Vanilla: -2; This many additional settlements can exist during any other crisis

	// Hardened
	q.m.HD_EnableCustomLocationBuilding = true;
	q.m.HD_AlternativeBanners = ::Const.BarbarianBanners;
	q.m.HD_BannerAssimilationDistance = 15;		// Vanilla: 15

	q.create = @(__original) function()
	{
		__original();

		this.HD_addLocationTicket("scripts/entity/world/locations/barbarian_shelter_location", {
			RatioMax = 0.5,
		});

		this.HD_addLocationTicket("scripts/entity/world/locations/barbarian_camp_location", {
			RatioMax = 0.6,
		});

		this.HD_addLocationTicket("scripts/entity/world/locations/barbarian_sanctuary_location", {
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
		local minY = 0.75;
		switch (_script)
		{
			case "scripts/entity/world/locations/barbarian_shelter_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
				], 7, 20, 1000, 7, 7, null, minY);
				return tile;
			}
			case "scripts/entity/world/locations/barbarian_camp_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
				], 10, 25, 1000, 7, 7, null, minY);
				return tile;
			}
			case "scripts/entity/world/locations/barbarian_sanctuary_location":
			{
				local tile = this.getTileToSpawnLocation(::Const.Factions.BuildCampTries, [
					::Const.World.TerrainType.Mountains,
				], 15, 35, 1000, 7, 7, null, minY);
				return tile;
			}
		}
		return __original(_script);
	}

	q.HD_getLocationsMax = @() function()
	{
		local ret = this.m.HD_SettlementsBase;

		if (this.World.FactionManager.isGreaterEvil())
		{
			ret += this.m.HD_SettlementsAnyCrisis;
		}

		return ret;
	}
});
