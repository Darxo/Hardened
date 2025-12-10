::Hardened.HooksMod.hook("scripts/skills/actives/zombie_bite", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.HD_IsSortedBeforeMainhand = true;
	}
});
