::Hardened.HooksMod.hook("scripts/skills/actives/recover_skill", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Spends your wait action and causes the Wait-Debuff"
		})
		return ret;
	}

	q.onUse = @(__original) function( _user, _targetTile )
	{
		if (__original(_user, _targetTile))
		{
			this.getContainer().getActor().m.IsWaitActionSpent = true;
			this.getContainer().add(::new("scripts/skills/effects/hd_wait_effect"));
			return true;
		}
		return false;
	}
});
