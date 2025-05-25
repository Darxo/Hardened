// Ancient Auxiliary
::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/skeleton_light", function(q) {
// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.battle_forged");
	}
});
