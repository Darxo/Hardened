// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/slave", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChanceForNoChest = 30;
		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/tattered_sackcloth"],
			[12, "scripts/items/armor/sackcloth"],
		]);

		this.m.ChanceForNoHelmet = 70;
		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/oriental/southern_head_wrap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/butchers_cleaver"],
			[12, "scripts/items/weapons/knife"],
			[12, "scripts/items/weapons/pickaxe"],
			[12, "scripts/items/weapons/pitchfork"],
			[12, "scripts/items/weapons/wooden_stick"],
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
		this.getSprite("socket").setBrush("bust_base_southern");

		local tattoo_head = this.actor.getSprite("tattoo_head");
		if (::Math.rand(1, 100) <= 50)
		{
			tattoo_head.setBrush("bust_head_darkeyes_01");
		}
		else
		{
			tattoo_head.setBrush("scar_02_head");
		}
		tattoo_head.Visible = true;

		if (::Math.rand(1, 100) <= 75)
		{
			local dirt = this.getSprite("dirt");
			dirt.Visible = true;
		}

		if (::Math.rand(1, 100) <= 75)
		{
			local tattoo_body = this.actor.getSprite("tattoo_body");
			local body = this.actor.getSprite("body");
			tattoo_body.setBrush("scar_02_" + body.getBrush().Name);
			tattoo_body.Visible = true;
		}

		if (this.m.Ethnicity == 0)
		{
			local body = this.getSprite("body");
			body.Color = this.createColor("#ffeaea");
			body.varyColor(0.05, 0.05, 0.05);
			local head = this.getSprite("head");
			head.Color = body.Color;
			head.Saturation = body.Saturation;
		}
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Slave);
		b.TargetAttractionMult = 0.5;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_strength_in_numbers"));

		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
