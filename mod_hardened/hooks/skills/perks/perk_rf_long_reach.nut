::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_long_reach", function(q) {
	q.create = @(__original) function()
	{
		__original();
		// Long Reach now only works with a Polearm weapon but no longer cares about Reach
		this.m.RequiredWeaponType = ::Const.Items.WeaponType.Polearm;
		this.m.RequiredWeaponReach = 0;
	}
});
