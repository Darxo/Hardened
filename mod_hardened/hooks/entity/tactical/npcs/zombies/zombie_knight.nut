// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

// Zombie Knights are now called "Fallen Soldiers" in Hardened
::Const.Strings.EntityName[::Const.EntityType.ZombieKnight] = "Fallen Soldier";
::Const.Strings.EntityNamePlural[::Const.EntityType.ZombieKnight] = "Fallen Soldiers";

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_knight", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.IsResurrectingOnFatality = false;	// Zombie Knights can no longer be reanimated without a head

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/arming_sword"],
			[12, "scripts/items/weapons/flail"],
			[12, "scripts/items/weapons/morning_star"],
			[12, "scripts/items/weapons/military_pick"],
		]);

		this.m.ChanceForNoOffhand = 50;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/worn_heater_shield"],
			[12, "scripts/items/shields/worn_kite_shield"],
		]);
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
			if (weapon.isWeaponType(::Const.Items.WeaponType.Flail))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_flail"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_hammer"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Mace))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_bone_breaker"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_mastery_sword"));
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
		b.setValues(::Const.Tactical.Actor.ZombieKnight);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_anchor"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rotation"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor = @() function()
	{
		local armor = ::new(::MSU.Class.WeightedContainer([
			[1, "scripts/items/armor/decayed_reinforced_mail_hauberk"],
		]).roll());
		if (::Math.rand(1, 100) <= 33)
		{
			armor.setArmor(::Math.round(armor.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(armor);

		local helmet = ::new(::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/decayed_closed_flat_top_with_mail"],
			[12, "scripts/items/helmets/decayed_full_helm"],
		]).roll());
		if (::Math.rand(1, 100) <= 33)
		{
			helmet.setArmor(::Math.round(helmet.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(helmet);
	}
});
