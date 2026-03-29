::Hardened.HooksMod.hook("scripts/items/weapons/wonky_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 150;				// Vanilla: 100
		this.m.RangeMax = 6;			// Vanilla: 7
		// this.m.RegularDamage = 30;		// Vanilla: 30
		this.m.RegularDamageMax = 45;	// Vanilla: 50
		this.m.AdditionalAccuracy = 0;	// Vanilla: -10

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
