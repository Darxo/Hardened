::Hardened.HooksMod.hook("scripts/ambitions/ambitions/sergeant_ambition", function(q) {
	q.onUpdateScore = @(__original) function()
	{
		if (::World.Assets.getBusinessReputation() < 1000) return;

		__original();
	}
});
