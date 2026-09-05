// Modified Reforged Concepts
::Reforged.NestedTooltips.Tooltips.Concept.Reach = ::MSU.Class.CustomTooltip(function(_data){
	local ret = [
		{
			id = 1,
			type = "title",
			text = "Reach",
		},
		{
			id = 2,
			type = "description",
			text = ::Reforged.Mod.Tooltips.parseString(
				"Reach is a depiction of how far a character\'s attacks can reach, making melee combat easier against targets with shorter reach.\n\n" +
				"Gain " + ::MSU.Text.colorizeMultWithText(::Reforged.Reach.ReachAdvantageMult) + " [$ $|Concept.MeleeSkill] when attacking someone with shorter reach.\n\n" +
				"Characters who are [fleeing|Skill+hd_dummy_morale_state_fleeing] or without a viable [Attack of Opportunity|Concept.ZoneOfControl] skill have no Reach."
			),
		},
	];
	if ("entityId" in _data && "TooltipEvents" in this.getroottable())
	{
		ret.extend(::TooltipEvents.getBaseAttributesTooltip( _data.entityId, _data.elementId, null));
	}
	return ret;
});
::Reforged.NestedTooltips.Tooltips.Concept.ReachAdvantage = ::MSU.Class.BasicTooltip("Reach Advantage", ::Reforged.Mod.Tooltips.parseString(
	"A character is considered to have Reach Advantage when their [Reach|Concept.Reach] is greater than that of the other character during a melee attack."
));
::Reforged.NestedTooltips.Tooltips.Concept.ReachDisadvantage = ::MSU.Class.BasicTooltip("Reach Disadvantage", ::Reforged.Mod.Tooltips.parseString(
	"A character is considered to have Reach Disadvantage when their [Reach|Concept.Reach] is lower than that of the other character during a melee attack."
));
::Reforged.NestedTooltips.Tooltips.Concept.Wait = ::MSU.Class.BasicTooltip("Wait", ::Reforged.Mod.Tooltips.parseString(
	"If you are not the last character in the [turn order|Concept.Turn] in a [round|Concept.Round], you may use the Wait action, which delays your [turn|Concept.Turn] to the end of the current [round|Concept.Round].\n\n" +
	"You can only use Wait once per [round|Concept.Round].\n\n" +
	"Using Wait applies the [$ $|Skill+hd_wait_effect] effect, causing you to act later in the following [round|Concept.Round]."
));
::Reforged.NestedTooltips.Tooltips.Concept.ZoneOfControl = ::MSU.Class.BasicTooltip("Zone of Control", ::Reforged.Mod.Tooltips.parseString(
	"Zone of Control is exerted onto adjacent tiles by any character with a viable melee attack. Characters that are [Stunned|Concept.Stunned] or [$ $|Skill+hd_dummy_morale_state_fleeing] do not exert Zone of Control.\n\n" +
	"A character is considered Engaged in Melee while standing inside the Zone of Control of an enemy faction. Characters standing in smoke are not considered Engaged in Melee.\n\n" +
	"A character attempting to move while Engaged in Melee will trigger one free Attack of Opportunity from each enemy exerting Zone of Control on them. If any of these attacks hit, the movement is interrupted."
));

// New Concepts
::MSU.Table.merge(::Reforged.NestedTooltips.Tooltips.Concept, {
	ArmorPenetration = ::MSU.Class.BasicTooltip("Armor Penetration", ::Reforged.Mod.Tooltips.parseString(
		"Armor Penetration is a property that determines how much of an attack\'s damage bypasses armor and directly affects the target's [$ $|Concept.Hitpoints].\n\n" +
		"It is expressed as a percentage, ranging from " + ::MSU.Text.colorPositive("0%") + " to a maximum of " + ::MSU.Text.colorPositive("100%") + ".\n\n" +
		"Before the damage reaches the [$ $|Concept.Hitpoints], any regular damage reduction from other effects is applied first. Then, the remaining armor on the body part hit reduces the damage further by " + ::MSU.Text.colorizePct(::Const.Combat.ArmorDirectDamageMitigationMult) + " of its current value."
	)),
	CriticalDamage = ::MSU.Class.BasicTooltip("Critical Damage", ::Reforged.Mod.Tooltips.parseString(
		"Critical Damage refers to bonus [Hitpoint|Concept.Hitpoints] Damage inflicted when striking specific body parts. This damage is applied after armor mitigation.\n\n" +
		"By default, [hits to the head|Concept.ChanceToHitHead] deal " + ::MSU.Text.colorizeMult(::Const.CharacterProperties.DamageAgainstMult[::Const.BodyPart.Head]) + " additional Critical Damage."
	)),
	Cover = ::MSU.Class.BasicTooltip("Cover", ::Reforged.Mod.Tooltips.parseString(
		"Cover refers to obstacles or characters, which characters can hide behind.\n\n" +
		"A character is considered being in Cover when standing directly behind an obstacle or character from an attackers point of view.\n\n" +
		"Your allies will not provide cover for enemies that are 2 tiles away from you.\n\n" +
		"Ranged Attacks against characters that are in cover have a " + ::MSU.Text.colorPositive("75%") + " chance to instead hit one of the covering tiles at random."
	)),
	DayTime = ::MSU.Class.CustomTooltip(function( _data ) {
		local tierConditions = [
			{
				id = 56,
				type = "hint",
				icon = (::World.Ambitions.getCompleted() == 0) ? "ui/icons/icon_locked.png" : "ui/icons/unlocked_small.png",
				text = "Complete any Ambition",
			},
			{
				id = 57,
				type = "hint",
				icon = ::World.Ambitions.getAmbition("ambition.make_nobles_aware").isDone() ? "ui/icons/unlocked_small.png" : "ui/icons/icon_locked.png",
				text = "Make Nobles Aware",
			},
		];

		return [
			{
				id = 1,
				type = "title",
				text = "Day Time",
			},
			{
				id = 2,
				type = 	"description",
				text = ::Reforged.Mod.Tooltips.parseString(
					"Each day in Battle Brothers follows a cycle of distinct phases, impacting visibility, combat effectiveness, and available town services.\n\n" +
					"Daytime begins with 2 hours of Sunrise, followed by 6 hours of Morning, 2 hours of Midday, and 6 hours of Afternoon and ending after 2 hours of Sunset.\n\n" +
					"Nighttime starts with 2 hours of Dusk followed by 2 hours of Midnight and ending after 2 hours of Dawn.\nFighting during Night will apply [$ $|Skill+night_effect] to every character."
				),
			},
			{
				id = 50,
				type = "hint",
				icon = "ui/icons/miniboss.png",
				text = "World Difficulty: " + ::MSU.Text.colorizePct(::Hardened.Global.getWorldDifficultyMult()),
			},
			{
				id = 55,
				type = "hint",
				icon = "ui/icons/miniboss.png",
				text = "Maximum Contract Tier: " + ::MSU.Text.colorPositive(::World.Contracts.HD_getMaxContractTier()),
				children = tierConditions,
			},
		];
	}),
	Displacement = ::MSU.Class.BasicTooltip("Displacement", ::Reforged.Mod.Tooltips.parseString(
		"Displacement is the act of moving a character to a different tile involuntarily against their will.\n\n" +
		"A character that is displaced into a tile with more adjacent enemies than before will receive a Negative [Morale Check|Concept.Morale]."
	)),
	Hitchance = ::MSU.Class.BasicTooltip("Hitchance", ::Reforged.Mod.Tooltips.parseString(
		"Hitchance is a unified term representing both [$ $|Concept.MeleeSkill] and [$ $|Concept.RangeSkill].\n\n" +
		"Any modifier or multiplier to Hitchance applies equally to both Melee Skill and Ranged Skill, and are affected by their respective multipliers.\n\n" +
		"Minimum Hitchance: " + ::MSU.Text.colorNeutral(::Const.Combat.MV_HitChanceMin + "%") + "\n" +
		"Maximum Hitchance: " + ::MSU.Text.colorNeutral(::Const.Combat.MV_HitChanceMax + "%")
	)),
	LevelUp = ::MSU.Class.BasicTooltip("Level Up", ::Reforged.Mod.Tooltips.parseString(
		"A Level Up is gained whenever a character reaches a new level and allows you to improve three of their attributes.\n\n" +
		"During a Level Up, an increase is rolled for each attribute, influenced by its [Talent|Concept.Talent]. You must then choose " + ::MSU.Text.colorPositive(3) + " attributes and increase them by their rolled amounts:\n" +
		"• [$ $|Concept.MeleeSkill] and [$ $|Concept.MeleeDefense] roll between " + ::MSU.Text.colorPositive(1) + " and " + ::MSU.Text.colorPositive(3) + " points\n" +
		"• [$ $|Concept.RangeSkill], [$ $|Concept.RangeDefense], [$ $|Concept.Hitpoints], [Stamina|Concept.MaximumFatigue] and [$ $|Concept.Bravery] roll between " + ::MSU.Text.colorPositive(2) + " and " + ::MSU.Text.colorPositive(4) + " points\n" +
		"• [$ $|Concept.Initiative] rolls between " + ::MSU.Text.colorPositive(3) + " and " + ::MSU.Text.colorPositive(5) + " points\n\n" +
		"Level Ups beyond level " + ::MSU.Text.colorPositive(::Const.XP.MaxLevelWithPerkpoints) + " grant at most " + ::MSU.Text.colorPositive(1) + " point in each chosen attribute and ignore [Talent|Concept.Talent]."
	)),
	Mood = ::MSU.Class.BasicTooltip("Mood", ::Reforged.Mod.Tooltips.parseString(
		"Mood reflects how satisfied member of your company are.\n\n" +
		"It is expressed as a value between " + ::MSU.Text.colorNeutral(0.0) + " and " + ::MSU.Text.colorNeutral(6.95) + " which translates into the following seven mood states: Angry, Disgruntled, Dissatisfied, Content, In good spirit, Eager and Euphoric.\n\n" +
		"Mood states above Neutral grant an increasing chance that the character begins battles with [$ $|Skill+hd_dummy_morale_state_confident] morale.\n" +
		"Mood states below Neutral reduce the maximum possible morale state of the character during battle.\n" +
		"A character who is Angry might desert you and leave your company.\n\n" +
		"The default mood value is " + ::MSU.Text.colorNeutral(3.15) + ". Every hour, each character\'s mood shifts toward this value by at least " + ::MSU.Text.colorPositive(::Const.MoodChange.RecoveryPerHour) + ".\n\n" +
		"Mood is typically gained from:\n" +
		"• Visiting a city (" + ::MSU.Text.colorizeValue(::Const.MoodChange.NearCity, {AddSign = true}) + ")\n" +
		"• Winning a battle (" + ::MSU.Text.colorizeValue(::Const.MoodChange.BattleWon, {AddSign = true}) + ")\n" +
		"• Getting drunk in a tavern (" + ::MSU.Text.colorizeValue(::Const.MoodChange.DrunkAtTavern, {AddSign = true}) + ")\n" +
		"• Fulfulling an Ambition (" + ::MSU.Text.colorizeValue(::Const.MoodChange.AmbitionFulfilled, {AddSign = true}) + ")\n" +
		"• Various Events\n\n" +
		"Mood is typically lost from:\n" +
		"• Sitting out a battle (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.BattleWithoutMe, {AddSign = true}) + ")\n" +
		"• Retreating from a battle (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.BattleRetreat, {AddSign = true}) + ")\n" +
		"• Losing a battle (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.BattleLost, {AddSign = true}) + ")\n" +
		"• Not getting paid (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.NotPaid, {AddSign = true}) + ")\n" +
		"• No food (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.NotEaten, {AddSign = true}) + ")\n" +
		"• Brother died (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.BrotherDied, {AddSign = true}) + ")\n" +
		"• Dismissing Brother (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.BrotherDismissed, {AddSign = true}) + ")\n" +
		"• Dismissing Veteran (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.VeteranDismissed, {AddSign = true}) + ")\n" +
		"• Receiving an Injury (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.Injury, {AddSign = true}) + ")\n" +
		"• Permanent Injury (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.PermanentInjury, {AddSign = true}) + ")\n" +
		"• Failing an Ambition (" + ::MSU.Text.colorizeValue(-::Const.MoodChange.AmbitionFailed, {AddSign = true}) + ")\n" +
		"• Various Events"
	)),
	Morale = ::MSU.Class.BasicTooltip("Morale", ::Reforged.Mod.Tooltips.parseString(
		"Morale represents the mental condition of characters and influences their effectiveness in battle. It exists in one of five states: [$ $|Skill+hd_dummy_morale_state_fleeing], [$ $|Skill+hd_dummy_morale_state_breaking], [$ $|Skill+hd_dummy_morale_state_wavering], Steady or [$ $|Skill+hd_dummy_morale_state_confident].\n\n" +
		"A positive morale check raises morale on success, a negative check lowers it, and a neutral check does not change morale but may trigger other effects.\n\n" +
		"A Mental Attack is a special type of morale check, triggered by supernatural skills such as fear or mind control. It has no implicit effect and instead triggers unique effects.\n\n" +
		"Typical positive checks:\n" +
		"• Killing an enemy\n" +
		"• Seeing an enemy killed by an ally\n" +
		"• Beginning a [turn|Concept.Turn] while [$ $|Skill+hd_dummy_morale_state_fleeing] and not in a [$ $|Concept.ZoneOfControl] triggers a [Rally|Concept.Rally]\n\n" +
		"Typical negative checks:\n" +
		"• Seeing an ally killed\n" +
		"• Seeing an ally flee\n" +
		"• Being hit for at least 15 damage to hitpoints\n" +
		"• Being engaged by multiple opponents\n" +
		"• Being [displaced|Concept.Displacement] into more opponents"
	)),
	Stunned = ::MSU.Class.BasicTooltip("Stunned", ::Reforged.Mod.Tooltips.parseString(
		"A stunned character is incapacitated and unable to act. Their turns are skipped until they are no longer stunned.\n\n" +
		"Stunned characters exert no [Zone of Control|Concept.ZoneOfControl].\n\n" +
		"Effects that cause a character to be stunned include [Stunned|Skill+stunned_effect], [Horrified|Skill+horrified_effect] and [Sleeping|Skill+sleeping_effect]."
	)),
	Talent = ::MSU.Class.BasicTooltip("Talent", ::Reforged.Mod.Tooltips.parseString(
		"Talent represents a character\'s aptitude for developing an attribute. It is represented by up to " + ::MSU.Text.colorPositive(3) + " stars\n\n" +
		"Newly generated characters have " + ::MSU.Text.colorPositive(3) + " talented attributes by default. Their number of Talent Stars is determined randomly:\n" +
		"• 1 Talent Star: " + ::MSU.Text.colorPositive("60%") + "\n" +
		"• 2 Talent Stars: " + ::MSU.Text.colorPositive("30%") + "\n" +
		"• 3 Talent Stars: " + ::MSU.Text.colorPositive("10%") + "\n\n" +
		"Talent Stars improve the attribute's rolls during each [Level Up|Concept.LevelUp]:\n" +
		"• The first star grants " + ::MSU.Text.colorPositive("+1") + " to the minimum attribute roll\n" +
		"• The second star grants " + ::MSU.Text.colorPositive("+1") + " to the maximum attribute roll\n" +
		"• The first star grants " + ::MSU.Text.colorPositive("+1") + " to the minimum attribute roll\n\n"
	)),
	Threat = ::MSU.Class.BasicTooltip("Threat", ::Reforged.Mod.Tooltips.parseString(
		"Threat is a character property that represents how intimidating or dangerous a combatant appears on the battlefield.\n\n" +
		"Each point of Threat increases the difficulty of [Morale Checks|Concept.Morale] made by adjacent enemies by 1. Only characters who are not [fleeing|Skill+hd_dummy_morale_state_fleeing] apply their Threat.\n\n" +
		"By default, Threat is 0, but it can be increased through certain perks, effects, or items."
	)),
	Turn = ::MSU.Class.BasicTooltip("Turn", ::Reforged.Mod.Tooltips.parseString(
		"Combat in Battle Brothers is turn-based. Each [round|Concept.Round], every character receives exactly one turn. The turn order is determined by their [$ $|Concept.Initiative].\n\n" +
		"A character is considered to be taking their turn while they are at the leftmost position of the turn sequence bar and can use active skills.\n\n" +
		"Using [Wait|Concept.Wait] pushes the remainder of the turn to the end of the current [round|Concept.Round]. When it becomes that character\'s turn again, they resume that same turn."
	)),
	Rally = ::MSU.Class.BasicTooltip("Rally", ::Reforged.Mod.Tooltips.parseString(
		"Rallying is a type of positive [Morale Check|Concept.Morale] that can only occur on a character who is currently [fleeing|Skill+hd_dummy_morale_state_fleeing]\n\n" +
		"A successful rally immediately raises the character\'s [Morale|Concept.Morale] to [$ $|Skill+hd_dummy_morale_state_wavering] but removes " + ::MSU.Text.colorNegative(::Math.abs(::Hardened.Global.ActionPointChangeOnRally)) + " [Action Points|Concept.ActionPoints] from them.\n\n" +
		"Characters will automatically attempt to rally at the start of their [turn|Concept.Turn], as long as they are not [Engaged in Melee|Concept.ZoneOfControl]."
	)),
	Recently = ::MSU.Class.BasicTooltip("Recently", ::Reforged.Mod.Tooltips.parseString(
		"Anything that happened either in the last [round|Concept.Round] or in the current [round|Concept.Round] is considered to have happened recently."
	)),
	Unarmed = ::MSU.Class.BasicTooltip("Unarmed", ::Reforged.Mod.Tooltips.parseString(
		"An unarmed character does not have a weapon equipped in their main hand or is currently [disarmed|Skill+disarmed_effect].\n\n" +
		"While [disarmed|Skill+disarmed_effect], an equipped weapon provides no [Reach|Concept.Reach] and none of its skills can be used."
	)),
	Weight = ::MSU.Class.BasicTooltip("Weight", ::Reforged.Mod.Tooltips.parseString(
		"Each equippable item can have a weight value, which determines how much it impacts a character\'s performance.\n\n" +
		"When equipped, an item\'s weight is subtracted from both [Stamina|Concept.MaximumFatigue] and [$ $|Concept.Initiative] after multipliers.\n\n" +
		"If an item is equipped in a [Bag slot|Concept.BagSlots], only half of its weight (rounded up) is subtracted from [Stamina|Concept.MaximumFatigue] and [$ $|Concept.Initiative].\n\n" +
		"Too much weight may cause [Encumbrance|Skill+rf_encumbrance_effect]."
	)),
});

::Reforged.Mod.Tooltips.setTooltips(::Reforged.NestedTooltips.Tooltips);
