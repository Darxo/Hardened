::Hardened.HooksMod.hook("scripts/skills/actives/rf_sword_thrust_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.HitChanceBonus = 0;		// Reforged: 20
	}
});
