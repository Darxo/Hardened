::Hardened.HooksMod.hook("scripts/skills/special/rf_frostbound_manager", function(q) {
	q.onAdded = @() function()
	{
		if (this.getContainer().getActor().getCurrentProperties().HD_ImmuneToChilled)
		{
			this.removeSelf();
		}
	}
});
