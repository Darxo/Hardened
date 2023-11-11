::Hardened.HooksMod.hook("scripts/skills/special/night_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";
	}
});
