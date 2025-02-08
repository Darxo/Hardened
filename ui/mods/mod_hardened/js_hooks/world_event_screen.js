Hardened.Hooks.WorldEventScreen_show = WorldEventScreen.prototype.show;
WorldEventScreen.prototype.show = function (_data)
{
	this.mBlockButtonInput = false;
	if(!this.mIsVisible)
	{
		this.mBlockButtonInput = true;
		var self = this
		setTimeout(function() {
			self.mBlockButtonInput = false;		// We prohibit event buttons to be pressed for 1 second to prevent player from accidentally clicking an event choice
		}, 1000);
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
