// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/mercenary", function(q) {
	// Public
	q.m.HD_BandageChance <- 30;

	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 130 - 190
			[12, "scripts/items/armor/basic_mail_shirt"],
			[12, "scripts/items/armor/leather_scale_armor"],
			[12, "scripts/items/armor/mail_shirt"],
			[12, "scripts/items/armor/light_scale_armor"],
			[12, "scripts/items/armor/mail_hauberk"],
			[12, "scripts/items/armor/footman_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 120 - 180
			[12, "scripts/items/helmets/padded_kettle_hat"],
			[12, "scripts/items/helmets/padded_nasal_helmet"],
			[12, "scripts/items/helmets/padded_flat_top_helmet"],
			[12, "scripts/items/helmets/closed_flat_top_helmet"],
			[12, "scripts/items/helmets/closed_flat_top_with_neckguard"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/arming_sword"],
			[12, "scripts/items/weapons/flail"],
			[12, "scripts/items/weapons/military_pick"],
			[6, "scripts/items/weapons/rf_battle_axe"],
			[6, "scripts/items/weapons/rf_greatsword"],
			[6, "scripts/items/weapons/rf_two_handed_falchion"],
			[6, "scripts/items/weapons/longsword"],
			[8, "scripts/items/weapons/billhook"],
			[8, "scripts/items/weapons/pike"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/heater_shield"],
			[12, "scripts/items/shields/kite_shield"],
			[12, "scripts/items/shields/wooden_shield"],
			[12, "scripts/items/tools/throwing_net"],
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
		b.setValues(::Const.Tactical.Actor.Mercenary);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_fast_adaption"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_skirmisher"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_coup_de_grace"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag) && ::Math.rand(1, 100) <= this.m.HD_BandageChance)
		{
			this.getItems().addToBag(::new("scripts/items/accessory/bandage_item"));
		}
		this.paintShieldsInCompanyColors();
	}
});
