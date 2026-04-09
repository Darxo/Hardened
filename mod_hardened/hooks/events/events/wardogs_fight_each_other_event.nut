::Hardened.HooksMod.hook("scripts/events/events/wardogs_fight_each_other_event", function(q) {
	q.m.HD_applicableDogItems <- [
		"accessory.wardog",
		"accessory.armored_wardog",
		"accessory.warhound",
		"accessory.armored_warhound",
	];

	q.m.HD_scorePerDog <- 5;

	q.create = @(__original) function()
	{
		__original();

		// Vanilla only removes those dogs from the stash, so we additionally check the equipped items too
		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "E")
			{
				local oldStart = screen.start;
				screen.start = function( _event )
				{
					::World.Assets.HD_removeItemAnywhere(_event.m.Wardog1);
					::World.Assets.HD_removeItemAnywhere(_event.m.Wardog2);
					oldStart(_event);
				}
			}
			else if (screen.ID == "G")
			{
				local oldStart = screen.start;
				screen.start = function( _event )
				{
					::World.Assets.HD_removeItemAnywhere(_event.m.Wardog1);
					oldStart(_event);
				}
			}
		}
	}

	// Overwrite, because we calculate the conditions score differently:
	// - This event now also counts dogs that are equipped
	// - This event can only trigger, while you have more than 1 dog per 2 brothers
	q.onUpdateScore = @() function()
	{
		local brothers = ::World.getPlayerRoster().getAll();
		local candidates_houndmaster = [];
		local candidates_other = [];
		local candidates_wardog = [];
		{	// Gather Information
			foreach (bro in brothers)
			{
				if (bro.getSkills().hasSkill("trait.player")) continue;

				if (bro.getBackground().getID() == "background.houndmaster")
				{
					candidates_houndmaster.push(bro);
				}
				else
				{
					candidates_other.push(bro);
				}
			}

			// Feat: we now also include items worn by player characters
			foreach (item in ::World.Assets.HD_getAllItems())
			{
				if (this.m.HD_applicableDogItems.find(item.getID()) != null)
				{
					candidates_wardog.push(item);
				}
			}
		}

		if (candidates_other.len() == 0) return;
		if (candidates_wardog.len() < 2) return;	// We require at least 2 dogs for this event

		// Feat: this event now only triggers, while you have more than 1 dog per 2 brothers
		if (candidates_wardog.len() * 2 <= brothers.len()) return;

		// The score scales with how many dogs we have, which are not "watched by" brothers
		this.m.Score = (candidates_wardog.len() * 2 - brothers.len()) * this.m.HD_scorePerDog;

		this.m.Otherbrother = ::MSU.Array.rand(candidates_other);
		if (candidates_houndmaster.len() != 0)
		{
			this.m.Houndmaster = ::MSU.Array.rand(candidates_houndmaster);
		}

		this.m.Wardog1 = ::MSU.Array.rand(candidates_wardog);
		::MSU.Array.removeByValue(candidates_wardog, this.m.Wardog1);
		this.m.Wardog2 = ::MSU.Array.rand(candidates_wardog);
	}
});
