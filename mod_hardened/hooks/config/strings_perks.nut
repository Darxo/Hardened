
local adjustedDescriptions = [
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
	}
];

foreach (description in adjustedDescriptions)
{
	::UPD.setDescription(description.ID, description.Key, ::Reforged.Mod.Tooltips.parseString(description.Description));
}
