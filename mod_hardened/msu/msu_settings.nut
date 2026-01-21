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

	qolWorldPage.addBooleanSetting("DisplayFoodDuration", true, "Display Food Duration", "Display next to your food supplies the amount of days that they will last for your company. This duration will never be larger than expiration date of your longest lasting food.");
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

	qolWorldPage.addDivider("MiscDivider7");

	qolWorldPage.addRangeSetting("WorldMouseWheelZoomMultiplier",0.4 ,0.1 , 0.8, 0.05, "Mouse Wheel Zoom Multiplier", "This controls how fast your mouse wheel will scroll. 0.3 is the vanilla default value.");
}

// QOL: Combat
{
	local qolCombatPage = ::Hardened.Mod.ModSettings.addPage("Combat (QoL)");

	qolCombatPage.addBooleanSetting("HoldOnDiscoverHostile", true, "Hold on Hostile Discovery", "Whenever you discover a hostile entity during your movement in combat, any further movement will be cancelled.");
	qolCombatPage.addBooleanSetting("HoldOnDiscoverAlly", false, "Hold on Ally Discovery", "Whenever you discover an ally entity during your movement in combat, any further movement will be cancelled.");

	qolCombatPage.addBooleanSetting("HideTileTooltipsDuringNPCTurn", false, "Hide Tooltips during NPC Turn", "Tile and Character tooltips will not show up, while it is not your turn.");

	qolCombatPage.addRangeSetting("MouseWheelZoomMultiplier",0.1 ,0.05 , 0.4, 0.01, "Mouse Wheel Zoom Multiplier", "This controls how fast your mouse wheel will scroll. 0.3 is the vanilla default value.");

	qolCombatPage.addDivider("MiscDivider1");

	qolCombatPage.addBooleanSetting("ShowGlowingEyes", true, "Show Red Glowing Eyes", "Display red glowing eyes on a humans and human-like characters, who have certain temporary damage buffs active.");
	qolCombatPage.addBooleanSetting("FullForceCameraShake", true, "Shake Camera On Full Force", "Shake the camera as part of the impact animation of a successful Full Force attack");
	qolCombatPage.addBooleanSetting("ShowUncappedHitchances", true, "Show Uncapped Hitchances", "If your uncapped Hitchance would be larger than the one you currently have when aiming at an enemy, display it in brackets");

	qolCombatPage.addDivider("MiscDivider2");

	qolCombatPage.addBooleanSetting("UseSoundEngineFix", true, "Use Sound Engine Fix", "Rework directional sound during combat to be according to the real direction where the sound is coming from.");

	qolCombatPage.addDivider("MiscDivider3");

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

	qolCombatPage.addDivider("MiscDivider4");

	qolCombatPage.addBooleanSetting("DisplayHitchanceOverlays", true, "Display Hitchance Overlays", "Whenever you preview an Attack that is using Hitchance, generate a text label with your hitchance on every character you can attack from your current position.");
	qolCombatPage.addEnumSetting("HitchanceOverlayColoring", "Green <-> Red", ["Green <-> Red", "Black & White"], "Hitchance Coloring", "Define how you want the Hitchance numbers to appear.\n\nGreen <-> Red: High hitchance numbers are colored green, which then turns into yellow, orange and red as the chances get lower.\n\nWhite & Black: All hitchance numbers are colored white with a black outline.");
	qolCombatPage.addRangeSetting("HitchanceOverlayFontSize", 2.0, 0.5, 2.5, 0.1, "Hitchance Overlay Font Size", "This controls the font size of the hitchance text on enemies. A bigger font size may clip into neighboring tiles making it more difficult to target those.");

	qolCombatPage.addDivider("MiscDivider5");

	qolCombatPage.addBooleanSetting("DisplaySkillTags", true, "Display Skill Tags", "List common tags and the damage types at the top of the descriptions of active skill.");

	qolCombatPage.addDivider("MiscDivider6");

	qolCombatPage.addBooleanSetting("CombineCombatSkillLogs", true, "Combine Combat Logs of Skills", "Combat Logs, which are the result of the same skill execution no longer produce regular newlines.");
	qolCombatPage.addBooleanSetting("ShowCoverCombatLogs", true, "Show Cover Combat Logs", "Generate an additional combat log when targeting someone with a ranged attack, who is in cover. This log contains the chance and roll for bypassing the cover and also the initial target and the new target.");

}

// QOL: Character Screen
{
	local qolCharScreenPage = ::Hardened.Mod.ModSettings.addPage("Character Screen (QoL)");

	local silhouetteCallback = function( _oldValue )	// We need to update all characters so that these changes take effect
	{
		if (!::MSU.Utils.hasState("world_state") && !::MSU.Utils.hasState("tactical_state")) return;	// otherwise the game crashes when changing settings in main menu

		if (::MSU.Utils.hasState("world_state"))
		{
			foreach (brother in ::World.getPlayerRoster().getAll())
			{
				brother.getSkills().update();
				brother.setDirty(true);
			}
		}
		else if (::MSU.Utils.hasState("tactical_state"))
		{
			foreach (actor in ::Tactical.Entities.getAllInstancesAsArray())
			{
				actor.getSkills().update();
				brother.setDirty(true);
			}
		}
	}

	qolCharScreenPage.addRangeSetting("BagSilhouetteAlpha", 200, 0, 255, 5, "Bag Silhouette Alpha", "This controls the alpha value of the bag item silhouettes during combat only. In the character screen they always show up with an alpha of 255. A value of 0 makes them invisible everywhere and effectively turns off this feature.").addAfterChangeCallback(silhouetteCallback);
	qolCharScreenPage.addRangeSetting("BagSilhouetteColor", 60, 0, 255, 5, "Bag Silhouette Color", "This controls the color value of the bag item silhouettes. A value of 0 makes item completely black while a value of 255 keeps its original color.").addAfterChangeCallback(silhouetteCallback);
	qolCharScreenPage.addBooleanSetting("ShowShieldSilhouettes", false, "Show Shield Silhouettes", "Display silhouettes for shields in your bag slots. These sprites might look most out of place, so not everyone might want them to show up").addAfterChangeCallback(silhouetteCallback);

	qolCharScreenPage.addDivider("MiscDivider1");

	qolCharScreenPage.addBooleanSetting("SkipConfirmationNewRecruits", false, "Skip Confirmation for new Recruits", "Skip the confirmation dialog when trying to dismiss a brother if they were just hired (0 days with the company). Characters with a Level 2 or higher are automatically paid compensation to not miss out on XP.");

	qolCharScreenPage.addDivider("MiscDivider2");

	qolCharScreenPage.addBooleanSetting("ShowAbsoluteMoodValue", true, "Show Absolute Mood Value", "When viewing the mood tooltip of a brother, display the current mood as an absolute value between 0.0 and 6.95. This improves your understanding on how much impact certain mood changes will have. In Vanilla this value is shows as a percentage.");
}
