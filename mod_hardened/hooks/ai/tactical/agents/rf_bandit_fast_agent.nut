::Hardened.HooksMod.hook("scripts/ai/tactical/agents/rf_bandit_fast_agent", function(q) {
	q.create = @(__original) { function create()
	{
		__original();

		// We lower their likelyhood to flank as that just wastes too much of their time
		// And they need allies around them as they are backstabber
		this.m.Properties.EngageFlankingMult = 1.0;		// Reforged: 2.5

		// We increase their formationMult and magnetismMult, as they need allies around them to boost backstabber and between the ribs
		this.m.Properties.OverallFormationMult = 1.2;	// Vanilla: 1.0; Reforged 0.8
		this.m.Properties.OverallMagnetismMult = 1.0;
	}}.create;
});
