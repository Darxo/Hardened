::Hardened.HooksMod.hook("scripts/contracts/contract", function(q) {
	// Private
	q.m.BufferedListItems <- [];	// Array of Tables, defining changes that need to be displayed in the next possible screen as they happened in response to an option
	q.m.IsProcessingInput <- false;		// Is true, while we are calling getResult from the chosen contract option
	q.m.HD_CalledPrematureSetScreen <- false;	// If true, then we have called a setScreen, before this contract was even shown to the player

	q.processInput = @(__original) function( _option )
	{
		this.m.IsProcessingInput = true;
		local ret = __original(_option);
		this.m.IsProcessingInput = false;
		return ret;
	}

	q.setScreen = @(__original) function( _screen, _restartIfAlreadyActive = true )
	{
		this.m.IsProcessingInput = false;	// since setScreen may be called during processInput and marks the end of the input-procession, we have to set it to false here too

		if (_screen != null && !::World.Contracts.m.IsEventVisible)
		{
			this.m.HD_CalledPrematureSetScreen = true;
		}

		__original(_screen, _restartIfAlreadyActive);
	}

	// Overwrite, because we remove the vanilla strength-scaling in it, as contract spawns are now affected by our WorldDiffultyMult instead
	q.getScaledDifficultyMult = @() function()
	{
		local ret = 1.0;	// Vanillas lowest value is 0.75, but we start at 1.0 directly and hope that early game contracts are still doable
		ret *= ::Hardened.Global.getWorldContractMult();
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}

	// Overwrite, because we scale the payment of all contracts linearly with their global difficulty
	// We don't do the smae treatment to getReputationToPaymentLightMult, because that one is no guaranteed to encounter enemies
	q.getReputationToPaymentMult = @() function()
	{
		local ret = 1.35;	// Vanillas lowest value is this, so we use it as a baseline, to upscale our own multiplier
		ret *= ::Hardened.Global.getWorldContractMult();
		ret *= ::Const.Difficulty.PaymentMult[::World.Assets.getEconomicDifficulty()];
		return ret;
	}

// New Functions
	// Add a list item either to the active screen or the next screen over
	q.addListItem <- function( _listItem )
	{
		if (this.m.IsProcessingInput)
		{
			this.addBufferedListItem(_listItem);
		}
		else if (::MSU.isNull(this.getActiveScreen()))
		{
			// Do nothing, as we are currently debugging this
		}
		else
		{
			this.getActiveScreen().List.push(_listItem);
		}
	}

	q.addBufferedListItem <- function( _listItem )
	{
		this.m.BufferedListItems.push(_listItem);
	}

	// This is triggered, just before the start() of a new screen is triggered
	q.onBeforeStart <- function( _screen )
	{
		// We add bufferedListItems from the previous screen to this list
		foreach (bufferedListItem in this.m.BufferedListItems)
		{
			_screen.List.push(bufferedListItem);
		}
		this.m.BufferedListItems = [];
	}
});

::Hardened.HooksMod.hookTree("scripts/contracts/contract", function(q) {
	// We make sure that all screens of all contracts contain at least an empty start() function
	q.createScreens = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			if (!("start" in screen))
			{
				screen.start <- function() {};
			}

			if (!("HD_hookedOnBeforeStart" in screen))
			{
				screen.HD_hookedOnBeforeStart <- true;
				local oldStart = screen.start;
				screen.start = function() {
					this.Contract.onBeforeStart(this);
					oldStart();
				}
			}
		}
	}
});
