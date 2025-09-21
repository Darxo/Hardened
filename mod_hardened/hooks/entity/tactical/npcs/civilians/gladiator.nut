// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/gladiator", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 40
			[12, "scripts/items/oriental/gladiator_harness"],
		]);

		this.m.ChanceForNoHelmet = 50;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 230
			[12, "scripts/items/oriental/gladiator_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[16, "scripts/items/weapons/fighting_axe"],
			[16, "scripts/items/weapons/fighting_spear"],
			[16, "scripts/items/weapons/shamshir"],
			[16, "scripts/items/weapons/three_headed_flail"],
			[16, "scripts/items/weapons/oriental/heavy_southern_mace"],

			[6, "scripts/items/weapons/bardiche"],
			[6, "scripts/items/weapons/greataxe"],
			[8, "scripts/items/weapons/oriental/two_handed_scimitar"],
			[8, "scripts/items/weapons/rf_kriegsmesser"],
			[8, "scripts/items/weapons/warbrand"],
			[12, "scripts/items/weapons/two_handed_hammer"],
			[12, "scripts/items/weapons/two_handed_flail"],
			[12, "scripts/items/weapons/two_handed_flanged_mace"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/oriental/metal_round_shield"],
			[12, "scripts/items/tools/reinforced_throwing_net"],
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

		if (this.getHeadItem() == null)
		{
			this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));	// To offset the huge difference in head defense (from 230 to 0)
		}

		if (this.getOffhandItem() == null)	// Two Handed Weapon
		{
			this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));
		}
		else	// One Handed Weapon
		{
			if (this.getOffhandItem().isItemType(::Const.Items.ItemType.Shield))
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_rebuke"));
			}
			else	// Net
			{
				this.getSkills().add(::new("scripts/skills/perks/perk_rf_angler"));
				this.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));
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
		b.setValues(::Const.Tactical.Actor.Gladiator);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_poise"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_survival_instinct"));

		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_skirmisher"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		local bodyItem = this.getBodyItem();
		if (bodyItem != null)
		{
			local attachement = ::MSU.Class.WeightedContainer([
				[12, "scripts/items/armor_upgrades/light_gladiator_upgrade"],
				[12, "scripts/items/armor_upgrades/heavy_gladiator_upgrade"],
			]).roll();
			bodyItem.setUpgrade(::new(attachement));
		}
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
	}
});
