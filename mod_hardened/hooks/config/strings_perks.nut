
local adjustedDescriptions = [
	// Vanilla Perks
	{
		ID = "perk.dodge",
		Key = "Dodge",
		Description = ::UPD.getDescription({
			Fluff = "Too fast for you!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorGreen("5%") + " of the character\'s current Initiative as a bonus to Melee and Ranged Defense.",
					"Gain " + ::MSU.Text.colorGreen("2,5%") + " of the character\'s current Initiative as a bonus to Melee and Ranged Defense for each empty adjacent tile.",
					"This bonus can never be negative"
				]
			}]
		})
	},
	{
		ID = "perk.duelist",
		Key = "Duelist",
		Description = ::UPD.getDescription({
			Fluff = "One by one!",
			Requirement = "One-Handed Melee Weapon",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"An additional " + ::MSU.Text.colorGreen("30%") + " of damage ignores armor while attacking adjacent enemies.",
					"Gain " + ::MSU.Text.colorGreen("+2") + " [Reach|Concept.Reach]"
					"These boni are halfed while engaged with 2 enemies and disabled while engaged with 3 or more enemies."
				]
			}]
		})
	},
	{
		ID = "perk.footwork",
		Key = "Footwork",
		Description = ::UPD.getDescription({
			Effects = [
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Footwork|Skill+footwork] skill which allows you to leave a [Zone of Control|Concept.ZoneOfControl] without triggering free attacks.",
					]
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Sprint|Skill+rf_sprint_skill] skill that allows you to travel longer distances during your [turn|Concept.Turn]."
					]
				}
			]
		})
	},
	{
		ID = "perk.mastery.dagger",
		Key = "SpecDagger",
		Description = ::UPD.getDescription({
			Fluff = "Master swift and deadly daggers.",
			Requirement = "Dagger",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Skills build up " + ::MSU.Text.colorGreen("25%") + " less Fatigue.",
					"The [Action Point|Concept.ActionPoints] cost of [Puncture|Skill+puncture] and [Deathblow|Skill+deathblow_skill] is reduced to " + ::MSU.Text.colorGreen("3") + ".",
				]
			}]
		})
	},
	{
		ID = "perk.pathfinder",
		Key = "Pathfinder",
		Description = ::UPD.getDescription({
			Fluff = "Learn to move on difficult terrain.",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"[Action Point|Concept.ActionPoints] costs for movement on all terrain is reduced by " + ::MSU.Text.colorRed("-1") + " to a minimum of 2 [Action Points|Concept.ActionPoints] per tile, and [Fatigue|Concept.Fatigue] cost is reduced to half.",
						"Changing height levels also has no additional [Action Point|Concept.ActionPoints] cost anymore."
					]
				}
			]
		})
	},
	{	// This perk Description doesn't line up with my shield-group reworks.
		ID = "perk.relentless",
		Key = "Relentless",
		Description = ::UPD.getDescription({
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Initiative is reduced only by " + ::MSU.Text.colorRed("50%") + " of your Fatigue, instead of all of it.",
						"Using the \'Wait\' command or [Recover|Skill+recover_skill] will no longer give you a penalty to Initiative until your next turn."
					]
				}
			]
		})
	},
	{	// This perk Description doesn't line up with my shield-group reworks.
		ID = "perk.shield_expert",
		Key = "ShieldExpert",
		Description = ::UPD.getDescription({
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"The shield defense bonus is increased by " + ::MSU.Text.colorGreen("25%") + ". This also applies to the additional defense bonus of the [Shieldwall|Skill+shieldwall] skill.",
						"Shield damage received is reduced by " + ::MSU.Text.colorRed("50%") + " to a minimum of 1.",
						"The [Knock Back|Skill+knock_back] skill gains " + ::MSU.Text.colorGreen("+15%") + " chance to hit and now applies the [Staggered|Skill+staggered_effect] effect.",
						"Missed attacks against you no longer increase your [Fatigue|Concept.Fatigue]."					]
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Cover Ally|Skill+rf_cover_ally_skill] skill which allows you to target an ally to allow them to move 1 tile ignoring [Zone of Control|Concept.ZoneOfControl] on their [turn|Concept.Turn] while improving their position in the turn order in the next [round|Concept.Round]."					]
				}
			]
		})
	},

	// Reforged Perks
	{
		ID = "perk.rf_formidable_approach",
		Key = "RF_FormidableApproach",
		Description = ::UPD.getDescription({
			// Fluff = "Make them think twice about getting close!",
			Requirement = "Two-Handed Melee Weapon",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Moving next to an enemy that has no adjacent enemies now triggers a morale check.",
					"Moving next to an enemy that has no adjacent enemies grants " + ::MSU.Text.colorGreen("+15") + " [Melee Skill|Concept.MeleeSkill] against them until they land a hit against you."
				]
			}]
		})
	},
	{
		ID = "perk.inspiring_presence",
		Key = "InspiringPresence",
		Description = ::UPD.getDescription({
			Fluff = "Standing next to a company\'s leader figure inspires your men to go beyond their limits!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"At the start of each battle, if you have the highest Resolve out of all Brothers with this perk, gain the [Inspiring Presence|Skill+perk_inspiring_presence] effect until the end of this battle.",
					"While you have that effect: At the start of each round every adjacent ally gains " + ::MSU.Text.colorGreen("+3") + " Action Points if they are adjacent to an enemy, or have an adjacent ally who is adjacent to an enemy.",
					"Only affects allies that have less Resolve than you."
				]
			}]
		})
	},
	{
		ID = "perk.rf_spear_advantage",
		Key = "RF_SpearAdvantage",
		Description = ::UPD.getDescription({
			Fluff = "Stick \'em with the pointy end.",
			Requirement = "Spear",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"[Melee Skill|Concept.MeleeSkill] is increased by another " + ::MSU.Text.colorGreen((::Reforged.Reach.ReachAdvantageMult * 100 - 100) + "%") + " while you have [Reach Advantage|Concept.ReachAdvantage]"
				]
			}]
		})
	}
];

foreach (description in adjustedDescriptions)
{
	::UPD.setDescription(description.ID, description.Key, ::Reforged.Mod.Tooltips.parseString(description.Description));
}

::Const.Strings.PerkName.Footwork = "Escape Artist";
::Const.Perks.findById("perk.footwork").Name = ::Const.Strings.PerkName.Footwork;
