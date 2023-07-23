
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
					"While you have that effect: Any ally that starts their turn adjacent to you gains " + ::MSU.Text.colorGreen("+3") + " Action Points if they are adjacent to an enemy, or have an adjacent ally who is adjacent to an enemy.",
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
