::Hardened.HooksMod.hook("scripts/skills/actives/rf_hold_steady_skill", function(q) {
	// Public
	q.m.HD_SoundOnTarget <- "sounds/combat/hd_hold_steady_secondary.wav";

	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "skills/hd_hold_steady_skill.png";	// This modified icon has more contrast and is brighter
		this.m.SoundOnUse = ["sounds/combat/hd_hold_steady_main.wav"];
		this.m.SoundVolume = 1.4;	// The original soundfile above is a bit quiet at -3db peak
		this.m.ActionPointCost = 8;	// In Reforged this is 7
		this.m.FatigueCost = 40;	// In Reforged this is 30
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
			else if (entry.id == 21)
			{
				entry.text = "Can only be used once per battle";
			}
			else if (entry.id == 22)
			{
				entry.text = ::MSU.Text.colorNegative("Has already been used this battle");
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
