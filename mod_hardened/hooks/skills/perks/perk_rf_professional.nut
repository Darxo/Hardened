::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_professional", function(q) {
	// Public
	q.m.XPGainMult <- 0.95;
	// Overwrite Reforged lose adding of line breaker skill

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.XPGainMult *= this.m.XPGainMult;
	}
});
