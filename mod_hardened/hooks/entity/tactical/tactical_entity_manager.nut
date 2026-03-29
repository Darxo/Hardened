::Hardened.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	q.m.HD_ChanceForDesertStorm <- 20;		// Combat on Desert or DesertHill tiles during day have this much chance to also have a cosmetic desert storm effect

	q.makeAllHostilesRetreat = @(__original) function()
	{
		// Vanilla Fix: Kill enemy non-combatants, when you end the battle early
		// In Vanilla non-combatants will are not killed in this case and instead "flee", causing caravan donkey to grant no meat
		this.killNonCombatants();

		__original();
	}

	q.spawn = @(__original) function( _properties )
	{
		__original(_properties);

		// Feat: Whenever you start any battle,
		//	you gain a relationship hit against any faction that you fight against with the reason "Attacked them"
		//	you gain a morale reputation hit, if you fight against temporary enemies
		local currentContract = ::World.Contracts.getActiveContract();
		local fightsAgainstTemporaryEnemy = false;
		foreach (factionID, entityList in this.getAllInstances())
		{
			if (entityList.len() == 0) continue;
			local faction = ::World.FactionManager.getFaction(factionID);
			if (faction == null) continue;	// The first three entries in the this.m.Factions array are always null
			if (faction.isAlliedWithPlayer()) continue;
			if (currentContract != null && factionID == currentContract.getFaction()) continue;	// Some contracts force you to fight against their own (deserter twist), we dont want those cases to cause non-scripted relation damage

			faction.addPlayerRelation(::Const.World.Assets.HD_RelationAttackedThem, "Attacked them");

			if (faction.isTemporaryEnemy())
			{
				// Similar to what vanilla subtracts, when you attack a party
				::World.Assets.addMoralReputation(::Const.World.Assets.HD_MoraleReputationAttackedThem);
			}
		}
	}

	q.setupAmbience = @(__original) function( _worldTile )
	{
		// Feat: We apply a consistent seed, so that multiple calls of this function provide the exact same weather/ambience
		// We do this to make sure, that reloading a fight, or doing quick fights in succession will make them happen with the same weather effects
		// We decide that the ambience/weather stays the same during a whole day or night
		::Reforged.Math.seedRandom(
			"HD_FixedAmbienceSeed",			// Fixed salt, specific to use-case
			::World.getTime().Days			// Day specific salt
			::World.getTime().IsDaytime		// Day/Night specific salt
		);

		__original(_worldTile);

		if (::Math.rand(1, 100) <= this.m.HD_ChanceForDesertStorm && ::World.getTime().IsDaytime)
		{
			switch (_worldTile.TacticalType)
			{
				case ::Const.World.TerrainTacticalType.Desert:
				case ::Const.World.TerrainTacticalType.DesertHills:
				{
					// We create "clouds" similar to how vanilla created blizzards
					local weather = ::Tactical.getWeather();
					local clouds = weather.createCloudSettings();
					clouds.Type = this.getconsttable().CloudType.Custom;
					clouds.MinClouds = 150;
					clouds.MaxClouds = 150;
					clouds.MinVelocity = 400.0;
					clouds.MaxVelocity = 500.0;
					clouds.MinAlpha = 0.2;
					clouds.MaxAlpha = 0.5;
					clouds.MinScale = 1.0;
					clouds.MaxScale = 2.0;
					clouds.Sprite = "wind_01";
					clouds.RandomizeDirection = false;
					clouds.RandomizeRotation = false;
					clouds.Direction = ::createVec(-1.0, -0.7);

					// We give those desert storms a yellow coloring
					clouds.Color = ::createColor("#f0df9c");

					weather.buildCloudCover(clouds);

					// The blizzard track also fits pretty well with a desert storm, so we re-use it
					::Sound.setAmbience(0, ::Const.SoundAmbience.Blizzard, ::Const.Sound.Volume.Ambience, 0);
				}
			}
		}

		// We randomize the seed again, as we are done with its usage for our purpose. We dont want following random calls to be influenced too
		::Math.seedRandom(::Time.getRealTime());
	}
});
