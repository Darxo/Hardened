::Hardened.HooksMod.hook("scripts/skills/actives/rf_kata_step_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.RequiredDamageType = null;	// Any damage type is allowed, as long as it came from a sword
		this.m.RequireOffhandFree = false;	// Anything in the offhand is allowed
	}
});
