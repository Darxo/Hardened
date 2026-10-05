::Hardened.HooksMod.hook("scripts/skills/actives/nightmare_skill", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.IsAttack = false;	// This skill is no longer considered an attack. This flag didn't make sense in vanilla anyways
	}}.create;

	// Vanilla Fix: alp tooltips not generating correctly when player controlled
	// Overwrite to remove the vanilla implementation, because it is redundant and calls getAIAgent() without checking its result, which causes problems on player controlled characters
	q.isUsable = @() function()
	{
		return this.skill.isUsable();
	}
});
