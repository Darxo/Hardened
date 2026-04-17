// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_fighter_low", function(q) {
	q.create = @() function()
	{
		this.m.Type = ::Const.EntityType.HD_GoblinSkirmisher;
		this.m.XP = ::Const.Tactical.Actor.HD_GoblinSkirmisher.XP;
		this.goblin.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/goblin_melee_agent");
		this.m.AIAgent.setActor(this);

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/greenskins/goblin_light_armor"],
			[12, "scripts/items/armor/greenskins/goblin_medium_armor"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_falchion"],
			[12, "scripts/items/weapons/greenskins/goblin_notched_blade"],
			[12, "scripts/items/weapons/greenskins/goblin_spear"],
		]);

		this.m.OffhandWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/tools/throwing_net"],
			[12, "scripts/items/shields/greenskins/goblin_light_shield"],
		]);
	}

	// Overwrite, because we completely replace Vanillas stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.goblin_fighter.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Vanillas item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.goblin_fighter.assignRandomEquipment();
	}}.assignRandomEquipment;

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @() function()
	{
		this.goblin.HD_onInitStatsAndSkills();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.HD_GoblinSkirmisher);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear <- function()
	{
		local offhand = this.getOffhandItem();
		if (offhand == null || !offhand.isItemType(::Const.Items.ItemType.Shield))
		{
			// Only goblins without shields get a throwing weapon, as they are usually less resilient in direct melee contact
			local throwingWeapon = ::new("scripts/items/weapons/greenskins/goblin_spiked_balls");
			throwingWeapon.m.Ammo = 2;
			this.getItems().addToBag(throwingWeapon);
		}
	}
});
