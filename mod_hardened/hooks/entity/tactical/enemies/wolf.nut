::Hardened.HooksMod.hook("scripts/entity/tactical/enemies/wolf", function(q) {
	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/effects/hd_bite_reach"));
	}
});
