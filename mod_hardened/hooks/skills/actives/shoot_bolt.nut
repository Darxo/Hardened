::Hardened.HooksMod.hook("scripts/skills/actives/shoot_bolt", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AdditionalAccuracy += 10;	// In Reforged this is 10
	}
});
