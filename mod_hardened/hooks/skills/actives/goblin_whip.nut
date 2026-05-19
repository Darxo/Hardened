::Hardened.HooksMod.hook("scripts/skills/actives/goblin_whip", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.UtilityTargeted;

	// Hardened
		// Feat: Goblin Leader can now only whip goblins to confident, while not engaged in melee
		this.m.HD_UsableWhileEngagedInMelee = false;
	}
});
