::Hardened.HooksMod.hook("scripts/skills/actives/nightmare_skill", function(q) {
	// Vanilla Fix: alp tooltips not generating correctly when player controlled
	// Overwrite to remove the vanilla implementation, because it is redundant and calls getAIAgent() without checking its result, which causes problems on player controlled characters
	q.isUsable = @() function()
	{
		return this.skill.isUsable();
	}
});
