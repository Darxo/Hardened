::Hardened.HooksMod.hook("scripts/items/weapons/short_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 250;				// Vanilla: 200
		this.m.RangeMax = 6;			// Vanilla: 7
		this.m.RegularDamage = 35;		// Vanilla: 30
		// this.m.RegularDamageMax = 50;	// Vanilla: 50

		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.5
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/quick_shot"));
		this.addSkill(::new("scripts/skills/actives/aimed_shot"));
	}}.onEquip;
});
