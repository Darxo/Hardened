::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bolster", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RequiredWeaponType = ::Const.Items.WeaponType.Polearm;
		this.m.RequiredWeaponReach = 0;
	}
});
