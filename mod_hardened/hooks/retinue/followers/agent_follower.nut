::Hardened.HooksMod.hook("scripts/retinue/followers/agent_follower", function(q) {
	q.m.HD_RelationRequired <- 90.0;

	q.create = @(__original) function()
	{
		__original();
		this.m.ID = "follower.HD_agent";	// We change the ID, so that the settlement.nut tooltip no longer applies the vanilla effect
		this.m.Effects[0] = "+1 Maximum Contract in Settlements";
		this.m.Effects.push("Civilian Contracts refresh 1 days sooner");
		this.m.Effects.push("Tavern Rumors are more likely to contain useful information");
	}

	q.onUpdate = @(__original) function()
	{
		__original();
		::World.Assets.m.IsNonFlavorRumorsOnly = true;
		::World.Assets.m.HD_AdditionalCivilianContracts += 1;
		::World.Assets.m.HD_CivilianContractDayDelayModifier -= 1.0;
	}

	q.onEvaluate = @() function()
	{
		local highestRelation = this.HD_getHighestAlliedRelation();
		this.m.Requirements[0].Text = "Have " + highestRelation + "/" + this.m.HD_RelationRequired + " Relation with any Noble House or City State";
		this.m.Requirements[0].IsSatisfied = highestRelation >= this.m.HD_RelationRequired;
	}

// New Functions
	q.HD_getHighestAlliedRelation <- function()
	{
		local highestRelation = 0;

		foreach (noble in ::World.FactionManager.getFactionsOfType(::Const.FactionType.NobleHouse))
		{
			if (noble.getPlayerRelation() >= highestRelation)
			{
				highestRelation = noble.getPlayerRelation();
			}
		}

		foreach (cityState in ::World.FactionManager.getFactionsOfType(::Const.FactionType.OrientalCityState))
		{
			if (cityState.getPlayerRelation() >= highestRelation)
			{
				highestRelation = cityState.getPlayerRelation();
			}
		}

		return ::Math.round(highestRelation);
	}
});
