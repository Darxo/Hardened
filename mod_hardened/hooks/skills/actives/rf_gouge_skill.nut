::Hardened.removeTooClosePenalty("scripts/skills/actives/rf_gouge_skill");

::Hardened.HooksMod.hook("scripts/skills/actives/rf_gouge_skill", function(q) {
	q.getInjuryThresholdMult = @(__original) function()
	{
		local properties = this.getContainer().getActor().getCurrentProperties();
		local oldIsSpecializedInCleavers = properties.IsSpecializedInCleavers;
		properties.IsSpecializedInCleavers = false;

		local ret = __original();

		properties.IsSpecializedInCleavers = oldIsSpecializedInCleavers;

		return ret;
	}
});
