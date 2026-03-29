::Hardened.HooksMod.hook("scripts/skills/actives/rf_hold_steady_skill", function(q) {
	// Public
	q.m.HD_SoundOnTarget <- "sounds/combat/hd_hold_steady_secondary.wav";

	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "skills/hd_hold_steady_skill.png";	// This modified icon has more contrast and is brighter
		this.m.SoundOnUse = ["sounds/combat/hd_hold_steady_main.wav"];
		this.m.SoundVolume = 1.4;	// The original soundfile above is a bit quiet at -3db peak
		this.m.ActionPointCost = 7;	// In Reforged this is 7
		this.m.FatigueCost = 30;	// In Reforged this is 30
		this.m.MaxRange = 4;		// In Reforged this is unused (0)
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("You and your allies within " + ::MSU.Text.colorPositive(this.m.MaxRange) + " tiles gain the [Holding Steady|Skill+rf_hold_steady_effect] effect for two [rounds|Concept.Round]");
			}
			else if (entry.id == 20)
			{
				entry.icon = "ui/icons/unlocked_small.png";		// Reforged: "ui/icons/warning.png"
			}
			else if (entry.id == 21)
			{
				if (this.m.IsSpent)
				{
					entry.icon = "ui/icons/warning.png";
					entry.text = "Cannot be used, because you already used this skill";
				}
				else
				{
					entry.icon = "ui/icons/unlocked_small.png";
					entry.text = "Can only be used once per battle";
				}
			}
		}

		foreach (key, entry in ret)
		{
			// We remove the bullet point about this skill already having been used, because we now put that information in the ID 21 bullet point
			if (entry.id == 22)
			{
				ret.remove(key);
				break;
			}
		}

		return ret;
	}

	// Overwrite because we change a few things:
	// 	- Remove one-per-company rule;
	// 	- Utilize MinRange/MaxRange member;
	// 	- Remove varying turn duration logic (instead they now always last 2 rounds on the target)
	q.onUse = @() function( _user, _targetTile )
	{
		this.m.IsSpent = true;

		local myTile = _user.getTile();
		local affectedAllies = 0;
		foreach (ally in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()))
		{
			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
			if (ally.getCurrentProperties().IsStunned) continue;
			if (ally.getTile().getDistanceTo(myTile) < this.getMinRange()) continue;
			if (ally.getTile().getDistanceTo(myTile) > this.getMaxRange()) continue;

			ally.getSkills().add(::new("scripts/skills/effects/rf_hold_steady_effect"));
			affectedAllies++;
		}

		if (affectedAllies > 1)		// We don't play a secondary sound effect, if this skill only affects ourselves
		{
			local volume = ::Math.minf(1.5 + affectedAllies / 5.0, 3.0);	// The secondary sound clip gets louder the more allies are affected
			::Time.scheduleEvent(::TimeUnit.Virtual, 100, this.HD_playSoundEffectOnTarget, { Skill = this, Volume = volume });
		}

		return true;
	}

	q.addResources = @(__original) function()
	{
		__original();
		::Tactical.addResource(this.m.HD_SoundOnTarget);
	}

// New Functions
	q.HD_playSoundEffectOnTarget <- function( _data )
	{
		::Sound.play(_data.Skill.m.HD_SoundOnTarget, _data.Volume, _data.Skill.getContainer().getActor().getPos(), 1.0);
	}
});
