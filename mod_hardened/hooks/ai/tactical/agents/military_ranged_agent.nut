::Hardened.HooksMod.hook("scripts/ai/tactical/agents/military_ranged_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		// While noble ranged troops have the option to rotate, they have more important things to do
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Rotation] = 0.5;
	}}.create;
});
