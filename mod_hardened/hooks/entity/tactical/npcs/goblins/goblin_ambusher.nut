// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_ambusher", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/greenskins/goblin_skirmisher_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/greenskins/goblin_skirmisher_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_heavy_bow"],
		]);
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.goblin.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		local weapon = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/named/named_goblin_heavy_bow"],
		]).roll();
		this.getItems().equip(::new(weapon));

		this.getSkills().add(::new("scripts/skills/perks/perk_overwhelm"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_unstoppable"));

		return true;
	}}.makeMiniboss;

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

// Hardened Functions
	// Assign Socket and adjust Sprites
	q.HD_onInitSprites = @(__original) function()
	{
		__original();
		this.getSprite("head").setBrush("bust_goblin_01_head_0" + this.Math.rand(1, 3));
		this.getSprite("quiver").Visible = true;
		this.addDefaultStatusSprites();
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.GoblinAmbusher);
		b.TargetAttractionMult = 1.1;

		// Generic Effects
		this.getSkills().add(::new("scripts/skills/racial/goblin_ambusher_racial"));

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));
	}

	// Assign Head and Body armor to this character
	q.HD_assignArmor <- function()
	{
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		this.getItems().equip(::new("scripts/items/ammo/quiver_of_arrows"));
		this.getItems().addToBag(::new("scripts/items/weapons/greenskins/goblin_notched_blade"));

		if (this.Math.rand(1, 100) <= 10)
		{
			this.getItems().addToBag(::new("scripts/items/accessory/poison_item"));	// This is just added as a drop. Goblin Ambusher have a special effect to always poison
		}
	}
});
