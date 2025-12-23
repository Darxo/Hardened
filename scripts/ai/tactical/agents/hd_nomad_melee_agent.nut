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

	function onUpdate()
	{
		this.bandit_melee_agent.onUpdate();

		// bandit_melee_agent sets the following value to 0.25 for weapons with a range of 2; and to 0.5 for weapons with a range of 1
		// The behavior for weapon range of 2 is ok and we like that. But we need to overwrite that for a range of 1, because nomads want empty spaces
		if (this.m.Properties.EngageTargetAlreadyBeingEngagedMult == 0.5)
		{
			this.m.Properties.EngageTargetAlreadyBeingEngagedMult = 1.25;
		}
	}
});
