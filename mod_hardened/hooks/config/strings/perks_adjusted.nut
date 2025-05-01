// This is loaded AFTER perk_defs.nut is loaded

local adjustedDescriptions = [
	// Vanilla Perks
	{
		ID = "perk.anticipation",
		Key = "Anticipation",
		Description = ::UPD.getDescription({
			Fluff = "I saw these coming!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Take less Damage from the first " + ::MSU.Text.colorPositive(2) + " attacks you, or your shield receive each battle",
					"This reduction is a percentage equal to your current [Ranged Defense|Concept.RangeDefense] plus an additional " + ::MSU.Text.colorPositive("10%") + " for each tile between the attacker and you",
				],
			}],
		}),
	},
	{
		ID = "perk.backstabber",
		Key = "Backstabber",
		Description = ::UPD.getDescription({
			Fluff = "Honor doesn\'t win you fights, stabbing the enemy where it hurts does.",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
					"Gain " + ::MSU.Text.colorPositive("+5%") + " [Hitchance|Concept.Hitchance] for every character [surrounding|Concept.Surrounding] your target, except the first one",
				],
 			}],
	 	}),
	},
	{
		ID = "perk.bags_and_belts",
		Key = "BagsAndBelts",
		Description = ::UPD.getDescription({
			Fluff = "Preparedness is the key to victory.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Unlock two extra [bag slots.|Concept.BagSlots]",
					"Items placed in [bags|Concept.BagSlots] no longer apply a penalty to [Stamina|Concept.MaximumFatigue]",
				],
			}],
		}),
	},
	{
		ID = "perk.battle_forged",
		Key = "BattleForged",
		Description = ::UPD.getDescription({
			Fluff = "Specialize in heavy armor!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Take " + ::MSU.Text.colorPositive("1%") + " less Armor Damage from Attacks for every " + ::MSU.Text.colorPositive("20") + " current combined Body Armor and Helmet condition",
				],
			}],
		}),
	},
	{
		ID = "perk.berserk",
		Key = "Berserk",
		Description = ::UPD.getDescription({
			Fluff = "RAAARGH!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Once per turn, when you kill an enemy, recover " + ::MSU.Text.colorPositive("4") + " [Action Points|Concept.ActionPoints]",
				],
			}],
		}),
	},
	{
		ID = "perk.bullseye",
		Key = "Bullseye",
		Description = ::UPD.getDescription({
			Fluff = "An open shot is all you need!",
			Requirement = "Ranged Weapon",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("+25%") + " [Armor Penetration|Concept.ArmorPenetration] against targets who are not in cover",
				],
			}],
		}),
	},
	{
		ID = "perk.brawny",
		Key = "Brawny",
		Description = ::UPD.getDescription({
			Fluff = "Wear your armor like a tortoise wears its shell.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"The [Stamina|Concept.MaximumFatigue] penalty from your Body Armor and Helmet [Weight|Concept.Weight] is reduced by " + ::MSU.Text.colorPositive("30%"),
				],
			}],
		}),
	},
	{
		ID = "perk.colossus",
		Key = "Colossus",
		Description = ::UPD.getDescription({
			Fluff = "Bring it on!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("+15") + " [Hitpoints|Concept.Hitpoints]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_death_dealer",
		Key = "RF_DeathDealer",
		Description = ::UPD.getDescription({
			Fluff = "Like wheat before a scythe!",
			Requirement = "AoE Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Deal " + ::MSU.Text.colorPositive("5%") + " more Damage for every enemy within 2 tiles of you",
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
					"For each empty adjacent tile, gain " + ::MSU.Text.colorPositive("5%") + " of your current [Initiative|Concept.Initiative] as a bonus to [Melee Defense|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense]",
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
					"While adjacent to at most 1 enemy, gain "  + ::MSU.Text.colorPositive("+2") + " [Reach|Concept.Reach] and " + ::MSU.Text.colorPositive("+30%") + " [Armor Penetration|Concept.ArmorPenetration]",
					"While adjacent to exactly 2 enemies, gain "  + ::MSU.Text.colorPositive("+1") + " [Reach|Concept.Reach] and " + ::MSU.Text.colorPositive("+15%") + " [Armor Penetration|Concept.ArmorPenetration]",
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
					"Gain " + ::MSU.Text.colorPositive("+25") + " [Resolve|Concept.Bravery]",
					"Lose [Resolve|Concept.Bravery] equal to the [Weight|Concept.Weight] of your Helmet",
				],
			}],
		}),
	},
	{
		ID = "perk.footwork",
		Key = "Footwork",
		Description = ::UPD.getDescription({
			Fluff = "Slip right from an opponent\'s grasp!",
			Effects = [{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Footwork|Skill+footwork] skill which allows you to leave a [Zone of Control|Concept.ZoneOfControl] without triggering free attacks",
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
					"At the start of each [round|Concept.Round] every adjacent ally from your company, with less [Resolve|Concept.Bravery] than you, gains " + ::MSU.Text.colorPositive("+3") + " [Action Points|Concept.ActionPoints] if they are adjacent to an enemy",
					"Does not affect [stunned|Skill+stunned_effect] or [fleeing|Concept.Morale] allies. Every character can only be [inspired|Skill+hd_inspiring_presence_buff_effect] once per [round|Concept.Round]"
				],
			}],
		}),
	},
	{
		ID = "perk.lone_wolf",
		Key = "LoneWolf",
		Description = ::UPD.getDescription({
			Fluff = "I work best alone.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"When no members of your faction are within 2 tiles of distance from you, gain " + ::MSU.Text.colorPositive("15%") + " more [Melee Skill,|Concept.MeleeSkill] [Ranged Skill,|Concept.RangeSkill] [Melee Defense,|Concept.MeleeDefense] [Ranged Defense,|Concept.RangeDefense] and [Resolve|Concept.Bravery]",
				],
			}]
		})
	},
	{
		ID = "perk.nimble",
		Key = "Nimble",
		Description = ::UPD.getDescription({
			Fluff = "Specialize in light armor! By nimbly dodging or deflecting blows, convert any hits to glancing hits",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Take " + ::MSU.Text.colorPositive("60%") + " less [Hitpoint|Concept.Hitpoints] Damage from Attacks",
					"Take more Armor Damage equal to the combined [Weight|Concept.Weight] of your Body Armor and Helmet as a percentage",
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
						"Axe Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
						"[Round Swing|Skill+round_swing] gains " + ::MSU.Text.colorPositive("+5%") + " [Hitchance|Concept.Hitchance]",
						"[Split Shield|Skill+split_shield] applies [Dazed|Skill+dazed_effect] for " + ::MSU.Text.colorPositive(1) + " [turn|Concept.Turn]",
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
		ID = "perk.mastery.bow",
		Key = "SpecBow",
		Description = ::UPD.getDescription({
			Fluff = "Master the art of archery and pelting your opponents with arrows from afar.",
			Requirement = "Bow",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
						"Shooting range with bows is increased by " + ::MSU.Text.colorPositive("+1"),
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Arrow to the Knee|Skill+rf_arrow_to_the_knee_skill] skill to debilitate your opponents\' capability to move around the battlefield.",
					],
				},
			],
		}),
	},
	{
		ID = "perk.mastery.cleaver",
		Key = "SpecCleaver",
		Description = ::UPD.getDescription({
			Fluff = "Master cleavers and fight with a bloodlust.",
			Requirement = "Cleaver",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
						"Gain the [Bloodlust|Perk+perk_rf_bloodlust] perk.",
						"Attacks from cleavers apply an additional stack of [Bleeding.|Skill+bleeding_effect]",
						"[Disarm|Skill+disarm_skill] gains " + ::MSU.Text.colorPositive("+10%") + " [Hitchance|Concept.Hitchance]",
						"[Gouge|Skill+rf_gouge_skill] has a " + ::MSU.Text.colorNegative("50%") + " lower [threshold|Concept.InjuryThreshold] to inflict [injuries.|Concept.InjuryTemporary]",
					],
				},
			],
		}),
	},
	{
		ID = "perk.mastery.crossbow",
		Key = "SpecCrossbow",
		Description = ::UPD.getDescription({
			Fluff = "Master crossbows and firearms, and how best to aim.",
			Requirement = "Crossbow or Firearm",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
						"Gain " + ::MSU.Text.colorPositive("+1") + " [Vision|Concept.SightDistance] if you wear a Helmet with a vision penalty",
						"[Reload|Skill+reload_handgonne_skill] with [Handgonnes|Item+handgonne] costs " + ::MSU.Text.colorPositive("-3") + " [Action Points|Concept.ActionPoints]",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Take Aim|Skill+rf_take_aim_skill] skill which allows you to target opponents behind obstacles with a [crossbow|Item+crossbow] or hit more targets with a [handgonne.|Item+handgonne]",
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
					"Dagger Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
					"The [Action Point|Concept.ActionPoints] cost of [Puncture|Skill+puncture] and [Deathblow|Skill+deathblow_skill] is reduced to " + ::MSU.Text.colorPositive("3"),
					"Once per [turn,|Concept.Turn] the first use of your offhand item [weighing|Concept.Weight] less than " + ::MSU.Text.colorPositive(10) + " costs no [Action Points|Concept.ActionPoints]",
				],
			}],
		}),
	},
	{
		ID = "perk.mastery.flail",
		Key = "SpecFlail",
		Description = ::UPD.getDescription({
			Fluff = "Master flails and circumvent your opponent\'s shield.",
			Requirement = "Flail",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Flail Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
					"[Lash|Skill+lash_skill] and [Hail|Skill+hail_skill] ignore the defense bonus granted by shields but not by [Shieldwall|Skill+shieldwall_effect]",
					"[Pound|Skill+pound] gains " + ::MSU.Text.colorPositive("+10%") + " [Armor Penetration|Concept.ArmorPenetration] on head hits",
					"After you use a Flail Skill, gain the [From all Sides|Skill+rf_from_all_sides_effect] effect until the start of your next [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.mastery.hammer",
		Key = "SpecHammer",
		Description = ::UPD.getDescription({
			Fluff = "Master hammers and fighting against heavily armored opponents.",
			Requirement = "Hammer",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Hammer Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue.|Concept.Fatigue]",
						"[Shatter|Skill+shatter_skill] gains " + ::MSU.Text.colorPositive("+5%") + " [Hitchance|Concept.Hitchance]",
						::MSU.Text.colorPositive("50%") + " of the Armor Damage you deal to one body part is also dealt to the other body part",
					],
				},
			],
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
					"Polearm Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
					"[Hook|Skill+hook] and [Repel|Skill+repel] gain " + ::MSU.Text.colorPositive("+15%") + " [Hitchance|Concept.Hitchance]",
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
						"Spear Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
						"[Spearwall|Skill+spearwall] can be used while engaged in melee and is no longer disabled when enemies overcome it",
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
						"Sword Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
						"[Gash|Skill+gash_skill] has a " + ::MSU.Text.colorPositive("50%") + " lower threshold to inflict [injuries|Concept.InjuryTemporary]",
						"[Split|Skill+split] and [Swing|Skill+swing] gain " + ::MSU.Text.colorPositive("+15%") + " [Hitchance|Concept.Hitchance]",
						"Whenever you attack an enemy whose [turn|Concept.Turn] has already started, lower their [Initiative|Concept.Initiative] by a stacking " + ::MSU.Text.colorNegative("15%") + " (up to " + ::MSU.Text.colorNegative("90%") + ") until the start of their next [turn|Concept.Turn]",
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
					"Throwing Skills cost " + ::MSU.Text.colorPositive("25%") + " less [Fatigue|Concept.Fatigue]",
					"Your first throwing attack each [turn|Concept.Turn] deals " + ::MSU.Text.colorizeMultWithText(1.3) + " damage",
					"Swapping a throwing weapon with an empty throwing weapon or an empty slot becomes a free action once per [turn|Concept.Turn]",
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
						"Using [Wait|Concept.Wait] or [Recover|Skill+recover_skill] will no longer apply the [Waiting|Skill+hd_wait_effect] debuff",
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
			Requirement = "Shield",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Enemies will never have [Reach Advantage|Concept.ReachAdvantage] against you",
						"Your shield takes " + ::MSU.Text.colorPositive("50%") + " less damage up to a minimum of 1",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Cover Ally|Skill+rf_cover_ally_skill] skill which allows you to target an ally to allow them to move 1 tile ignoring [Zone of Control|Concept.ZoneOfControl] on their [turn|Concept.Turn] while improving their position in the [turn|Concept.Turn] order in the next [round|Concept.Round]",
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
	{
		ID = "perk.underdog",
		Key = "Underdog",
		Description = ::UPD.getDescription({
			Fluff = "I\'m used to it.",
	 		Effects = [{
 				Type = ::UPD.EffectType.Passive,
 				Description = [
					"Gain " + ::MSU.Text.colorPositive("+5") + " [Melee Defense|Concept.MeleeDefense] for every enemy [surrounding|Concept.Surrounding] you, except the first one",
				],
 			}],
	 	}),
	},


	// Reforged Perks
	{
		ID = "perk.rf_angler",
		Key = "RF_Angler",
		Description = ::UPD.getDescription({
			Fluff = "Throw nets in a way that perfectly billows around your targets.",
			Requirement = "Throwing Net",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"[Throw Net|Skill+throw_net] applies [Staggered|Skill+staggered_effect]",
						"The range of [Throw Net|Skill+throw_net] is increased by " + ::MSU.Text.colorGreen(1) + " tile",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Net Pull|Skill+rf_net_pull_skill] skill that allows you to pull a target and [net|Skill+net_effect] it",
					],
				},
			],
		}),
	},
	{
		ID = "perk.rf_battle_fervor",
		Key = "RF_BattleFervor",
		Description = ::UPD.getDescription({
			Fluff = "It is our destiny!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("10%") + " more [Resolve|Concept.Bravery]",
					"While at Steady [Morale,|Concept.Morale] gain " + ::MSU.Text.colorPositive("10%") + " more [Melee Skill,|Concept.MeleeSkill] [Ranged Skill,|Concept.RangeSkill] [Melee Defense,|Concept.MeleeDefense] and [Ranged Defense|Concept.RangeDefense]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_bear_down",
		Key = "RF_BearDown",
		Description = ::UPD.getDescription({
			Fluff = "\'Give their \'ed a nice knock, then move in for the kill!\'",
			Requirement = "Mace",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Every hit to the head will [daze|Skill+dazed_effect] your target for " + ::MSU.Text.colorPositive(1) + " [turn|Concept.Turn] or increase the duration of an existing [daze|Skill+dazed_effect] by " + ::MSU.Text.colorPositive(1) + " [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_between_the_ribs",
		Key = "RF_BetweenTheRibs",
		Description = ::UPD.getDescription({
			Fluff = "Striking when an enemy is distracted allows this character to aim for the vulnerable bits!",
			Requirement = "Dagger",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"For every character [surrounding|Concept.Surrounding] your target, except the first one, gain " + ::MSU.Text.colorPositive("10%") + " more damage, " + ::MSU.Text.colorPositive("+10%") + " [Armor Penetration|Concept.ArmorPenetration] and " + ::MSU.Text.colorNegative("-10%") + " [chance to hit the head|Concept.ChanceToHitHead]"
				],
			}],
		}),
	},
	{
		ID = "perk.rf_bestial_vigor",
		Key = "RF_BestialVigor",
		Description = ::UPD.getDescription({
			Fluff = "Time for Plan B!",
			Effects = [{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Backup Plan|Skill+hd_backup_plan_skill] skill, allowing you to recover [Action Points|Concept.ActionPoints] once per battle",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_bloodlust",
		Key = "RF_Bloodlust",
		Description = ::UPD.getDescription({
			Fluff = "When surrounded by carnage, you feel revitalized and right at home!",
			Requirement = "Cleaver",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Deal " + ::MSU.Text.colorPositive("10%") + " more Damage against [bleeding|Skill+bleeding_effect] characters",
					"Receive " + ::MSU.Text.colorPositive("10%") + " less Damage from [bleeding|Skill+bleeding_effect] characters",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_bolster",
		Key = "RF_Bolster",
		Description = ::UPD.getDescription({
			Fluff = "Your battle brothers feel confident when you\'re there backing them up!",
			Requirement = "Polearm",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"While not engaged in melee, whenever you attack, trigger a Positive [Morale Check|Concept.Morale] for adjacent members of your company",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_bone_breaker",
		Key = "RF_BoneBreaker",
		Description = ::UPD.getDescription({
			Fluff = "Snap, crunch, crumble. Music to your ears!",
			Requirement = "Mace Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Armor Damage you deal is treated as additional Hitpoint Damage for purpose of inflicting [injuries|Concept.InjuryTemporary]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_bulwark",
		Key = "RF_Bulwark",
		Description = ::UPD.getDescription({
			Fluff = "\'Not much to be afraid of behind a suit of plate!\'",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("5%") + " of your current combined head and body armor condition as [Resolve|Concept.Bravery]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_cheap_trick",
		Key = "RF_CheapTrick",
		Description = ::UPD.getDescription({
			Fluff = "Fighting dirty? We call that winning.",
			Effects = [{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Cheap Trick|NullEntitySkill+rf_cheap_trick_skill] skill which increases the [Hitchance|Concept.Hitchance] of your next attack skill but reduces its damage",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_command",
		Key = "RF_Command",
		Description = ::UPD.getDescription({
			Fluff = "\'You shall do it!\'",
			Effects = [{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Command|Skill+rf_command_skill] skill which allows you to [rally|Concept.Morale] an ally and move them forward in the [turn|Concept.Turn] order",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_combo",
		Key = "RF_Combo",
		Description = ::UPD.getDescription({
			Fluff = "The good ole' one-two.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"All skills that you have not used yet this [round,|Concept.Round] cost " + ::MSU.Text.colorPositive(-1) + " [Action Point|Concept.ActionPoints], except the first skill you use each [round|Concept.Round]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_concussive_strikes",
		Key = "RF_ConcussiveStrikes",
		Description = ::UPD.getDescription({
			Fluff = "Crush one, and watch the shockwave rattle the rest!",
			Requirement = "Mace",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Whenever you stun or kill an enemy, apply [Dazed|Skill+dazed_effect] to all enemies adjacent to the target for " + ::MSU.Text.colorPositive(1) + " [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_deep_impact",
		Key = "RF_DeepImpact",
		Description = ::UPD.getDescription({
			Fluff = "Clear a path with every strike, claiming the ground as your own.",
			Requirement = "Hammer",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"[Shatter|Skill+shatter_skill] will always knock back enemies you hit"
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Gain the [Pummel|Skill+rf_pummel_skill] skill allowing you to hit an enemy and take their position, all in one action",
					],
				},
			],
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
					"Deal " + ::MSU.Text.colorPositive("100%") + " more Shield Damage",
					"Deal " + ::MSU.Text.colorPositive("+40%") + " Armor Damage gainst enemies who have full health",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_dismemberment",
		Key = "RF_Dismemberment",
		Description = ::UPD.getDescription({
			Fluff = "Welcome to the chopping block!",
			Requirement = "Axe",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"When inflicting an [injury|Concept.InjuryTemporary] with a cutting damage attack, if you meet the [threshold|Concept.InjuryThreshold] for the lowest possible [injury|Concept.InjuryTemporary], instead inflict one with the highest [threshold|Concept.InjuryThreshold]",
					"Gain " + ::MSU.Text.colorPositive("+20%") + " chance to hit the body part with the most [temporary injuries|Concept.InjuryTemporary]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_double_strike",
		Key = "RF_DoubleStrike",
		Description = ::UPD.getDescription({
			Fluff = "Here, have another!",
			Requirement = "Non-AOE Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"After a successful hit, deal " + ::MSU.Text.colorPositive("20%") + " more Damage until you miss an attack, move, [wait|Concept.Wait] or end your [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_dynamic_duo",
		Key = "RF_DynamicDuo",
		Description = ::UPD.getDescription({
			Fluff = "You\'ve learned that you fight best with a buddy to watch your back!",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"You and your Partner gain the [Shuffle|Skill+rf_dynamic_duo_shuffle_skill] skill that allows you to swap places with each other once per [turn|Concept.Turn]",
						"You and your Partner gain " + ::MSU.Text.colorPositive("+20") + " [Resolve|Concept.Bravery] and [Initiative|Concept.Initiative] while you are adjacent to each other and there are no other member of your company adjacent to you or your partner",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Gain the [Select Partner|Skill+rf_dynamic_duo_select_partner_skill] skill which allows you to choose a partner, if you don\'t already have one",
					]
				}
			],
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
					"Gain " + ::MSU.Text.colorPositive("+10") + " [Melee Skill|Concept.MeleeSkill] while it is not your [turn|Concept.Turn]",
					"[Riposte|Skill+riposte_effect] is no longer removed when you get hit or do a counter attack",
					"Recover " + ::MSU.Text.colorPositive("1") + " [Action Point|Concept.ActionPoints] whenever an opponent misses a melee attack against you",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_entrenched",
		Key = "RF_Entrenched",
		Description = ::UPD.getDescription({
			Fluff = "From an advantageous position, you control the battlefield!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("+5") + " [Resolve|Concept.Bravery] per adjacent ally",
					"Gain " + ::MSU.Text.colorPositive("+5") + " [Ranged Defense|Concept.RangeDefense] per adjacent obstacle",
					"Gain " + ::MSU.Text.colorPositive("15%") + " more [Ranged Skill|Concept.RangeSkill] while at least 3 adjacent tiles are occupied by allies or obstacles",
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
					"Gain a stacking " + ::MSU.Text.colorPositive("+10%") + " [Hitchance|Concept.Hitchance] whenever an opponent misses an attack against you",
					"Bonus is reset upon landing a hit",
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
		ID = "perk.rf_finesse",
		Key = "RF_Finesse",
		Description = ::UPD.getDescription({
			Fluff = "Years of combat training have given you insight into the most efficient way of carrying yourself on the battlefield.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"All skills cost " + ::MSU.Text.colorPositive("20%") + " less [Fatigue|Concept.Fatigue]",
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
					"Whenever you use an Attack during your [turn,|Concept.Turn] perform a free extra attack of the same type to a different valid enemy within 2 tiles. This attack deals " + ::MSU.Text.colorNegative("50%") + " less damage",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_flaming_arrows",
		Key = "RF_FlamingArrows",
		Description = ::UPD.getDescription({
			Fluff = "Burn them all!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"A successful [Aimed Shot|Skill+aimed_shot] will now light the target tile on fire for 2 [rounds|Concept.Round] and trigger a [Morale Check|Concept.Morale] for all adjacent enemies",
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
					"Moving next to an enemy grants " + ::MSU.Text.colorPositive("+15") + " [Melee Skill|Concept.MeleeSkill] against them until they damage you",
					"Moving next to an enemy that has less maximum [Hitpoints|Concept.Hitpoints] than you, removes [Confident|Concept.Morale] from them",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_fresh_and_furious",
		Key = "RF_FreshAndFurious",
		Description = ::UPD.getDescription({
			Fluff = "The period of vigor at the beginning of the fight is when you do the most damage!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your first skill each [turn|Concept.Turn] during your [turn|Concept.Turn] costs " + ::MSU.Text.colorPositive("50%") + " less [Action Points|Concept.ActionPoints] (rounded down)",
					"This effect becomes disabled if you end your [turn|Concept.Turn] with " + ::MSU.Text.colorNegative("50%") + " or more [Fatigue|Concept.Fatigue] and remains disabled until you use [Recover|Skill+recover_skill]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_from_all_sides",
		Key = "RF_FromAllSides",
		Description = ::UPD.getDescription({
			Fluff = "You\'ve learned to use the unpredictable swings to keep your enemies guessing!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"After you use an Attack Skill, gain the [From all Sides|Skill+rf_from_all_sides_effect] effect until the start of your next [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_fruits_of_labor",
		Key = "RF_FruitsOfLabor",
		Description = ::UPD.getDescription({
			Fluff = "You\'ve quickly realized that your years of hard labor give you an edge in mercenary work!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("5%") + " more [Hitpoints,|Concept.Hitpoints] [Stamina,|Concept.MaximumFatigue] [Resolve|Concept.Bravery] and [Initiative|Concept.Initiative]"
				],
			}],
		}),
	},
	{
		ID = "perk.rf_hold_steady",
		Key = "RF_HoldSteady",
		Description = ::UPD.getDescription({
			Fluff = "Direct your troops to stand their ground!",
			Effects = [{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Hold Steady|Skill+rf_hold_steady_skill] skill which can be used once per battle to grant nearby members of your company increased defenses, immunity against [Stuns|Skill+stunned_effect] and immunity against [Displacement|Concept.Displacement] for two [rounds|Concept.Round]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_hybridization",
		Key = "RF_Hybridization",	// This is now called "Toolbox"
		Description = ::UPD.getDescription({
			Fluff = "Every tool has its use.",
			Requirement = "Throwing Weapon",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"Piercing type throwing attacks apply [Arrow to the Knee|Skill+rf_arrow_to_the_knee_debuff_effect] when hitting the body",
						"Cutting type throwing attacks apply [Overwhelmed|Skill+overwhelmed_effect]",
						"Headshots with blunt type throwing attacks apply [Staggered.|Skill+staggered_effect] All hits with blunt type throwing attacks will [stun|Skill+stunned_effect] the target if already [staggered|Skill+staggered_effect]",
						"[Throwing Spears|Item+throwing_spear] deal " + ::MSU.Text.colorizeMultWithText(2.0) + " damage to shields",
					],
				},
			],
		}),
	},
	{
		ID = "perk.rf_ghostlike",
		Key = "RF_Ghostlike",
		Description = ::UPD.getDescription({
			Fluff = "Blink and you\'ll miss me.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"During your [turn|Concept.Turn], gain " + ::MSU.Text.colorPositive("50%") + " of your [Resolve|Concept.Bravery] as additional [Melee Defense|Concept.MeleeDefense]"
					"When you start or resume your [turn|Concept.Turn] not adjacent to enemies, gain " + ::MSU.Text.colorPositive("+15%") + " [Armor Penetration|Concept.ArmorPenetration] and " + ::MSU.Text.colorPositive("15%") + " more Damage against adjacent targets until you [wait|Concept.Wait] or end your [turn|Concept.Turn]"
				],
			}],
		}),
	},
	{
		ID = "perk.rf_iron_sights",
		Key = "RF_IronSights",
		Description = ::UPD.getDescription({
			Fluff = "With a little tinkering, you\'ve managed to rig up sighting methods for your ranged weapons that allow more focused shots!",
			Requirement = "Crossbow or Firearm",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Attacks have an additional " + ::MSU.Text.colorPositive("25%") + " chance to hit the head",
					"Headshots from ranged attacks with firearms apply the [Shellshocked|Skill+shellshocked_effect] effect except on characters with " + ::Const.MoraleStateName[::Const.MoraleState.Ignore] + " [morale.|Concept.Morale]",
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
					"Your spear attacks cost no [Fatigue|Concept.Fatigue]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_kingfisher",
		Key = "RF_Kingfisher",
		Description = ::UPD.getDescription({
			Fluff = "\'Teach a man to fish and he'll be worth his salt to the end of his days.\'",
			Requirement = "Throwing Net",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("+2") + " [Reach|Concept.Reach]",
					"[Netting|Skill+throw_net] an adjacent target does not expend your net but prevents you from using or swapping it until that target breaks free or dies",
					"If you move more than 1 tile away from that netted target, lose your equipped net",
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
					"Your first attack each [turn|Concept.Turn] costs " + ::MSU.Text.colorPositive("-1") + " [Action Point|Concept.ActionPoints] for every adjacent ally",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_line_breaker",
		Key = "RF_LineBreaker",
		Description = ::UPD.getDescription({
			Fluff = "\'Make way for the bad guy!\'",
			Requirement = "Shield",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"[Knock Back|Skill+knock_back] gains " + ::MSU.Text.colorPositive("+15%") + " [Hitchance|Concept.Hitchance] and [staggers|Skill+staggered_effect] the target on a hit",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Line Breaker|Skill+rf_line_breaker_skill] skill which allows you to knock back an enemy and take their place, all in one action",
					],
				},
			],
		}),
	},
	{
		ID = "perk.rf_long_reach",
		Key = "RF_LongReach",
		Description = ::UPD.getDescription({
			Fluff = "\'If the target is watchin\' the head of yer pike, they\'re sure not watchin\' their back!\'",
			Requirement = "Polearm",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Enemies at a distance of 2 tiles are [surrounded|Concept.Surrounding] by you",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_marksmanship",
		Key = "RF_Marksmanship",
		Description = ::UPD.getDescription({
			Fluff = "Free of nearby threats, your awareness sharpens.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"While no enemy is within 2 tiles of you, deal " + ::MSU.Text.colorPositive("+10") + " Damage",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_nailed_it",
		Key = "RF_NailedIt",
		Description = ::UPD.getDescription({
			Fluff = "\'One javelin to the head will take \'em right out!\'",
			Requirement = "Ranged attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("30%") + " [chance to hit the head.|Concept.ChanceToHitHead] Lose " + ::MSU.Text.colorNegative("5%") + " of that bonus for every tile between you and your target",
					"The penalty to hitchance from obstructed line of sight is reduced by " + ::MSU.Text.colorPositive("50%") + " at a distance of 2 tiles",
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
					"Gain " + ::MSU.Text.colorPositive("+1") + " [Reach|Concept.Reach] per adjacent ally equipped with a shield",
					"[Shieldwall|Skill+shieldwall_effect] does not expire at the start of your [turn|Concept.Turn] if an adjacent ally is also using [Shieldwall|Skill+shieldwall_effect]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_professional",
		Key = "RF_Professional",
		Description = ::UPD.getDescription({
			Fluff = "I know what I\'m doing, I\'m a professional.",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain the first two [perks|Concept.Perk] in a random melee perk group that you have access to",
					"Gain " + ::MSU.Text.colorNegative("5%") + " less [Experience|Concept.Experience]",
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
					"Tool skills cost " + ::MSU.Text.colorPositive("-1") + " [Action Point|Concept.ActionPoints]",
					"Wielding a tool in your offhand does not disable [Double Grip|Skill+double_grip]",
					"While wielding a tool in your offhand, the first successful attack each [turn|Concept.Turn] will [stagger|Skill+staggered_effect] your target",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_onslaught",
		Key = "RF_Onslaught",
		Description = ::UPD.getDescription({
			Fluff = "Break their ranks, break their backs, break them all!",
			Effects = [{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Onslaught|Skill+rf_onslaught_skill] skill which can be used once per battle to grant nearby members of your company [Initiative,|Concept.Initiative] [Melee Skill|Concept.MeleeSkill] and one use of the [Line Breaker|Skill+rf_line_breaker_skill] skill for two [rounds|Concept.Round]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_opportunist",
		Key = "RF_Opportunist",
		Description = ::UPD.getDescription({
			Fluff = "Glide over terrain and strike before your enemies even see you coming.",
			Requirement = "Throwing Weapon",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Throwing Attacks cost " + ::MSU.Text.colorPositive(-1) + " [Action Point|Concept.ActionPoints] per tile moved during your [turn|Concept.Turn], until you use a throwing attack, [wait|Concept.Wait] or end your [turn|Concept.Turn]",
					"Moving costs " + ::MSU.Text.colorPositive(-2) + " [Fatigue|Concept.Fatigue]",
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
					"Take up to " + ::MSU.Text.colorPositive("60%") + " less [Armor Penetration|Concept.ArmorPenetration] Damage from attacks. Lose " + ::MSU.Text.colorNegative("1%") + " reduction for each [Weight|Concept.Weight] on your Body Armor and Helmet combined",
					"Take " + ::MSU.Text.colorPositive("2%") + " less Armor Damage from Attacks for every " + ::MSU.Text.colorPositive("5") + " [Initiative|Concept.Initiative] you have, up to a maximum of " + ::MSU.Text.colorPositive("40%"),
				],
			}],
		}),
	},
	{
		ID = "perk.rf_rattle",
		Key = "RF_Rattle",		// Current name is 'Full Force'
		Description = ::UPD.getDescription({
			Fluff = "Leave nothing in reserve, strike with everything you've got!",
			Requirement = "Hammer",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Whenever you use an attack, spend all remaining [Action Points|Concept.ActionPoints] and deal " + ::MSU.Text.colorizeMultWithText(1.1) + " Damage during this attack for every [Action Point|Concept.ActionPoints] spent this way",
					"This bonus is doubled for one-handed weapons",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_rebuke",
		Key = "RF_Rebuke",
		Description = ::UPD.getDescription({
			Fluff = "Show \'em how it\'s done!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Whenever an opponent misses a melee attack against you while it is not your [turn,|Concept.Turn] gain the [Rebuke|Skill+hd_rebuke_effect] effect until the start of your next [turn|Concept.Turn]",
					"Requires a usable [Attack of Opportunity.|Concept.ZoneOfControl] Does not work while [stunned|Skill+stunned_effect] or [fleeing|Concept.Morale]"
				],
			}],
		}),
	},
	{
		ID = "perk.rf_sanguinary",
		Key = "RF_Sanguinary",
		Description = ::UPD.getDescription({
			Fluff = "Make it rain blood!",
			Requirement = "Cleaver",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Once per turn during your turn, when you move next to an [injured|Concept.InjuryTemporary] enemy, recover " + ::MSU.Text.colorPositive(3) + " [Action Points|Concept.ActionPoints]",
					"Once per turn during your turn, when you cause a [Fatality,|Concept.Fatality] recover " + ::MSU.Text.colorPositive(3) + " [Action Points|Concept.ActionPoints]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_savage_strength",
		Key = "RF_SavageStrength",
		Description = ::UPD.getDescription({
			Fluff = "Orcs call me brother!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Weapon Skills cost " + ::MSU.Text.colorPositive("20%") + " less [Fatigue|Concept.Fatigue]",
					"You are immune to [disarm|Skill+disarmed_effect]",
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
					"Allies with a shield will gain the [Shieldwall effect|Skill+shieldwall_effect] for free at the start of each battle",
					"Whenever you use a shield skill during your [turn,|Concept.Turn] all allies within " + ::MSU.Text.colorPositive(3) + " tiles who also have that skill will use it for free on a random valid tile",
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
					"The [Initiative|Concept.Initiative] penalty from your Body Armor [Weight|Concept.Weight] is reduced by " + ::MSU.Text.colorPositive("50%"),
				],
			}],
		}),
	},
	{
		ID = "perk.rf_survival_instinct",
		Key = "RF_SurvivalInstinct",
		Description = ::UPD.getDescription({
			Fluff = "Your will to live is strong!",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Whenever you get hit by an attack, gain 1 stack",
					"Whenever an attack misses you, lose 1 stack",
					"You gain " + ::MSU.Text.colorPositive("+10") + " [Melee Defense|Concept.MeleeDefense] and " + ::MSU.Text.colorPositive("+10") + " [Ranged Defense|Concept.RangeDefense] per stack",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_sweeping_strikes",
		Key = "RF_SweepingStrikes",
		Description = ::UPD.getDescription({
			Fluff = "Keep your enemies at bay with the swing of your weapon!",
			Requirement = "Two-Handed Melee Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Once per [turn|Concept.Turn], if you use an attack on an adjacent enemy, gain " + ::MSU.Text.colorPositive("+5") + " [Melee Defense|Concept.MeleeDefense] for every adjacent enemy until the start of your next [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_swift_stabs",
		Key = "RF_SwiftStabs",
		Description = ::UPD.getDescription({
			Fluff = "Strike swiftly and vanish before your enemies can react!",
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
		ID = "perk.rf_target_practice",
		Key = "RF_TargetPractice",
		Description = ::UPD.getDescription({
			Fluff = "With the right focus, your arrows will find their way!",
			Requirement = "Bow",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Your attacks are " + ::MSU.Text.colorPositive("50%") + " less likely to hit the cover, when you have no clear line of fire on your target",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_tempo",
		Key = "RF_Tempo",
		Description = ::UPD.getDescription({
			Fluff = "By keeping ahead of your opponent, you set the terms of engagement!",
			Requirement = "Sword",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Gain " + ::MSU.Text.colorPositive("+15") + " [Initiative|Concept.Initiative] until the start of your next [turn|Concept.Turn] whenever you move a tile during your [turn|Concept.Turn]",
				],
			},
			{
				Type = ::UPD.EffectType.Active,
				Description = [
					"Unlocks the [Passing Step|Skill+rf_passing_step_skill] skill which allows you to dance around your opponent after a successful attack",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_the_rush_of_battle",
		Key = "RF_TheRushOfBattle",
		Description = ::UPD.getDescription({
			Fluff = "\'It\'s not uncommon to make it to the end of the battle not remembering any details, just that you slew many men!\'",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"While adjacent to an ally and an enemy, gain " + ::MSU.Text.colorPositive("20%") + " more [Injury Threshold|Concept.InjuryThreshold] for each adjacent enemy and Skills cost " + ::MSU.Text.colorPositive("10%") + " less [Fatigue|Concept.Fatigue] for each adjacent ally",
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
					"You no longer deal [Critical Damage|Concept.CriticalDamage] on a hit to the head",
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
					"Each stack grants " + ::MSU.Text.colorPositive("+1") + " [Action Point|Concept.ActionPoints] and " + ::MSU.Text.colorPositive("8%") + " more [Initiative|Concept.Initiative]",
					"All the stacks are lost if you [wait|Concept.Wait] or end your [turn|Concept.Turn] with more than half of your [Action Points|Concept.ActionPoints] remaining",
					"All the stacks are lost if you use [Recover|Skill+recover_skill], or get [Stunned|Skill+stunned_effect], Rooted or [Staggered|Skill+staggered_effect]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_vanquisher",
		Key = "RF_Vanquisher",
		Description = ::UPD.getDescription({
			Fluff = "Who\'s next?",
			Effects = [
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"When you step on a corpse, that was created this [round,|Concept.Round] take " + ::MSU.Text.colorPositive("25%") + " less Damage and become immune to [Displacement|Concept.Displacement] until the start of your next [turn|Concept.Turn]",
					],
				},
				{
					Type = ::UPD.EffectType.Active,
					Description = [
						"Unlocks the [Gain Ground|Skill+rf_gain_ground_skill] skill which, immediately after killing an adjacent opponent, allows you to move into their tile for free, ignoring [Zone of Control|Concept.ZoneOfControl]"
					],
				},
			],
		}),
	},
	{
		ID = "perk.rf_vigorous_assault",
		Key = "RF_VigorousAssault",
		Description = ::UPD.getDescription({
			Fluff = "You\'ve learned to use the very momentum of your movement as a weapon unto itself!",
			Requirement = "Melee or Throwing Attack",
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"For every 2 tiles moved during your [turn,|Concept.Turn] your next Attack costs " + ::MSU.Text.colorPositive(-1) + " [Action Point|Concept.ActionPoints] (to a minimum of " + ::MSU.Text.colorPositive(1) + ") and " + ::MSU.Text.colorPositive("10%") + " less [Fatigue|Concept.Fatigue]",
					"The effect is lost when you use any skill, [wait|Concept.Wait] or end your [turn|Concept.Turn]",
				],
			}],
		}),
	},
	{
		ID = "perk.rf_weapon_master",
		Key = "RF_WeaponMaster",
		Description = ::UPD.getDescription({
			Fluff = "Weapons are like tools, tailor-made to accomplish specific tasks.",
			Requirement = "Non-Hybrid Weapon",
			Effects = [
				{
					Type = ::UPD.EffectType.OneTimeEffect,
					Description = [
						"Unlock a new random weapon perk group",
					],
				},
				{
					Type = ::UPD.EffectType.Passive,
					Description = [
						"When you equip a weapon whose perk group you have access to, gain the first, second, or third perk in that weapon\'s perk group if you have the corresponding perk in another weapon\'s perk group, regardless of its tier."
					],
				},
			],
			Footer = ::MSU.Text.colorNegative("This perk cannot be refunded."),
		}),
	},
	{
		ID = "perk.rf_wear_them_down",
		Key = "RF_WearThemDown",
		Description = ::UPD.getDescription({
			Fluff = "Overwhelm your foes with metal and meat!"
			Effects = [{
				Type = ::UPD.EffectType.Passive,
				Description = [
					"Any hit builds up an additional " + ::MSU.Text.colorNegative("10") + " [Fatigue|Concept.Fatigue] on the target",
					"Any miss builds up an additional " + ::MSU.Text.colorNegative("5") + " [Fatigue|Concept.Fatigue] on the target",
					"After your attack, if your target is fully [fatigued|Concept.Fatigue], apply [Worn Down|Skill+rf_worn_down_effect] until the end of their [turn|Concept.Turn]",
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
					"The [Stamina|Concept.MaximumFatigue] and [Initiative|Concept.Initiative] penalty from your Mainhand and Offhand [Weight|Concept.Weight] is reduced by " + ::MSU.Text.colorPositive("50%"),
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

::Const.Strings.PerkName.RF_BestialVigor = "Backup Plan";
::Const.Perks.findById("perk.rf_bestial_vigor").Name = ::Const.Strings.PerkName.RF_BestialVigor;

::Const.Strings.PerkName.RF_ConcussiveStrikes = "Shockwave";
::Const.Perks.findById("perk.rf_concussive_strikes").Name = ::Const.Strings.PerkName.RF_ConcussiveStrikes;

::Const.Strings.PerkName.RF_DeepImpact = "Breakthrough";
::Const.Perks.findById("perk.rf_deep_impact").Name = ::Const.Strings.PerkName.RF_DeepImpact;

::Const.Strings.PerkName.RF_Hybridization = "Toolbox";
local hybridizationPerkDef = ::Const.Perks.findById("perk.rf_hybridization");
hybridizationPerkDef.Name = ::Const.Strings.PerkName.RF_Hybridization;
hybridizationPerkDef.Icon = "ui/perks/perk_hd_toolbox.png";	// Give Toolbox a new perk icon, so we can reuse the hybridization art
hybridizationPerkDef.IconDisabled = "ui/perks/perk_hd_toolbox_sw.png";	// Give Toolbox a new perk icon, so we can reuse the hybridization art

::Const.Strings.PerkName.RF_Poise = "Flexible";
::Const.Perks.findById("perk.rf_poise").Name = ::Const.Strings.PerkName.RF_Poise;
::Const.Perks.findById("perk.rf_poise").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Strings.PerkName.RF_KingOfAllWeapons = "Spear Flurry";
::Const.Perks.findById("perk.rf_king_of_all_weapons").Name = ::Const.Strings.PerkName.RF_KingOfAllWeapons;

::Const.Strings.PerkName.RF_Rattle = "Full Force";
::Const.Perks.findById("perk.rf_rattle").Name = ::Const.Strings.PerkName.RF_Rattle;

::Const.Strings.PerkName.RF_SwiftStabs = "Hit and Run";
::Const.Perks.findById("perk.rf_swift_stabs").Name = ::Const.Strings.PerkName.RF_SwiftStabs;

::Const.Perks.findById("perk.rf_dismantle").Icon = "ui/perks/perk_13.png";
::Const.Perks.findById("perk.rf_dismantle").IconDisabled = "ui/perks/perk_13_sw.png";

::Const.Perks.findById("perk.battle_forged").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}

::Const.Perks.findById("perk.nimble").verifyPrerequisites <- function( _player, _tooltip )
{
	return true;
}
