::Hardened.HooksMod.hook("scripts/items/weapons/warbrand", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 2600;			// Vanilla: 1600
		this.m.StaminaModifier = -12;	// Vanilla: -10
		this.m.RegularDamage = 65;		// Vanilla: 50
		this.m.RegularDamageMax = 75;	// Vanilla: 75
		this.m.ArmorDamageMult = 0.75;	// Vanilla: 0.75
		this.m.DirectDamageMult = 0.3;	// Vanilla: 0.2
		this.m.ChanceToHitHead = 0;		// Vanilla: 5
		this.m.Reach = 6;				// Reforged: 6
	}

	// Overwrite, because we dont change the skill costs, move over our armor penetration values and add riposte instead of swing
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::new("scripts/skills/actives/slash"));
		this.addSkill(::new("scripts/skills/actives/swing"));
		this.addSkill(::new("scripts/skills/actives/riposte"));
	}}.onEquip;
});
