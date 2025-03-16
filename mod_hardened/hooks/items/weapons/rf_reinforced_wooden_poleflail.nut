::Hardened.HooksMod.hook("scripts/items/weapons/rf_reinforced_wooden_poleflail", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Reach = 5;		// In Reforged this is 6
	}
});
