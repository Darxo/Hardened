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
			[1, "scripts/items/armor/padded_leather"],
			[1, "scripts/items/armor/worn_mail_shirt"],
			[1, "scripts/items/armor/patched_mail_shirt"],
			[1, "scripts/items/armor/ragged_surcoat"],
			[1, "scripts/items/armor/basic_mail_shirt"],
		]).roll());
		if (this.Math.rand(1, 100) <= 66)
		{
			armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1) / 1.0);
		}
		this.m.Items.equip(armor);

		if (this.Math.rand(1, 100) <= 75)
		{
			local helmet = ::new(::MSU.Class.WeightedContainer([
				[1, "scripts/items/helmets/aketon_cap"],
				[1, "scripts/items/helmets/full_aketon_cap"],
				[1, "scripts/items/helmets/full_leather_cap"],
				[1, "scripts/items/helmets/kettle_hat"],
				[1, "scripts/items/helmets/padded_kettle_hat"],
				[1, "scripts/items/helmets/dented_nasal_helmet"],
				[1, "scripts/items/helmets/mail_coif"],
			]).roll());
			if (this.Math.rand(1, 100) <= 66)
			{
				helmet.setArmor(this.Math.round(helmet.getArmorMax() / 2 - 1) / 1.0);
			}
			this.m.Items.equip(helmet);
		}
	}
});
