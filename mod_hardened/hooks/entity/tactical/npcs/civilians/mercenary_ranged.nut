// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/mercenary_ranged", function(q) {
	// Public
	q.m.HD_BandageChance <- 30;

	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 110 - 140
			[12, "scripts/items/armor/worn_mail_shirt"],
			[12, "scripts/items/armor/basic_mail_shirt"],
			[12, "scripts/items/armor/leather_scale_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 110 - 130
			[12, "scripts/items/helmets/rf_scale_helmet"],
			[12, "scripts/items/helmets/rf_padded_scale_helmet"],
			[12, "scripts/items/helmets/kettle_hat"],
			[12, "scripts/items/helmets/padded_kettle_hat"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/hunting_bow"],
			[12, "scripts/items/weapons/crossbow"],
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
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_militia");
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.MercenaryRanged);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_fast_adaption"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_skirmisher"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_through_the_ranks"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_combo"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Bow))
			{
				this.getItems().equip(::new("scripts/items/ammo/quiver_of_arrows"));
			}
			else
			{
				this.getItems().equip(::new("scripts/items/ammo/quiver_of_bolts"));
			}
		}

		local sidearm = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/falchion"],
			[12, "scripts/items/weapons/hand_axe"],
		]).roll();
		this.getItems().addToBag(::new(sidearm));

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag) && ::Math.rand(1, 100) <= this.m.HD_BandageChance)
		{
			this.getItems().addToBag(::new("scripts/items/accessory/bandage_item"));
		}
	}
});
