::Hardened.HooksMod.hook("scripts/items/weapons/wooden_flail", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RegularDamage += 5;
		this.m.RegularDamageMax += 5;
		this.m.Value += 20;
	}
});
