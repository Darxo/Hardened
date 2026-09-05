::Hardened.HooksMod.hook("scripts/ambitions/ambitions/make_nobles_aware_ambition", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.RewardTooltip = ::MSU.String.replace(this.m.RewardTooltip, "new", "more difficult contracts and completely new");
	}

	q.onReward = @(__original) function()
	{
		__original();

		this.m.SuccessList.push({
			id = 10,
			icon = "ui/icons/miniboss.png",
			text = ::MSU.Text.colorPositive("+1") + " maximum Contract Tier",	// See HD_getMaxContractTier
		});
	}

	q.getButtonTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/miniboss.png",
			text = ::MSU.Text.colorPositive("+1") + " maximum Contract Tier",	// See HD_getMaxContractTier
		});

		return ret;
	}
});
