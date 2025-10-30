::Hardened.HooksMod.hook("scripts/items/weapons/rf_swordstaff", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.StaminaModifier = -12;	// Reforged: -10
	}
});
