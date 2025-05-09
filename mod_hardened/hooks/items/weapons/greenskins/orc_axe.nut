::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/orc_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ShieldDamage = 20;	// In Vanilla this is 16
		this.m.Reach = 4;	// In Reforged this is 3
	}
});
