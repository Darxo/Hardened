// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_heavy", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/ancient/crypt_cleaver"],
			[12, "scripts/items/weapons/ancient/rhomphaia"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.skeleton.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		local weapon = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/named/named_crypt_cleaver"],
		]).roll();
		this.getItems().equip(::new(weapon));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_unstoppable"));
		return true;
	}}.makeMiniboss;

	// Overwrite, because we completely replace Reforged item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.HD_assignArmor();
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		::Reforged.Skills.addMasteryOfEquippedWeapon(this);

		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Cleaver))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_mauler"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_sanguinary"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_tempo"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_death_dealer"));
			}
		}
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.SkeletonHeavy);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_sweeping_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Reforged code, as there is no easier way to apply our changes via hooking
		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Body))
		{
			local armor = ::MSU.Class.WeightedContainer([
				[1, "scripts/items/armor/ancient/ancient_plate_harness"],
				[1, "scripts/items/armor/ancient/ancient_plated_scale_hauberk"]
			]).roll();

			this.getItems().equip(::new(armor));
		}

		if (this.getItems().hasEmptySlot(::Const.ItemSlot.Head))
		{
			this.getItems().equip(::new("scripts/items/helmets/ancient/ancient_honorguard_helmet"));
		}
	}
});
