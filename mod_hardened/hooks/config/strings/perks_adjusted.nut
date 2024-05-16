local adjustedDescriptions = [
	// Vanilla Perks
	{
		ID = "perk.battle_forged",
		Key = "BattleForged",
		Description = ::UPD.getDescription({
			Fluff = "Specialize in heavy armor!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Armor damage taken from Attacks is reduced by a percentage equal to " + ::MSU.Text.colorPositive("5%") + " of the current total armor value of both body and head armor.",
				],
			}],
		}),
	},
	{
		ID = "perk.dodge",
		Key = "Dodge",
		Description = ::UPD.getDescription({
			Fluff = "Too fast for you!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("5%") + " of the character\'s current Initiative as a bonus to Melee and Ranged Defense.",
					"Gain " + ::MSU.Text.colorPositive("2,5%") + " of the character\'s current Initiative as a bonus to Melee and Ranged Defense for each empty adjacent tile.",
					"This bonus can never be negative",
				],
			}],
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
					"An additional " + ::MSU.Text.colorPositive("30%") + " of damage ignores armor while attacking adjacent enemies.",
					"Gain " + ::MSU.Text.colorPositive("+2") + " [Reach|Concept.Reach]",
					"These boni are halfed while engaged with 2 enemies and disabled while engaged with 3 or more enemies.",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_flail_spinner",
		Key = "RF_FlailSpinner",
		Description = ::UPD.getDescription({
			Fluff = "Use the momentum of your flail to enable quick follow-up blows!",
			Requirement = "Flail",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Attacks have a " + ::MSU.Text.colorPositive("100%") + " chance to perform a free extra attack of the same type with " + ::MSU.Text.colorNegative("50%") + " reduced damage to a different valid enemiy within 2 tiles.",
				],
			}],
		}),
	},
	{
		ID = "perk.fortified_mind",
		Key = "FortifiedMind",
		Description = ::UPD.getDescription({
			Fluff = "An iron will is not swayed from the true path easily.",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
					"Resolve is increased by " + ::MSU.Text.colorPositive("30%") + ".",
					"This Bonus is reduced by 1% for each Base Weight on your Helmet.",
				],
 			}],
	 	}),
	},
	{
		ID = "perk.nimble",
		Key = "Nimble",
		Description = ::UPD.getDescription({
	 		Fluff = "Specialize in light armor! By nimbly dodging or deflecting blows, convert any hits to glancing hits.",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
 					"Damage from Attacks to [Hitpoints|Concept.Hitpoints] is reduced by " + ::MSU.Text.colorPositive("60%") + ".",
 					"Damage from Attacks to Armor is increased by the combined weight of your head and body armor.",
				],
 			}],
	 	}),
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
					"Skills build up " + ::MSU.Text.colorPositive("25%") + " less Fatigue.",
					"The [Action Point|Concept.ActionPoints] cost of [Puncture|Skill+puncture] and [Deathblow|Skill+deathblow_skill] is reduced to " + ::MSU.Text.colorPositive("3") + ".",
				],
			}],
		}),
	},
	{
		ID = "perk.mastery.sword",
		Key = "SpecSword",
		Description = ::UPD.getDescription({
			Fluff = "Master the art of swordfighting and using your opponent\'s mistakes to your advantage.",
			Requirement = "Sword",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Skills build up " + ::MSU.Text.colorPositive("25%") + " less Fatigue.",
					"Riposte no longer has a penalty to hitchance.",
					"Gash has a " + ::MSU.Text.colorPositive("50%") + " lower threshold to inflict injuries.",
					"Split and Swing no longer have a penalty to hitchance.",
				],
			}],
		}),
	},
	{	// This perk Description doesn't line up with my shield-group reworks.
		ID = "perk.relentless",
		Key = "Relentless",
		Description = ::UPD.getDescription({
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Initiative is reduced only by " + ::MSU.Text.colorPositive("50%") + " of your Fatigue, instead of all of it.",
						"Using the \'Wait\' command or [Recover|Skill+recover_skill] will no longer give you a penalty to Initiative until your next turn.",
					],
				},
			],
		}),
	},/*
	{	// This perk Description doesn't line up with my shield-group reworks.
		ID = "perk.shield_expert",
		Key = "ShieldExpert",
		Description = ::UPD.getDescription({
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"The shield defense bonus is increased by " + ::MSU.Text.colorPositive("25%") + ". This also applies to the additional defense bonus of the [Shieldwall|Skill+shieldwall] skill.",
						"Shield damage received is reduced by " + ::MSU.Text.colorNegative("50%") + " to a minimum of 1.",
						"The [Knock Back|Skill+knock_back] skill gains " + ::MSU.Text.colorPositive("+15%") + " chance to hit and now applies the [Staggered|Skill+staggered_effect] effect.",
						"Missed attacks against you no longer increase your [Fatigue|Concept.Fatigue]."					]
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Cover Ally|Skill+rf_cover_ally_skill] skill which allows you to target an ally to allow them to move 1 tile ignoring [Zone of Control|Concept.ZoneOfControl] on their [turn|Concept.Turn] while improving their position in the turn order in the next [round|Concept.Round]."					]
				}
			]
		})
	},*/


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
					"Moving next to an enemy that has less maximum Hitpoints than you, removes Confident from them.",
					"Moving next to an enemy grants " + ::MSU.Text.colorPositive("+15") + " [Melee Skill|Concept.MeleeSkill] against them until they damage you.",
				],
			}],
		}),
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
					"While you have that effect: At the start of each round every adjacent ally gains " + ::MSU.Text.colorPositive("+3") + " Action Points if they are adjacent to an enemy, or have an adjacent ally who is adjacent to an enemy.",
					"Only affects allies that have less Resolve than you.",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_poise",
		Key = "RF_Poise",
		Description = ::UPD.getDescription({
			Fluff = "Deftly shift and twist, even within your armor, to minimize the impact of attacks.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Reduce the damage which ignores Armor by " + ::MSU.Text.colorPositive("60%") + ". Lose " + ::MSU.Text.colorNegative("1%") + " reduction for each weight on your helmet and body armor combined.",
					"Armor damage taken from attacks is reduced by a percentage equal to " + ::MSU.Text.colorPositive("40%") + " of your current [Initiative|Concept.Initiative], up to a maximum of " + ::MSU.Text.colorPositive("40%"),
				],
			}],
		}),
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
					"[Melee Skill|Concept.MeleeSkill] is increased by another " + ::MSU.Text.colorizeMult(::Reforged.Reach.ReachAdvantageMult) + " while you have [Reach Advantage|Concept.ReachAdvantage]",
				],
			}],
		}),
	},
];

foreach (description in adjustedDescriptions)
{
	::UPD.setDescription(description.ID, description.Key, ::Reforged.Mod.Tooltips.parseString(description.Description));
}

::Const.Strings.PerkName.RF_Poise = "Flexible";
::Const.Perks.findById("perk.rf_poise").Name = ::Const.Strings.PerkName.RF_Poise;
