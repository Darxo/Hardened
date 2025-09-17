// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/militia_captain", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 130 - 150
			[12, "scripts/items/armor/basic_mail_shirt"],
			[12, "scripts/items/armor/mail_shirt"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 130
			[12, "scripts/items/helmets/nasal_helmet"],
			[12, "scripts/items/helmets/kettle_hat"],
			[12, "scripts/items/helmets/padded_kettle_hat"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/fighting_spear"],
			[12, "scripts/items/weapons/arming_sword"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/kite_shield"],
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
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Spear))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_king_of_all_weapons"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_en_garde"));
			}
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_militia");
		this.getSprite("accessory_special").setBrush("bust_militia_band_02");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.MilitiaCaptain);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_battle_fervor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_shield_sergeant"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
