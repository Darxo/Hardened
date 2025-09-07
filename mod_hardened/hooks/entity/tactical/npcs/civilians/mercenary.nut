// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/mercenary", function(q) {
	// Public
	q.m.HD_BandageChance <- 30;

	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/arming_sword"],
			[12, "scripts/items/weapons/flail"],
			[12, "scripts/items/weapons/military_pick"],
			[8, "scripts/items/weapons/bardiche"],
			[8, "scripts/items/weapons/rf_kriegsmesser"],
			[12, "scripts/items/weapons/billhook"],
			[12, "scripts/items/weapons/pike"],
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

		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_coup_de_grace"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently mostly a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		local r = ::Math.rand(1, 11);
		if (r == 1)
		{
			this.m.Items.equip(::new("scripts/items/armor/sellsword_armor"));
		}
		else if (r == 2)
		{
			this.m.Items.equip(::new("scripts/items/armor/padded_leather"));
		}
		else if (r == 3)
		{
			this.m.Items.equip(::new("scripts/items/armor/patched_mail_shirt"));
		}
		else if (r == 4)
		{
			this.m.Items.equip(::new("scripts/items/armor/basic_mail_shirt"));
		}
		else if (r == 5)
		{
			this.m.Items.equip(::new("scripts/items/armor/mail_shirt"));
		}
		else if (r == 6)
		{
			this.m.Items.equip(::new("scripts/items/armor/reinforced_mail_hauberk"));
		}
		else if (r == 7)
		{
			this.m.Items.equip(::new("scripts/items/armor/mail_hauberk"));
		}
		else if (r == 8)
		{
			this.m.Items.equip(::new("scripts/items/armor/lamellar_harness"));
		}
		else if (r == 9)
		{
			this.m.Items.equip(::new("scripts/items/armor/footman_armor"));
		}
		else if (r == 10)
		{
			this.m.Items.equip(::new("scripts/items/armor/light_scale_armor"));
		}
		else if (r == 11)
		{
			this.m.Items.equip(::new("scripts/items/armor/leather_scale_armor"));
		}

		if (::Math.rand(1, 100) <= 90)
		{
			local helmets = [
				"scripts/items/helmets/nasal_helmet",
				"scripts/items/helmets/nasal_helmet_with_mail",
				"scripts/items/helmets/mail_coif",
				"scripts/items/helmets/reinforced_mail_coif",
				"scripts/items/helmets/headscarf",
				"scripts/items/helmets/kettle_hat",
				"scripts/items/helmets/kettle_hat_with_mail",
				"scripts/items/helmets/flat_top_helmet",
				"scripts/items/helmets/flat_top_with_mail",
				"scripts/items/helmets/closed_flat_top_helmet",
				"scripts/items/helmets/closed_mail_coif",
				"scripts/items/helmets/bascinet_with_mail",
				"scripts/items/helmets/nordic_helmet",
				"scripts/items/helmets/steppe_helmet_with_mail",
			];
			this.m.Items.equip(::new(::MSU.Array.rand(helmets)));
		}
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
