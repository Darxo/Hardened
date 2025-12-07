::Hardened.HooksMod.hook("scripts/items/weapons/military_pick", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.StaminaModifier = -10;		// Vanilla: -8
	}
});
