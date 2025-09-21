// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/bounty_hunter_ranged", function(q) {
	// Public
	q.m.HD_BandageChance <- 30;

	q.create = @(__original) function()
	{
		__original();

		// We switch the agent to the regular melee one, as this unit is a hybrid and needs to be smarter with considering melee combat
		this.m.AIAgent = ::new("scripts/ai/tactical/agents/bounty_hunter_melee_agent");		// Vanilla: bounty_hunter_ranged_agent
		this.m.AIAgent.setActor(this);

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
			[12, "scripts/items/weapons/barbarians/heavy_throwing_axe"],
			[12, "scripts/items/weapons/barbarians/heavy_javelin"],
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
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.BountyHunterRanged);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_head_hunter"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_parry"));

		this.getSkills().add(::new("scripts/skills/perks/perk_quick_hands"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_small_target"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_hybridization"));	// Toolbox
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_opportunist"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local sidearm = ::new(::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/arming_sword"],
			[12, "scripts/items/weapons/flail"],
			[12, "scripts/items/weapons/morning_star"],
			[12, "scripts/items/weapons/hand_axe"],
			[12, "scripts/items/weapons/boar_spear"],
		]).roll());
		this.getItems().addToBag(sidearm);

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Bag) && ::Math.rand(1, 100) <= this.m.HD_BandageChance)
		{
			this.getItems().addToBag(::new("scripts/items/accessory/bandage_item"));
		}
	}
});
