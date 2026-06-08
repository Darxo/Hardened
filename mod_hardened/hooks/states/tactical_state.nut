::Hardened.HooksMod.hook("scripts/states/tactical_state", function(q) {
	// Public
	q.m.HD_CameraPanSpeed <- 1200.0;		// Vanilla: 1500.0

	// Private
	q.m.HD_HasDiscoveredEnemy <- false;
	q.m.HD_IsHidingMusic <- false;

	q.computeEntityPath = @(__original) function( _activeEntity, _mouseEvent )
	{
		__original(_activeEntity, _mouseEvent);

		local activeEntity = ::Tactical.TurnSequenceBar.getActiveEntity();
		if (activeEntity != null && this.m.CurrentActionState == ::Const.Tactical.ActionState.ComputePath)
		{
			if (::Settings.getGameplaySettings().AdjustCameraLevel && ::Hardened.Mod.ModSettings.getSetting("AutoCameraLevelMovement").getValue())
			{
				if (::Hardened.Camera.PreviousCameraLevel == null)
				{
					::Hardened.Camera.PreviousCameraLevel = ::Tactical.getCamera().Level;
				}

				::Tactical.getCamera().Level = ::Hardened.Camera.getBestLevelForMoving(this.m.LastTileSelected);
			}
		}
	}

	q.gatherLoot = @(__original) function()
	{
		// In Hardened we default initialize this.m.StrategicProperties to improve compatibility of tactical scenarios
		// Vanilla tries to access World.State, if this is not null, so we need to revert StrategicProperties back to null
		if (this.isScenarioMode())
		{
			this.m.StrategicProperties = null;
		}

		__original();
	}

	// We have to hook onFinish, because it is the last thing that happens, before tactical_state is deconstructed
	// And it is happening right after the combat loot is added to the stash
	q.onFinish = @(__original) function()
	{
		__original();	// During this time ::Tactical.State will be destroyed, turning off all most combat-only checks

		// We remove tactical_state entry early, because most of it was already deconstructed anyways.
		// Otherwise we potentially run into issues with the following restoreEquipment call, when something uses hasState to check for TacticalState presence
		::MSU.Utils.States.rawdelete("tactical_state");

		// Vanilla Fix: Vanilla calls this during `onCombatFinished()`, but that timing is too early.
		// By that time none of the ground- or camp items have been looted. So dropped items will not be able to be restored correctly
		if (::Settings.getGameplaySettings().RestoreEquipment)
		{
			if (::World.Assets != null)		// When the player Quits out of Battle into main menu, onFinish is called too, but ::World.Asset is null by then
			{
				::World.Assets.restoreEquipment();
			}
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
			// Swicheroo: set player faction briefly to 0 to prevent vanilla from revealing the map for the player
			// This is revered in tooltip::hide, because we can't wait for the whole function to finish and need to revert it early
			::Const.Faction.Player = 0;
		}

		__original();
	}

	q.onMouseInput = @(__original) function( _mouse )
	{
		if (this.isInLoadingScreen()) return __original(_mouse);
		if (this.m.IsBattleEnded) return __original(_mouse);
		if (!::Tactical.State.isPaused() && this.isInputLocked()) return __original(_mouse);		// Feat: We allow zooming while the game is paused

		// We overwrite only the mouse wheel events coming from vanilla to customize the zoom multiplier
		if (_mouse.getID() == 7)
		{
			local mouseWheelZoomMultiplier = ::Hardened.Mod.ModSettings.getSetting("MouseWheelZoomMultiplier").getValue();
			if (_mouse.getState() == 3)
			{
				::Tactical.getCamera().zoomBy(-mouseWheelZoomMultiplier);
				return true;
			}
			else if (_mouse.getState() == 4)
			{
				::Tactical.getCamera().zoomBy(mouseWheelZoomMultiplier);
				return true;
			}
		}

		return __original(_mouse);
	}

	q.tactical_retreat_screen_onYesPressed = @(__original) function()
	{
		// Vanilla Fix: We prevent a rare end-of-combat freeze, when "something" is animating while we click the "It\'s over" button
		// Vanilla always hides dialog when we click the "Yes" button. But some important actions only happen during the popping of the menu stack
		// Those actions don't happen if TacticalDialogScreen.isAnimating() == true
		// So in the rare case that something is animating while we press that button, we are softlocked because all interfaces are hidden
		// In one reported case, this animation turned out to be really long, or permanent, so we can't just have the player wait it out
		// Instead, we pretend like nothing is animating during the resolution of the original function, guaranteeing, that it always resolves
		local oldTacticalDialogScreen = this.m.TacticalDialogScreen.m.Animating;
		this.m.TacticalDialogScreen.m.Animating = false;
		__original();
		this.m.TacticalDialogScreen.m.Animating = oldTacticalDialogScreen;
	}

	q.tactical_retreat_screen_onNoPressed = @(__original) function()
	{
		// Vanilla Fix: We prevent a rare end-of-combat freeze, when "something" is animating while we click the "Run them down!" button
		// Vanilla always hides dialog when we click the "No" button. But some important actions only happen during the popping of the menu stack
		// Those actions don't happen if TacticalDialogScreen.isAnimating() == true
		// So in the rare case that something is animating while we press that button, we are softlocked because all interfaces are hidden
		// In one reported case, this animation turned out to be really long, or permanent, so we can't just have the player wait it out
		// Instead, we pretend like nothing is animating during the resolution of the original function, guaranteeing, that it always resolves
		local oldTacticalDialogScreen = this.m.TacticalDialogScreen.m.Animating;
		this.m.TacticalDialogScreen.m.Animating = false;
		__original();
		this.m.TacticalDialogScreen.m.Animating = oldTacticalDialogScreen;
	}

	q.helper_handleContextualKeyInput = @(__original) function( _key )
	{
		if (this.isInLoadingScreen()) return __original(_key);
		if (this.helper_handleDeveloperKeyInput(_key)) return true;
		if (this.isBattleEnded()) return __original(_key);
		if (_key.getModifier() == KeyModifier.Control) return __original(_key);
		if (_key.getState() == 1)
		{
			// Feat: We allow moving the camera with hotkeys while the game is paused
			if ((!::Tactical.State.isPaused() && this.isInputLocked()) || this.isInCharacterScreen() || this.m.IsDeveloperModeEnabled || this.m.MenuStack.hasBacksteps()) return false;

			// Vanilla Fix: We prevent Lag Spikes during battle from causing the camera position to jump from pressing WASD keys
			// This is caused because (I assume) helper_handleContextualKeyInput is called once every frame
			// Therefor we need to scale the distance, that we move by the time since the last frame (::Time.getDelta())
			// A lag causes the time since the last frame to skyrocket, which would then catapult your camera in one direction if you happened to have held a WASD key down
			// Our solution is to limit the speed-up of the camera panning to at most that of a 20 FPS (delta of 0.05 seconds since last frame) game
			// As a consequence, if you happen to have less than 20 FPS consistently, your camera movement will slow down
			local dt = ::Math.minf(::Time.getDelta(), 0.05);
			switch(_key.getKey())
			{
				case Key.A:
				case Key.Q:		// Probably supported because of french keyboards
				case Key.ArrowLeft:
				{
					::Tactical.getCamera().move(-this.m.HD_CameraPanSpeed * dt, 0);
					return true;
				}

				case Key.D:
				case Key.ArrowRight:
				{
					::Tactical.getCamera().move(this.m.HD_CameraPanSpeed * dt, 0);
					return true;
				}

				case Key.W:
				case Key.Z:		// Probably supported because of french keyboards
				case Key.ArrowUp:
				{
					::Tactical.getCamera().move(0, this.m.HD_CameraPanSpeed * dt);
					return true;
				}

				case Key.S:
				case Key.ArrowDown:
				{
					::Tactical.getCamera().move(0, -this.m.HD_CameraPanSpeed * dt);
					return true;
				}
			}
		}
		else (_key.getState() != 1)		// Vanilla checks some keys only on release
		{
			if (this.isInCharacterScreen()) return __original(_key);
			if (this.m.MenuStack.hasBacksteps()) return __original(_key);

			// We prevent some hard-coded vanilla F keybind from doing anything. MSU has a custom keybind for this
			if (_key.getKey() == Key.F) return false;
			if (_key.getKey() == Key.Return) return false;
		}
		return __original(_key);
	}

	q.turnsequencebar_onNextRound = @(__original) function( _round )
	{
		// Our goal here is to call onRoundStart/End for otherwise left-out entities. Those all have in common that they have IsActingEachTurn set to false
		// For that we wrap the __original() call with an additional onRoundEnd() before, and onRoundStart() after.
		// That works because turnsequencebar_onNextRound() is the first thing happening after vanilla calls onRoundEnd() and the first thing happening before onRoundStart()

		// We clone this in order to not trigger onRoundEnd() for newly spawned entities which were just added by other onRoundEnd() calls
		local instances = clone ::Tactical.Entities.getAllInstances();
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
		instances = clone ::Tactical.Entities.getAllInstances();
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
