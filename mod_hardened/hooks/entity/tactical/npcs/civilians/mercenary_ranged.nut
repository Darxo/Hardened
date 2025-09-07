// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/mercenary_ranged", function(q) {
	// Public
	q.m.HD_BandageChance <- 30;

	q.create = @(__original) function()
	{
		__original();

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
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		local r = this.Math.rand(1, 6);
		if (r == 1) this.getItems().equip(::new("scripts/items/armor/thick_tunic"));
		else if (r == 2) this.getItems().equip(::new("scripts/items/armor/padded_surcoat"));
		else if (r == 3) this.getItems().equip(::new("scripts/items/armor/basic_mail_shirt"));
		else if (r == 4) this.getItems().equip(::new("scripts/items/armor/mail_shirt"));
		else if (r == 5) this.getItems().equip(::new("scripts/items/armor/ragged_surcoat"));
		else if (r == 6) this.getItems().equip(::new("scripts/items/armor/padded_leather"));

		if (::Math.rand(1, 100) <= 75)
		{
			local helmets = [
				"scripts/items/helmets/hood",
				"scripts/items/helmets/aketon_cap",
				"scripts/items/helmets/full_leather_cap",
				"scripts/items/helmets/headscarf",
				"scripts/items/helmets/full_aketon_cap",
				"scripts/items/helmets/kettle_hat",
				"scripts/items/helmets/mail_coif",
			];
			this.getItems().equip(::new(::MSU.Array.rand(helmets)));
		}
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
