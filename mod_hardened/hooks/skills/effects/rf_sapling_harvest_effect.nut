::Hardened.HooksMod.hook("scripts/skills/effects/rf_sapling_harvest_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.DamageThreshold = 0.07;	// Reforged: 0.1; We reduce this value because Schrats have more base hitpoints in Hardened
		this.m.Icon = "ui/orientation/schrat_02_orientation.png";	// In Reforged this is an unused bush of leaves
	}
});
