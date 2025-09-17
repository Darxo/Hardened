// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/assassin", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/oriental/assassin_robe"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/oriental/assassin_head_wrap"],
			[12, "scripts/items/helmets/oriental/assassin_face_mask"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/oriental/qatal_dagger"],
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
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.Assassin);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_poise"));

		this.getSkills().add(::new("scripts/skills/perks/perk_backstabber"));
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_dagger"));
		this.getSkills().add(::new("scripts/skills/perks/perk_quick_hands"));
		this.getSkills().add(::new("scripts/skills/perks/perk_relentless"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_between_the_ribs"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_ghostlike"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_swift_stabs"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_scout"));

		// Generic Actives
		this.getSkills().add(::new("scripts/skills/actives/fake_drink_night_vision_skill"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}
});
