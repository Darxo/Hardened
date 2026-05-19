::Hardened.HooksMod.hook("scripts/skills/actives/serpent_hook_skill", function(q) {
// Hardened
	q.m.HD_UsableWhileEngagedInMelee = false;

	q.isUsable = @(__original) function()
	{
		local actor = this.getContainer().getActor();
		local oldIsRooted = actor.getCurrentProperties().IsRooted;
		actor.getCurrentProperties().IsRooted = false;	// We switcheroo this property, because Snakes are now allowed to use serpent hook even while rooted

		local ret = __original();

		actor.getCurrentProperties().IsRooted = oldIsRooted;

		return ret;
	}
});
