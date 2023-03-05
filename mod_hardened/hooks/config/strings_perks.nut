
local adjustedDescriptions = [
	{
		ID = "perk.dodge",
		Key = "Dodge",
		Description = ::UPD.getDescription({
			Fluff = "Too fast for you!",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
					"Gain " + ::MSU.Text.colorGreen("20%") + " of the character\'s current Initiative as a bonus to Melee and Ranged Defense.",
					"The Melee Defense bonus is reduced by " + ::MSU.Text.colorRed("10")
					"These boni can never be negative"
				]
 			}]
	 	}),
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
	}
];

foreach (description in adjustedDescriptions)
{
	::UPD.setDescription(description.ID, description.Key, ::Reforged.Mod.Tooltips.parseString(description.Description));
}
