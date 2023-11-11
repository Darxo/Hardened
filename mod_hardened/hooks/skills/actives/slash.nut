::Hardened.HooksMod.hook("scripts/skills/actives/slash", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.HitChanceBonus = 0;
	}
});
