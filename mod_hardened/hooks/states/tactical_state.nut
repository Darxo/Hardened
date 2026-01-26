::Hardened.HooksMod.hook("scripts/states/tactical_state", function(q) {
	// Public
	q.m.HD_CameraPanSpeed <- 1200.0;		// Vanilla: 1500.0
	q.m.HD_NeutralCombatTracks <- ["music/hd_silent_music.ogg"];	// Playlist of songs that are played at the start of battle, while you haven't discovered any enemy yet

	// Private
	q.m.HD_IsPlayingRealCombatMusic <- false;

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
		if (this.isInputLocked()) return __original(_mouse);

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

	q.onShow = @(__original) { function onShow()
	{
		__original();

		// Feat: Combat Music no longer plays right from the start in order to not spoil the enemy type you are up against
		// We overwrite the vanilla setTrackList call by calling it again with our neutral track list
		::Music.setTrackList(this.m.HD_NeutralCombatTracks, ::Const.Sound.CrossFadeTime);
		this.m.HD_IsPlayingRealCombatMusic = false;
	}}.onShow;

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
		if (this.helper_handleDeveloperKeyInput(_key)) return __original(_key);
		if (this.isBattleEnded()) return __original(_key);
		if (_key.getModifier() == KeyModifier.Control) return __original(_key);
		if (_key.getState() == 1)
		{
			if (this.isInputLocked() || this.isInCharacterScreen() || this.m.IsDeveloperModeEnabled || this.m.MenuStack.hasBacksteps()) return false;

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
		return __original(_key);
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

// New Functions
	// Enable combat music, similar to how Vanilla does it in the onShow function
	q.RF_playActualTrackList <- function()
	{
		if (this.m.HD_IsPlayingRealCombatMusic) return;
		this.m.HD_IsPlayingRealCombatMusic = true;

		if (this.m.Scenario != null)
		{
			::Music.setTrackList(this.m.Scenario.getMusic(), ::Const.Sound.CrossFadeTime);
		}
		else
		{
			if (this.m.StrategicProperties != null)
			{
				::Music.setTrackList(this.m.StrategicProperties.Music, ::Const.Music.CrossFadeTime);
			}
			else
			{
				::Music.setTrackList(::Const.Music.BattleTracks[this.m.Factions.getHostileFactionWithMostInstances()], ::Const.Music.CrossFadeTime);
			}
		}
	}
});
