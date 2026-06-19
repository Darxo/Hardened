::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/rf_orc_mace_2h", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.StaminaModifier = -40;	// Reforged: -45
	}
});
