::Hardened.HooksMod.hook("scripts/skills/actives/chop", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ChanceDecapitate = 50;	// In Reforged/Vanilla this is 25
	}
});
