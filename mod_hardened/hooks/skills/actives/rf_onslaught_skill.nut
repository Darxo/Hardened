::Hardened.HooksMod.hook("scripts/skills/actives/rf_onslaught_skill", function(q) {
	q.m.HD_Radius <- 4;

	q.create = @(__original) function()
	{
		__original();
		this.m.Icon = "skills/hd_onslaught_skill.png";	// This modified icon has more contrast and is brighter
		this.m.SoundOnUse = ["sounds/enemy_sighted_02.wav"];
		this.m.ActionPointCost = 7;		// Reforged: 7
		this.m.FatigueCost = 30;		// Reforged: 30
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("You and your allies within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles gain the [Onslaught|Skill+rf_onslaught_effect] effect for two [rounds|Concept.Round]");
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
			else if (entry.id == 22)
			{
				entry.text = ::MSU.Text.colorNegative("Has already been used this battle");
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
		foreach (ally in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()))
		{
			if (ally.getMoraleState() == ::Const.MoraleState.Fleeing) continue;
			if (ally.getCurrentProperties().IsStunned) continue;
			if (ally.getTile().getDistanceTo(myTile) > this.m.HD_Radius) continue;

			ally.getSkills().add(::new("scripts/skills/effects/rf_onslaught_effect"));
		}

		return true;
	}
});
