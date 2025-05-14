::Reforged.NestedTooltips.Tooltips.Concept.Reach = ::MSU.Class.BasicTooltip("Reach", ::Reforged.Mod.Tooltips.parseString("Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\nGain " + ::MSU.Text.colorizeMultWithText(::Reforged.Reach.ReachAdvantageMult) + " [Melee skill|Concept.MeleeSkill] when attacking someone with shorter reach.\n\nCharacters who are [stunned|Skill+stunned_effect], fleeing, or without an [Attack of Opportunity|Concept.ZoneOfControl] have no Reach."));
::Reforged.NestedTooltips.Tooltips.Concept.ReachAdvantage = ::MSU.Class.BasicTooltip("Reach Advantage", ::Reforged.Mod.Tooltips.parseString("A character is considered to have Reach Advantage when their [Reach|Concept.Reach] is greater than that of the other character during a melee attack."));
::Reforged.NestedTooltips.Tooltips.Concept.ReachDisadvantage = ::MSU.Class.BasicTooltip("Reach Disadvantage", ::Reforged.Mod.Tooltips.parseString("A character is considered to have Reach Disadvantage when their [Reach|Concept.Reach] is lower than that of the other character during a melee attack."));

// New Concepts
::MSU.Table.merge(::Reforged.NestedTooltips.Tooltips.Concept, {
	ArmorPenetration = ::MSU.Class.BasicTooltip("Armor Penetration", ::Reforged.Mod.Tooltips.parseString(
		"Armor Penetration is a property that determines how much of an attack\'s damage bypasses armor and directly affects the target's hitpoints.\n\n" +
		"It is expressed as a percentage, ranging from " + ::MSU.Text.colorPositive("0%") + " to a maximum of " + ::MSU.Text.colorPositive("100%") + ".\n\n" +
		"Before the damage reaches the hitpoints, any regular damage reduction from other effects is applied first. Then, the remaining armor on the body part hit reduces the damage further by " + ::MSU.Text.colorizePct(::Const.Combat.ArmorDirectDamageMitigationMult) + " of its current value."
	)),
	CriticalDamage = ::MSU.Class.BasicTooltip("Critical Damage", ::Reforged.Mod.Tooltips.parseString(
		"Critical Damage refers to bonus Hitpoint Damage inflicted when striking specific body parts. This damage is applied after armor mitigation.\n\n" +
		"By default, hits to the head deal " + ::MSU.Text.colorPositive("+50%") + " additional critical damage."
	)),
	DayTime = ::MSU.Class.BasicTooltip("Day Time", ::Reforged.Mod.Tooltips.parseString(
		"Each day in Battle Brothers follows a cycle of distinct phases, impacting visibility, combat effectiveness, and available town services.\n\n" +
		"Daytime begins with 2 hours of Sunrise, followed by 6 hours of Morning, 2 hours of Midday, and 6 hours of Afternoon and ending after 2 hours of Sunset.\n\n" +
		"Nighttime starts with 2 hours of Dusk followed by 2 hours of Midnight and ending after 2 hours of Dawn.\nFighting during Night will apply the [Nighttime effect.|Skill+night_effect]"
	)),
	Displacement = ::MSU.Class.BasicTooltip("Displacement", ::Reforged.Mod.Tooltips.parseString(
		"Displacement is the act of moving a character to a different tile involuntarily against their will.\n\n" +
		"A character that is displaced into a tile with more adjacent enemies than before will receive a Negative [Morale Check.|Concept.Morale]"
	)),
	Hitchance = ::MSU.Class.BasicTooltip("Hitchance", ::Reforged.Mod.Tooltips.parseString(
		"Hitchance is a unified term representing both [Melee Skill|Concept.MeleeSkill] and [Ranged Skill.|Concept.RangeSkill]\n\n" +
		"Any modifier or multiplier to Hitchance apply equally to both Melee Skill and Ranged Skill, and are affected by their respective multipliers."
	)),
	Morale = ::MSU.Class.BasicTooltip("Morale", ::Reforged.Mod.Tooltips.parseString(
		"Morale represents the mental condition of characters and influences their effectiveness in battle. It exists in one of five states: Fleeing, Breaking, Wavering, Steady, or Confident.\n\n" +
		"A positive morale check raises morale on success, a negative check lowers it, and a neutral check does not change morale but may trigger other effects.\n\n" +
		"A Mental Attack is a special type of morale check triggered by supernatural effects such as fear or mind control.\n\n" +
		"Typical positive checks:\n" +
		"- Killing an enemy\n" +
		"- Seeing an enemy killed by an ally\n" +
		"- Beginning a turn while Fleeing triggers a [Rally|Concept.Rally]\n\n" +
		"Typical negative checks:\n" +
		"- Seeing an ally killed\n" +
		"- Seeing an ally flee\n" +
		"- Being hit for at least 15 damage to hitpoints\n" +
		"- Being engaged by multiple opponents\n" +
		"- Being [displaced|Concept.Displacement] into more opponents"
	)),
	Rally = ::MSU.Class.BasicTooltip("Rally", ::Reforged.Mod.Tooltips.parseString(
		"Rallying is a type of positive [Morale Check|Concept.Morale] that can only occur on a character currently in the [Fleeing|Concept.Morale] state.\n\n" +
		"A successful rally immediately raises the character's morale to [Wavering|Concept.Morale], allowing them to act again.\n\n" +
		"Characters will automatically attempt to rally at the start of their turn, as long as they are not engaged in melee combat."
	)),
	Weight = ::MSU.Class.BasicTooltip("Weight", ::Reforged.Mod.Tooltips.parseString(
		"Each equippable item can have a weight value, which determines how much it impacts a character\'s performance.\n\n" +
		"When equipped, an item\'s weight is subtracted from both [Stamina|Concept.MaximumFatigue] and [Initiative.|Concept.Initiative]\n\n" +
		"If an item is equipped in a [Bag slot,|Concept.BagSlots] only half of its weight (rounded up) is subtracted from [Stamina|Concept.MaximumFatigue] and [Initiative|Concept.Initiative].\n\n" +
		"Too much weight may cause [Encumbrance.|Skill+rf_encumbrance_effect]"
	)),
});

::Reforged.Mod.Tooltips.setTooltips(::Reforged.NestedTooltips.Tooltips);
