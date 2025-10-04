::Hardened.HooksMod.hook("scripts/skills/actives/riposte", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.ActionPointCost -= 1;
		this.m.FatigueCost = 15;	// Vanilla: 25;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 4 && entry.icon == "ui/icons/hitchance.png")
			{
				ret.remove(index);	// Riposte no longer has a hitchance penalty
				break;
			}
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain the [Riposte Effect|Skill+riposte_effect]"),
		});

		return ret;
	}

	q.isUsable = @(__original) function()
	{
		return __original() && !this.getContainer().hasSkill("effects.riposte");
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		__original(_user, _targetTile);

		this.m.IsSpent = false;		// We set this back to false to completely disable the vanilla once-per-turn rule
	}
});
