::Hardened.HooksMod.hookTree("scripts/skills/skill", function(q) {
	// Fix: skills sometimes not being attached to anything, causing getActor() calls to fail
	q.getTooltip = @(__original) function()
	{
		// Switcheroo of this.m.Container to attach this skill to the dummy player, if its not attached to anything
		local oldContainer = this.getContainer();
		if (::MSU.isNull(this.getContainer())) this.m.Container = ::MSU.getDummyPlayer().getSkills();
		local ret = __original();
		this.m.Container = oldContainer;

		return ret;
	}
});
