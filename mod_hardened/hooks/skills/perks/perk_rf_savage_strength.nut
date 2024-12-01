::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_savage_strength", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Mult = 0.8;	// In Reforged this is 0.75
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.IsImmuneToDisarm = true;
	}
});
