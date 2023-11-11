::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_pattern_recognition", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IconMini = "";
	}
});
