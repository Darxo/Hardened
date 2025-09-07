// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_ambusher", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_heavy_bow"],
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
		// This is currently a 1:1 copy of Vanilla code, as there is no easier way to apply our changes via hooking
		if (this.getItems().getItemAtSlot(::Const.ItemSlot.Body) == null)
		{
			this.getItems().equip(::new("scripts/items/armor/greenskins/goblin_skirmisher_armor"));
		}

		if (this.getItems().getItemAtSlot(::Const.ItemSlot.Head) == null)
		{
			this.getItems().equip(::new("scripts/items/helmets/greenskins/goblin_skirmisher_helmet"));
		}
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
