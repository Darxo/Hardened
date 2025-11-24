::Hardened.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
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
});
