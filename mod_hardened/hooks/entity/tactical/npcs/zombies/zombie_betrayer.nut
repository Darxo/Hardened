// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_betrayer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Same Loadout as Fallen Heroes, except guaranteed with full condition
		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/decayed_coat_of_plates"],
			[12, "scripts/items/armor/decayed_coat_of_scales"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/decayed_great_helm"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greataxe"],
			[12, "scripts/items/weapons/two_handed_flail"],
			[12, "scripts/items/weapons/two_handed_flanged_mace"],
			[12, "scripts/items/weapons/two_handed_hammer"],
		]);

		// Turn off the randomized condition coming from the zombie_knight base class
		this.m.ChestConditionRoll = null;
		this.m.HelmetConditionRoll = null;
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.zombie.onInit();
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
		this.getSkills().add(::new("scripts/skills/perks/perk_devastating_strikes"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_anchor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor = @() function()
	{
	}
});
