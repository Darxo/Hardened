// New Hardened Perk Defs
::DynamicPerks.Perks.addPerks([
	{
		ID = "perk.hd_anchor",
		Script = "scripts/skills/perks/perk_hd_anchor",
		Name = ::Const.Strings.PerkName.HD_Anchor,
		Tooltip = ::Const.Strings.PerkDescription.HD_Anchor,
		Icon = "ui/perks/perk_hd_anchor.png",
		IconDisabled = "ui/perks/perk_hd_anchor_sw.png",
	},
	{
		ID = "perk.hd_brace_for_impact",
		Script = "scripts/skills/perks/perk_hd_brace_for_impact",
		Name = ::Const.Strings.PerkName.HD_BraceForImpact,
		Tooltip = ::Const.Strings.PerkDescription.HD_BraceForImpact,
		Icon = "ui/perks/perk_hd_brace_for_impact.png",		// Existing unused vanilla art, that we just renamed
		IconDisabled = "ui/perks/perk_hd_brace_for_impact_sw.png",		// Edited (desatured) version of existing unused vanilla art
	},
	{
		ID = "perk.hd_hybridization",
		Script = "scripts/skills/perks/perk_hd_hybridization",
		Name = ::Const.Strings.PerkName.HD_Hybridization,
		Tooltip = ::Const.Strings.PerkDescription.HD_Hybridization,
		Icon = "ui/perks/perk_rf_hybridization.png",
		IconDisabled = "ui/perks/perk_rf_hybridization_sw.png",
	},
	{
		ID = "perk.hd_one_with_the_shield",
		Script = "scripts/skills/perks/perk_hd_one_with_the_shield",
		Name = ::Const.Strings.PerkName.HD_OneWithTheShield,
		Tooltip = ::Const.Strings.PerkDescription.HD_OneWithTheShield,
		Icon = "ui/perks/perk_02.png",	// Unused vanilla art of a shield deflecting a flail attack
		IconDisabled = "ui/perks/perk_02_sw.png",
	},
	{
		ID = "perk.hd_parry",
		Script = "scripts/skills/perks/perk_hd_parry",
		Name = ::Const.Strings.PerkName.HD_Parry,
		Tooltip = ::Const.Strings.PerkDescription.HD_Parry,
		Icon = "ui/perks/perk_hd_parry.png",
		IconDisabled = "ui/perks/perk_hd_parry_sw.png",
	},
	{
		ID = "perk.hd_scout",
		Script = "scripts/skills/perks/perk_hd_scout",
		Name = ::Const.Strings.PerkName.HD_Scout,
		Tooltip = ::Const.Strings.PerkDescription.HD_Scout,
		Icon = "ui/perks/perk_hd_scout.png",
		IconDisabled = "ui/perks/perk_hd_scout_sw.png",
	},
	{
		ID = "perk.hd_elusive",
		Script = "scripts/skills/perks/perk_hd_elusive",
		Name = ::Const.Strings.PerkName.HD_Elusive,
		Tooltip = ::Const.Strings.PerkDescription.HD_Elusive,
		Icon = "ui/perks/perk_rf_trip_artist.png",
		IconDisabled = "ui/perks/perk_rf_trip_artist_sw.png",
	},
	{
		ID = "perk.hd_forestbond",
		Script = "scripts/skills/perks/perk_hd_forestbond",
		Name = ::Const.Strings.PerkName.HD_Forestbond,
		Tooltip = ::Const.Strings.PerkDescription.HD_Forestbond,
		Icon = "skills/terrain_icon_06.png",	// Unused Vanilla art showing a lot of forest leaves
		IconDisabled = "skills/terrain_icon_06.png",
	},
]);

// Reforged Fix: Add missing Vanilla Perk Defs, so that they display tooltips correctly
::DynamicPerks.Perks.addPerks([
	{
		ID = "perk.captain",
		Script = "scripts/skills/perks/perk_captain",
		Name = ::Const.Strings.PerkName.Captain,
		Tooltip = ::Const.Strings.PerkDescription.Captain,
		Icon = "ui/perks/perk_28.png",
		IconDisabled = "ui/perks/perk_28_sw.png",
	},
]);
