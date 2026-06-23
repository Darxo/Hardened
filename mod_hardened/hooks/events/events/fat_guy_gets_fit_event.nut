::Hardened.HooksMod.hook("scripts/events/events/fat_guy_gets_fit_event", function(q) {
	// Overwrite, because we make the condition for the candidates more moddable
	q.onUpdateScore = @() function()
	{
		local candidates = [];
		foreach (brother in ::World.getPlayerRoster().getAll())
		{
			if (this.HD_isCandidateValid(brother))
			{
				candidates.push(brother);
			}
		}

		if (candidates.len() > 0)
		{
			this.m.FatGuy = ::MSU.Array.rand(candidates);
			this.m.Score = candidates.len() * 5;
		}
	}

// New Functions
	q.HD_isCandidateValid <- function( _brother )
	{
		if (_brother.getLevel() < 5) return false;
		if (!_brother.getSkills().hasSkill("trait.fat")) return false;
		if (_brother.getSkills().hasSkill("trait.gluttonous")) return false;	// Feat: this event no longer procs on someone who is gluttonous

		return true;
	}
});
