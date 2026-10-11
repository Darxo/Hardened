::Hardened.HooksMod.hook("scripts/entity/tactical/tactical_entity_manager", function(q) {
	// Overwrite, because we split up this large vanilla function to make it more moddable
	q.spawn = @() { function spawn( _properties )
	{
		// Seeding
		if (::World.State.getCombatSeed() != 0)
		{
			::Math.seedRandom(::World.State.getCombatSeed());
		}

		::Time.setRound(0);

		foreach (faction in _properties.TemporaryEnemies)
		{
			if (faction > 2)
			{
				::World.FactionManager.getFaction(faction).setIsTemporaryEnemy(true);
			}
		}

		// In Vanilla this is called after player characters are gathered. We instead give the opportunity to influence that process
		if (_properties.BeforeDeploymentCallback != null)
		{
			_properties.BeforeDeploymentCallback();
		}

		::Hardened.Tactical.Deployment.spawn(::Tactical.State.getStrategicProperties());

		// Callback after all AI participants have been deployed
		if (_properties.EnemyDeploymentCallback != null)
		{
			_properties.EnemyDeploymentCallback();
		}

		// This vanilla variable might have had some use at some point. But it's currently unused
		this.m.IsLineVSLine = _properties.PlayerDeploymentType == ::Const.Tactical.DeploymentType.Line && _properties.EnemyDeploymentType == ::Const.Tactical.DeploymentType.Line;

		if (!::Tactical.State.isScenarioMode() && !_properties.IsPlayerInitiated && !_properties.InCombatAlready)
		{
			foreach( i, s in this.m.Strategies )
			{
				if (!::World.FactionManager.isAllied(::Const.Faction.Player, i))
				{
					s.setIsAttackingOnWorldmap(true);
				}
			}
		}

		if (_properties.AfterDeploymentCallback != null)
		{
			_properties.AfterDeploymentCallback();
		}

		if (_properties.IsAutoAssigningBases)
		{
			this.assignBases();
		}
		this.makeEnemiesKnownToAI(_properties.InCombatAlready);

		if (::World.Assets.getOrigin().getID() == "scenario.manhunters")
		{
			local roster = ::World.getPlayerRoster().getAll();
			local slaves = 0;
			local nonSlaves = 0;

			foreach( bro in roster )
			{
				if (!bro.isPlacedOnMap())
				{
					continue;
				}

				if (bro.getBackground().getID() == "background.slave")
				{
					slaves = ++slaves;
				}
				else
				{
					nonSlaves = ++nonSlaves;
				}
			}

			if (slaves <= nonSlaves)
			{
				foreach( bro in roster )
				{
					if (!bro.isPlacedOnMap())
					{
						continue;
					}

					if (bro.getBackground().getID() != "background.slave")
					{
						bro.worsenMood(::Const.MoodChange.TooFewSlavesInBattle, "Too few indebted in battle");
					}
				}
			}
		}

		foreach( player in this.m.Instances[::Const.Faction.Player] )
		{
			player.onCombatStart();
		}

		::Math.seedRandom(::Time.getRealTime());
	}}.spawn;
});
