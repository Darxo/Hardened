::Hardened.HooksMod.hook("scripts/items/weapons/rf_greatsword", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2000;	// Reforged: 2400
		this.m.ShieldDamage = 0;	// Reforged: 0
	}

	// Overwrite, because we remove the discount from all skills and remove the addition of split_shield
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/overhead_strike"));
		this.addSkill(::new("scripts/skills/actives/split"));
		this.addSkill(::new("scripts/skills/actives/swing"));
	}}.onEquip;
});
