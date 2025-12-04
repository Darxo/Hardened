// We completely re-design this weapon to become a Tier 2 Two-Handed Axe, slotting in between Woodcutters Axe and Greataxe
::Hardened.HooksMod.hook("scripts/items/weapons/rf_battle_axe", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "A lightweight two-handed axe made for battle, striking with enough force to split shields and the foes behind them.";

		this.m.Value = 1200;				// Reforged: 1950

		this.m.RegularDamage = 60;			// Reforged: 50
		this.m.RegularDamageMax = 80;		// Reforged: 70
		this.m.ShieldDamage = 32;			// Reforged: 26
		this.m.ConditionMax = 64.0;
		this.m.StaminaModifier = -10;		// Reforged: -14
		this.m.ArmorDamageMult = 1.40;		// Reforged: 1.25
		this.m.DirectDamageMult = 0.4;
		this.m.ChanceToHitHead = 0;			// Reforged: 5
	}

	q.onEquip = @() { function onEquip()
	{
		this.weapon.onEquip();

		this.addSkill(::Reforged.new("scripts/skills/actives/split_man"));
		this.addSkill(::Reforged.new("scripts/skills/actives/round_swing"));
		this.addSkill(::Reforged.new("scripts/skills/actives/split_shield"));
	}}.onEquip;
});
