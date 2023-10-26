::mods_hookExactClass("skills/actives/recover_skill", function(o) {
	local oldGetTooltip = o.getTooltip;
	o.getTooltip = function()
	{
		local ret = oldGetTooltip();
		ret.push({
			id = 8,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Spends your wait action and causes the Wait-Debuff"
		})
		return ret;
	}

	local oldOnUse = o.onUse;
	o.onUse = function( _user, _targetTile )
	{
		if (oldOnUse(_user, _targetTile))
		{
			this.getContainer().getActor().m.IsWaitActionSpent = true;
			this.getContainer().add(::new("scripts/skills/effects/hd_wait_effect"));
			return true;
		}
		return false;
	}
});
