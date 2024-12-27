// QOL: World
{
	local qolWorldPage = ::Hardened.Mod.ModSettings.addPage("World (QoL)");

	qolWorldPage.addBooleanSetting("AutoRepairUpgradedArmor", true, "Always Repair Upgraded Armor", "Any armor with an upgrade will always be marked as \'To be repaired\' when put into your stash.");
	qolWorldPage.addBooleanSetting("AutoRepairNamedArmor", true, "Always Repair Named Armor", "Any named or legendary armor will always be marked as \'To be repaired\' when put into your stash.");

	qolWorldPage.addDivider("MiscDivider1");

	qolWorldPage.addBooleanSetting("DisplayForbiddenPorts", true, "Display forbidden Ports", "Enable this setting to also list Ports which are currently considered 'forbidden' due to hostile status with the player or the origin port.");

	qolWorldPage.addDivider("MiscDivider2");

	qolWorldPage.addRangeSetting("DistanceForLocationName", 5, 0, 10, 1, "Distance for Location Name", "When you are this many tiles away from certain locations, their name is displayed to you");

	qolWorldPage.addBooleanSetting("DisplayUniqueLocationsNames", true, "Display Unique Location Names", "Unique display their name to you while you are near them.");
	qolWorldPage.addBooleanSetting("DisplayCampLocationsNames", true, "Display Lair Location Names", "Lairs display their name to you while you are near them.");
	qolWorldPage.addBooleanSetting("DisplayAttachedLocationNames", false, "Display Attached Location Names", "Attached Location display their name to you while you are near them.");

	qolWorldPage.addDivider("MiscDivider3");

	qolWorldPage.addBooleanSetting("AlwaysDisplayRenownValue", true, "Always Display Renwon Value", "Always display your exact renown value in brackets whenever displaying your current renown state.");
	qolWorldPage.addBooleanSetting("DisplayRelationValue", true, "Display Relation Value", "Always display your exact relation value in brackets when displaying the current relationship state.");
	qolWorldPage.addBooleanSetting("DisplayMoraleValue", true, "Display Morale Reputation Value", "Always display your exact morale value in brackets when displaying the current morale reputation state.");
}

// QOL: Combat
{
	local qolCombatPage = ::Hardened.Mod.ModSettings.addPage("Combat (QoL)");

	local continuousWaitKeybindSetting = qolCombatPage.addBooleanSetting("ContinuousWaitKeybind", false , "Continuous Wait Keybind", "While active it is enough to hold down your 'wait' Keybind in order to wait so you can more easily wait with multiple brothers.");
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

	qolCombatPage.addDivider("MiscDivider1");

	qolCombatPage.addBooleanSetting("HideTileTooltipsDuringNPCTurn", true, "Hide Tooltips during NPC Turn", "Tile and Character tooltips will not show up, while it is not your turn.");
}
