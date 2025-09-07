::Hardened.HooksMod.hook("scripts/entity/tactical/wardog", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.SoundVolume[::Const.Sound.ActorEvent.Attack] = 0.8;
	}
});
