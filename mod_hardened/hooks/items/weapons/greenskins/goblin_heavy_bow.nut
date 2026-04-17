::Hardened.HooksMod.hook("scripts/items/weapons/greenskins/goblin_heavy_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.RegularDamage = 40;		// Vanilla: 30
		this.m.RegularDamageMax = 55;	// Vanilla: 50
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.6
		// In Vanilla named goblin bows have +10% Armor Penetration. We choose to give that to every goblin bow now
		this.m.DirectDamageAdd = 0.1;	// Vanilla: 0.0
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/quick_shot"));
		this.addSkill(::new("scripts/skills/actives/aimed_shot"));
	}}.onEquip;
});

