::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.RegularDamage = 30;		// Vanilla: 25
		this.m.RegularDamageMax = 45;	// Vanilla: 40
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.55
		this.m.DirectDamageMult = 0.45;	// Vanilla: 0.35
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/quick_shot"));
		this.addSkill(::new("scripts/skills/actives/aimed_shot"));
	}}.onEquip;
});

