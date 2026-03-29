::Hardened.HooksMod.hook("scripts/items/weapons/ancient/ancient_spear", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 750;				// Vanilla: 150
		this.m.StaminaModifier = -10;	// Vanilla: 6
		this.m.RegularDamage = 30;		// Vanilla: 20
		this.m.RegularDamageMax = 40;	// Vanilla: 35
	}

	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/thrust"));
		this.addSkill(::new("scripts/skills/actives/spearwall"));
	}}.onEquip;
});
