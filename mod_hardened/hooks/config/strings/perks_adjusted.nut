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
					"Armor damage taken from Attacks is reduced by a percentage equal to " + ::MSU.Text.colorPositive("5%") + " of the current total armor value of both body and head armor",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_dismantle",
		Key = "RF_Dismantle",
		Description = ::UPD.getDescription({
			Fluff = "Strip them of their protection first!",
			Requirement = "Axe",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Deal " + ::MSU.Text.colorPositive("+40%") + " Armor Damage and " + ::MSU.Text.colorPositive("100%") + " more Shield Damage against enemies who have full health",
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
					"An additional " + ::MSU.Text.colorPositive("30%") + " of damage ignores armor while attacking adjacent enemies",
					"Gain " + ::MSU.Text.colorPositive("+2") + " [Reach|Concept.Reach]",
					"These bonuses are halved while engaged with 2 enemies and disabled while engaged with 3 or more enemies",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_fencer",
		Key = "RF_Fencer",
		Description = ::UPD.getDescription({
			Fluff = "Master the art of fighting with a nimble sword",
			Requirement = "Fencing Sword",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your weapon loses " + ::MSU.Text.colorPositive("50%") + " less condition",
					"When using a one-handed fencing sword, the [Action Point|Concept.ActionPoints] costs of [Sword Thrust|Skill+rf_sword_thrust_skill], [Riposte|Skill+riposte] and [Lunge|Skill+lunge_skill] are reduced by " + ::MSU.Text.colorPositive(1),
					"When using a two-handed fencing sword, the range of [Lunge|Skill+lunge_skill] is increased by " + ::MSU.Text.colorPositive(1) + " tile",
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
					"Attacks have a " + ::MSU.Text.colorPositive("100%") + " chance to perform a free extra attack of the same type to a different valid enemiy within 2 tiles. This attack deals " + ::MSU.Text.colorNegative("50%") + " less damage",
				],
			}],
		}),
	},
	{
		ID = "perk.fortified_mind",
		Key = "FortifiedMind",
		Description = ::UPD.getDescription({
			Fluff = "An iron will is not swayed from the true path easily",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Resolve is increased by " + ::MSU.Text.colorPositive("30%") + "",
					"This Bonus is reduced by 1% for each Base Weight on your Helmet",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_hybridization",
		Key = "RF_Hybridization",
		Description = ::UPD.getDescription({
			Fluff = "\'Hatchet, throwing axe, spear, javelin... they all kill just the same!\'",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Gain " + ::MSU.Text.colorPositive("10%") + " of your Base [Ranged Skill|Concept.RangeSkill] as additional [Melee Skill|Concept.MeleeSkill] and [Melee Defense.|Concept.MeleeDefense]",
						"Piercing type throwing attacks apply [Arrow to the Knee|Skill+rf_arrow_to_the_knee_debuff_effect] when hitting the body",
						"Cutting type throwing attacks apply [Overwhelmed|Skill+overwhelmed_effect] on a hit",
						"Headshots with blunt type throwing attacks apply [Staggered|Skill+staggered_effect]. All hits with blunt type throwing attacks will [stun|Skill+stunned_effect] the target if already [staggered|Skill+staggered_effect]",
						"[Throwing Spear|Item+throwing_spear] deal " + ::MSU.Text.colorizeMultWithText(1.5) + " damage to shields",
					],
				},
			],
		}),
	},
	{
		ID = "perk.nimble",
		Key = "Nimble",
		Description = ::UPD.getDescription({
			Fluff = "Specialize in light armor! By nimbly dodging or deflecting blows, convert any hits to glancing hits",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Take " + ::MSU.Text.colorPositive("60%") + " less [Hitpoint|Concept.Hitpoints] damage from Attacks",
					"Take more armor damage equal to the combined weight of your head and body armor as a percentage",
				],
			}],
		}),
	},
	{
		ID = "perk.mastery.axe",
		Key = "SpecAxe",
		Description = ::UPD.getDescription({
			Fluff = "Master combat with axes and destroying shields",
			Requirement = "Axe",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue.|Concept.Fatigue]",
						"[Round Swing|Skill+round_swing] gains " + ::MSU.Text.colorPositive("+5%") + " chance to hit",
						"[Split Shield|Skill+split_shield] applies [Dazed|Skill+dazed_effect] for " + ::MSU.Text.colorPositive(1) + " turn",
						"The [Longaxe|Item+longaxe] no longer has a penalty for attacking targets directly adjacent",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Bearded Blade|Skill+rf_bearded_blade_skill] skill which allows you to disarm your opponents during an attack or when they miss attacks against you",
					],
				},
			],
		}),
	},
	{
		ID = "perk.mastery.dagger",
		Key = "SpecDagger",
		Description = ::UPD.getDescription({
			Fluff = "Master swift and versatile daggers",
			Requirement = "Dagger",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
					"The [Action Point|Concept.ActionPoints] cost of [Puncture|Skill+puncture] and [Deathblow|Skill+deathblow_skill] is reduced to " + ::MSU.Text.colorPositive("3"),
					"Swapping items becomes a free action once per [turn.|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.mastery.polearm",
		Key = "SpecPolearm",
		Description = ::UPD.getDescription({
			Fluff = "Master polearms and keeping the enemy at bay",
			Requirement = "Polearm",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
					"[Hook|Skill+hook] and [Repel|Skill+repel] have " + ::MSU.Text.colorPositive("+15%") + " chance to hit",
					"Polearms no longer have a penalty for attacking targets directly adjacent",
					"Gain the [Bolster|Perk+perk_rf_bolster] perk",
				],
			}],
		}),
	},
	{
		ID = "perk.mastery.spear",
		Key = "SpecSpear",
		Description = ::UPD.getDescription({
			Fluff = "Master fighting with spears and keeping the enemy at bay",
			Requirement = "Spear",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue.|Concept.Fatigue]",
						"[Spearwall|Skill+spearwall] can be used while engaged in melee and is no longer disabled when enemies overcome it",
						"The [Spetum|Item+spetum] and [Warfork|Item+warfork] no longer have a penalty for attacking targets directly adjacent",
						"[Reach Advantage|Concept.ReachAdvantage] grants an additional " + ::MSU.Text.colorizeMultWithText(::Reforged.Reach.ReachAdvantageMult) + " [Melee Skill|Concept.MeleeSkill]",
					],
				},
			],
		}),
	},
	{
		ID = "perk.mastery.sword",
		Key = "SpecSword",
		Description = ::UPD.getDescription({
			Fluff = "Master the art of swordfighting and using your opponent\'s mistakes to your advantage",
			Requirement = "Sword",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
						"[Riposte|Skill+riposte] no longer has a penalty to hitchance",
						"[Gash|Skill+gash_skill] has a " + ::MSU.Text.colorPositive("50%") + " lower threshold to inflict injuries",
						"[Split|Skill+split] and [Swing|Skill+swing] no longer have a penalty to hitchance",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Kata Step|Skill+rf_kata_step_skill] skill which allows you to dance around your opponent after a successful attack",
					],
				},
			],
		}),
	},
	{
		ID = "perk.mastery.throwing",
		Key = "SpecThrowing",
		Description = ::UPD.getDescription({
			Fluff = "Master throwing weapons to wound or kill the enemy before they even get close",
			Requirement = "Throwing Weapon",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Skills build up " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
					"Your first throwing attack each turn deals " + ::MSU.Text.colorizeMultWithText(1.3) + " damage",
					"Swapping a throwing weapon with an empty throwing weapon or an empty slot becomes a free action once per turn",
				],
			}],
		}),
	},
	{
		ID = "perk.quick_hands",
		Key = "QuickHands",
		Description = ::UPD.getDescription({
			Fluff = "Fastest hands in the West.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Swapping items, except shields, becomes a free action once per [turn|Concept.Turn]",
				]
			}]
		})
	},
	{
		ID = "perk.relentless",
		Key = "Relentless",
		Description = ::UPD.getDescription({
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Receive " + ::MSU.Text.colorPositive("50%") + " less [Initiative|Concept.Initiative] penalty from your [Fatigue|Concept.Fatigue]",
						"Using [Wait|Concept.Wait] or [Recover|Skill+recover_skill] will no apply the [Waiting|Skill+hd_wait_effect] debuff",
					],
				},
			],
		}),
	},
	{
		ID = "perk.shield_expert",
		Key = "ShieldExpert",
		Description = ::UPD.getDescription({
			Fluff = "Learn to better deflect hits to the side instead of blocking them head on",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Enemies will never have [Reach Advantage|Concept.ReachAdvantage] against you",
						"Your shield takes " + ::MSU.Text.colorPositive("50%") + " less damage up to a minimum of 1",
						"Missed attacks against you no longer build up [Fatigue|Concept.Fatigue]",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Cover Ally|Skill+rf_cover_ally_skill] skill which allows you to target an ally to allow them to move 1 tile ignoring [Zone of Control|Concept.ZoneOfControl] on their [turn|Concept.Turn] while improving their position in the turn order in the next [round|Concept.Round]",
					],
				},
			],
		}),
	},
	{
		ID = "perk.student",	// This does not need to be the updated id
		Key = "Student",
		Description = ::UPD.getDescription({
			Fluff = "Everything can be learned if you put your mind to it",
			Effects = [{
				Type = ::UPD.EffectType.OneTimeEffect,
				Description = [
					"Gain " + ::MSU.Text.colorPositive(1) + " perk point when you reach [level|Concept.Level] 8",
				],
			}],
			Footer = ::MSU.Text.colorNegative("This perk cannot be refunded."),
		}),
	},


	// Reforged Perks
	{
		ID = "perk.rf_between_the_ribs",
		Key = "RF_BetweenTheRibs",
		Description = ::UPD.getDescription({
			Fluff = "Striking when an enemy is distracted allows this character to aim for the vulnerable bits!",
			Requirement = "Dagger",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Deal " + ::MSU.Text.colorPositive("10%") + " more damage and gain " + ::MSU.Text.colorPositive("+10%") + " armor penetration per character [surrounding|Concept.Surrounding] the target",
					"Lose " + ::MSU.Text.colorNegative("10%") + " [chance to hit the head|Concept.ChanceToHitHead] per character [surrounding|Concept.Surrounding] the target",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_exploit_opening",
		Key = "RF_ExploitOpening",
		Description = ::UPD.getDescription({
			Fluff = "A low shield. A slobby stab. A fake stumble. All are ways that you\'ve learned to tempt your opponent into a fatal false move!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain a stacking " + ::MSU.Text.colorPositive("+10%") + " chance to hit whenever an opponent misses an attack against you",
					"Bonus is reset upon landing a hit",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_formidable_approach",
		Key = "RF_FormidableApproach",
		Description = ::UPD.getDescription({
			// Fluff = "Make them think twice about getting close!",
			Requirement = "Two-Handed Melee Weapon",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Moving next to an enemy that has less maximum Hitpoints than you, removes Confident from them",
					"Moving next to an enemy grants " + ::MSU.Text.colorPositive("+15") + " [Melee Skill|Concept.MeleeSkill] against them until they damage you",
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
					"Gain " + ::MSU.Text.colorPositive("+15") + " [Melee Skill|Concept.MeleeSkill] while it is not your [turn|Concept.Turn]",
					"[Riposte|Skill+riposte_effect] is no longer removed when you get hit or do a counter attack",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_phalanx",
		Key = "RF_Phalanx",
		Description = ::UPD.getDescription({
			Fluff = "Learn the ancient art of fighting in a shielded formation",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("+1") + " [Reach|Concept.Reach] per adjacent ally also equipped with a shield",
					"[Shieldwall|Skill+shieldwall_effect] does not expire at the start of your [turn|Concept.Turn] if an adjacent ally is also using [Shieldwall.|Skill+shieldwall_effect]",
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
					"At the start of each battle, if you have the highest Resolve out of all Brothers with this perk, gain the [Inspiring Presence|Skill+perk_inspiring_presence] effect until the end of this battle",
					"While you have that effect: At the start of each round every adjacent ally gains " + ::MSU.Text.colorPositive("+3") + " Action Points if they are adjacent to an enemy, or have an adjacent ally who is adjacent to an enemy",
					"Only affects allies that have less Resolve than you",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_offhand_training",
		Key = "RF_OffhandTraining",
		Description = ::UPD.getDescription({
			Fluff = "Frequent use of tools with your offhand has given you an enviable level of ambidexterity!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Once per [turn,|Concept.Turn] the first use of your offhand item weighing less than " + ::MSU.Text.colorNegative(10) + " costs no [Action Points|Concept.ActionPoints]",
					"When wielding any [net|Item+throwing_net], the first successful melee attack every [turn|Concept.Turn] against an adjacent target will [stagger|Skill+staggered_effect] them",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_opportunist",
		Key = "RF_Opportunist",
		Description = ::UPD.getDescription({
			Fluff = "\'I\'m not lootin\' Captain! Just grabbing my javelin!\'",
			Requirement = "Throwing Weapon",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"The first 2 throwing attacks during a combat have their [Action Point|Concept.ActionPoints] costs " + ::MSU.Text.colorPositive("halved"),
					"Every time you stand over an enemy\'s corpse during your [turn,|Concept.Turn] gain " + ::MSU.Text.colorPositive(1) + " ammo and restore " + ::MSU.Text.colorPositive(4) + " [Action Points.|Concept.ActionPoints] Afterward, the next throwing attack has its [Fatigue|Concept.Fatigue] cost " + ::MSU.Text.colorPositive("halved"),
					"A corpse can only be used once per combat and cannot be used by multiple characters with this perk",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_poise",
		Key = "RF_Poise",		// Current name is 'Flexible'
		Description = ::UPD.getDescription({
			Fluff = "Deftly shift and twist, even within your armor, to minimize the impact of attacks",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Take up to " + ::MSU.Text.colorPositive("60%") + " less armor penetration damage from attacks. Lose " + ::MSU.Text.colorNegative("1%") + " reduction for each weight on your helmet and body armor combined",
					"Take up to " + ::MSU.Text.colorPositive("40%") + " less armor damage from attack. This reduction is a percentage equal to " + ::MSU.Text.colorPositive("40%") + " of your current [Initiative|Concept.Initiative]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_shield_sergeant",
		Key = "RF_ShieldSergeant",
		Description = ::UPD.getDescription({
			Fluff = "Lock and Shield",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Allies with a shield will gain [Shieldwall|Skill+shieldwall_effect] for free at the start of each battle",
					"Whenever you use a non-free shield skill, all allies within " + ::MSU.Text.colorPositive(3) + " tiles who also have that skill will use it for free on a random valid tile",
					"[Knock Back|Skill+knock_back] can be used on empty tiles",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_skirmisher",
		Key = "RF_Skirmisher",
		Description = ::UPD.getDescription({
			Fluff = "Gain increased speed and endurance by balancing your armor and mobility",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Receive " + ::MSU.Text.colorPositive("50%") + " less [Initiative|Concept.Initiative] penalty from your [Fatigue|Concept.Fatigue]",
					"Gain [Initiative|Concept.Initiative] equal to " + ::MSU.Text.colorPositive("50%") + " of the weight of your body armor",
				],
			}],
		}),
	},
	/*	This perk was removed from Reforged
	{
		ID = "perk.rf_spear_advantage",
		Key = "RF_SpearAdvantage",
		Description = ::UPD.getDescription({
			Fluff = "Stick \'em with the pointy end",
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
					"Whenever you use an attack on an enemy, gain " + ::MSU.Text.colorPositive("+3") + " [Melee Defense|Concept.MeleeDefense] for every adjacent enemy until the start of your next [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_swift_stabs",
		Key = "RF_SwiftStabs",
		Description = ::UPD.getDescription({
			Fluff = "Strike swiftly and vanish before your enemies can react, mastering the art of elusive combat!",
			Requirement = "Dagger",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Dagger attacks can now target enemies up to 2 tiles away. Attacking from 2 tiles away moves you 1 tile closer before the attack",
					"If the attack hits, you automatically return to your original tile",
					"Does not affect dagger attacks with a range of 2 tiles or more",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_through_the_gaps",
		Key = "RF_ThroughTheGaps",
		Description = ::UPD.getDescription({
			Fluff = "Learn to call your strikes and target gaps in your opponents\' armor!",
			Requirement = "Piercing Attack with Spear",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your attacks against targets with armor will always target the body part with the lowest armor",
					"Armor penetration is reduced by " + ::MSU.Text.colorNegative("10%"),
				],
			}],
		}),
	},
	{
		ID = "perk.rf_king_of_all_weapons",
		Key = "RF_KingOfAllWeapons",		// Current name is 'Spear Flurry'
		Description = ::UPD.getDescription({
			Fluff = "Wield the spear with unmatched endurance!",
			Requirement = "Spear",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your spear attacks no longer build up fatigue",
					"Deal " + ::MSU.Text.colorNegative("10%") + " less damage",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_unstoppable",
		Key = "RF_Unstoppable",
		Description = ::UPD.getDescription({
			Fluff = "Once you get going, you cannot be stopped!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"If you have attacked at least once this [turn|Concept.Turn] and end your [turn|Concept.Turn] with half or fewer of your [Action Points|Concept.ActionPoints] remaining, gain a stack, up to a maximum of 5 stacks",
					"Each stack grants " + ::MSU.Text.colorPositive("+1") + " [Action Point(s)|Concept.ActionPoints] and " + ::MSU.Text.colorPositive("+10") + " [Initiative.|Concept.Initiative]",
					"All the stacks are lost if you [wait|Concept.Wait] or end your [turn|Concept.Turn] with more than half of your [Action Points|Concept.ActionPoints] remaining",
					"All the stacks are lost if you use [Recover|Skill+recover_skill], or get [Stunned|Skill+stunned_effect], Rooted or [Staggered|Skill+staggered_effect]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_leverage",
		Key = "RF_Leverage",
		Description = ::UPD.getDescription({
			Fluff = "Use the support of your comrades to amplify your strikes!",
			Requirement = "Polearm",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your first polearm attack each turn costs " + ::MSU.Text.colorPositive("-1") + " [Action Point|Concept.ActionPoints] for every adjacent ally",
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
					"Gain [Stamina|Concept.MaximumFatigue] and [Initiative|Concept.Initiative] equal to " + ::MSU.Text.colorPositive("50%") + " of your combined mainhand and offhand weight",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_whirling_death",
		Key = "RF_WhirlingDeath",
		Description = ::UPD.getDescription({
			Fluff = "Create a whirlwind of death with the spinning head of your flail!",
			Requirement = "Flail",
			Effects = [{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Whirling Death|Skill+hd_whirling_death_skill] skill, allowing you to prepare a devastating attack",
				]
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

::Const.Strings.PerkName.RF_KingOfAllWeapons = "Spear Flurry";
::Const.Perks.findById("perk.rf_king_of_all_weapons").Name = ::Const.Strings.PerkName.RF_KingOfAllWeapons;

::Const.Strings.PerkName.RF_SwiftStabs = "Hit and Run";
::Const.Perks.findById("perk.rf_swift_stabs").Name = ::Const.Strings.PerkName.RF_SwiftStabs;
