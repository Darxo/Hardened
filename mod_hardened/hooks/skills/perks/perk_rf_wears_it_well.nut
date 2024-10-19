::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_wears_it_well", function(q) {
	q.m.WeightMult <- 0.5;

	// Replace Reforged calculation
	q.onUpdate = @() function( _properties )
	{
		_properties.WeightStaminaMult[::Const.ItemSlot.Mainhand] *= this.m.WeightMult;
		_properties.WeightStaminaMult[::Const.ItemSlot.Offhand] *= this.m.WeightMult;
		_properties.WeightInitiativeMult[::Const.ItemSlot.Mainhand] *= this.m.WeightMult;
		_properties.WeightInitiativeMult[::Const.ItemSlot.Offhand] *= this.m.WeightMult;
	}
});
