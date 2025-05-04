::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_pike", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.addWeaponType(::Const.Items.WeaponType.Spear, true);
		this.m.Reach = 6;	// In Reforged this is 7
	}
});
