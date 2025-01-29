::Hardened.HooksMod.hook("scripts/skills/actives/rf_kata_step_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 20 && entry.icon == "ui/tooltips/warning.png")
			{
				ret.remove(index);	// Remove tooltip line about specific restrictions
				break;
			}
		}

		return ret;
	}

	// Overwrite because we now also allow shields and other offhand items equipped
	q.isEnabled = @(__original) function()
	{
		if (this.m.IsForceEnabled) return true;

		local actor = this.getContainer().getActor();
		if (actor.isDisarmed()) return false;

		local weapon = actor.getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Sword))
			return false;

		return true;
	}
});
