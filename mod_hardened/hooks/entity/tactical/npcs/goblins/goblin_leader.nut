// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_leader", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_crossbow"],
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
		this.HD_assignOtherGear();
	}}.assignRandomEquipment;

// Hardened Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites = @(__original) function()
	{
		__original();
		this.getSprite("head").setBrush("bust_goblin_03_head_01");
		this.addDefaultStatusSprites();
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.GoblinLeader);
		b.TargetAttractionMult = 1.5;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_combo"));
		this.getSkills().add(::new("scripts/skills/perks/perk_bullseye"));
		this.getSkills().add(::new("scripts/skills/perks/perk_captain"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_crossbow"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/goblin_whip"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		this.m.Items.equip(this.new("scripts/items/armor/greenskins/goblin_leader_armor"));
		this.m.Items.equip(this.new("scripts/items/helmets/greenskins/goblin_leader_helmet"));
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		this.m.Items.equip(this.new("scripts/items/ammo/quiver_of_bolts"));
		this.m.Items.addToBag(this.new("scripts/items/weapons/greenskins/goblin_falchion"));
	}
});
