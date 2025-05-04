::Hardened.HooksMod.hook("scripts/states/tactical_state", function(q) {
	q.onFinish = @(__original) function()
	{
		__original();	// During this time ::Tactical.State will be destroyed, turning off all combat-only checks

		// Vanilla Fix: Vanilla calls this during `onCombatFinished()`, but that timing is too early.
		// By that time none of the ground- or camp items have been looted. So dropped items will not be able to be restored correctly
		if (::Settings.getGameplaySettings().RestoreEquipment)
		{
			::World.Assets.restoreEquipment();
		}

		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			// In Vanilla there is no update() call, after entities lose their isPlacedOnMap() == true. So some positioning-related effects will be inaccurate
			// Examples are Lone Wolf, Entrenched, Scout, Militia
			bro.getSkills().update();
		}
	}

	q.onBattleEnded = @(__original) function()
	{
		if (!this.m.IsExitingToMenu)	// In vanilla this function ends early so we don't apply our switcheroo
		{
			::Const.Faction.Player = 0;		// Swicheroo: set player faction briefly to 0 to prevent vanilla from revealing the map for the player
		}

		__original();
	}

	q.onMouseInput = @(__original) function( _mouse )
	{
		// We overwrite only the mouse wheel events coming from vanilla to customize the zoom multiplier
		if (_mouse.getID() == 7)
		{
			local mouseWheelZoomMultiplier = ::Hardened.Mod.ModSettings.getSetting("MouseWheelZoomMultiplier").getValue();
			if (_mouse.getState() == 3)
			{
				::Tactical.getCamera().zoomBy(-::Time.getDelta() * ::Math.max(60, ::Time.getFPS()) * mouseWheelZoomMultiplier);
				return true;
			}
			else if (_mouse.getState() == 4)
			{
				::Tactical.getCamera().zoomBy(::Time.getDelta() * ::Math.max(60, ::Time.getFPS()) * mouseWheelZoomMultiplier);
				return true;
			}
		}

		return __original(_mouse);
	}

	q.turnsequencebar_onNextRound = @(__original) function( _round )
	{
		// Our goal here is to call onRoundStart/End for otherwise left-out entities. Those all have in common that they have IsActingEachTurn set to false
		// For that we wrap the __original() call with an additional onRoundEnd() before, and onRoundStart() after.
		// That works because turnsequencebar_onNextRound() is the first thing happening after vanilla calls onRoundEnd() and the first thing happening before onRoundStart()

		// We clone this in order to not trigger onRoundEnd() for newly spawned entities which were just added by other onRoundEnd() calls
		local instances = clone this.Tactical.Entities.getAllInstances();
		foreach (faction in instances)
		{
			foreach (entity in faction)
			{
				if (!entity.isAlive() || entity.m.IsActingEachTurn)
				{
					continue;
				}

				entity.onRoundEnd();
			}
		}

		__original(_round);

		// We clone this in order to not trigger onRoundStart() for newly spawned entities which were just added by other onRoundStart() calls
		instances = clone this.Tactical.Entities.getAllInstances();
		foreach (faction in instances)
		{
			foreach (entity in faction)
			{
				if (!entity.isAlive() || entity.m.IsActingEachTurn)
				{
					continue;
				}

				entity.onRoundStart();
			}
		}
	}
});
