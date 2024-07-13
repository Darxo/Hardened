// This is loaded AFTER perk_defs.nut is loaded

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
					"Gain " + ::MSU.Text.colorPositive("4%") + " of the character\'s current Initiative as a bonus to [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense] for each empty adjacent tile. This bonus can never be negative",
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
		ID = "perk.rf_fencer",
		Key = "RF_Fencer",
		Description = ::UPD.getDescription({
			Fluff = "Master the art of fighting with a nimble sword.",
			Requirement = "Fencing Sword",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your weapon loses " + ::MSU.Text.colorPositive("50%") + " less durability.",
					"When using a one-handed fencing sword, the [Action Point|Concept.ActionPoints] costs of [Sword Thrust|Skill+rf_sword_thrust_skill], [Riposte|Skill+riposte] and [Lunge|Skill+lunge_skill] are reduced by " + ::MSU.Text.colorGreen(1) + ".",
					"When using a two-handed fencing sword, the range of [Lunge|Skill+lunge_skill] is increased by " + ::MSU.Text.colorGreen(1) + " tile.",
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
					"Attacks have a " + ::MSU.Text.colorPositive("100%") + " chance to perform a free extra attack of the same type to a different valid enemiy within 2 tiles. This attack deals " + ::MSU.Text.colorNegative("50%") + " less damage.",
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
 					"Take " + ::MSU.Text.colorPositive("60%") + " less [Hitpoint|Concept.Hitpoints] damage from Attacks.",
 					"Take more armor damage equal to the combined weight of your head and body armor as a percentage.",
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
					"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].",
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
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue].",
						"Riposte no longer has a penalty to hitchance.",
						"Gash has a " + ::MSU.Text.colorPositive("50%") + " lower threshold to inflict injuries.",
						"Split and Swing no longer have a penalty to hitchance.",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Kata Step|Skill+rf_kata_step_skill] skill which, immediately after a successful attack, allows you to move one tile ignoring [Zone of Control|Concept.ZoneOfControl] with reduced [Action Point|Concept.ActionPoints] cost and [Fatigue|Concept.Fatigue] cost of movement.",
						"The target tile for the movement must be adjacent to an enemy.",
						"Only works with Two-Handed swords or with One-Handed swords with the offhand free.",
					],
				},
			],
		}),
	},
	{
		ID = "perk.relentless",
		Key = "Relentless",
		Description = ::UPD.getDescription({
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Receive " + ::MSU.Text.colorPositive("50%") + " less Initiative penalty from your [Fatigue|Concept.Fatigue].",
						"Using the \'Wait\' command or [Recover|Skill+recover_skill] will no longer give you a penalty to [Initiative|Concept.Initiative] until your next turn.",
					],
				},
			],
		}),
	},
	{
		ID = "perk.shield_expert",
		Key = "ShieldExpert",
		Description = ::UPD.getDescription({
	 		Fluff = "Learn to better deflect hits to the side instead of blocking them head on.",
	 		Effects = [
		 		{
	 				Type = ::UPD.EffectType.Passive,
	 				Description = [
						"Enemies will never have [Reach Advantage|Concept.ReachAdvantage] against you",
						"Your shield takes " + ::MSU.Text.colorGreen("50%") + " less damage up to a minimum of 1",
	 					"Missed attacks against you no longer build up [Fatigue|Concept.Fatigue].",
	 				],
	 			},
	 			{
	 				Type = ::UPD.EffectType.Active,
	 				Description = [
	 					"Unlocks the [Cover Ally|Skill+rf_cover_ally_skill] skill which allows you to target an ally to allow them to move 1 tile ignoring [Zone of Control|Concept.ZoneOfControl] on their [turn|Concept.Turn] while improving their position in the turn order in the next [round|Concept.Round].",
	 				],
	 			},
 			],
	 	}),
	},
	{
		ID = "perk.student",	// This does not need to be the updated id
		Key = "Student",
		Description = ::UPD.getDescription({
			Fluff = "Everything can be learned if you put your mind to it.",
	 		Effects = [{
 				Type = ::UPD.EffectType.OneTimeEffect,
 				Description = [
					"Gain " + ::MSU.Text.colorGreen(1) + " perk point when you reach [level|Concept.Level] 8.",
				],
 			}],
			Footer = ::MSU.Text.colorRed("This perk cannot be refunded."),
	 	}),
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
					"Moving next to an enemy that has less maximum Hitpoints than you, removes Confident from them.",
					"Moving next to an enemy grants " + ::MSU.Text.colorPositive("+15") + " [Melee Skill|Concept.MeleeSkill] against them until they damage you.",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_en_garde",
		Key = "RF_EnGarde",
		Description = ::UPD.getDescription({
			Fluff = "You\'ve become so well-practiced with a blade that attacking and defending are done congruously!",
			Requirement = "Sword",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("+15") + " [Melee Skill|Concept.MeleeSkill] while it is not your [turn|Concept.Turn].",
					"[Riposte|Skill+riposte_effect] is no longer removed when you get hit or do a counter attack.",
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
					"Take up to " + ::MSU.Text.colorPositive("60%") + " less armor penetration damage from attacks. Lose " + ::MSU.Text.colorNegative("1%") + " reduction for each weight on your helmet and body armor combined.",
					"Take up to " + ::MSU.Text.colorPositive("40%") + " less armor damage from attack. This reduction is a percentage equal to " + ::MSU.Text.colorPositive("40%") + " of your current [Initiative|Concept.Initiative].",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_skirmisher",
		Key = "RF_Skirmisher",
		Description = ::UPD.getDescription({
			Fluff = "Gain increased speed and endurance by balancing your armor and mobility.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain [Initiative|Concept.Initiative] equal to " + ::MSU.Text.colorPositive("50%") + " of the weight of your body armor.",
					"You lose " + ::MSU.Text.colorPositive("50%") + " less [Initiative|Concept.Initiative] from your current [Fatigue|Concept.Fatigue].",
				],
			}],
		}),
	},
	/*	This perk was removed from Reforged
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
	},*/
	{
		ID = "perk.rf_sweeping_strikes",
		Key = "RF_SweepingStrikes",
		Description = ::UPD.getDescription({
			Fluff = "Keep your enemies at bay with the sweeping swings of your weapon!",
			Requirement = "Two-Handed Melee Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Whenever you use an attack on an enemy, gain " + ::MSU.Text.colorGreen("+3") + " [Melee Defense|Concept.MeleeDefense] for every adjacent enemy until the start of your next [turn|Concept.Turn].",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_through_the_gaps",
		Key = "RF_ThroughTheGaps",
		Description = ::UPD.getDescription({
			Fluff = "Learn to call your strikes and target gaps in your opponents\' armor!",
			Requirement = "Spear and Piercing Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your attacks against targets with armor will always target the body part with the lowest armor.",
					"Armor penetration is reduced by " + ::MSU.Text.colorNegative("10%") + ".",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_unstoppable",
		Key = "RF_Unstoppable",
		Description = ::UPD.getDescription({
			Fluff = "Once you get going, you cannot be stopped!",
			Requirement = "Melee Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Whenever you end your [turn|Concept.Turn] with half or fewer of your [Action Points|Concept.ActionPoints] remaining, gain a stack, up to a maximum of 5 stacks.",
					"Each stack increases [Action Points|Concept.ActionPoints] by " + ::MSU.Text.colorGreen("+1") + " and [Initiative|Concept.Initiative] by " + ::MSU.Text.colorGreen("+10") + ".",
					"All the stacks are lost if you [wait|Concept.Wait] or end your [turn|Concept.Turn] with more than half of your [Action Points|Concept.ActionPoints] remaining.",
					"All the stacks are lost if you use [Recover|Skill+recover_skill], or get [Stunned|Skill+stunned_effect], Rooted or [Staggered|Skill+staggered_effect].",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_wears_it_well",
		Key = "RF_WearsItWell",
		Description = ::UPD.getDescription({
			Fluff = "Years of carrying heavy loads has given you the capability to carry the burden of your mercenary gear with ease!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain [Stamina|Concept.MaximumFatigue] and [Initiative|Concept.Initiative] equal to " + ::MSU.Text.colorPositive("50%") + " of your combined mainhand and offhand weight.",
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
