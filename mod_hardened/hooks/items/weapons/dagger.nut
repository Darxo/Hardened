::Hardened.HooksMod.hook("scripts/items/weapons/dagger", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RegularDamage = 20;		// Vanilla: 15
		this.m.RegularDamageMax = 30;	// Vanilla: 35
		this.m.ArmorDamageMult = 0.5;	// Vanilla: 0.6
	}

	// We overwrite Reforged skill additions, because we dont hand out any discounts
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();
		this.addSkill(::new("scripts/skills/actives/stab"));
		this.addSkill(::new("scripts/skills/actives/puncture"));
	}}.onEquip;
});
