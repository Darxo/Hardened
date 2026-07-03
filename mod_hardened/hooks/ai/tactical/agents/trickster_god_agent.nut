::Hardened.HooksMod.hook("scripts/ai/tactical/agents/trickster_god_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		// We make this boss charge weak character much less aggressively to allow more opportunities for fleeing
		this.m.Properties.TargetPriorityFinishOpponentMult = 0.6;	// Vanilla: 3.0

		// We make this boss seek tiles with multiple opponents much stronger
		this.m.Properties.EngageTargetMultipleOpponentsMult = 0.25;	// Vanilla: 0.5

		// We design this boss to alternate between teleporting + charging and just sweeping
		// By inflating its behavior multiplier, we make sure it is always used when possible
		// And by giving it a 2 round cooldown, we make sure it can only be used every other turn
		// As a result, the Ijirok will now teleport at most every other turn. But sometimes sooner, if he has no valid target during his sweep turn
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Swing] = 9000.0;
	}}.create;

	q.onAddBehaviors = @(__original) { function onAddBehaviors()
	{
		__original();

		// So that this character can now also use a melee attack
		this.addBehavior(::new("scripts/ai/tactical/behaviors/ai_attack_swing"));

		// New Replacement for the vanilla teleport behavior
		this.addBehavior(::new("scripts/ai/tactical/behaviors/hd_trickster_teleport"));

		this.removeBehavior(::Const.AI.Behavior.ID.Teleport);	// We replace this vanilla script with a better one
		this.removeBehavior(::Const.AI.Behavior.ID.Charge);		// This vanilla script is redundant, as it does not know about the unique trickster gore skill
	}}.onAddBehaviors;
});
