
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
			Fluff = "Make them think twice about getting close!",
	 		Requirement = "Two-Handed Melee Weapon",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
					"Your [Reach|Concept.Reach] is increased by " + ::MSU.Text.colorGreen("+2") + " against enemies in your [Zone of Control|Concept.ZoneOfControl], until they hit you.",
					"After being hit the effect expires, but is reset if the [Zone of Control|Concept.ZoneOfControl] is broken."
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
	}
];

foreach (description in adjustedDescriptions)
{
	::UPD.setDescription(description.ID, description.Key, ::Reforged.Mod.Tooltips.parseString(description.Description));
}

::Const.Strings.PerkName.Footwork = "Escape Artist";
::Const.Perks.findById("perk.footwork").Name = ::Const.Strings.PerkName.Footwork;
