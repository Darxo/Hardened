::Hardened.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
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

		// We randomize the seed again, as we are done with its usage for our purpose. We dont want following random calls to be influenced too
		::Math.seedRandom(::Time.getRealTime());
	}
});
