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
						"Gain " + ::MSU.Text.colorPositive("+5") + " [Melee Defense,|Concept.MeleeDefense] if you have at least " + ::MSU.Text.colorPositive("70") + " [Base Ranged Skill|Concept.RangeSkill]",
						"Gain " + ::MSU.Text.colorPositive("+5") + " [Ranged Defense,|Concept.RangeDefense] if you have at least " + ::MSU.Text.colorPositive("70") + " [Base Melee Skill|Concept.MeleeSkill]",
					],
				},
			],
		}),
	},
	{
		Key = "HD_OneWithTheShield",
		Name = "One with the Shield",
		Description = ::UPD.getDescription({
			Fluff = "Shift your shield to guard vital points; raised to protect your head, lowered to shield your body",
			Requirement = "Shield",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Gain " + ::MSU.Text.colorPositive("25%") + " more [Injury Threshold|Concept.InjuryThreshold]",	// Usually we would use "You have" here isntead of "Gain", but this is an exception, because this way the effect fits in one line
						"You take " + ::MSU.Text.colorPositive("40%") + " less Hitpoint damage from Attacks to the Head, while you have the [Shieldwall effect|Skill+shieldwall_effect]",
						"You take " + ::MSU.Text.colorPositive("40%") + " less Hitpoint damage from Attacks to the Body, while you don\'t have the [Shieldwall effect|Skill+shieldwall_effect]",
					],
				},
			],
		}),
	},
	{
		Key = "HD_Parry",
		Name = "Parry",
		Description = ::UPD.getDescription({
			Fluff = "With your quick reflexes, you deflect weapon strikes with ease.",
			Requirement = "One-Handed Melee Weapon",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Gain [Melee Defense|Concept.MeleeDefense] equal to your [Base Ranged Defense|Concept.RangeDefense] against weapon attacks",
						"You have " + ::MSU.Text.colorNegative("70%") + " less [Ranged Defense|Concept.RangeDefense] while engaged with someone wielding a melee weapon",
						"Does not work with shields. Does not work while [disarmed,|Skill+disarmed_effect] [stunned|Skill+stunned_effect] or [fleeing|Concept.Morale]",
					],
				},
			],
		}),
	},
	{
		Key = "HD_Scout",
		Name = "Scout",
		Description = ::UPD.getDescription({
			Fluff = "High ground and a clear view are your greatest assets.",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"You have " + ::MSU.Text.colorPositive("+1") + " [Vision|Concept.SightDistance] for every 3 adjacent tiles that are either empty or at least 2 levels below your tile",
						"Changing height levels has no additional [Action Point|Concept.ActionPoints] cost",
					],
				},
			],
		}),
	},
	{
		Key = "HD_Elusive",
		Name = "Elusive",
		Description = ::UPD.getDescription({
			Fluff = "You are impossible to pin down!",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"[Action Point|Concept.ActionPoints] costs for movement on all terrain is reduced by 1 to a minimum of 2 [Action Points|Concept.ActionPoints] per tile. This does not stack with [Pathfinder|Perk+perk_pathfinder]",
						"After moving 2 tiles, become immune to [rooted|Concept.Rooted] effects, until the start of your next [turn|Concept.Turn]",
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
