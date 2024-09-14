::Hardened.HooksMod.hook("scripts/skills/backgrounds/nomad_background", function(q) {
	q.onAdded = @(__original) function()
	{
		__original();
		this.getContainer().removeByID("actives.throw_dirt");	// Remove the skill added by reforged
	}
});
