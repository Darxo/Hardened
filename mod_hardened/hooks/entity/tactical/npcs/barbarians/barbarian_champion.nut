// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/barbarian_champion", function(q) {		// Barbarian Chosen
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 140 - 230
			[12, "scripts/items/armor/barbarians/rugged_scale_armor"],
			[12, "scripts/items/armor/barbarians/heavy_iron_armor"],
			[12, "scripts/items/armor/barbarians/thick_plated_barbarian_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 130 - 200
			[12, "scripts/items/helmets/barbarians/crude_metal_helmet"],
			[12, "scripts/items/helmets/barbarians/crude_faceguard_helmet"],
			[12, "scripts/items/helmets/barbarians/closed_scrap_metal_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/barbarians/skull_hammer"],
			[12, "scripts/items/weapons/barbarians/two_handed_spiked_mace"],
			[12, "scripts/items/weapons/barbarians/heavy_rusty_axe"],
			[12, "scripts/items/weapons/barbarians/rusty_warblade"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() function()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}

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
			if (weapon.isWeaponType(::Const.Items.WeaponType.Axe))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_death_dealer"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Cleaver))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_sanguinary"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Mace))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_bone_breaker"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Hammer))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_deep_impact"));		// Breakthrough
			}
		}
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_wildmen_01");
		local tattoos = [3,	4, 5, 6];
		if (this.Math.rand(1, 100) <= 66)
		{
			local tattoo_body = this.actor.getSprite("tattoo_body");
			local body = this.actor.getSprite("body");
			tattoo_body.setBrush("tattoo_0" + ::MSU.Array.rand(tattoos) + "_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.Math.rand(1, 100) <= 50)
		{
			local tattoo_head = this.actor.getSprite("tattoo_head");
			tattoo_head.setBrush("tattoo_0" + ::MSU.Array.rand(tattoos) + "_head");
			tattoo_head.Visible = true;
		}
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.BarbarianChampion);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
		this.getSkills().add(::new("scripts/skills/perks/perk_adrenalin"));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
		this.getSkills().add(::new("scripts/skills/perks/perk_berserk"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/barbarian_fury_skill"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
	}
});
