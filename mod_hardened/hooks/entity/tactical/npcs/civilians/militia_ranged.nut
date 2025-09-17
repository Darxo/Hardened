// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/militia_ranged", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[4, "scripts/items/armor/leather_tunic"],
			[12, "scripts/items/armor/linen_tunic"],
		]);

		this.m.ChanceForNoHelmet = 50;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/hood"],
			[12, "scripts/items/helmets/aketon_cap"],
			[12, "scripts/items/helmets/open_leather_cap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/short_bow"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
		this.HD_assignOtherGear();
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_militia");
		this.getSprite("accessory_special").setBrush("bust_militia_band_01");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.MilitiaRanged);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_battle_fervor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_entrenched"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		this.getItems().equip(::new("scripts/items/ammo/quiver_of_arrows"));

		local sidearm = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/knife"],
			[12, "scripts/items/weapons/wooden_flail"],
			[12, "scripts/items/weapons/wooden_stick"],
		]).roll();
		this.getItems().addToBag(::new(sidearm));
	}
});
