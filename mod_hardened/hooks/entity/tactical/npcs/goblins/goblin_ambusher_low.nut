// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/goblin_ambusher_low", function(q) {
	q.create = @() function()
	{
		this.m.Type = ::Const.EntityType.HD_GoblinAmbusher;
		this.m.XP = ::Const.Tactical.Actor.HD_GoblinAmbusher.XP;
		this.goblin.create();
		this.m.AIAgent = this.new("scripts/ai/tactical/agents/goblin_ranged_agent");
		this.m.AIAgent.setActor(this);

		this.m.ChestWeightedContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/armor/greenskins/goblin_skirmisher_armor"],
		]);

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/greenskins/goblin_bow"],
		]);
	}

	// Overwrite, because we completely replace Vanillas stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.goblin_ambusher.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Vanillas item adjustments with our own
	q.assignRandomEquipment = @() { function assignRandomEquipment()
	{
		this.goblin_ambusher.assignRandomEquipment();
	}}.assignRandomEquipment;


// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	q.HD_onInitStatsAndSkills = @() function()
	{
		this.goblin.HD_onInitStatsAndSkills();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.HD_GoblinAmbusher);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_hd_elusive"));
		this.getSkills().add(::new("scripts/skills/perks/perk_anticipation"));
	}

	// Assign all other gear to this character
	q.HD_assignOtherGear = @() function()
	{
	}
});
