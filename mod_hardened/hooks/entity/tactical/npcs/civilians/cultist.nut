// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/cultist", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/cultist_leather_robe"],
			[12, "scripts/items/armor/monk_robe"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/cultist_hood"],
			[12, "scripts/items/helmets/cultist_leather_hood"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/dagger"],
			[12, "scripts/items/weapons/reinforced_wooden_flail"],
			[12, "scripts/items/weapons/scramasax"],
			[12, "scripts/items/weapons/barbarians/thorned_whip"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.human.onInit();

		this.HD_onInitSprites();
		this.HD_onInitStatsAndSkills();
	}}.onInit;

	// Overwrite, because we completely replace Vanilla item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Cleaver))
			{
				this.getSkills().add(::new("scripts/skills/perks/rf_perk_sanguinary"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Dagger))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_between_the_ribs"));
			}
			else if (weapon.isWeaponType(::Const.Items.WeaponType.Flail))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_flail_spinner"));
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
		b.setValues(::Const.Tactical.Actor.Cultist);

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/traits/cultist_zealot_trait"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_coup_de_grace"));
		this.getSkills().add(::new("scripts/skills/perks/perk_crippling_strikes"));

		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
