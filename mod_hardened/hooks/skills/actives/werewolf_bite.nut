::Hardened.HooksMod.hook("scripts/skills/actives/werewolf_bite", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.FatigueCost = 10;	// Vanilla: 6
	}
});
