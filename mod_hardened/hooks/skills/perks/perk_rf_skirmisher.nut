::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_skirmisher", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.IsHidden = true;		// The information from this perk is very useless. At that point we might aswell display Colossus and Fortified Mind
	}
});
