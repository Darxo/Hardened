// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/bounty_hunter", function(q) {
	// Public
	q.m.HD_BandageChance <- 30;

	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 130 - 170
			[12, "scripts/items/armor/basic_mail_shirt"],
			[12, "scripts/items/armor/leather_scale_armor"],
			[12, "scripts/items/armor/mail_shirt"],
			[12, "scripts/items/armor/light_scale_armor"],
			[12, "scripts/items/armor/mail_hauberk"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 120 - 160
			[12, "scripts/items/helmets/nasal_helmet"],
			[12, "scripts/items/helmets/padded_nasal_helmet"],
			[12, "scripts/items/helmets/reinforced_mail_coif"],
			[12, "scripts/items/helmets/kettle_hat"],
			[12, "scripts/items/helmets/flat_top_helmet"],
			[12, "scripts/items/helmets/padded_flat_top_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/arming_sword"],
			[12, "scripts/items/weapons/flail"],
			[12, "scripts/items/weapons/morning_star"],
			[12, "scripts/items/weapons/hand_axe"],
			[12, "scripts/items/weapons/boar_spear"],
		]);

		this.m.ChanceForNoOffhand = 30;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
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
		::Hardened.util.preSwapRangedWeapon(this);

		if (this.getOffhandItem() == null)	// Variant with throwing spear
		{
			this.getSkills().add(::new("scripts/skills/perks/perk_rf_hybridization"));	// Toolbox
		}
		else	// Variant with throwing net
		{
			this.getSkills().add(::new("scripts/skills/perks/perk_rf_kingfisher"));
		}
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
		b.setValues(::Const.Tactical.Actor.BountyHunter);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_head_hunter"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_parry"));

		this.getSkills().add(::new("scripts/skills/perks/perk_quick_hands"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_offhand_training"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		if (this.getOffhandItem() == null)	// Variant with throwing spear
		{
			this.getItems().addToBag(::new("scripts/items/weapons/throwing_spear"));
		}

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag) && ::Math.rand(1, 100) <= this.m.HD_BandageChance)
		{
			this.getItems().addToBag(::new("scripts/items/accessory/bandage_item"));
		}
	}
});
