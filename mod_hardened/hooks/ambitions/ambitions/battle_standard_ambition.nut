::Hardened.HooksMod.hook("scripts/ambitions/ambitions/battle_standard_ambition", function(q) {
	q.onUpdateScore = @(__original) function()
	{
		if (::World.Assets.getBusinessReputation() < 600) return;

		__original();
	}
});
