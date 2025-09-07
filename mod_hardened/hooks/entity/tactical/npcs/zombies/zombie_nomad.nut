// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_nomad", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/boar_spear"],
			[12, "scripts/items/weapons/scimitar"],
			[12, "scripts/items/weapons/two_handed_wooden_hammer"],
			[12, "scripts/items/weapons/oriental/two_handed_saif"],
			[12, "scripts/items/weapons/oriental/light_southern_mace"],
		]);

		this.m.ChanceForNoOffhand = 50;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/oriental/southern_light_shield"],
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
		b.setValues(::Const.Tactical.Actor.HD_ZombieNomad);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor = @() function()
	{
		local armor = ::new(::MSU.Class.WeightedContainer([
			[1, "scripts/items/armor/oriental/stitched_nomad_armor"],
			[1, "scripts/items/armor/oriental/plated_nomad_mail"],
			[1, "scripts/items/armor/oriental/leather_nomad_robe"],
			[1, "scripts/items/armor/oriental/nomad_robe"],
			[1, "scripts/items/armor/oriental/thick_nomad_robe"],
		]).roll());
		if (this.Math.rand(1, 100) <= 66)
		{
			armor.setArmor(this.Math.round(armor.getArmorMax() / 2 - 1) / 1.0);
		}
		this.m.Items.equip(armor);

		local helmet = ::new(::MSU.Class.WeightedContainer([
			[6, "scripts/items/helmets/oriental/nomad_leather_cap"],
			[6, "scripts/items/helmets/oriental/nomad_light_helmet"],
			[6, "scripts/items/helmets/oriental/nomad_reinforced_helmet"],
			[6, "scripts/items/helmets/oriental/leather_head_wrap"],
			[12, "scripts/items/helmets/oriental/nomad_head_wrap"],
		]).roll());
		if (this.Math.rand(1, 100) <= 66)
		{
			helmet.setArmor(this.Math.round(helmet.getArmorMax() / 2 - 1) / 1.0);
		}
		this.m.Items.equip(helmet);
	}
});
