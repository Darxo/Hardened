/*
This agent is designed to be given to melee leader-type enemies which usually have one of the following perks:
	- Inspiring Presence, Rally the Troops, Captain, Exude Confidence
They are important figures on the battlefield to be kept safe but they are also good in melee combat.
They are expected to be in the center of the formation but also consistently move up to the enemy.
It is given to the likes of Brigand Leader, Nomad Leader, Militia Captain,
*/

this.hd_generic_melee_leader_agent <- ::inherit("scripts/ai/tactical/agents/bandit_melee_agent", {
	m = {},
	function create()
	{
		this.bandit_melee_agent.create();

		// These characters make up the core of an enemy formation. Their allies are expected to gather around them to maximize their effectiveness
		this.m.Properties.OverallMagnetismMult = 1.5;		// Base: 1.0
		// We want to stay in formation, where our AoE buffs are most useful
		this.m.Properties.OverallFormationMult = 1.5;		// Base: 1.0

		// We don't waste time flanking, we provide too much value than to be kited and baited around
		this.m.Properties.EngageFlankingMult = 0.8;		// Base: 1.25
		// We don't want to expose us to multiple enemies at the same time. That reduces our chances of survival and also leaves less spots for allies to take
		this.m.Properties.EngageTargetMultipleOpponentsMult = 1.75;		// Base: 1.25

		// Melee Leader are usually more proficient in Melee Combat than the average ally, so we want them to focus more on attacks in general
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.KnockBack] = 0.8;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.KnockOut] = 0.8;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Protect] = 0.8;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Shieldwall] = 0.8;
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.SplitShield] = 0.8;

		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Distract] = 0.5;	// Only relevant for Nomads
	}

	// We just overwrite the onUpdate of the base script, to disable all the hard-coded rules it applies during it
	function onUpdate()
	{
	}
});
