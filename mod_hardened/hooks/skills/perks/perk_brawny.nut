::Hardened.HooksMod.hook("scripts/skills/perks/perk_brawny", function(q) {
	// Public
	q.m.WeightStaminaMult <- 0.7;

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.WeightStaminaMult[::Const.ItemSlot.Body] *= this.m.WeightStaminaMult;
		_properties.WeightStaminaMult[::Const.ItemSlot.Head] *= this.m.WeightStaminaMult;
	}
});
