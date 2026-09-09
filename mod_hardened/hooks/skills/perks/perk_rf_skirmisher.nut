::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_skirmisher", function(q) {
	q.m.WeightInitiativeMult <- 0.5;

	q.create = @(__original) function()
	{
		__original();

		this.m.IsHidden = true;
	}

	q.onAdded = @(__original) function()
	{
		__original();

		local encumbrance = this.getContainer().getSkillByID("effects.rf_encumbrance");
		if (encumbrance != null) encumbrance.m.HD_EncumbranceMinWeight = 9999;
	}

	q.onRemoved = @(__original) function()
	{
		__original();

		local encumbrance = this.getContainer().getSkillByID("effects.rf_encumbrance");
		if (encumbrance != null) encumbrance.m.HD_EncumbranceMinWeight = encumbrance.b.HD_EncumbranceMinWeight;
	}

	// Replace Reforged calculation
	q.onUpdate = @() function( _properties )
	{
		_properties.WeightInitiativeMult[::Const.ItemSlot.Body] *= this.m.WeightInitiativeMult;
	}
});
