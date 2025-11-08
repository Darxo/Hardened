::Hardened.HooksMod.hook("scripts/factions/faction", function(q) {
	// Public
	q.m.HD_PricePctPerPositiveRelation <- 0.003;	// For every point of Relation above HD_NeutralRelation, prices are this much better
	q.m.HD_PricePctPerNegativeRelation <- -0.006;	// For every point of Relation below HD_NeutralRelation, prices are this much worse
	q.m.HD_NeutralRelation <- 50;	// At this relation, there is no price impact

// New Functions
	// Return the price percentage for this faction that is dependant on player relation
	// It may need to be inverted depending on the type of transaction that it influences (buy/sell)
	// A positive relation returns a positive pct; a negative one returns a negative pct
	q.HD_getRelationPricePct <- function()
	{
		local relation = this.getPlayerRelation();
		local relativeRelation = relation - this.m.HD_NeutralRelation;

		local ret = 0.0;
		if (relativeRelation < 0)
		{
			ret -= relativeRelation * this.m.HD_PricePctPerNegativeRelation;
		}
		else if (relativeRelation > 0)
		{
			ret += relativeRelation * this.m.HD_PricePctPerPositiveRelation;
		}

		return ret;
	}
});
