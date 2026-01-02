::Hardened.HooksMod.hook("scripts/items/weapons/longsword", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Value = 1200;			// Vanilla: 1700; Reforged: 2400

		this.m.StaminaModifier = -10;
		this.m.RegularDamage = 45;		// Vanilla: 65	; Reforged: 65
		this.m.RegularDamageMax = 55;	// Vanilla: 85	; Reforged: 75
		this.m.DirectDamageMult = 0.3;	// Vanilla: 0.25
		this.m.ArmorDamageMult = 0.75;	// Vanilla: 1.0
		this.m.ChanceToHitHead = 0;		// Vanilla: 5; 	Reforged: 10

		this.m.Reach = 6;				// Reforged: 5
	}

	// Overwrite, because we dont change the skill costs, move over our armor penetration values and add riposte instead of swing
	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		local self = this;

		this.addSkill(::new("scripts/skills/actives/slash"));
		this.addSkill(::new("scripts/skills/actives/swing"));
		this.addSkill(::new("scripts/skills/actives/riposte"));
	}}.onEquip;
});
