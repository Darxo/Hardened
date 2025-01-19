::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_ambusher", function(q) {
	q.assignRandomEquipment = @(__original) function()
	{
		__original();

		::Hardened.util.replaceMainhand(this, "scripts/items/weapons/greenskins/goblin_heavy_bow");
	}
});
