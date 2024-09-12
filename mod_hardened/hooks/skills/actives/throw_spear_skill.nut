::Hardened.HooksMod.hook("scripts/skills/actives/throw_spear_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();

	// Reforged Values
		this.m.FatigueDamage = 0;	// In Reforged this is 40
	}
});
