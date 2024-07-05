::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_fencer", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.FatigueMult = 1.0;	// This perk no longer grants a fatigue discount
		this.m.Bonus = 0;	// This perk no longer grants any hit chance bonus
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		if (!this.isEnabled()) return;
		_properties.WeaponDurabilityLossMult *= 0.5;
	}
});
