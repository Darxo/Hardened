::Reforged.NestedTooltips.Tooltips.Concept.Reach = ::MSU.Class.BasicTooltip("Reach", ::Reforged.Mod.Tooltips.parseString("Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\nGain " + ::MSU.Text.colorizeMultWithText(::Reforged.Reach.ReachAdvantageMult) + " [Melee skill|Concept.MeleeSkill] when attacking someone with shorter reach.\n\nCharacters who are [stunned|Skill+stunned_effect], fleeing, or without a melee attack have no Reach."));
::Reforged.NestedTooltips.Tooltips.Concept.ReachAdvantage = ::MSU.Class.BasicTooltip("Reach Advantage", ::Reforged.Mod.Tooltips.parseString("A character is considered to have Reach Advantage when their [Reach|Concept.Reach] is greater than that of the other character during a melee attack."));
::Reforged.NestedTooltips.Tooltips.Concept.ReachDisadvantage = ::MSU.Class.BasicTooltip("Reach Disadvantage", ::Reforged.Mod.Tooltips.parseString("A character is considered to have Reach Disadvantage when their [Reach|Concept.Reach] is lower than that of the other character during a melee attack."));

// New Concepts
::MSU.Table.merge(::Reforged.NestedTooltips.Tooltips.Concept, {
	ArmorPenetration = ::MSU.Class.BasicTooltip("Armor Penetration", ::Reforged.Mod.Tooltips.parseString("Armor Penetration is a property that determines how much of an attack\'s damage bypasses armor and directly affects the target's hitpoints.\n\nIt is expressed as a percentage, ranging from " + ::MSU.Text.colorPositive("0%") + " to a maximum of " + ::MSU.Text.colorPositive("100%") + ".\n\nBefore the damage reaches the hitpoints, any regular damage reduction from other effects is applied first. Then, the remaining armor on the body part hit reduces the damage further by " + ::MSU.Text.colorizePct(::Const.Combat.ArmorDirectDamageMitigationMult) + " of its current value.")),
	DayTime = ::MSU.Class.BasicTooltip("Day Time", ::Reforged.Mod.Tooltips.parseString("Each day in Battle Brothers follows a cycle of distinct phases, impacting visibility, combat effectiveness, and available town services.\n\nDaytime begins with 2 hours of Sunrise, followed by 6 hours of Morning, 2 hours of Midday, and 6 hours of Afternoon and ending after 2 hours of Sunset.\n\nNighttime starts with 2 hours of Dusk followed by 2 hours of Midnight and ending after 2 hours of Dawn.\nFighting during Night will apply the [Nighttime effect|Skill+night_effect].")),
	Weight = ::MSU.Class.BasicTooltip("Weight", ::Reforged.Mod.Tooltips.parseString("Each equippable item can have a weight value, which determines how much it impacts a character\'s performance.\n\nWhen equipped, an item\'s weight is subtracted from both [Stamina|Concept.MaximumFatigue] and [Initiative.|Concept.Initiative]\n\nIf an item is equipped in a [Bag slot,|Concept.BagSlots] only half of its weight (rounded up) is subtracted from [Stamina|Concept.MaximumFatigue] and [Initiative|Concept.Initiative].\n\nToo much weight may cause [Encumbrance|Skill+rf_encumbrance_effect].")),
});

::Reforged.Mod.Tooltips.setTooltips(::Reforged.NestedTooltips.Tooltips);
