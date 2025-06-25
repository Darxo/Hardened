::Hardened.HooksMod.hook("scripts/skills/perks/perk_fast_adaption", function(q) {
	q.getName = @(__original) function()
	{
		local ret = __original();
		if (this.m.Stacks >= 1) ret += " (x" + this.m.Stacks + ")";		// QoL: show amount of stacks in the effect name
		return ret;
	}
});
