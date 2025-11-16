this.hd_nomad_melee_agent <- ::inherit("scripts/ai/tactical/agents/bandit_melee_agent", {
	m = {},
	function create()
	{
		this.bandit_melee_agent.create();

		// We adjust some parameters to make nomads more likely to play in a lose formation to maximize their dodge values
		this.m.Properties.OverallFormationMult = 0.75;	// Base: 1.0
		this.m.Properties.EngageTargetMultipleOpponentsMult = 1.5;	// Base: 1.25
		this.m.Properties.EngageFlankingMult = 1.5;		// Base: 1.25
		this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 1.25;		// Base: 0.5
	}
});
