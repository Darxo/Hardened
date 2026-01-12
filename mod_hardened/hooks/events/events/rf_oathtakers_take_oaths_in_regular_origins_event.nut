::Hardened.HooksMod.hook("scripts/events/events/rf_oathtakers_take_oaths_in_regular_origins_event", function(q) {
	// We disable this event from ever firing
	// Existing oathtakers will be stuck on their oath as a result as long as Hardened is installed
	q.isValid = @() function()
	{
		return false;
	}
});
