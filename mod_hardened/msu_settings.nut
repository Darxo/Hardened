// Quality of Life Page
{
	local qolPage = ::Hardened.Mod.ModSettings.addPage("Quality of Life");

	qolPage.addBooleanSetting("AutoRepairUpgradedArmor", true, "Always Repair Upgraded Armor", "Any armor with an upgrade will always be marked as \'To be repaired\' when put into your stash.");
	qolPage.addBooleanSetting("AutoRepairNamedArmor", true, "Always Repair Named Armor", "Any named or legendary armor will always be marked as \'To be repaired\' when put into your stash.");

	qolPage.addDivider("MiscDivider1");

	local continuousWaitKeybindSetting = qolPage.addBooleanSetting("ContinuousWaitKeybind", false , "Continuous Wait Keybind", "While active it is enough to hold down your 'wait' Keybind in order to wait so you can more easily wait with multiple brothers.");
	local continuousWaitKeybindCallback = function( _oldValue )
	{
		if (this.Value)
		{
			::MSU.System.Keybinds.KeybindsByMod["vanilla"]["tactical_waitTurn"].KeyState = ::MSU.Key.KeyState.Continuous;
		}
		else
		{
			::MSU.System.Keybinds.KeybindsByMod["vanilla"]["tactical_waitTurn"].KeyState = ::MSU.Key.KeyState.Release;
		}
	};
	continuousWaitKeybindSetting.addAfterChangeCallback(continuousWaitKeybindCallback);
}
