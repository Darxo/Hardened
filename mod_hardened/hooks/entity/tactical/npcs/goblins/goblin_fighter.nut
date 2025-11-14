// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_fighter", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/greenskins/goblin_light_armor"],
			[12, "scripts/items/armor/greenskins/goblin_medium_armor"],
			[12, "scripts/items/armor/greenskins/goblin_heavy_armor"],
		]);

		this.m.HelmetWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/helmets/greenskins/goblin_light_helmet"],
			[4, "scripts/items/helmets/greenskins/goblin_heavy_helmet"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_falchion"],
			[12, "scripts/items/weapons/greenskins/goblin_spear"],
			[12, "scripts/items/weapons/greenskins/goblin_pike"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[24, "scripts/items/tools/throwing_net"],
			[12, "scripts/items/shields/greenskins/goblin_light_shield"],
			[12, "scripts/items/shields/greenskins/goblin_heavy_shield"],
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
			[12, "scripts/items/weapons/named/named_goblin_falchion"],
			[12, "scripts/items/weapons/named/named_goblin_pike"],
			[12, "scripts/items/weapons/named/named_goblin_spear"],
		]).roll();
		this.getItems().equip(::new(weapon));

		this.getSkills().add(::new("scripts/skills/perks/perk_nimble"));
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
		this.addDefaultStatusSprites();
	}

	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();
		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.GoblinFighter);

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
		// Same condition as vanilla for when to assign bolas
		if (this.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getID() != "weapon.goblin_spear" && this.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand).getID() != "weapon.named_goblin_spear")
		{
			this.getItems().addToBag(::new("scripts/items/weapons/greenskins/goblin_spiked_balls"));
		}
	}
});
