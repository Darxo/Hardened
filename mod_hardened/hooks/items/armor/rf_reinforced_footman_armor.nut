::Hardened.HooksMod.hook("scripts/items/armor/rf_reinforced_footman_armor", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 3500;			// In Reforged this is 4000
	}
});
