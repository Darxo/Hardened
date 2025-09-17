// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/militia", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([	// 20 - 50
			[12, "scripts/items/armor/leather_tunic"],
			[12, "scripts/items/armor/linen_tunic"],
			[12, "scripts/items/armor/thick_tunic"],
			[4, "scripts/items/armor/apron"],
			[4, "scripts/items/armor/butcher_apron"],
		]);

		this.m.ChanceForNoHelmet = 50;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 20 - 40
			[12, "scripts/items/helmets/hood"],
			[12, "scripts/items/helmets/aketon_cap"],
			[12, "scripts/items/helmets/headscarf"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/bludgeon"],
			[12, "scripts/items/weapons/hatchet"],
			[36, "scripts/items/weapons/militia_spear"],	// Higher chance because it has militia in the name
			[12, "scripts/items/weapons/pitchfork"],
			[12, "scripts/items/weapons/shortsword"],
			[12, "scripts/items/weapons/reinforced_wooden_flail"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/buckler_shield"],
			[12, "scripts/items/shields/wooden_shield_old"],
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
		b.setValues(::Const.Tactical.Actor.Militia);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_battle_fervor"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});

