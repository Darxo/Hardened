::Hardened.HooksMod.hook("scripts/skills/effects/shieldwall_effect", function(q) {
	q.getTooltip = @() function()
	{
		if (this.getContainer().getActor().getID() ==  ::MSU.getDummyPlayer().getID())
		{
			return this.skill.getTooltip();		// This tooltip is more resilient against a shield missing
		}
		else
		{
			return __original();
		}
	}
});
