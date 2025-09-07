// Hardened completely redesign most NPCs
// For that we overwrite the core generation functions onInit, makeMiniboss, assignRandomEquipment and onSpawned because we completely disregard Reforged or Vanillas design

::Hardened.HooksMod.hook("scripts/entity/tactical/armored_wardog", function(q) {
// Hardened Functions
	q.create = @(__original) function()
	{
		__original();

		// armored wardogs cost 12 to spawn, unlike the normal variant, so they grant more XP
		this.m.XP = 120;	// wardog: 80
	}
});
