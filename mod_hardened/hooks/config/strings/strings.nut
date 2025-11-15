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

::Const.Strings.Tactical.EntityName.Brush = "Bush";	// Vanilla: Brush

::Const.Strings.Distance[0] += " (0 - 5 tiles)";
::Const.Strings.Distance[1] += " (6 - 11 tiles)";
::Const.Strings.Distance[2] += " (12 - 17 tiles)";
::Const.Strings.Distance[3] += " (18 - 23 tiles)";
::Const.Strings.Distance[4] += " (24 - 29 tiles)";
::Const.Strings.Distance[5] += " (30+ tiles)";

local newPerks = [
	{
		Key = "HD_Anchor",
		Name = "Anchor",
		Description = ::UPD.getDescription({
			Fluff = "No wave nor warrior can move you from your place!",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"If you end your turn on the same tile you started it on, become immune to [Displacement|Concept.Displacement] until the start of your next [turn|Concept.Turn]",
						"During your [turn,|Concept.Turn] take " + ::MSU.Text.colorPositive("50%") + " less Damage from Attacks",
					],
				},
			],
		}),
	},
	{
		Key = "HD_Hybridization",
		Name = "Hybridization",
		Description = ::UPD.getDescription({
			Fluff = "\'Hatchet, throwing axe, spear, javelin... they all kill just the same!\'",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Once per [round,|Concept.Round] swapping two weapons with no shared weapon type becomes a free action",
						"Gain " + ::MSU.Text.colorPositive("+10") + " [Melee Defense,|Concept.MeleeDefense] if you have at least " + ::MSU.Text.colorPositive("70") + " [Base|Concept.BaseAttribute] [Ranged Skill|Concept.RangeSkill]",
						"Gain " + ::MSU.Text.colorPositive("+10") + " [Ranged Defense,|Concept.RangeDefense] if you have at least " + ::MSU.Text.colorPositive("70") + " [Base|Concept.BaseAttribute] [Melee Skill|Concept.MeleeSkill]",
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
						"You take " + ::MSU.Text.colorPositive("40%") + " less [Hitpoint|Concept.Hitpoints] damage from Attacks to the Head, while you have the [Shieldwall effect|Skill+shieldwall_effect]",
						"You take " + ::MSU.Text.colorPositive("40%") + " less [Hitpoint|Concept.Hitpoints] damage from Attacks to the Body, while you don\'t have the [Shieldwall effect|Skill+shieldwall_effect]",
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
						"Gain [Melee Defense|Concept.MeleeDefense] equal to your [Base|Concept.BaseAttribute] [Ranged Defense|Concept.RangeDefense] against Weapon Attacks",
						"You have " + ::MSU.Text.colorNegative("70%") + " less [Ranged Defense|Concept.RangeDefense] while engaged with someone wielding a Melee Weapon",
						"Does not work with shields. Does not work while [disarmed,|Skill+disarmed_effect] [stunned|Skill+stunned_effect] or [fleeing|Skill+hd_dummy_morale_state_fleeing]",
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
	{
		Key = "HD_Forestbond",
		Name = "Forestbond",
		Description = ::UPD.getDescription({
			Fluff = "Draw strength from the living forest, letting its lifeblood mend your wounds.",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"At the start of each [turn,|Concept.Turn] recover " + ::MSU.Text.colorPositive("3%") + " [Hitpoints|Concept.Hitpoints] for each adjacent obstacle that is a tree",
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

::Const.Strings.EntityName[::Const.EntityType.UnholdBog] = "Bog Unhold";		// Vanilla: Unhold
::Const.Strings.EntityName[::Const.EntityType.UnholdFrost] = "Frost Unhold";	// Vanilla: Unhold
::Const.Strings.EntityName[::Const.EntityType.BarbarianUnholdFrost] = "Armored Frost Unhold";	// Vanilla: Armored Unhold
