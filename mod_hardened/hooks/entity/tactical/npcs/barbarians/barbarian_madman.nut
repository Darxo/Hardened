// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/barbarian_madman", function(q) {		// Barbarian Madman (Icy Cave)
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/barbarians/barbarian_ritual_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/barbarians/barbarian_ritual_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/named/named_rusty_warblade"],
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

		// Unlike Vanilla, we guarantee tattoos on this NPC, as he is unique and you only encounter him once per campaign
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
		b.setValues(::Const.Tactical.Actor.BarbarianMadman);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_survival_instinct"));
		this.getSkills().add(::new("scripts/skills/racial/trickster_god_racial"));	// Regen Effect

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_vigorous_assault"));
		this.getSkills().add(::new("scripts/skills/perks/perk_fast_adaption"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_cleaver"));

		this.getSkills().add(::new("scripts/skills/perks/perk_battering_ram"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
	}
});
