::Hardened.HooksMod.hook("scripts/events/events/wound_gets_infected_event", function(q) {
	q.m.ScorePerInjury <- 5;	// In Vanilla this is 7 per injured brother (no matter how many injuries)
	q.m.ScoreMultWithoutMedicine <- 2.0;

	q.create = @(__original) function()
	{
		__original();
		this.m.Cooldown = 14.0 * this.World.getTime().SecondsPerDay;
	}

	// Overwrite, because we calculate the score a bit differently
	q.onUpdateScore = @() function()
	{
		this.m.Score = 0;	// Vanilla never does this explicitly
		local brothers = ::World.getPlayerRoster().getAll();
		if (brothers.len() < 2) return;		// Same condition as vanilla, because we need two brothers for this event

		local candidates = [];
		local secondaryCandidateList = [];
		local numberOfInjuries = 0;
		foreach (bro in brothers)
		{
			secondaryCandidateList.push(bro);

			local skip = true;
			local broScore = 0;
			foreach (inj in bro.getSkills().query(::Const.SkillType.TemporaryInjury))
			{
				if (inj.getID() == "injury.infection")	// We ignore any brother, who already has an infection
				{
					skip = true;
					break;
				}
				else if (!inj.isTreated() && inj.getInfectionChance() != 0)	// Only injuries, which are infectios and not treated, are valid ones
				{
					skip = false;
					broScore += this.m.ScorePerInjury;
				}
			}

			if (skip) continue;

			candidates.push(bro);
			this.m.Score += broScore;
		}
		if (candidates.len() == 0) return;

		this.m.Injured = ::MSU.Array.rand(candidates);

		secondaryCandidateList.remove(secondaryCandidateList.find(this.m.Injured));
		this.m.Other = ::MSU.Array.rand(secondaryCandidateList);

		if (::World.Assets.getMedicine() == 0)
		{
			this.m.Score *= this.m.ScoreMultWithoutMedicine;
		}
	}
});
