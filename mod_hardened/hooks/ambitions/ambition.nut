::Hardened.HooksMod.hook("scripts/ambitions/ambition", function(q) {
	q.onReward = @(__original) function()
	{
		__original();

		if (::World.Ambitions.getCompleted() == 0)
		{
			this.m.SuccessList.push({
				id = 10,
				icon = "ui/icons/miniboss.png",
				text = ::MSU.Text.colorPositive("+1") + " maximum Contract Tier",	// See HD_getMaxContractTier
			});
		}
	}

	q.getButtonTooltip = @(__original) function()
	{
		local ret = __original();

		if (::World.Ambitions.getCompleted() == 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/miniboss.png",
				text = ::MSU.Text.colorPositive("+1") + " maximum Contract Tier",	// See HD_getMaxContractTier
			});
		}

		return ret;
	}
});
