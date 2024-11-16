::Hardened.HooksMod.hook("scripts/entity/world/location", function(q) {
	q.m.TemporarilyShowingName <- false;	// is this location currently displaying its name?
});
