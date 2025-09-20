// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_scoundrel", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Skinny;	// Reforged ::Const.Bodies.AllMale
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 30 - 70
			[12, "scripts/items/armor/leather_tunic"],
			[12, "scripts/items/armor/thick_tunic"],
			[12, "scripts/items/armor/ragged_surcoat"],
			[12, "scripts/items/armor/padded_surcoat"],
			[12, "scripts/items/armor/blotched_gambeson"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 30 - 40
			[12, "scripts/items/helmets/hood"],
			[4, "scripts/items/helmets/straw_hat"],
			[4, "scripts/items/helmets/aketon_cap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/bludgeon"],
			[12, "scripts/items/weapons/hatchet"],
			[12, "scripts/items/weapons/militia_spear"],
			[12, "scripts/items/weapons/pickaxe"],
			[12, "scripts/items/weapons/knife"],
		]);

		this.m.ChanceForNoOffhand = 67;
		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/shields/buckler_shield"],
			[12, "scripts/items/shields/wooden_shield_old"],
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
	}}.assignRandomEquipment;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_bandits");
		if (::Math.rand(1, 100) <= 10)
		{
			local pox = this.getSprite("tattoo_head");
			pox.Visible = true;
			pox.setBrush("bust_head_pox_01");
		}
		else if (::Math.rand(1, 100) <= 15)
		{
			local pox = this.getSprite("tattoo_head");
			pox.Visible = true;
			pox.setBrush("bust_head_darkeyes_01");
		}
		else
		{
			local dirt = this.getSprite("dirt");
			dirt.Visible = true;
		}

		if (::Math.rand(1, 100) <= 25)
		{
			this.getSprite("eye_rings").Visible = true;
		}

		this.getSprite("armor").Saturation = 0.8;
		this.getSprite("helmet").Saturation = 0.8;
		this.getSprite("helmet_damage").Saturation = 0.8;
		this.getSprite("shield_icon").Saturation = 0.8;
		this.getSprite("shield_icon").setBrightness(0.9);
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_BanditScoundrel);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
