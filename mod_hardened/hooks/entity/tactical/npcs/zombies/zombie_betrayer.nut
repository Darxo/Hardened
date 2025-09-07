// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

// Fallen Betrayers are now called "Fallen Heroes" in Hardened
::Const.Strings.EntityName[::Const.EntityType.ZombieBetrayer] = "Fallen Hero";
::Const.Strings.EntityNamePlural[::Const.EntityType.ZombieBetrayer] = "Fallen Heroes";

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_betrayer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.IsResurrectingOnFatality = true;		// We turned off this value in zombie_knight, so we need to revert that again here

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greataxe"],
			[12, "scripts/items/weapons/two_handed_flail"],
			[12, "scripts/items/weapons/two_handed_flanged_mace"],
			[12, "scripts/items/weapons/two_handed_hammer"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.zombie.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
		this.HD_assignOtherGear();
	}}.assignRandomEquipment;

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.ZombieBetrayer);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_anchor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor = @() function()
	{
		local armor = ::new(::MSU.Class.WeightedContainer([
			[1, "scripts/items/armor/decayed_coat_of_plates"],
			[1, "scripts/items/armor/decayed_coat_of_scales"],
		]).roll());
		if (this.Math.rand(1, 100) <= 33)
		{
			armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(armor);

		local helmet = ::new(::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/decayed_great_helm"],
		]).roll());
		if (this.Math.rand(1, 100) <= 33)
		{
			helmet.setArmor(this.Math.round(helmet.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(helmet);
	}
});
