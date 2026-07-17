::Hardened.HooksMod.hook("scripts/ui/screens/menu/main_menu_screen", function(q)
{
	q.showNewCampaignMenu = @(__original) function()
	{
		__original();

		if (::Hardened.util.hasPersistentData("LastOriginSettings"))
		{
			local settings = ::Hardened.util.getPersistentData("LastOriginSettings");
			this.getNewCampaignMenuModule().m.JSHandle.asyncCall("HD_applyDefaultValues", settings);
		}
	}
});
