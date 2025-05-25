::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/bandit_leader", function(q) {
	q.create = @(__original) function()
	{
		this.m.Bodies = ::Const.Bodies.Muscular;	// In Reforged this is ::Const.Bodies.AllMale
		__original();
	}

// Reforged Functions
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().removeByID("perk.shield_expert");
	}
});
