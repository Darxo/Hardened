// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_shaman", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/greenskins/goblin_shaman_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/greenskins/goblin_shaman_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_staff"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.goblin.onInit();
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

// Hardened Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites = @(__original) function()
	{
		__original();
		this.getSprite("head").setBrush("bust_goblin_02_head_01");
		this.addDefaultStatusSprites();
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.GoblinShaman);
		b.TargetAttractionMult = 2.0;
		b.IsAffectedByNight = false;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/goblin_shaman_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_mace"));
		this.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/root_skill"));
		this.getSkills().add(::new("scripts/skills/actives/insects_skill"));
		this.getSkills().add(::new("scripts/skills/actives/grant_night_vision_skill"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});



