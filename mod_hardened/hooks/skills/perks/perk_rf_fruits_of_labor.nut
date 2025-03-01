::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_fruits_of_labor", function(q) {
	q.m.HitpointsMult <- 1.1;
	q.m.StaminaMult <- 1.1;

	// Overwrite because we adjust the character stats sligthly differently
	q.onUpdate = @() function( _properties )
	{
		_properties.HitpointsMult *= this.m.HitpointsMult;
		_properties.StaminaMult *= this.m.StaminaMult;
	}
});
