::Hardened.HooksMod.hook("scripts/skills/perks/perk_bags_and_belts", function(q) {
	// Public
	q.m.WeightStaminaMult <- 0.0;
	q.m.WeightInitiativeMult <- 0.0;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.WeightStaminaMult[::Const.ItemSlot.Bag] *= this.m.WeightStaminaMult;
	}
});
