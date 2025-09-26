// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

// Fallen Betrayers are now called "Fallen Heroes" in Hardened
::Const.Strings.EntityName[::Const.EntityType.ZombieBetrayer] = "Fallen Hero";
::Const.Strings.EntityNamePlural[::Const.EntityType.ZombieBetrayer] = "Fallen Heroes";

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_betrayer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greataxe"],
			[12, "scripts/items/weapons/two_handed_flail"],
			[12, "scripts/items/weapons/two_handed_flanged_mace"],
			[12, "scripts/items/weapons/two_handed_hammer"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.zombie.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		local namedMeleeWeapon = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/named/named_greataxe"],
			[12, "scripts/items/weapons/named/named_two_handed_flail"],
			[12, "scripts/items/weapons/named/named_two_handed_hammer"],
			[12, "scripts/items/weapons/named/named_two_handed_mace"],
		]).roll();
		this.getItems().equip(::new(namedMeleeWeapon));

		this.getSkills().add(::new("scripts/skills/perks/perk_battle_forged"));

		return true;
	}}.makeMiniboss;

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
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Axe))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_dismemberment"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_death_dealer"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Flail))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_flail"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_flail_spinner"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_hammer"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_rattle"));			// Full Force
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Mace))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_bone_breaker"));
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_concussive_strikes"));		// Shockwave
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
		b.setValues(::Const.Tactical.Actor.ZombieBetrayer);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/effects/hd_cursed_effect"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_anchor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor = @() function()
	{
		local armor = ::new(::MSU.Class.WeightedContainer([
			[1, "scripts/items/armor/decayed_coat_of_plates"],
			[1, "scripts/items/armor/decayed_coat_of_scales"],
		]).roll());
		if (this.Math.rand(1, 100) <= 33)
		{
			armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(armor);

		local helmet = ::new(::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/decayed_great_helm"],
		]).roll());
		if (this.Math.rand(1, 100) <= 33)
		{
			helmet.setArmor(this.Math.round(helmet.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(helmet);
	}
});
