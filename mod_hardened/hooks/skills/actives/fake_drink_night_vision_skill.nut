::Hardened.HooksMod.hook("scripts/skills/actives/fake_drink_night_vision_skill", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.AIBehaviorID = ::Const.AI.Behavior.ID.UsePotion;
	}
});
