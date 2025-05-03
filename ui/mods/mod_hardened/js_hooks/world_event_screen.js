Hardened.Hooks.WorldEventScreen_show = WorldEventScreen.prototype.show;
WorldEventScreen.prototype.show = function (_data)
{
	this.mBlockButtonInput = false;

	if (_data !== undefined && _data !== null && (typeof(_data) === 'object'))	// Sometimes _data can be null
	{
		if(!this.mIsVisible && !_data['isContract'])	// We ignore this for contracts, because those never appear spontaneously, and here the player will regularly be too fast for the 1 second delay
		{
			this.mBlockButtonInput = true;
			var self = this
			setTimeout(function() {
				self.mBlockButtonInput = false;		// We prohibit event buttons to be pressed for 0.8 seconds to prevent player from accidentally clicking an event choice
			}, 800);
		}
	}


	Hardened.Hooks.WorldEventScreen_show.call(this, _data);
}

Hardened.Hooks.WorldEventScreen_notifyBackendButtonPressed = WorldEventScreen.prototype.notifyBackendButtonPressed;
WorldEventScreen.prototype.notifyBackendButtonPressed = function (_buttonID)
{
	if (!this.mBlockButtonInput)
	{
		Hardened.Hooks.WorldEventScreen_notifyBackendButtonPressed.call(this, _buttonID);
	}
}
