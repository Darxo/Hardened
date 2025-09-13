::Hardened.HooksMod.hook("scripts/contracts/contract", function(q) {
	// Private
	q.m.BufferedListItems <- [];	// Array of Tables, defining changes that need to be displayed in the next possible screen as they happened in response to an option
	q.m.IsProcessingInput <- false;		// Is true, while we are calling getResult from the chosen contract option

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
		__original(_screen, _restartIfAlreadyActive);
	}

	q.addUnitsToEntity = @(__original) function( _worldParty, _party, _resources )
	{
		_resources *= ::Hardened.Global.getWorldDifficultyMult();
		return __original(_worldParty, _party, _resources);
	}

// New Functions
	// Add a list item either to the active screen or the next screen over
	q.addListItem <- function( _listItem )
	{
		if (this.m.IsProcessingInput)
		{
			this.addBufferedListItem(_listItem);
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
