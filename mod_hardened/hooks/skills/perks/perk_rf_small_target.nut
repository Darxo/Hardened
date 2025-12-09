::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_small_target", function(q) {
	// Public
	q.m.HD_HeadshotReceivedChanceModifier <- -10;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		_properties.HeadshotReceivedChance += this.m.HD_HeadshotReceivedChanceModifier;
	}
});
