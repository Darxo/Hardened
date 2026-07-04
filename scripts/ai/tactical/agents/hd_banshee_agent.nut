this.hd_banshee_agent <- ::inherit("scripts/ai/tactical/agents/ghost_agent", {
	m = {},
	function create()
	{
		this.ghost_agent.create();

		// These characters make up the core of an enemy formation. Their allies are expected to gather around them to maximize their effectiveness
		this.m.Properties.OverallMagnetismMult = 1.5;		// Base: 1.0
		// We want to stay in formation, where our crowd control abilities are most useful are most useful
		this.m.Properties.OverallFormationMult = 1.5;		// Ghost: 0.5

		this.m.Properties.EngageRangeMax = 4;		// Ghost: 3
		this.m.Properties.EngageRangeIdeal = 4;		// Ghost: 3
	}

	// We just overwrite the onUpdate of the base script, to disable all the hard-coded rules vanilla applies during it
	function onUpdate()
	{
		this.ghost_agent.onUpdate();

		// ghost_agent.update() considers, whether we wanna switch to melee. If not, then we need to re-adjust the ideal range
		if (this.m.Properties.EngageRangeIdeal == 3)
		{
			this.m.Properties.EngageRangeIdeal = 4
			this.m.Properties.EngageRangeMax = 4
		}
	}
});
