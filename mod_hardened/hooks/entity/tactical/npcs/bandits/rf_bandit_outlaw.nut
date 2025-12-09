// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_bandit_outlaw", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Thick;	// Reforged: ::Const.Bodies.AllMale
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 70 - 80
			[6, "scripts/items/armor/gambeson"],
			[12, "scripts/items/armor/blotched_gambeson"],
			[6, "scripts/items/armor/padded_leather"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/two_handed_mace"],
			[12, "scripts/items/weapons/two_handed_wooden_flail"],
			[12, "scripts/items/weapons/two_handed_wooden_hammer"],
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
		local dirt = this.getSprite("dirt");
		dirt.Visible = true;
		dirt.Alpha = ::Math.rand(150, 255);
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
		b.setValues(::Const.Tactical.Actor.RF_BanditOutlaw);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_bully"));
		this.getSkills().add(::new("scripts/skills/perks/perk_steel_brow"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_formidable_approach"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
