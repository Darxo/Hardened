::Hardened.HooksMod.hook("scripts/ui/screens/world/world_event_screen", function(q) {
	q.convertEventToUIData = @(__original) function( _event )
	{
		local ret = __original(_event);
		ret.isContract <- this.m.IsContract;	// We use this information to decide whether we lock the button presses for 1 second after the screen was created
		return ret;
	}
});
