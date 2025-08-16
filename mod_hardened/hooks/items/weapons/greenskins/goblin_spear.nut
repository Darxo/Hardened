::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_spear", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.addWeaponType(::Const.Items.WeaponType.Dagger, true);
	}

	// Overwrite because we don't want Reforged to add Thrust or Riposte
	q.onEquip = @() function()
	{
		this.weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/stab"));	// In Vanilla/Reforged this is Thrust
		this.addSkill(::new("scripts/skills/actives/spearwall"));	// Reforged: -1 AP, -12 Fatigue
		// We no longer add Riposte
	}
});
