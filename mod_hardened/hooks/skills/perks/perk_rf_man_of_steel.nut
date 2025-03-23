::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_man_of_steel", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.IsHidingIconMini = true;	// We hide the mini-icon to reduce bloat during battle as its existance conveys no situation-specific information
	}
});
