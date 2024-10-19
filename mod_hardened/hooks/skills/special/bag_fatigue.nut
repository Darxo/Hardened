::Hardened.HooksMod.hook("scripts/skills/special/bag_fatigue", function(q) {
	// Overwrite, because the Bag Fatigue is now handled implicitly by actor.nut
	// The discount from perks like Bags and Belts is now applied directly by those perks
	q.onUpdate = @() function( _properties )
	{
	}
});
