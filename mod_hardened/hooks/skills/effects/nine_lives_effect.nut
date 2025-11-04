::Hardened.HooksMod.hook("scripts/skills/effects/nine_lives_effect", function(q) {
	q.create = @(__original) { function create()
	{
		__original();
		this.m.Icon = "skills/hd_heightened_reflexes.png";	// This is an edit of the nine lives effect combined with a yellow exclamation mark
	}}.create;
});
