::Hardened.HooksMod.hook("scripts/items/weapons/hunting_bow", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 800;		// Vanilla: 400
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.55
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/quick_shot"));
		this.addSkill(::new("scripts/skills/actives/aimed_shot"));
	}}.onEquip;
});
