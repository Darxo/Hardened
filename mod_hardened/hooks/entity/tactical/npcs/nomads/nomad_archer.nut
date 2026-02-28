// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/humans/nomad_archer", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/oriental/nomad_robe"],
			[12, "scripts/items/armor/oriental/thick_nomad_robe"],
			[12, "scripts/items/armor/oriental/cloth_sash"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[24, "scripts/items/helmets/oriental/nomad_head_wrap"],
			[12, "scripts/items/helmets/oriental/nomad_leather_cap"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/oriental/composite_bow"],
		]);

		this.m.AIAgent = ::new("scripts/ai/tactical/agents/hd_nomad_ranged_agent");
		this.m.AIAgent.setActor(this);
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
	}

// New Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites <- function()
	{
		this.getSprite("socket").setBrush("bust_base_nomads");
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
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills <- function()
	{
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.NomadArcher);
		b.TargetAttractionMult = 1.1;

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_dodge"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_tricksters_purses"));

		this.getSkills().add(::new("scripts/skills/perks/perk_pathfinder"));
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_hybridization"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_target_practice"));
		this.getSkills().add(::new("scripts/skills/perks/perk_mastery_bow"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		this.getItems().equip(::new("scripts/items/ammo/quiver_of_arrows"));

		local sidearm = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/oriental/nomad_mace"],
			[12, "scripts/items/weapons/oriental/saif"],
		]).roll();
		this.getItems().addToBag(::new(sidearm));
	}
});
