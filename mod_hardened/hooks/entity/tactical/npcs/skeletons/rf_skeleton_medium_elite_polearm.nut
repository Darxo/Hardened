// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/rf_skeleton_medium_elite_polearm", function(q) {	// Ancient Palatinus
	q.create = @(__original) function()
	{
		__original();

		this.m.WeaponWeightContainer = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/ancient/warscythe"],
		]);

		this.m.OffhandWeightContainer = null;
	}

	// Overwrite, because we completely replace Reforged stats/skill adjustments with our own
	q.onInit = @() { function onInit()
	{
		this.skeleton.onInit();
	}}.onInit;

	// Overwrite, because we completely replace Reforged miniboss adjustments with our own
	q.makeMiniboss = @() { function makeMiniboss()
	{
		if (!this.actor.makeMiniboss()) return false;

		local weapon = ::MSU.Class.WeightedContainer([
			[12, "scripts/items/weapons/named/named_warscythe"],
			[12, "scripts/items/weapons/named/named_bladed_pike"],
		]).roll();
		this.getItems().equip(::new(weapon));

		this.getSkills().add(::new("scripts/skills/perks/perk_rf_unstoppable"));
		return true;
	}}.makeMiniboss;

// Reforged Functions
	// Overwrite, because we completely replace Reforged Perks/Skills that are depending on assigned Loadout
	q.onSpawned = @() function()
	{
	}

// Hardened Functions
	// Assign Stats and Unconditional Immunities, Perks and Actives
	// Overwrite, because we inherit from rf_skeleton_medium_elite but dont want to reuse their skills and perks
	q.HD_onInitStatsAndSkills = @() function()
	{
		this.skeleton.HD_onInitStatsAndSkills();

		// Tweak Base Properties
		local b = this.getBaseProperties();
		b.setValues(::Const.Tactical.Actor.HD_SkeletonMediumElitePolearm);

		// Generic Perks
		this.getSkills().add(::new("scripts/skills/perks/perk_fearsome"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_long_reach"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_leverage"));
		this.getSkills().add(::new("scripts/skills/perks/perk_rf_death_dealer"));
	}
});
