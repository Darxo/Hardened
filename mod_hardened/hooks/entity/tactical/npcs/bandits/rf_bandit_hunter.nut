// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_hunter", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Skinny;	// Reforged ::Const.Bodies.AllMale
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 50 - 60
			[12, "scripts/items/armor/ragged_surcoat"],
			[12, "scripts/items/armor/padded_surcoat"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 30 - 40
			[12, "scripts/items/helmets/hood"],
			[6, "scripts/items/helmets/hunters_hat"],
			[12, "scripts/items/helmets/aketon_cap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/short_bow"],
			[12, "scripts/items/weapons/light_crossbow"],
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
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_bandits");
		if (::Math.rand(1, 100) <= 20)
		{
			local pox = this.getSprite("tattoo_head");
			pox.Visible = true;
			pox.setBrush("bust_head_darkeyes_01");
		}
		else
		{
			local dirt = this.getSprite("dirt");
			dirt.Visible = true;
			dirt.Alpha = ::Math.rand(150, 255);
		}
		this.getSprite("armor").Saturation = 0.85;
		this.getSprite("helmet").Saturation = 0.85;
		this.getSprite("helmet_damage").Saturation = 0.85;
		this.getSprite("shield_icon").Saturation = 0.85;
		this.getSprite("shield_icon").setBrightness(0.85);
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.RF_BanditHunter);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local weapon = this.getMainhandItem();
		if (weapon != null)
		{
			if (weapon.isWeaponType(::Const.Items.WeaponType.Bow))
			{
				this.getItems().equip(::new("scripts/items/ammo/quiver_of_arrows"));
			}
			else
			{
				this.getItems().equip(::new("scripts/items/ammo/quiver_of_bolts"));
			}
		}

		this.getItems().addToBag(::new("scripts/items/weapons/knife"));
	}
});

