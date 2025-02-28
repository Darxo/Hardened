::Const.Strings.World.TimeOfDay <- [
	"Morning",
	"Morning",
	"Morning",
	"Midday",
	"Afternoon",
	"Afternoon",
	"Afternoon",
	"Sunset",
	"Dusk",
	"Midnight",
	"Dawn",
	"Sunrise",
];

::Const.Strings.Distance[0] += " (0 - 5 tiles)";
::Const.Strings.Distance[1] += " (6 - 11 tiles)";
::Const.Strings.Distance[2] += " (12 - 17 tiles)";
::Const.Strings.Distance[3] += " (18 - 23 tiles)";
::Const.Strings.Distance[4] += " (24 - 29 tiles)";
::Const.Strings.Distance[5] += " (30+ tiles)";

local newPerks = [
	{
		Key = "HD_Hybridization",
		Name = "Hybridization",
		Description = ::UPD.getDescription({
			Fluff = "\'Hatchet, throwing axe, spear, javelin... they all kill just the same!\'",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Swapping two weapons with no shared weapon types becomes a free action once per [turn|Concept.Turn]",
						"Whenever you swap two weapons, gain " + ::MSU.Text.colorPositive("+5%") + " [Hitchance|Concept.Hitchance] for your next attack until you [wait|Concept.Wait] or end your [turn|Concept.Turn]",
					],
				},
			],
		}),
	},
];

// Add new Hardened Perks
foreach (newPerk in newPerks)
{
	::Const.Strings.PerkName[newPerk.Key] <- ::Reforged.Mod.Tooltips.parseString(newPerk.Name);
	::Const.Strings.PerkDescription[newPerk.Key] <- ::Reforged.Mod.Tooltips.parseString(newPerk.Description);
}
