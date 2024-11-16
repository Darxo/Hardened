::Hardened.HooksMod.hook("scripts/entity/tactical/warhound", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.SoundVolume[::Const.Sound.ActorEvent.Attack] = 0.8;
	}

	q.onSpawned = @(__original) function()
	{
		__original();
		this.getSkills().add(::new("scripts/skills/effects/hd_bite_reach"));
	}
});
