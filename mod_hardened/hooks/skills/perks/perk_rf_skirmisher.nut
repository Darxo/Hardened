::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_skirmisher", function(q) {
	q.m.WeightInitiativeMult <- 0.5;

	q.create = @(__original) function()
	{
		__original();

		this.m.IsHidden = true;
	}

	// Replace Reforged calculation
	q.onUpdate = @() function( _properties )
	{
		_properties.FatigueToInitiativeRate *= 0.5;
		_properties.WeightInitiativeMult[::Const.ItemSlot.Body] *= this.m.WeightInitiativeMult;
	}
});
