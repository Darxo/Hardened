// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/master_archer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/war_bow"],
			[12, "scripts/items/weapons/heavy_crossbow"],
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

		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Bow))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_trick_shooter"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Crossbow))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_iron_sights"));
			}
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
		b.setValues(::Const.Tactical.Actor.MasterArcher);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_marksmanship"));
		this.getSkills().add(::new("scripts/skills/perks/perk_bullseye"));
		this.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_quick_hands"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_combo"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Body))
		{
			this.m.Items.equip(::new(::MSU.Class.WeightedContainer([
				[1, "scripts/items/armor/thick_tunic"],
				[1, "scripts/items/armor/padded_surcoat"],
				[1, "scripts/items/armor/gambeson"]
			]).roll()));
		}

		if (this.m.Items.hasEmptySlot(::Const.ItemSlot.Head))
		{
			if (this.m.IsMiniboss)
			{
				this.m.Items.equip(::new("scripts/items/helmets/greatsword_hat"));
			}
			else
			{
				local helmet = ::MSU.Class.WeightedContainer([
					[1, "scripts/items/helmets/hood"],
					[1, "scripts/items/helmets/hunters_hat"]
				]).rollChance(33);

				if (helmet != null) this.m.Items.equip(::new(helmet));
			}
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
			[12, "scripts/items/weapons/arming_sword"],
		]).roll();
		this.getItems().addToBag(::new(sidearm));
	}
});
