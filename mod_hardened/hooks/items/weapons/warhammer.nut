::Hardened.HooksMod.hook("scripts/items/weapons/warhammer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.StaminaModifier = -12;		// Vanilla: -8
	}
});
