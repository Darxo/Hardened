::Hardened.HooksMod.hook("scripts/entity/world/locations/legendary/black_monolith_location", function(q) {
	// Feat: Turn the tile below the black monolith and all adjacent tiles into badlands
	q.onSpawned = @(__original) function()
	{
		__original();

		// Feat: Replace the Reforged visual lineup with our own
		this.HD_refreshLineup();

		// During the tactical scenario version of the black monolith fight, we call this onSpawned, to fetch all units for the fight
		// In that case we need to return early, because this location does not exist on an actual tile
		if (::Tactical.isActive() && ::Tactical.State.isScenarioMode()) return;

		local myTile = this.getTile();
		local badlandsTiles = [
			myTile,
		];
		local mapGen = ::MapGen.get(::Const.World.TerrainScript[::Const.World.TerrainType.Badlands]);

		foreach (nextTile in ::MSU.Tile.getNeighbors(myTile))
		{
			badlandsTiles.push(nextTile);

			// Look tiles up to two tiles away, but those further tiles only have a 66% chance to be transformed
			foreach (veryNextTile in ::MSU.Tile.getNeighbors(nextTile))
			{
				if (::Math.rand(1, 100) > 66) continue;
				if (veryNextTile.getDistanceTo(myTile) != 2) continue;
				badlandsTiles.push(veryNextTile);

				foreach (veryVeryNextTile in ::MSU.Tile.getNeighbors(veryNextTile))
				{
					if (::Math.rand(1, 100) > 66) continue;
					if (veryVeryNextTile.getDistanceTo(myTile) != 3) continue;
					badlandsTiles.push(veryVeryNextTile);
				}
			}
		}

		foreach (tile in badlandsTiles)
		{
			if (tile.Type == ::Const.World.TerrainType.Shore) continue;
			if (tile.Type == ::Const.World.TerrainType.Ocean) continue;
			if (tile.Type == ::Const.World.TerrainType.Hills) continue;
			if (tile.Type == ::Const.World.TerrainType.Mountains) continue;

			tile.Type = 0;
			tile.clear();
			mapGen.fill({
				X = tile.SquareCoords.X,
				Y = tile.SquareCoords.Y,
				W = 1,
				H = 1,
				IsEmpty = false
			}, null);
		}
	}

	// Overwrite, because we apply our own logic for how this location is restocked
	q.onBeforeCombatStarted = @() { function onBeforeCombatStarted()
	{
		// Feat: restock the line-up of this location everytime, it is considered as a fighting target
		// This is just a visual, as we manually insert the fighting troops into the combat at a later point
		this.HD_refreshLineup();

	}}.onBeforeCombatStarted;

// Hardened Functions
	q.HD_onGetLocalCombatProperties = @(__original) { function HD_onGetLocalCombatProperties( _combatInfo )
	{
		__original(_combatInfo);

		_combatInfo.HD_EngagementType = ::Hardened.Deployment.EngagementType.Custom;	// Disables automatic unit placement
		_combatInfo.BeforeDeploymentCallback = this.HD_deployCustom.bindenv(this);
	}}.HD_onGetLocalCombatProperties;

// New Functions
	q.HD_deployCustom <- function()
	{
		::Hardened.Deployment.DeploymentManager.ParticipantCollection = this.HD_generateParticipantCollection();
		::Hardened.Deployment.DeploymentManager.preparePlayerCharacters(::Tactical.State.getStrategicProperties());
		::Hardened.Deployment.DeploymentManager.RegionPlan = this.HD_generateRegionPlan();
		::Hardened.Deployment.DeploymentManager.deployParticipants();
	}

	q.HD_generateParticipantCollection <- function()
	{
		local ret = ::Hardened.Deployment.ParticipantCollection();

		{
			local participant = ::Hardened.Deployment.Participant();
			participant.Faction = this.getFaction();
			foreach (troopDef in this.HD_decanusArmy())
			{
				participant.addTroopDef(troopDef);
			}
			ret.registerParticipant(participant);
		}

		{
			local participant = ::Hardened.Deployment.Participant();
			participant.Faction = this.getFaction();
			foreach (troopDef in this.HD_centurionArmy())
			{
				participant.addTroopDef(troopDef);
			}
			ret.registerParticipant(participant);
		}

		{
			local participant = ::Hardened.Deployment.Participant();
			participant.Faction = this.getFaction();
			foreach (troopDef in this.HD_legatusArmy())
			{
				participant.addTroopDef(troopDef);
			}
			ret.registerParticipant(participant);
		}

		return ret;
	}

	q.HD_generateRegionPlan <- function()
	{
		local regionPlan = ::Hardened.Deployment.RegionPlan();

		regionPlan.Player = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 2, 9, { OffsetX = 2 });
		regionPlan.PersonalAlly = ::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 3, 13, { OffsetX = 2 });

		regionPlan.Default.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 10, { OffsetX = -12, Rotation = 180 }));
		regionPlan.Default.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 10, { OffsetX = -12, Rotation = 60 }));
		regionPlan.Default.push(::Hardened.Deployment.RegionManager.createRegion(::Hardened.Deployment.RegionShape.Portrait, 4, 10, { OffsetX = -12, Rotation = 300 }));

		return regionPlan;
	}

	q.HD_decanusArmy <- function()
	{
		local composition = [	// Shield Guys - East - 15
			[1, ::Const.World.Spawn.Troops.SkeletonBoss],
			[1, ::Const.World.Spawn.Troops.RF_VampireLord],
			[2, ::Const.World.Spawn.Troops.RF_SkeletonDecanus],
			[2, ::Const.World.Spawn.Troops.Vampire],

			[6, ::Const.World.Spawn.Troops.RF_SkeletonMediumElite],
			[3, ::Const.World.Spawn.Troops.SkeletonMediumPolearm],
		];

		return this.HD_compileTroopDefs(composition);
	}

	q.HD_centurionArmy <- function()
	{
		local composition = [	// Initiative - North - 15
			[2, ::Const.World.Spawn.Troops.RF_SkeletonCenturion],
			[2, ::Const.World.Spawn.Troops.Vampire],
			[1, ::Const.World.Spawn.Troops.SkeletonPriest],
			[1, ::Const.World.Spawn.Troops.RF_SkeletonHeavyEliteBodyguard],

			[2, ::Const.World.Spawn.Troops.SkeletonMedium],
			[2, ::Const.World.Spawn.Troops.SkeletonHeavy],
			[2, ::Const.World.Spawn.Troops.RF_SkeletonHeavyElite],
			[3, ::Const.World.Spawn.Troops.RF_SkeletonMediumElitePolearm],
		];

		return this.HD_compileTroopDefs(composition);
	}

	q.HD_legatusArmy <- function()
	{
		local composition = [	// Menacing - South - 15
			[2, ::Const.World.Spawn.Troops.RF_SkeletonLegatus],
			[2, ::Const.World.Spawn.Troops.Vampire],
			[1, ::Const.World.Spawn.Troops.SkeletonPriest],
			[1, ::Const.World.Spawn.Troops.RF_SkeletonHeavyEliteBodyguard],

			[2, ::Const.World.Spawn.Troops.RF_SkeletonMediumElite],
			[4, ::Const.World.Spawn.Troops.SkeletonHeavy],
			[3, ::Const.World.Spawn.Troops.RF_SkeletonMediumElitePolearm],
		];

		return this.HD_compileTroopDefs(composition);
	}

	q.HD_compileTroopDefs <- function( _composition )
	{
		local ret = [];

		foreach (entry in _composition)
		{
			for (local i = 1; i <= entry[0]; ++i)
			{
				local troopDef = clone entry[1];
				troopDef.Faction <- this.getFaction();
				troopDef.Variant <- 0;	// To make sure, no Champions can exist here
				ret.push(troopDef);
			}
		}

		return ret;
	}

	// Replace the hard-coded lineup from Vanilla and Reforged with our own one
	q.HD_refreshLineup <- function()
	{
		this.clearTroops();
		foreach (troop in this.HD_getLineup())
		{
			::Const.World.Common.addTroop(this, { Type = troop }, false);
		}
	}

	q.HD_getLineup <- function()
	{
		local ret = [];

		ret.extend(this.HD_decanusArmy());
		ret.extend(this.HD_centurionArmy());
		ret.extend(this.HD_legatusArmy());

		return ret;
	}
});
