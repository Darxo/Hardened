// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/barbarian_drummer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([		// 40 - 70
			[12, "scripts/items/armor/barbarians/thick_furs_armor"],
			[12, "scripts/items/armor/barbarians/animal_hide_armor"],
			[12, "scripts/items/armor/barbarians/reinforced_animal_hide_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([	// 20 - 60
			[12, "scripts/items/helmets/barbarians/leather_headband"],
			[12, "scripts/items/helmets/barbarians/bear_headpiece"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/barbarians/drum_item"],
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
		this.getSprite("socket").setBrush("bust_base_wildmen_01");
		local tattoos = [3,	4, 5, 6];
		local tattoo_body = this.actor.getSprite("tattoo_body");
		local body = this.actor.getSprite("body");
		tattoo_body.setBrush("tattoo_0" + ::MSU.Array.rand(tattoos) + "_" + body.getBrush().Name);
		tattoo_body.Visible = true;
		local tattoo_head = this.actor.getSprite("tattoo_head");
		tattoo_head.setBrush("tattoo_0" + ::MSU.Array.rand(tattoos) + "_head");
		tattoo_head.Visible = true;
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.BarbarianDrummer);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hold_out"));

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
		local sidearm = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/barbarians/antler_cleaver"],
			[12, "scripts/items/weapons/barbarians/claw_club"],
		]).roll();
		this.getItems().addToBag(::new(sidearm));
	}
});
