::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_fruits_of_labor", function(q) {
	q.m.HitpointsMult <- 1.05;
	q.m.StaminaMult <- 1.05;
	q.m.BraveryMult <- 1.05;
	q.m.InitiativeMult <- 1.05;

	// Overwrite because we adjust the character stats sligthly differently
	q.onUpdate = @() function( _properties )
	{
		_properties.HitpointsMult *= this.m.HitpointsMult;
		_properties.StaminaMult *= this.m.StaminaMult;
		_properties.BraveryMult *= this.m.BraveryMult;
		_properties.InitiativeMult *= this.m.InitiativeMult;
	}
});
