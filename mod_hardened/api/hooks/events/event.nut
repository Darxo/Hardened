::Hardened.HooksMod.hook("scripts/events/event", function(q) {
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

	q.setScreen = @(__original) function( _screen )
	{
		this.m.IsProcessingInput = false;	// since setScreen may be called during processInput and marks the end of the input-procession, we have to set it to false here too
		__original(_screen);
	}

	// Overwrite, to remove the reputation/playerstrength/day scaling
	//	because event scaling is now done by ::Hardened.Global.getWorldDifficultyMult() globally
	q.getScaledDifficultyMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
		return ret;
	}

	// Overwrite, to remove the day scaling
	//	because event scaling is now done by ::Hardened.Global.getWorldDifficultyMult() globally
	q.getReputationToDifficultyLightMult = @() function()
	{
		local ret = 1.0;
		ret *= ::Const.Difficulty.EnemyMult[::World.Assets.getCombatDifficulty()];
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
		else
		{
			this.m.ActiveScreen.List.push(_listItem);
		}
	}

	q.addBufferedListItem <- function( _listItem )
	{
		this.m.BufferedListItems.push(_listItem);
	}
});

::Hardened.HooksMod.hookTree("scripts/events/event", function(q) {
	// We make sure that all screens of all contracts contain at least an empty start() function
	q.create = @(__original) function()
	{
		__original();
		foreach (screen in this.m.Screens)
		{
			local oldStart = screen.start;	// Events are guaranteed to have at least an empty start() function
			screen.start = function( _event ) {
				oldStart(_event);

				// We add bufferedListItems from the previous screen to this list
				foreach (bufferedListItem in _event.m.BufferedListItems)
				{
					this.List.push(bufferedListItem);
				}
				_event.m.BufferedListItems = [];
			}
		}
	}
});
