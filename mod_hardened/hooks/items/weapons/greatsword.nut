::Hardened.HooksMod.hook("scripts/items/weapons/greatsword", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ChanceToHitHead = 10;	// Vanilla: 5
		this.m.ShieldDamage = 0;	// Reforged: 0

		this.m.Reach = 6;	// In Reforged this is 7
	}

	// Overwrite, because we remove split_shield
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/overhead_strike"));
		this.addSkill(::new("scripts/skills/actives/split"));
		this.addSkill(::new("scripts/skills/actives/swing"));
	}}.onEquip;
});
