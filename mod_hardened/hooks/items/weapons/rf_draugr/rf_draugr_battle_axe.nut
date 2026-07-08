::Hardened.HooksMod.hook("scripts/items/weapons/rf_draugr/rf_draugr_battle_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// We restrict this weapon to one visual type to improve clarity on the battlefield
		this.m.Variant = 1;		// Reforged: ::Math.rand(1, 3);
		this.updateVariant();

		// Same State as Battle Axe, except Value and Reach
		this.m.Value = 1700;				// Reforged: 1650
		this.m.RegularDamage = 60;			// Reforged: 45
		this.m.RegularDamageMax = 80;		// Reforged: 65
		this.m.ShieldDamage = 32;			// Reforged: 24
		this.m.ConditionMax = 64.0;			// Reforged: 72.0
		this.m.StaminaModifier = -12;		// Reforged: -14
		this.m.ArmorDamageMult = 1.40;		// Reforged: 1.35
		this.m.DirectDamageMult = 0.4;
		this.m.DirectDamageAdd = 0.0;		// Reforged: 0.05
		this.m.ChanceToHitHead = 0;			// Reforged: 5

		this.m.Reach = 6;					// Reforged: 5
	}

	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/split_man"));
		this.addSkill(::Reforged.new("scripts/skills/actives/round_swing"));
		this.addSkill(::Reforged.new("scripts/skills/actives/split_shield"));
	}}.onEquip;
});
