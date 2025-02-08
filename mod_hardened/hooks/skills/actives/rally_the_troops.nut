::Hardened.HooksMod.hook("scripts/skills/actives/rally_the_troops", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.HD_Cooldown = 1;	// We now use the cooldown framework replacing the vanilla way of adding a dummy skill on ourselves
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 9 && entry.icon == "ui/tooltips/warning.png")
			{
				ret.remove(index);	// Remove warning, when this character has the rallied-effect. That effect no longer prevents you from using this skill
			}
		}

		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		local ret = __original(_user, _targetTile);
		this.getContainer().removeByID("effects.rallied");	// We remove this dummy effect, that vanilla always puts on the user
		return ret;
	}

	// We overwrite this function because we remove the check for hasSkill("effects.rallied")
	q.isUsable = @() function()
	{
		return this.skill.isUsable();
	}
});
