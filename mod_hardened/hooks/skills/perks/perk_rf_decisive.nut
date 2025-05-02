::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_decisive", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.InitiativeModifier = 0;
	}
});
