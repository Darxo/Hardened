// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/zombie_knight_bodyguard", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.ChanceForNoOffhand = 0;
	}

	// Overwrite, because we dont want the Vanilla stats/skill adjustments
	q.onInit = @() { function onInit()
	{
		this.zombie_knight.onInit();
	}}.onInit;

// Hardened Functions
	q.HD_onInitStatsAndSkills = @(__original) function()
	{
		__original();

		// This skill is only relevant for the Waterwheel legendary location, where it causes these bodyguards to follow the Rachegeist
		this.getSkills().add(::new("scripts/skills/effects/rf_mentors_presence_effect"));
	}
});
