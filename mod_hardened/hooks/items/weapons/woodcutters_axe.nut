::Hardened.HooksMod.hook("scripts/items/weapons/woodcutters_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RegularDamageMax -= 10;	// In Vanilla this is 70
	}
});
