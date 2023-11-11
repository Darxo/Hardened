::Hardened.HooksMod.hook("scripts/skills/special/double_grip", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";
	}
});
