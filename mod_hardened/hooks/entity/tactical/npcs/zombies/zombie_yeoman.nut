// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_yeoman", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/bludgeon"],
			[12, "scripts/items/weapons/scramasax"],
			[12, "scripts/items/weapons/shortsword"],
			[12, "scripts/items/weapons/reinforced_wooden_flail"],
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
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.ZombieYeoman);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor = @() function()
	{
		local armor = ::new(::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/padded_leather"],
			[12, "scripts/items/armor/worn_mail_shirt"],
			[12, "scripts/items/armor/patched_mail_shirt"],
			[6, "scripts/items/armor/basic_mail_shirt"],
		]).roll());
		if (::Math.rand(1, 100) <= 50)
		{
			armor.setArmor(::Math.round(armor.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(armor);

		local helmet = ::new(::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/full_aketon_cap"],
			[12, "scripts/items/helmets/full_leather_cap"],
			[12, "scripts/items/helmets/padded_kettle_hat"],
			[12, "scripts/items/helmets/dented_nasal_helmet"],
			[24, "scripts/items/helmets/rusty_mail_coif"],
		]).roll());
		if (::Math.rand(1, 100) <= 66)
		{
			helmet.setArmor(::Math.round(helmet.getArmorMax() / 2 - 1) / 1.0);
		}
		this.getItems().equip(helmet);
	}
});
