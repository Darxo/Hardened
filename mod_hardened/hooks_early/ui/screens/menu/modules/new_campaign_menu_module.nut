::Hardened.HooksMod.hook("scripts/ui/screens/menu/modules/new_campaign_menu_module", function(q)
{
	q.onStartButtonPressed = @(__original) function( _settings )
	{
		::Hardened.util.savePersistentData("LastOriginSettings", _settings)
		__original(_settings);
	}
});
