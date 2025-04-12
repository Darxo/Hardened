// QOL: World
{
	local qolWorldPage = ::Hardened.Mod.ModSettings.addPage("World (QoL)");

	qolWorldPage.addBooleanSetting("AutoRepairUpgradedArmor", true, "Always Repair Upgraded Armor", "Any armor with an upgrade will always be marked as \'To be repaired\' when put into your stash.");
	qolWorldPage.addBooleanSetting("AutoRepairNamedArmor", true, "Always Repair Named Armor", "Any named or legendary armor will always be marked as \'To be repaired\' when put into your stash.");

	qolWorldPage.addDivider("MiscDivider1");

	qolWorldPage.addBooleanSetting("DisplayForbiddenPorts", true, "Display forbidden Ports", "Enable this setting to also list Ports which are currently considered 'forbidden' due to hostile status with the player or the origin port.");

	qolWorldPage.addDivider("MiscDivider2");

	// Callback Function to update the location types variable in the world_state class
	local updateLocationTypesToDisplay = function( _oldValue )
	{
		if (!::MSU.Utils.hasState("world_state")) return;	// otherwise the game crashes when changing settings in main menu

		::World.State.m.HD_LocationTypesToDisplay = 0;
		if (::Hardened.Mod.ModSettings.getSetting("DisplayCampLocationsNames").getValue()) ::World.State.m.HD_LocationTypesToDisplay += ::Const.World.LocationType.Lair;
		if (::Hardened.Mod.ModSettings.getSetting("DisplayUniqueLocationsNames").getValue()) ::World.State.m.HD_LocationTypesToDisplay += ::Const.World.LocationType.Unique;
		if (::Hardened.Mod.ModSettings.getSetting("DisplayAttachedLocationNames").getValue()) ::World.State.m.HD_LocationTypesToDisplay += ::Const.World.LocationType.AttachedLocation;

		::World.State.updateLocationNames();
	}

	qolWorldPage.addBooleanSetting("DisplayLocationNumerals", true, "Display Numerals for Location", "Locations display the Numerals for their Troops if they are known to you.").addAfterChangeCallback(updateLocationTypesToDisplay);
	qolWorldPage.addBooleanSetting("DisplayUniqueLocationsNames", true, "Display Unique Location Names", "Unique display their name to you while you are near them.").addAfterChangeCallback(updateLocationTypesToDisplay);
	qolWorldPage.addBooleanSetting("DisplayCampLocationsNames", true, "Display Lair Location Names", "Lairs display their name to you while you are near them.").addAfterChangeCallback(updateLocationTypesToDisplay);
	qolWorldPage.addBooleanSetting("DisplayAttachedLocationNames", false, "Display Attached Location Names", "Attached Location display their name to you while you are near them.").addAfterChangeCallback(updateLocationTypesToDisplay);

	qolWorldPage.addDivider("MiscDivider3");

	qolWorldPage.addBooleanSetting("AlwaysDisplayRenownValue", true, "Always Display Renown Value", "Always display your exact renown value in brackets whenever displaying your current renown state.");
	qolWorldPage.addBooleanSetting("DisplayRelationValue", true, "Display Relation Value", "Always display your exact relation value in brackets when displaying the current relationship state.");
	qolWorldPage.addBooleanSetting("DisplayMoraleValue", true, "Display Morale Reputation Value", "Always display your exact morale value in brackets when displaying the current morale reputation state.");

	qolWorldPage.addDivider("MiscDivider4");

	qolWorldPage.addBooleanSetting("DisplayFoodDuration", true, "Display Food Duration", "Display next to your food supplies the amount of days that they will last for your company.");
	qolWorldPage.addBooleanSetting("DisplayRepairDuration", true, "Display Repair Duration", "Display next to your tool supplies the amount of hours that it will take to fully repair all gear.");
	qolWorldPage.addBooleanSetting("DisplayMinMedicineCost", true, "Display Min Medicine Cost", "Display next to your medicine supplies the minimum supplies that your currently injured brothers will require to fully recover.");

	qolWorldPage.addDivider("MiscDivider5");

	// Callback Function to update the numeral strings for enemies after touching the world party option
	local updateEntitiyStrengthCallback = function( _oldValue )
	{
		if (!::MSU.Utils.hasState("world_state")) return;	// otherwise the game crashes when changing settings in main menu
		::Hardened.Numerals.updateAllParties();
	}

	local myEnumSetting = ::MSU.Class.EnumSetting("WorldPartyRepresentation", "Numeral", ["Numeral", "Range"], "World Party Size", "Define how the party size of entities on the world map are shown. 'Numeral' is a word/string while 'Range' is the range that is represented by that word");
	myEnumSetting.addAfterChangeCallback(updateEntitiyStrengthCallback);
	qolWorldPage.addElement(myEnumSetting);

	myEnumSetting = ::MSU.Class.EnumSetting("CombatDialogRepresentation", "Numeral (Range)", ["Numeral", "Numeral (Range)", "Range"], "Combat Dialog Size", "Define how the size of entities in combat dialogs and tooltips are shown. 'Numeral' is a word/string while 'Range' is the range that is represented by that word");
	qolWorldPage.addElement(myEnumSetting);

	qolWorldPage.addDivider("MiscDivider6");

	local waypointUpdateCallback = function( _oldValue )
	{
		if (!::MSU.Utils.hasState("world_state")) return;	// otherwise the game crashes when changing settings in main menu
		if (::MSU.isNull(::World.State.m.HD_WaypointReference)) return;

		if (!::Hardened.Mod.ModSettings.getSetting("DisplayWaypoint").getValue())
		{
			::World.State.m.HD_WaypointReference.die();
		}
		else
		{
			::World.State.m.HD_WaypointReference.getSprite("waypoint").Scale = ::Hardened.Mod.ModSettings.getSetting("WaypointSize").getValue();
			if (::Hardened.Mod.ModSettings.getSetting("IsWaypointScaling").getValue()) ::World.State.m.HD_WaypointReference.getSprite("waypoint").Scale *= ::World.getCamera().Zoom;
		}
	}

	qolWorldPage.addBooleanSetting("DisplayWaypoint", true, "Display a Waypoint when you move", "Spawn a copy of your banner on the destination to where your player character is moving to currently.").addAfterChangeCallback(waypointUpdateCallback);
	qolWorldPage.addBooleanSetting("IsWaypointScaling", true, "Is Waypoint Scaling", "If \'true\', then the Waypoint sprite will take less screen space as you zoom out and more as you zoom in. If \'false\', then it will always take the same amount of space on your screen.").addAfterChangeCallback(waypointUpdateCallback);
	qolWorldPage.addRangeSetting("WaypointSize", 0.8, 0.5, 1.5, 0.1, "Waypoint Banner Size", "This controls big the banner of your Waypoint is.").addAfterChangeCallback(waypointUpdateCallback);
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

	qolCombatPage.addBooleanSetting("CombineCombatSkillLogs", true, "Combine Combat Logs of Skills", "Combat Logs, which are the result of the same skill execution no longer produce regular newlines.");

	qolCombatPage.addRangeSetting("MouseWheelZoomMultiplier",0.1 ,0.05 , 0.4, 0.01, "Mouse Wheel Zoom Multiplier", "This controls how fast your mouse wheel will scroll. 0.3 is the vanilla default value.");

	qolCombatPage.addDivider("MiscDivider2");

	qolCombatPage.addBooleanSetting("UseSoundEngineFix", true, "Use Sound Engine Fix", "Rework directional sound during combat to be according to the real direction where the sound is coming from.");
}
