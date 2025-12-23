/*
This agent is designed to be given to enemies with dangerous weapons with good hitpoints, armor or damage mitigation perks
Since they are impactful and durable, they are expected to enter combat consitently and not waste time flanking
But they are smart enough to not just Bum-Rush into a full surround without backup
It inherits from bounty_hunter_melee_agent
It is given to the likes of Executioner and Hedge Knights
*/

this.hd_generic_carry_agent <- ::inherit("scripts/ai/tactical/agents/bounty_hunter_melee_agent", {
	m = {},
	function create()
	{
		this.bounty_hunter_melee_agent.create();

		// So that these guys enter combat more consistently and quickly
		this.m.Properties.OverallDefensivenessMult = 0.8;	// Base: 1.0
		// We want these characters to not be left alone where they would be perma CC'ed and quickly killed off
		this.m.Properties.OverallMagnetismMult = 1.2;		// Base: 1.0

		// We don't waste time flanking, we provide too much value than to be kited and baited around
		this.m.Properties.EngageFlankingMult = 0.8;		// Base: 1.25

		// Our Damage Output is far too important to waste it on
		// Stunning/Disarming someone
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.KnockOut] = 0.25;
		// Protecting allies
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Protect] = 0.5;
		// Using defensive options
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Shieldwall] = 0.5;
		// Splitting a shield
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.SplitShield] = 0.8;
		// Knocking someone back
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.KnockBack] = 0.8;
		// Use Pocket Sand (It already costs only 3 AP so they will have opportunities to use it anyways)
		this.m.Properties.BehaviorMult[::Const.AI.Behavior.ID.Distract] = 0.5;	// Only relevant for Nomads
	}

	// We overwrite the onUpdate of the base script, to disable all the hard-coded rules it applies during it
	function onUpdate()
	{
		// The one thing we like from the base script is that backline-carries want to be tucked into formation more often
		if (this.m.Properties.EngageRangeIdeal > 1)
		{
			this.m.Properties.OverallFormationMult = 1.5;
		}
		else
		{
			this.m.Properties.OverallFormationMult = 1.0;
		}
	}
});
