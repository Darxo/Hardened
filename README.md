# Introduction
Hardened is a large overhaul mod for Reforged, offering an alternate vision that stays within the bounds of savegame compatibility.

While Reforged focuses on realism and polished mechanics, Hardened embraces a simpler, more experimental approach. The submod takes more risks with innovative perk designs and mechanics, unlocking new possibilities for gameplay, though this can occasionally introduce more bugs or incompatibilities than Reforged. Hardened also walks back several of Reforged's more complex or restrictive design choices, opting for streamlined systems that prioritize fluidity and player freedom.

Hardened reflects my personal vision of a Vanilla Overhaul — a balanced, varied, and challenging experience, with enough depth and randomness to keep each playthrough fresh and unpredictable.

# Overview
- Simplified Reach Mechanic and Double Grip effect
- Shields are destructible again
- 6 New Perks
- ~90 Perks are tweaked or reworked
- ~50 Weapons and Shields are tweaked
- ~50 Body Armors are reworked
- A few hundred other adjustments to enemies, ai, perk trees, skills and general mechanics
- A plethora of Quality of Life improvements; several of them are optional
- Dozens of minor Vanilla Fixes, including the removal of several cheese strategies

# List of all Changes

## Major Changes

### Reach Rework
*Forget everything you know about the Reforged Reach Mechanic*
- Every Character has a Reach value. This is usually 0 for those who can wield Weapons. All other characters have a value from 1-7 depending on their size
- Every Weapon has a Reach value. This is usually 0 for ranged Weapons
- Some skills or perks may increase or reduce the Reach of a character
- **Reach** is 0 while the character does not emit a zone of control (e.g. stunned, fleeing, wielding ranged weapon)
- You have **Reach Advantage** during any melee attack if your Reach is greater than the Reach of the entity you are attacking
- **Reach Advantage** grants 15% more Melee Skill

### Shield Revert/Rework

- Fatigue no longer has any effect on the defenses granted by shields (just like in Vanilla)
- All reforged changes to Condition, Melee Defense, Ranged Defense and Weight of vanilla shields have been reverted
- Named shields can roll condition as one of their two buffed properties (just like in Vanilla)
- **Craftable Schrat Shield** no longer spawns saplings
- Additionally the following balance changes have been made compared to the vanilla stats:
	- **Buckler** now have a Weight of 2 (down from 4)
	- **Tower Shields** now have 30 Condition (up from 24) and lose **Knock Back**
	- **Heater Shields** now have 25 Melee Defense (up from 20) and lose **Shieldwall**
	- **Kite Shields** lose **Knock Back**
	- **Reinforced Skirmisher Shields** now have 15 Melee Defense (up from 10), 15 Ranged Defense (up from 10), lose **Shieldwall** and now grant **Knock Back**
	- **Wooden Skirmisher Shields** lose **Shieldwall** and now grant **Knock Back**
	- **Heavy Metal Shields** now have 20 Melee Defense (up from 15) and 20 Ranged Defense (up from 15)
	- **Feral Shields** now have 20 Melee Defense (up from 15), 25 Ranged Defense (up from 20), 20 Weight (up from 12), 24 Condition (up from 16), +5 Fatige on use (up from 0) and they lose **Knock Back**
	- **Adarga Shields** now have 8 Weight (down from 10), 16 Condition (down from 18), 18 Ranged Defense (down from 20) and lose **Knock Back**
	- **Old Wooden Shields** now have 13 Melee Defense (down from 15) and 13 Ranged Defense (down from 15)
	- **Worn Heater Shields** now have 23 Melee Defense (up from 20), 13 Ranged Defense (down from 15) and lose **Shieldwall**
	- **Worn Kite Shields** now have 13 Melee Defense (down from 15), 23 Ranged Defense (down from 25) and lose **Knock Back**
- Wooden Shields, Kite Shields and Heater Shields which are colored in Mercenary Colors (e.g. your own) grant +5 Resolve while equipped

### Throwing Weapon Rework

- Throwing Weapons now have a minimum attack range of 1, just like all other ranged attacks
- Throwing regular **Throwing Weapons** now cost 15 Fatigue (up from 10 for Axes, 14 for Javelins and 12 for Bolas), just like in Vanilla
- Throwing **Heavy Throwing Weapons** now costs 5 Action Points (up from 4) and 18 Fatigue (up from 15)
- Throwing **Crude Javelins** now costs 5 Action Points (up from 4)
- **Heavy Javelin** now deal 40-50 Damage (up from 35-50), have 85% Armor Damage (up from 80%), have +0% Hitchance (up from -5%), 4 Maximum Ammo (down from 5), 0 Weight (down from 8), 3 Weight per Ammo, 4 Ammo Cost (up from 3) and costs 500 Crowns (up from 300)
- **Heavy Throwing Axes** now deal 45-60 Damage (up from 30-50), have 120% Armor Damage (up from 115%), have -10% Hitchance (down from -5%), +10% Headshot Chance (up from +5%), 0 Weight (down from 8), 3 Weight per Ammo and costs 600 Crowns (up from 300)
- **Bolas** now deal 25-40 Damage (up from 20-35), have 0 Weight (down from 3), 1.5 Weight per Ammo and costs 300 Crowns (up from 150)
- **Crude Javelins** now deal 35-45 Damage (up from 30-40), have 0 Weight (down from 8), 3 Weight per Ammo and 2 Ammo Cost (down from 3)
- **Javelins** now deal 35-45 Damage (up from 30-45), deal 70% Armor Damage (down from 75%), have 0 Weight (down from 6), 2 Weight per Ammo and costs 350 Crowns (up from 200)
- **Throwing Axes** now deal 35-50 Damage (up from 30-50), have -10% Hitchance (down from +0%), +10% Headshot Chance (up from +5%), 0 Weight (down from 4), 2 Weight per Ammo and costs 400 Crowns (up from 200)
- Marketplaces now sell **Crude Javelins** instead of regular **Javelins**
- Crude Javelins on NPCs start with 3/4 ammo and Heavy Throwing Weapons on NPCs start with 4/5 ammo

### Double Grip Rework

- Double Grip no longer provides unique effects for each weapon type
- Double Grip now always grants 20% more damage and 20% reduced fatigue cost of non-attack skills

### Crowded

*Forget everything you know about the Reforged Crowded Mechanic*
- Any Melee Attack Skill that has a Range of at least 2 tiles may have to deal with the new **Crowded** mechanic:
- Every adjacent ally (except the first two) causes -5% Hitchance with such a skill
- Every adjacent enemy causes -10% Hitchance with such a skill
- As a consequence of the **Crowded** mechanic, 2-tile melee attacks lose the vanilla hitchance penalty to attack adjacent targets

### Crossbows & Firearms

- Crossbows and Firearms now start each battles unloaded
- Crossbows and Firearms are unloaded after battle and their shots are returned to your Ammunition Supplies
- Reloading any Crossbow or Firearm now applies the **Reload Disorientation**  until the start of your next turn
  - **Reload Disorientation** grants 50% less Ranged Defense
- All Crossbows now have +10% chance to hit and +10% Armor Penetration
- Reloading all Crossbows now costs 5 Action Points (up from 4)
- Reloading all Firearms now costs 7 Action Points (down from 9)

### Attacking Allies

- Force Attacking an ally on the world map no longer drops their Relation with you to 0 or causes a Morale Reputation hit. Instead it only makes them temporarily your enemy until you cancel the combat dialog or end the fight with them
- Whenever you start combat, lose 5 Relation with all hostile Factions that you fight against
- Whenever you start combat against a temporary enemy (e.g. when Force Attacking an ally), lose 2 Morale Reputation
- Killing any character now changes Relation with their faction by -2 (down from -0.5). This action will now print a relation change entry with a reason

### New Perks

- Add new **Anchor** perk in Tier 3 of **Unstoppable Group**. It grants immunity against **Displacement** until the start of your next turn, if you end your turn on the same tile you started it on. You also take 50% less Damage from Attacks during your turn.
- Add new **Hybridization** perk in Tier 3 of **Ranged Group**. It allows swapping two weapons with no shared weapon types for free, once per turn. It grants +10 Melee Defense if you have at least 70 Base Ranged Skill and it grants +10 Ranged Defense, if you have at least 70 Base Melee Skill
- Add new **Elusive** perk in Tier 2 of **Swift Group**. It reduces the AP cost for movement on all terrain by 1 to a minimum of 2. This does not stack with Pathfinder. After moving 2 tiles, become immune to rooted effects, until the start of your next turn
- Add new **One with the Shield** perk in Tier 7 of **Shield Group**. It requires a shield. It grants 25% more Injury Threshold. While you have Shieldwall effect you take 40% less Hitpoint damage from head attack. While you don't have Shieldwall effect you take 40% less Hitpoint damage from body attacks
- Add new **Parry** perk in Tier 3 of **Swift Group**. It requires a one handed melee weapon. It grants Melee Defense equal to your base Ranged Defense against weapon attacks. While engage with someone wielding a melee weapon, you have 70% less Ranged Defense. Does not work with shields, while stunned, fleeing or disarmed
- Add new **Scout** perk in Tier 1 of **Ranged Group**. It grants +1 Vision for every 3 adjacent tiles that are either empty or at least 2 levels below your tile. It also removes the Action Point cost for changing height levels, just like **Pathfinder**
- Add the existing enemy-only perk **Wear them Down** in Tier 3 of **Fast Group**

### Reworked Day-Night-Cycle

- Each Day now consists of **Sunrise** (2 hours) followed by **Morning** (6 hours), **Midday** (2 hours), **Afternoon** (6 hours) and ending with **Sunset** (2 hours)
- Each Night now consists of **Dusk** (2 hours), followed by **Midnight** (2 hours) and **Dawn** (2 hours)
- Each new day now starts exactly the moment that night changes to day (Double Arena fix)
- The Day-Night disk on the world map now aligns correctly with the current time

### Stamina, Initiaitive and Weight

- The term **Maximum Fatigue** in many places is replaced with the shorter term **Stamina**. They mean the same thing
- You no longer lose or gain **Initiative**, when you lose or gain **Stamina** (e.g. from **Strong Trait** or from certain Injuries)
- A new term **Weight** replaces the existing **Maximum Fatigue** property on equippable items but works very similar
- The **Stamina** penalty from **Weight** is now applied last (after Stamina Multiplier from effects). This is similar to how the **Initiative** penalty from **Weight** is applied in Vanilla
  - Therefor percentage based debuffs and injuries affecting **Stamina** are worse
  - And percentage based buffs affecting **Stamina** are stronger
- No Character can ever have less than 10 **Stamina**

### Numeral Rework

- Add new numerals for enemy sizes and change the ranges of existing numerals
	- 2-3: A Few
	- 4-6: Some
	- 7-10:	Several
	- 11-15: Many
	- 16-21: Lots
	- 22-37: Dozens
	- 38-69: A plethora
	- 70+: An army
- You can no longer see the exact number of enemy parties on the world map
- Add settings to control, whether to display Numerals or their actual Ranges

### Other Major Changes from Reforged

- Disable **Veteran Perks**. Your brothers no longer gain perk points after Level 11
- You can no longer swap your weapon with a dagger from your bag for free

### Other Major Changes

- **Night Effect** now causes -3 Vision (down from -2)
- When you pay compensation on dismissing a brother, he will share 50% of his experience with all remaining brothers. Each brother can only receive up to 10% of this shared experience.
- You can now use **Bandages** to treat injuries during battle that were received at most 1 round ago
- Attachements no longer randomly spawn on NPCs
- Add new **Retreat** skill for player characters, which allows you to retreat individual brothers from a battle if they stand on a border tile and are not engaged in melee
- Add new **Battle Song** skill while holding a **Lute** for applying a temporary Resolve buff to nearby allies
- Hostile Locations now hide their Defender Line-Up during night
- The fatigue discount from having multiple weapon masteries now stacks when using hybrid weapons

## Skills

### Active Skills

- **Chop** now has a 50% chance to decapitate (up from 25%)
- **Cover Ally** (granted by **Shield Expert**) is mostly reworked. It still costs 4 Action Points and 20 Fatigue and can only target adjacent allies. It now grants the target defenses equal to the base defenses of the users equipped shield and it causes the user to lose an equal amount of defenses. It still lasts until the start of your next turn or until you get stunned or move away from that target
- **Dazed** no longer reduces the Stamina by 25%. It now increases the fatigue cost of all non-attacks by 25%
- **Distracted** (caused by **Throw Dirt**) now reduces the damage by 20% (down from 35%) and disables the targets Zone of Control during the effect
- **Encourage** (granted by **Supporter**) can no longer make someone confident and it no longer requires the user to have a higher morale than the target per tile distance.
- **Hand-to-Hand Attack** is now enabled if you carry an empty throwing weapon in your main hand.
- **Insect Swarm** now disables the targets Zone of Control during its effect. It no longer reduces the Initiative. It now reduces the combat stats by 30% (down from 50%)
- **Flaming Arrow** (granted by **Trick Shooter**) no longer causes an extra morale check on the main target. It now deals 100% Burning Damage (instead of 25% Burning and 75% Piercing Damage)
- **Passing Step** (granted by **Tempo**) can now be used no matter the damage type of the attack or whether you have something in your offhand
- **Lunge** now has -10% additional Hitchance (up from -20%)
- **Net Effect** (caused by **Throw Net**) no longer affects the Initiative of the target. It now applies 50% less Melee Defense (up from 25%) and 50% less Ranged Defense (up from 45%)
- **Net Pull** now costs 30 Fatigue (up from 25)
- **Quick Shot** now has -2 Shooting Range (down from -1)
- **Puncture** now requires the target to be surrounded by atleast 2 enemies. It is now affected by **Double Grip**
- **Recover** now applies the same Initiative debuff as using **Wait**
- **Riposte** now costs 3 Action Points (down from 4), 15 Fatigue (down from 25). It now grants +10 Melee Defense during its effect. It is now disabled when you get hit or after your first counter-attack. Riposte no longer has a penalty to Hitchance
- **Shuffle** (granted by **Dynamic Duo**) no longer puts your partner to the next position in the turn order
- **Spider Poison** now also reduces the Hitpoints Recovery of the target by 50%
- **Stab** now costs 3 Action Points (down from 4) and has a 25% higher threshold to inflict injuries
- **Sword Thrust** now has 0% additional Hitchance (up from -20%)
- **Take Aim** (granted by **Crossbow and Firearm Mastery**) now costs 3 Action Points (up from 2) and 20 Fatigue (down from 25)
- **Throw Axe** now has a 50% chance to decapitate (up from 0%) and 25% chance to disembowel (up from 0%)
- **Throw Net** now costs 4 Action Points (down from 5), has a Range of 3 (up from 2) and no longer requires the targets Base Reach to be below a certain value
- **Withered** no longer reduces Stamina or Fatigue Recovery. It now causes Non-Attacks to cost 50% more Fatigue per remaining turns on the effect duration

Skill nerfs as a result of the Reach system:
- **Gash** now has 0% additional Hitchance (down from 5%)
- **Hook** now has 0% additional Hitchance (down from 10%)
- **Impale** now has 0% additional Hitchance (down from 10%)
- **Lightbringer** now has 0% additional Hitchance (down from 10%)
- **Overhead Strike** now has 0% additional Hitchance (down from 5%)
- **Prong** now has 0% additional Hitchance (down from 10%)
- **Repel** now has 0% additional Hitchance (down from 10%)
- **Rupture** now has 0% additional Hitchance (down from 5%)
- **Swing** now has -10% additional Hitchance (down from -5%)
- **Slash** now has 0% additional Hitchance (down from 5%)
- **Split** now has -10% additional Hitchance (down from -5%)
- **Strike** now has 0% additional Hitchance (down from 5%)
- **Thrust** now has 0% additional Hitchance (down from 10%)

### Perks

Just the images side-by-side: https://github.com/Darxo/Hardened/wiki/Perk-changes-Side‐By‐Side

- **Adrenaline** skill now costs 15 Fatigue (up from 10)
- **Angler** no longer increases the cost of **Break Free** on the target. It now staggers every character that you net. **Net Pull** now has a Range of 3 (up from 2)
- **Anticipation** now also proccs whenever your shield takes damage from an attack
- **Axe Mastery** no longer grants **Hook Shield**. It now causes **Split Shield** to apply **Dazed** for 1 turn
- **Backstabber** is rewritten. It now grants +5% Hitchance per character surrounding your target, except the first one. It now also affects ranged attacks
- **Bags and Belts** now also includes two-handed weapons but no longer grants Initiative
- **Battle Fervor** is completely reworked. It grants 10% more Resolve. It also grants 10% more Melee Skill, Melee Defense, Ranged Skill and Ranged Defense while at Steady Morale
- **Battle Forged** no longer has any prerequisites. It no longer provide any Reach Ignore
- **Bear Down** (granted by **Mace Mastery**) is completely reworked. It now causes every headshot to daze the target for 1 turn, or increase the duration of an existing daze by 1 turn
- **Bestial Vigor** is completely reworked. It is now called **Backup Plan** and grants the skill **Backup Plan** which can be used once per battle to recover 7 Action Points and disable all Attack-Skills for the rest of this turn. It has been removed from the **Wildling** perk group and added to the **Tactician** perk group at Tier 2
- **Between the Ribs** no longer requires the attack to be of piercing type. It now also lowers your chance to hit the head by 10% for each surrounding character
- **Blitzkrieg** now costs 9 Action Points (up from 7), 50 Fatigue (up from 30), no longer requires 10 usable fatigue on the targets. It no longer has a shared cooldown with other brothers who have this perk. It is now limited to being usable once per battle instead of once per day
- **Bloodlust** (no longer available) is completely reworked. It now grants 10% more damage against bleeding enemies and makes you receive 10% less damage from bleeding enemies
- **Bolster** (granted by **Polearm Mastery**) now requires a Polearm equipped, instead of any weapon with a Reach of 6 or more
- **Bone Breaker** is completely reworked. It now causes Armor Damage you deal to be treated as additional Hitpoint damage for the purpose of inflicting injuries
- **Bow Mastery** no longer grants +1 Vision
- **Bullseye** no longer reduces the penalty for shooting behind cover. It also no longer works with **Take Aim**. It now provides 25% Armor Penetration (up from 10% and 20% resepctively)
- **Bulwark** is completely reworked. It now grants additional Resolve equal to 5% of your current combined Head and Body Armor condition
- **Brawny** no longer grants Initiative
- **Cheap Trick** now affects all attacks of a skill, when you use it with an AoE skill
- **Cleaver Mastery** is completely reworked. It still makes Cleaver Skills cost 25% less Fatigue and grants +10% Hitchance when using **Disarm**. You now deal +50% Critical Damage when hitting the Body of someone who is disarmed or who doesn't wield a Melee Weapon
- **Colossus** now grants +15 Hitpoints, instead of 25% more Hitpoints
- **Command** can now be used on fleeing allies. In this case it triggers a positive morale check first. Then, if they are not fleeing, they are moved forward in the turn order, like before
- **Combo** is reworked. It now reduces the cost of all skills you haven't used yet this turn by 2 Action Points, except the first skill you use each turn
- **Concussive strikes** is completely reworked. It is now called **Shockwave** and it makes it so your kills or stuns with maces will daze all enemies adjacent to your target for 1 turn
- **Crossbow and Firearm Mastery** now grants +1 Vision while you wear a Helmet with a Vision Penalty. It no longer reduces the reload cost of **Heavy Crossbows** by 1
- **Dagger Mastery** no longer grant any reach ignore. It now reduces the action point cost of the first offhand skill each turn to 0, if your offhand item has a weight lower than 10
- **Decisive** no longer grants 15% more Resolve at 1 Stack
- **Death Dealer** is completely reworked. It now grants 5% more damage with AoE-Attacks for every enemy within 2 tiles
- **Deep Impact** is now called **Breakthrough** and has been completely reworked. It grants the **Pummel** skill, which can now be used with any hammer. It also makes it so **Shatter** has a 100% chance to knock targets back on a hit and it increases the knock back distance of **Shatter** by 1
- **Dismantle** has been completely reworked. It now grants 100% more Shield Damage. It also grants +40% Armor Damage against enemies who have full health
- **Dismemberment** no longer causes any morale checks. It now grants +20% chance to hit the body part with the most temporary injuries
- **Dodge** now grants 5% of Initiative as extra Melee Defense and Ranged Defense for every empty adjacent tile (down from always 15%)
- **Double Strike** now works with ranged attacks and the damage bonus is no longer lost when you swap weapons
- **Duelist** is completely reworked. It now only works for one-handed weapons. It grants 30% Armor Penetration and +2 Reach while adjacent to 0 or 1 enemies and it grants 15% Armor Penetration and +1 Reach while adjacent to 2 enemies
- **Dynamic Duo** no longer grants Melee Skill or Melee Defense. It no longer reduces hitchance and damage when attacking your partner. It now grants +20 Resolve and +20 Initaitive, while the only adjacent allies next to your and your partner are each other
- **En Garde** is completely reworked. It now grants +10 Melee Skill while it is not your turn. It also makes it so **Riposte** is no longer disabled when you get hit or deal a counter attack (so like in Vanilla), and it recovers 1 Action Point whenever an opponent misses a melee attack against you
- **Entrenched** has been completely reworked. It now grants +5 Resolve per adjacent ally, +5 Ranged Defense per adjacent obstacle and 15% more Ranged Skill if at least 3 adjacent tiles are allies or obstacles
- **Exploit Opening** is completely reworked. It now grants a stacking +10% chance to hit whenever an opponent misses an attack against you. Bonus is reset upon landing a hit (just like Fast Adaptation)
- **Fencer** no longer grants +10% chance to hit or 20% less fatigue cost. It no longer removes the damage type requirement from **Passing Step**. It now causes your fencing swords to lose 50% less durability
- **Flail Mastery** no longer grants +5% HitChance with **Thresh** and it no longer grants the **From all Sides** perk. You now gain the **From all Sides** effect until the start of your next turn, after you use a Flail Skill. This effect makes you count twice for the purpose of surrounding adjacent enemies
- **Flail Spinner** now has a 100% chance to procc (up from 50%) but will only target a random different valid enemy
- **Formidable Approach** is completely reworked. Moving next to an enemy that has less maximum Hitpoints than you, removes Confident from them. Moving next to an enemy grants +15 Melee Skill against them until they damage you or you move away from each other
- **Fortified Mind** now grants +25 Resolve (instead of 25% more) and you lose Resolve equal to the Weight of your Helmet
- **Footwork** perk no longer grants **Sprint**
- **Fresh and Furious** is completely reworked. It now makes all Attacks cost -5 Action Points. After you use any Attack during your turn, this effect gets disabled until you use **Recover**
- **From All Sides** (enemy only perk) is completely reworked. You now gain the **From all Sides** effect until the start of your next turn, after you use a Attack Skill. This effect makes you count twice for the purpose of surrounding adjacent enemies
- **Fruits of Labor** is reworked. It now grants 5% more Hitpoints, Stamina, Resolve and Initiative
- **Ghostlike** has been completely reworked. It no longer has any requirements. It now grants 50% of your Resolve as extra Melee Defense during your turn. When you start or resume your turn not adjacent to enemies, gain +15% Armor Penetration and 15% more damage against adjacent targets until you wait or end your turn
- **Hammer Mastery** no longer grants **Pummel** or increases the Armor Damage dealt by **Crush Armor** and **Demolish Armor**. Now 50% of the Armor Damage you deal to one body part is also dealt to the other body part.
- **Hold Steady** no longer has a shared cooldown with other brothers who have this perk. It now lasts for 2 rounds, instead of having a turn-based duration
- **Hybridization** is completely reworked. It is now called **Toolbox** and requires a Throwing Weapon. It grants +1 Bag Slot if you dont have **Weapon Master**. It now causes piercing type hits to the body to inclict **Arrow to the Knee** for 1 turn, cutting type attacks to inflict **Overwhelmed**, blunt type headshots to inflict stagger for 1 turn and any hit with them to stun a staggered opponent and throwing spears to deal 100% more damage to shields
- **Inspiring Presence** no longer requires a banner. At the start of each round it grants adjacent allies of your faction +3 Action Points for this turn, if they are adjacent to an enemy and have less Resolve than you. The same target can't be inspired multiple times per turn.
- **Iron Sights** headshot chance now also works with melee weapons
- **King of all Weapons** is now called **Spear Flurry** and is completely reworked. It now prevents spear attacks from building up any fatigue
- **Kingfisher** is reworked: It grants +2 Reach while you have a net equipped. Netting an adjacent target does not expend your net but prevents you from using or swapping it until that target breaks free or dies. If you move more than 1 tile away from that netted target, lose your equipped net
- **Leverage** is completely reworked. It now reduces the Action Point cost of your first polearm attack each turn by 1 for each adjacent ally.
- **Line Breaker** no longer grants **Shield Bash**. It now causes **Knock Back** to stagger the target on a hit
- **Lone Wolf** is now only active if no ally from your company is within 2 tiles
- **Long Reach** now only works while it is NOT your turn
- **Marksmanship** is completely reworked. It now grants +10 minimum and maximum damage while there are no enemies within 2 tiles
- **Nimble** is completely reworked: It now always provides a 60% Hitpoint damage reduction but no longer reduces your armor damage taken. It now increases your armor damage taken by a percentage equal to your combined helmet and armor weight
- **Offhand Training** is completely reworked. It now reduces the AP cost of tool skills by 1. Wielding a tool in your offhand no longer disables **Double Grip** and while wielding a tool in your offhand, the first successful attack each turn, will stagger your target
- **Onslaught** no longer has a shared cooldown with other brothers who have this perk. It now lasts for 2 rounds, instead of having a turn-based duration
- **Opportunist** is completely reworked. It now grants throwing attacks -1 Action Point cost per tile moved, until you use a throwing attack, wait or end your turn. Moving on all terrain costs -2 Fatigue, just like the **Athletic** Trait
- **Phalanx** is completely reworked. It grants +1 Reach for every adjacent ally with a shield. **Shieldwall** no longer ends, while an adjacent brother also has **Shieldwall** active
- **Poise** is now called **Flexible** and is completely reworked: It now reduces damage which ignores Armor by 60%. This is reduced by 1% for each combined helmet and body armor weight. You take 2% less Armor Damage from Attacks for every 5 Initiative you have, up to a maximum of 40%.
- **Polearm Mastery** no longer reduces the Action Point cost of 2 handed reach weapons by 1. It now grants +15% chance to hit for **Repel** and **Hook**.
- **Professional** now reduces the experience gained by 5%
- **Quickhands** can now also swap two two-handed weapons, just like in Vanilla. It now stacks with other effects that grant free swaps
- **Rally the Troops** can now also be used even the user was already rallied by someone else this round
- **Rattle** is now called **Full Force** and has been completely reworked. It now causes you to spend all remaining Action Points whenever you attack and gain 10% more damage per Action Point spent. The effect is double for one-handed weapons
- **Rebuke** is completely reworked. It now grants the **Rebuke Effect** whenever an opponent misses a melee attack against you while it's not your turn, until the start of your next turn. This effect reduces your damage by 25% but will make you retaliate every melee attack miss against you.
- **Rush of Battle** is completely reworked. While adjacent to an ally and an enemy, gain 20% more Injury Threshold per adjacent enemy and Skills cost 10% less Fatigue per adjacent ally
- **Sanguinary** can now only trigger once per turn from inflicting fatalities. Now you also recover 3 Action Points once per turn, when you move next to an injured enemy
- **Savage Strength** now reduces fatigue cost of weapon skills by 20% (down from 25%). It now grants Immunity to Disarm
- **Shield Expert** no longer grants 25% increased shield defenses and no longer prevents fatigue build-up when you dodge attacks. It now grants 50% less shield damage taken and it makes it so enemies will never have Reach Advantage over the shield user
- **Shield Sergeant** is completely reworked. It grants **Shieldwall** effect to all allies who have a shield equippe, at the start of combat. It now causes allies within 3 tiles to imitate shield skills for free that you use during your turn. It also allows you to use **Knock Back** and **Cover Ally** on empty tiles
- **Skirmisher** now grants 50% of body armor weight as initiative (previously 30% of body/helmet armor weight) and no longer displays an effect icon
- **Spear Mastery** no longer provides a free spear attack each turn. Instead it now grants 15% more Melee Skill while you have Reach Advantage
- **Survival Instinct** is completely reworked. It now grants 1 stack, when you get hit by an attack, and you lose 1 stack when you dodge an attack. Every stack grants 10 Melee Defense and 10 Ranged Defense
- **Steady Brace** is now called **Ready to Go** and has been completely reworked. It makes it so your Crossbows and Firearms start each battle loaded, including those carried in the bag, if you have the correct- and enough ammunition equipped
- **Student** no longer grants any experience. It now grants +1 Perk Point when you reach level 8 instead of level 11
- **Sweeping Strikes** is completely reworked. It now grants +5 Melee Defense for every adjacent enemy until the start of your next turn the first time you use a melee attack skill on an adjacent enemy. It still requires a two-handed weapon
- **Swift Stabs** has been completely reworked. It's now called **Hit and Run**. It makes it so all dagger attacks can be used at 2 tiles and will move the user one tile closer before the attack. When the attack hits the enemy, the user is moved back to the original tile
- **Sword Mastery** no longer grants **Passing Step** and it no longer increases the HitChance with **Riposte**. It now causes your attacks against enemies whose turn has already started to lower their Initaitive by a stacking 15% (up to a maximum of 90%) until the start of their next turn
- **Target Practice** has been completely reworked. It now makes it 50% less likely for your arrows to hit the cover, when you have no clear line of fire (stronger than vanilla Bullseye)
- **Tempo** is completely reworked. It grants 10% more Initiative until the start of your next turn whenever you move a tile during your turn. It also grants **Passing Step**
- **Through the Gaps** is completely reworked. It causes your piercing spear attacks to always target the body part with the lowest total armor but no longer deal critical damage on a hit to the head
- **Throwing Mastery** is mostly completely reworked. It now grants 30% more damage for your first throwing attack each turn, no matter the range. It now allows swapping a throwing weapon with an empty throwing weapon or empty slot for free, once per turn
- **Trick Shooter** is completely reworked. It makes all Bow Skills that you have not used yet this battle, have +15% Hitchance. It also grants the Flaming Arrow skill (instead of the perk)
- **Underdog** is rewritten. It now grants +5 Melee Defense for every character surrounding you, except the first one. Compared to the vanilla implementation this defense is now affected by defense multiplier and by the softcap for defense
- **Unstoppable** is completely reworked. Once per round during your turn, if you hit an enemy with an attack, gain 1 stack up to a maximum of 3. Each stack grants +1 Action Points and 10% more Initiative. Lose 1 stack if you wait. Lose 1 stack if you end your turn with more than half of your action points remaining. Lose all stacks when you use recover, get stunned or staggered
- **Vanquisher** is completely reworked. After you step on a corpse that has been created this round, you become Immune to **Displacement** and take 25% less Damage until the start of your next turn. **Gain Ground** (granted by **Vanquisher** perk) is now free
- **Vigorous Assault** discount is no longer removed when switching items
- **Weapon Master** no longer grants weapon perks while wielding a hybrid weapons. It now grants +1 Bag Slot at all times. When you learn **Weapon Master** you now gain a new random weapon perk group
- **Wears it well** now grants 50% of combined Mainhand and Offhand Weight as Stamina and Initiative (Instead of 20% of Mainhand, Offhand, Helmet and Chest Weight)
- **Wear them Down** is completely reworked. It now causes your hits to apply an additional 10 Fatigue on the target and your misses to apply 5 Fatigue. After your attack, if your target is fully fatigued, apply **Worn Down** effect until the end of their turn, which prevents them from using **Recover** and applies 30% less Melee Defense and 30% less Ranged Defense
- **Whirling Death** is completely reworked. It now grants a new active skill which creates a buff for 3 turns granting 25% more damage, +2 Reach and 10 Melee Defense to the user

### Perk Groups

- **Bags and Belts** is added to **Light Armor** group and removed from **General** group
- **Bone Breaker** moved to Tier 5 (down from Tier 7)
- **Bullseye** moved to Tier 6 (up from Tier 3)
- **Cheap Trick** moved to Tier 1 (down from Tier 2)
- **Colossus** is added to **Wildling** group
- **Decisive** is added to **Leadership** group
- **Death Dealer** is removed from **Agile** and added to **Powerful Strikes**. It moved to Tier 6 (up from Tier 4)
- **Deep Impact** (now **Breakthrough**) moved to T3 perk (down from Tier 6)
- **Dismantle** moved to Tier 6 perk (up from Tier 2)
- **Dismemberment** moved to Tier 2 perk (down from Tier 6)
- **Dodge** is removed from **Light Armor** group
- **Duelist** is removed from **Shield** group
- **Dynamic Duo** is removed from **Fast** group and added to **Agile** group
- **Wear them Down** is added to **Fast** group in Tier 3
- **Footwork** moved to Tier 1 (down from Tier 5)
- **Ghostlike** is now Tier 5 (up from Tier 4)
- **Inspiring Presence** added to **Noble** group
- **King of all Weapons** (now **Spear Flurry**) moved to Tier 6 perk (down from Tier 7)
- **Leverage** moved to Tier 7 (up from Tier 3)
- **Long Reach** moved to Tier 2 (down from Tier 7)
- **Marksmanship** is added to **Ranged** group. It is no longer a special perk
- **Overwhelm** is removed from **Ranged** group
- **Pathfinder** moved to Tier 3 (up from Tier 1). It is removed from **Wildling** group and added to **Leadership** group
- **Polearm Mastery** and **Fortified Mind** are removed from the **Leadership** group
- **Rally the Troops** moved to Tier 3 (up from Tier 2). It is added to **Soldier** group
- **Rattle** (now **Full Force**) moved to Tier 6 (up from Tier 3)
- **Student** is added to **General** group. It is no longer a special perk
- **Tricksters Purses** moved to Tier 3 (up from Tier 1)
- **Vigorous Assault** is removed from **Swift Strikes** group
- **Knave** no longer guarantees the **Dagger** perk group. Now it is just twice as likely. It also no longer guarantees the **Nimble** per group
- **Wildling** no longer prevents the perk groups **Ranged**, **Gifted** and **Leadership** from appearing
- **Leadership** perk group is now part of the **Shared** perk group collection and will compete with shared perk groups#
- **Soldier Group** no longer guarantees **Professional perk** or **Trained Group**. Instead it only applies a 2.5x multiplier for **Trained Group**
- **Tactician** is now a **Special** perk group and no longer replaces a shared perk group, when it appears

### Backgrounds

- **Assassin** now has +5 to minimum Ranged Skill (up from 0) and +10 to maximum Ranged Skill (up from 0)
- **Butcher** loses the Hitchance Bonus with **Butchers Cleaver**
- **Farmhand** loses the Hitchance Bonus with **Pitchforks** and **Hooked Blades**
- **Indebted** no longer roll **Pauper Perk Group**. Instead they randomly roll any one of the other exclusive perk groups (except swordmaster)
- **Lumberjack** loses the Hitchance Bonus with **Woodcutter's Axe** and **Hatchet**
- **Miner** loses the Hitchance Bonus with **Pickaxe**
- **Oathtaker** now spawn with +1 Weapon Group (down from +2)
- **Pimp** now has 0 to minimum Melee Skill (up from -5) and +5 to maximum Melee Skill (up from -5)
- **Shepherd** loses the Hitchance Bonus with **Slings**
- **Swordmaster** no longer has **Sword Mastery** unlocked by default. This perk is now moved to Tier 3 (down from 4) for them. They now have a hiring cost of 400 Crowns (down from 2400), just like in Vanilla

### Traits

- **Ailing** now also makes temporary injuries you receive during combat last 50% longer
- **Brute Trait** now grants 15% more damage instead of 15% more hitpoint damage. It is no longer negated by **Steelbrow** or enemies who are immune to critical damage
- **Huge** no longer increases the Reach by 1
- **Irrational** will no longer appear on recruits.
- **Night Blind** now causes -2 Vision during night (down from -1)
- **Night Owl** now grants +2 Vision during night (up from +1)
- **Lucky** no longer grants a chance to reroll incoming attacks. It now provides a 5% chance to avoid damage from any source
- **Tiny** no longer reduces the Reach by 1
- **Weasel** now provides an additional 25 Melee Defense during that brothers turn while fleeing

### Injuries

- Injuries now require 2 Medicine Supplies per day (up from 1)
- Injuries now have a 50% chance to improve each day when you have no remaining Medicine Supplies (up from 0%)
- **Collapsed Lung** no longer reduces the Stamina. Instead it now disables the use of **Recover**
- **Crushed Windpipe** no longer reduces the Stamina. Instead it now disables the use of **Recover**
- **Pierced Lung** now reduces Stamina by 30% (down from 60%) and disables the use of **Recover**
- **Grazed Neck**, **Cut Artery** and **Cut Throat** are no longer removed, when bandaged
- **Grazed Neck**, **Cut Artery** and **Cut Throat** no longer deals damage over time
- **Grazed Neck** now applies 1 stack of bleed when inflicted
- **Cut Artery** now applies 3 stack of bleed when inflicted
- **Cut Throat** now applies 6 stack of bleed when inflicted

### Misc

- Knockback of all skills is reworked and standardized. It still always knocks someone back in a straight line, if user and target are on the same axis and there is space behind the target. In all other cases the destination is now random, instead of fixed and clock-wise

## Items

### Weapons

- **Ancient Pikes** gains the **Spear** Weapontype
- **Berserk Chain** now has 4 Reach (down from 5)
- **Cruel Falchion** are now a Sword/Dagger hybrid. They now also grant **Stab**. **Slash** and **Rispote** lose any discount
- **Cudgel** now deals 40-60 damage (up from 30-50), has 4 Reach (up from 3), costs 400 Crowns (up from 300). **Bash** now costs 5 AP (up from 4). **Knock Out** now has a 100% chance to stun
- **Estoc** now has 6 Reach (up from 5)
- **Goblin Skewer** are now a Spear/Dagger hybrid. **Thrust** is replaced with **Stab**. **Spearwall** no longer has any discount. **Riposte** is removed
- **Goedendag** no longer grants **Cudgel** skill. It now has a 100% chance to stun with **Knock Out** (up from 75%)
- **Fighting Axe** now costs 2300 crowns (down from 2800)
- **Firelance** now also has the **Firearm** weapontype
- **Flail** now deals 30-55 damage (up from 25-55) and has 3 Reach (down from 4)
- **Goblin Pike** now has a Reach of 6 (down from 7) and gains the **Spear** Weapontype
- **Halberd** now has 6 Reach (down from 7)
- **Head Chopper** now has 4 Reach (up from 3)
- **Head Splitter** now has 4 Reach (up from 3) and deals 20 Shield Damage (up from 16)
- **Heavy Crossbow** now has +2 Fatigue Cost for its weapon skills
- **Hooked Blade** now deals 40-60 Damage (down from 40-70) and costs 550 Crowns (down from 700)
- **Longsword** now costs 2000 Crowns (down from 2400)
- **Lute** now has a 100% chance to stun with **Knock Out** (up from 30%), 6 Condition (up from 2) and 50% Armor Damage (up from 10%)
- **Pike** and gains the **Spear** Weapontype
- **Player Banner** now causes -5 to Ranged Defense and it grants **Repel**
- **Poleflail** now has 5 Reach (down from 6) and costs 1600 Crowns (up from 1400). Its skills **Flail** and **Lash** now cost 6 Action Points (up from 5)
- **Reinforced Wooden Poleflail** now has 5 Reach (down from 6). Its skills **Flail** and **Lash** now cost 6 Action Points (up from 5)
- **Spetum** now has a Reach of 7 (up from 6), a Weight of 12 (down from 14) and costs 900 Crowns (down from 1050). The named variant now costs 2800 Crowns (down from 3500)
- **Spiked Impaler** now has +2 Fatigue Cost for its weapon skills
- **Thorned Whip** now deals 20-35 Damage (up from 15-25), has a Weight of 10 (up from 6), has a Condition of 25 (down from 40) and costs 600 Crowns (up from 400)
- **Three-Headed Flail** now has 3 Reach (down from 4)
- **Throwing Spears** no longer inflict any fatigue when hitting a shield. They now have a Weight of 4 (down from 6) and costs 60 Crowns (down from 80)
- **Tree Limb** now deals 30-50 damage (up from 25-40), deals 90% Armor Damage (up from 75%), has 4 Reach (up from 3), a weight of 15 (down from 20), costs 300 Crowns (up from 150). **Bash** now costs 5 AP (up from 4). **Knock Out** now has a 100% chance to stun
- **Two-handed Flail** now has 4 Reach (down from 5)
- **Two-handed Wooden Flail** now has 4 Reach (down from 5)
- **Two-handed Wooden Hammer** now costs 600 Crowns (up from 500)
- **Warbow** now has a Weight of 8 (up from 6) and +2 Fatigue Cost for its weapon skills
- **Warfork** now has a Weight of 14 (up from 12) and costs 400 Crowns (down from 600)
- **Woodcutters Axe** now deals 35-60 damage (down from 35-70)
- **Zweihander** now has 6 Reach (down from 7)

### Armor Condition/Weight/Value changes

Side-by-side comparison between Old and New: https://github.com/Darxo/Hardened/wiki/Vanilla-Hardened-Armor-Changes

**Vanilla:**
- **Adorned Mail Shirt** now has 150 Condition (up from 130), 16 Weight (up from 11) and costs 1050 Crowns (up from 800)
- **Animal Hide Armor** now has 50 Condition (up from 45) and 8 Weight (up from 0)
- **Apron** now has 50 Condition (up from 25), 9 Weight (up from 0) and costs 70 Crowns (up from 55)
- **Assassins Robe** now has 80 Condition (down from 120) and 4 Weight (down from 9)
- **Basic Mail Shirt** now has 130 Condition (up from 115), 15 Weight (up from 11) and costs 600 Crowns (up from 450)
- **Blotched Gambeson** now has 10 Weight (up from 8) and costs 130 Crowns (down from 160)
- **Butcher's Apron** now has 50 Condition (up from 25), 9 Weight (up from 0) and costs 70 Crowns (up from 55)
- **Cloth Sash** now has 2 Weight (up from 0)
- **Cultist Leather Robe** now has 90 Condition (down from 88), 10 Weight (up from 9) and costs 300 Crowns (up from 240)
- **Dark Rugged Surcoat** now has 7 Weight (up from 4) and costs 120 Crowns (up from 100)
- **Dark Thick Tunic** now has 40 Condition (up from 35), 5 Weight (up from 2) and costs 80 Crowns (up from 75)
- **Gambeson** now has 70 Condition (up from 65) and 9 Weight (up from 6)
- **Heavy Iron Armor** now costs 1000 Crowns (up from 700)
- **Hide and Bone Armor** now has 100 Condition (up from 95), 15 Weight (up from 10) and costs 250 Crowns (up from 220)
- **Leather Lamellar Armor** now has 90 Condition (down from 95), 11 Weight (up from 10) and costs 250 Crowns (down from 300)
- **Leather Nomad Robe** now has 70 Condition (up from 65), 8 Weight (up from 7) and costs 150 Crowns (up from 140)
- **Leather Scale Armor** now has 15 Weight (down from 16)
- **Leather Tunic** now has 5 Weight (up from 0) and costs 50 Crowns (down from 65)
- **Leather Wraps** now has 4 Weight (up from 0) and costs 30 Crowns (down from 40)
- **Light Scale Armor** now has 19 Weight (down from 21)
- **Linen Tunic** now has 3 Weight (up from 0)
- **Linothorax** now has 80 Condition (up from 75), 9 Weight (up from 7) and costs 200 Crowns (up from 180)
- **Mail Hauberk** now has 170 Condition (up from 150) and 21 Weight (up from 18)
- **Mail Shirt** now has 150 Condition (up from 130), 18 Weight (up from 13) and costs 800 Crowns (up from 650)
- **Mail with Lamellar Plating** now has 160 Condition (up from 135), 18 Weight (up from 15) and costs 850 Crowns (up from 750)
- **Monk's Robe** now has 30 Condition (up from 20), 5 Weight (up from 0) and costs 50 Crowns (up from 45)
- **Noble Tunic** now has 30 Condition (up from 20) and 2 Weight (up from 0)
- **Nomad Robe** now has 4 Weight (up from 2)
- **Occult Robes** now has 70 Condition (down from 75) and costs 300 Crowns (up from 190)
- **Padded Leather** now has 10 Weight (up from 8) and costs 180 Crowns (down from 200)
- **Padded Surcoat** now has 60 Condition (up from 50), 8 Weight (up from 4) and costs 100 Crowns (up from 90)
- **Padded Vest** now has 7 Weight (up from 5) and costs 120 Crowns (down from 140)
- **Patched Mail Shirt** now has 100 Condition (up from 90) and 15 Weight (up from 10)
- **Plated Nomad Mail** now has 110 Condition (up from 105), 13 Weight (up from 11) and costs 400 Crowns (up from 350)
- **Reinforced Animal Hide Armor** now has 70 Condition (up from 65) and 11 Weight (up from 7)
- **Reinforced Leather Armor** now has 90 Condition (down from 100), 10 Weight (up from 9) and costs 300 Crowns (down from 500)
- **Rugged Surcoat** now has 50 Condition (down from 55), 7 Weight (up from 6) and costs 90 Crowns (down from 100)
- **Sackcloth** now has 20 Condition (up from 10), 4 Weight (up from 0) and costs 30 Crowns (up from 20)
- **Scrap Metal Armor** now has 80 Condition (up from 75), 12 Weight (up from 8) and costs 150 Crowns (up from 130)
- **Southern Mail Shirt** now has 13 Weight (up from 11)
- **Stiched Nomad Armor** now has 9 Weight (up from 8)
- **Tattered Sackcloth** now has 10 Condition (up from 5) and 4 Weight (up from 0)
- **Thick Furs** now has 40 Condition (up from 30) and 7 Weight (up from 1)
- **Thick Nomad Robe** now has 6 Weight (up from 5)
- **Thick Tunic** now has 40 Condition (up from 35), 6 Weight (up from 3) and costs 70 Crowns (down from 75)
- **Undertaker's Apron** now has 40 Condition (up from 30), 5 Weight (up from 0) and costs 80 Crowns (up from 65)
- **Wanderer's Coat** now has 60 Condition (down from 65), 7 Weight (up from 5) and costs 120 Crowns (down from 180)
- **BasicMailShirt** now has 130 Condition (up from 115), 15 Weight (up from 12) and costs 600 Crowns (up from 450)
- **Wizard's Robe** now has 30 Condition (up from 20), 1 Weight (up from 0) and costs 150 Crowns (up from 60)
- **Worn Mail Shirt** now has 110 Condition (up from 105), 14 Weight (up from 12) and costs 350 Crowns (down from 400)

**Reforged:**
- **Breastplate** now has 230 Condition (up from 210), 25 Weight (up from 24) and costs 4200 Crowns (up from 3600)
- **Brigandine Armor** now has 150 Condition (down from 230), 14 Weight (down from 26) and costs 3000 Crowns (down from 4600)
- **Brigandine Harness** now has 180 Condition (down from 270), 18 Weight (down from 28) and costs 4000 Crowns (down from 6000)
- **Brigandine Shirt** now has 110 Condition (down from 190), 9 Weight (down from 21) and costs 2000 Crowns (down from 3000)
- **Reinforced Footman Armor** now costs 3500 Crowns (down from 4000)

### Helmet Condition/Weight/Vision/Value changes

Side-by-side comparison between Old and New: https://github.com/Darxo/Hardened/wiki/Hardened-Helmet-Changes

**Vanilla:**
- **Adorned Closed Flat Top** now has 260 Condition (up from 250), 17 Weight (up from 15) and costs 2200 Crowns (up from 2000)
- **Adorned Full Helm** now has 20 Weight (up from 18) and costs 3500 Crowns (down from 3700)
- **Aketon Cap** now has 4 Weight (up from 1) and costs 80 Crowns (up from 70)
- **Ancient Honor Guard Helmet** now has 15 Weight (up from 13) and costs 900 Crowns (up from 1000)
- **Ancient Household Helmet** now has 100 Condition (up from 95)
- **Ancient Legionary Helmet** now costs 400 Crowns (down from 600)
- **Assassin's Face Mask** now has 130 Condition (down from 140), 8 Weight (up from 6) and costs 500 Crowns (up from 1800)
- **Assassin's Head Wrap** now has 60 Condition (up from 40), 1 Weight (up from 0), -2 Vision (down from 0) and costs 900 Crowns (up from 60)
- **Barbute Helmet** now has 180 Condition (down from 190) and costs 2500 Crowns (down from 2600)
- **Bascinet with Mail** now has 230 Condition (up from 210) and 16 Weight (up from 13)
- **Bear Headpiece** now has 60 Condition (up from 50), 7 Weight (up from 3), -1 Vision (down from 0) and costs 80 Crowns (up from 100)
- **Beastmaster's Headpiece** now costs 500 Crowns (up from 350)
- **Blade Dancer's Head Wrap** now has -2 Vision (down from 0) and costs 900 Crowns (up from 150)
- **Closed Flat Top Helmet** now has 180 Condition (up from 170), 12 Weight (up from 10) and costs 1100 Crowns (up from 1000)
- **Closed Flat Top with Mail** now costs 300 Crowns (down from 3000)
- **Closed Mail Coif** now has 100 Condition (down from 90), 6 Weight (up from 4), -1 Vision (down from 0) and costs 450 Crowns (up from 250)
- **Closed Scrap Metal Helmet** now has 200 Condition (up from 190), 17 Weight (down from 18) and -3 Vision (down from -2)
- **Closed and Padded Flat Top** now has 12 Weight (up from 11)
- **Conic Helmet with Closed Mail** now has 260 Condition (down from 265), 17 Weight (down from 18) and -3 Vision (down from -2)
- **Covered Decayed Closed Flat Top with Mail** will no longer appear in the game. Any versions of it will instead change to look like **Decayed Closed Flat Top with Mail**
- **Crude Faceguard Helmet** now has -3 Vision (down from -2)
- **Crude Metal Helmet** now has 130 Condition (down from 145) and costs 400 Crowns (down from 550)
- **Cultist Hood** now has 50 Condition (up from 30), 4 Weight (up from 0), -3 Vision (down from -1) and costs 50 Crowns (up from 20)
- **Cultist Leather Hood** now has 80 Condition (up from 60), 7 Weight (up from 3), -3 Vision (down from -1) and costs 90 Crowns (up from 140)
- **Dark Cowl** now has 30 Condition (down from 40), 3 Weight (up from 0), -1 Vision (down from 0) and costs 30 Crowns (up from 100)
- **Decayed Closed Flat Top with Mail** now has 220 Condition (down from 230), 18 Weight (down from 19) and costs 1200 Crowns (down from 1250)
- **Decayed Great Helm** now has 240 Condition (down from 255) and 23 Weight (up from 22)
- **Decorated Full Helm** now has 300 Condition (down from 320), 23 Weight (up from 21) and costs 5000 Crowns (up from 4000)
- **Desert Stalker's Head Wrap** now has 40 Condition (down from 45), 1 Weight (up from 0) and costs 900 Crowns (up from 120)
- **Duelist's Hat** now has 50 Condition (down from 70), 1 Weight (down from 3), -1 Vision (down from 0) and costs 900 Crowns (up from 200)
- **Engineer's Hat** now has 60 Condition (up from 30), 4 Weight (up from 0) and costs 500 Crowns (up from 50)
- **Feathered Hat** now has 40 Condition (up from 30), 5 Weight (up from 0) and costs 50 Crowns (down from 80)
- **Flat Top Helmet** now has 160 Condition (up from 125), 10 Weight (down from 7), -2 Vision (down from -1) and costs 800 Crowns (up from 500)
- **Flat Top with Closed Mail** now has 260 Condition (down from 265) and costs 2500 Crowns (down from 2600)
- **Flat Top with Mail** now has 240 Condition (up from 230) and 16 Weight (up from 15)
- **Full Aketon Cap** now has 60 Condition (up from 50), 6 Weight (up from 2) and -1 Vision (down from 0)
- **Full Leather Cap** now has 60 Condition (up from 45), 6 Weight (up from 3), -1 Vision (down from 0) and costs 100 Crowns (down from 80)
- **Gladiator Helmet** now has 230 Condition (up from 225), -4 Vision (down from -3) and costs 2500 Crowns (up from 2200)
- **Gunner's Hat** now has 70 Condition (up from 30), 4 Weight (up from 0), -1 Vision (down from 0) and costs 500 Crowns (up from 50)
- **Headscarf** now has 2 Weight (up from 0) and costs 20 Crowns (down from 30)
- **Heavy Horned Plate Helmet** now has and costs 1500 Crowns (up from 1300)
- **Heavy Lamellar Helmet** now has 260 Condition (up from 255) and 18 Weight (up from 17)
- **Heavy Mail Coif** now has 120 Condition (up from 110), 7 Weight (up from 5), -1 Vision (down from 0) and costs 600 Crowns (up from 375)
- **Hood** now has 3 Weight (up from 0), -1 Vision (down from 0) and costs 30 Crowns (down from 40)
- **Hunter's Hat** now has 2 Weight (up from 0)
- **Jester's Hat** now has 40 Condition (up from 30), 6 Weight (up from 0), -1 Vision (down from 0) and costs 40 Crowns (down from 70)
- **Kettle Hat with Closed Mail** now has 18 Weight (up from 17)
- **Kettle Hat with Mail** now has 230 Condition (up from 215), 16 Weight (up from 14), -1 Vision (up from -2) and costs 1700 Crowns (up from 1500)
- **Kettle hat** now has 130 Condition (up from 115), 8 Weight (up from 6) and costs 500 Crowns (up from 450)
- **Leather Head Wrap** now has 50 Condition (up from 40), 5 Weight (up from 2), -1 Vision (down from 0) and costs 80 Crowns (up from 60)
- **Leather Headband** now has 20 Condition (down from 30), 2 Weight (up from 0) and costs 20 Crowns (down from 30)
- **Leather Helmet** now has 100 Condition (down from 105), 7 Weight (up from 6) and costs 200 Crowns (down from 320)
- **Mail Coif** now has 6 Weight (up from 4) and costs 350 Crowns (up from 200)
- **Masked Kettle Helmet** now has 140 Condition (up from 120), 8 Weight (up from 6), -3 Vision (down from -2) and costs 500 Crowns (down from 550)
- **Mouth Piece** now has 20 Condition (up from 10), 2 Weight (up from 0) and costs 20 Crowns (up from 15)
- **Nasal Helmet** now has 120 Condition (up from 105), 7 Weight (up from 5) and -2 Vision (down from -1)
- **Nasal Helmet With Rusty Mail** now has 130 Condition (down from 140), 10 Weight (down from 9) and costs 400 Crowns (down from 600)
- **Nasal Helmet with Closed Mail** now has 250 Condition (up from 240), 18 Weight (up from 16) and costs 2200 Crowns (up from 2000)
- **Nasal Helmet with Mail** now has 14 Weight (up from 12)
- **Nomad Head Wrap** now has 3 Weight (up from 0), -1 Vision (down from 0) and costs 30 Crowns (down from 40)
- **Nomad Leather Cap** now has 60 Condition (up from 50), 6 Weight (up from 2), -1 Vision (down from 0) and costs 100 Crowns (down from 110)
- **Nomad Light Helmet** now has 60 Condition (down from 70), 5 Weight (up from 3), -1 Vision (down from 0) and costs 120 Crowns (down from 140)
- **Nomad Reinforced Helmet** now has 130 Condition (up from 125) and costs 500 Crowns (up from 450)
- **Nordic Helmet** now has 170 Condition (up from 125), 8 Weight (up from 7), -3 Vision (down from -1) and costs 1500 Crowns (down from 500)
- **Nordic Helmet with Closed Mail** now has 260 Condition (down from 265), 17 Weight (down from 18) and -3 Vision (down from -2)
- **Open Leather Cap** now has 50 Condition (up from 40), 5 Weight (up from 2), -1 Vision (down from 0) and costs 80 Crowns (up from 60)
- **Padded Dented Nasal Helmet** now has 120 Condition (up from 110) and -2 Vision (down from -1)
- **Padded Flat Top Helmet** now has 160 Condition (up from 150), 10 Weight (down from 9) and -2 Vision (down from -1)
- **Padded Kettle hat** now has 130 Condition (down from 140) and costs 500 Crowns (down from 650)
- **Padded Nasal Helmet** now has 120 Condition (down from 130), -2 Vision (down from -1) and costs 350 Crowns (down from 550)
- **Physician's Mask** now has 5 Weight (up from 3), -3 Vision (down from -1) and costs 150 Crowns (down from 170)
- **Reinforced Mail Coif** now has 120 Condition (up from 100), 6 Weight (up from 5), -2 Vision (down from -1) and costs 600 Crowns (up from 300)
- **Rusty Mail Coif** now has 80 Condition (up from 70), 9 Weight (up from 4) and costs 200 Crowns (up from 150)
- **Sallet Helmet** now has 7 Weight (up from 5)
- **Southern Head Wrap** now has 3 Weight (up from 0), -1 Vision (down from 0) and costs 30 Crowns (down from 50)
- **Southern Helmet with Coif** now has 180 Condition (down from 200) and -1 Vision (up from -2)
- **Spiked Skull Cap with Mail** now has 130 Condition (up from 125) and 8 Weight (up from 7)
- **Steppe Helmet with Mail** now has 14 Weight (up from 12)
- **Straw Hat** now has 3 Weight (up from 0), -1 Vision (down from 0) and costs 30 Crowns (down from 60)
- **Turban Helmet** now has 280 Condition (down from 290), 19 Weight (down from 20) and costs 3000 Crowns (down from 3200)
- **Undertaker's Hat** now has 50 Condition (up from 40), 3 Weight (up from 0) and -1 Vision (down from 0)
- **Witchhunter's Hat** now has 50 Condition (up from 40), 3 Weight (up from 0), -1 Vision (down from 0) and costs 120 Crowns (up from 100)
- **Wizard's Hat** now has 50 Condition (up from 30), 2 Weight (up from 0), -1 Vision (down from 0) and costs 300 Crowns (up from 30)
- **Wrapped Southern Helmet** now has 100 Condition (down from 105), 6 Weight (up from 5) and costs 450 Crowns (up from 350)
- **Zweihander's Helmet** now has 8 Weight (up from 7) and costs 1500 Crowns (up from 850)

**Reforged:**
- **Closed Bascinet with Mail** now has 230 Condition (down from 260), 14 Weight (down from 17), -2 Vision (down from -3) and costs 2500 Crowns (up from 2400)
- **Conical Billed Helmet** now has 140 Condition (down from 220), 6 Weight (up from 12) and costs 2000 Crowns (down from 2500)
- **Duelist's Helmet** now has 8 Weight (up from 7) and costs 1500 Crowns (down from 2000)
- **Great Helm** now has 370 Condition (up from 360), 27 Weight (up from 26) and costs 5200 Crowns (up from 4500)
- **Half Closed Sallet** now has -3 Vision (up from -2) and costs 3000 Crowns (up from 2400)
- **Half Closed Sallet with Bevor** now has 330 Condition (up from 315), 23 Weight (up from 20) and costs 4800 Crowns (down from 5000)
- **Half Closed Sallet with Mail** now has 280 Condition (down from 290), 16 Weight (down from 18), -3 Vision (up from -2) and costs 4500 Crowns (up from 4000)
- **Hounskull Bascinet with Mail** now has 350 Condition (up from 340), 25 Weight (up from 22) and costs 5000 Crowns (down from 6000)
- **Padded Conical Billed Helmet** now has 140 Condition (down from 245), 6 Weight (up from 14) and costs 2000 Crowns (down from 2900)
- **Padded Sallet Helmet** now has 150 Condition (down from 180), 8 Weight (down from 9) and costs 1250 Crowns (down from 2000)
- **Padded Scale Helmet** now has 110 Condition (down from 115) and costs 350 Crowns (down from 375)
- **Padded Skull Cap** now has 8 Weight (up from 7) and costs 800 Crowns (up from 1200)
- **Padded Skull Cap with Rondels** now has 150 Condition (down from 160) and costs 1250 Crowns (down from 1500)
- **Sallet Helmet** now has 8 Weight (up from 7) and costs 1250 Crowns (down from 1500)
- **Sallet Helmet with Bevor** now has 270 Condition (down from 275), 16 Weight (down from 17) and costs 4500 Crowns (up from 3500)
- **Sallet Helmet with Mail** now has 180 Condition (down from 240), 11 Weight (down from 14), -1 Vision (down from -2) and costs 2000 Crowns (down from 2500)
- **Scale Helmet** now has 110 Condition (down from 90), 7 Weight (up from 5) and costs 350 Crowns (up from 300)
- **Skull Cap** now has 140 Condition (up from 115) and  8 Weight (up from 5)
- **Skull Cap with Mail** now has 190 Condition (down from 210), 14 Weight (up from 12), -1 Vision (down from -2) and costs 1250 Crowns (down from 2000)
- **Skull Cap with Rondels** now has 150 Condition (up from 130), 8 Weight (up from 6) and costs 1250 Crowns (up from 1000)
- **Snubnose Bascinet with Mail** now has 350 Condition (up from 330), 25 Weight (up from 21) and costs 5000 Crowns (down from 5500)
- **Visored Bascinet** now has 350 Condition (up from 300), 25 Weight (up from 19) and costs 5000 Crowns (up from 4500)

### Other Item Changes

- Loot from beasts (like webbed valueables, ancient amber, etc.) are no longer affected by situations like **Collector**
- Food now only loses value once half of its shelf life is over
- **Adarga** is now called **Adarga Shield** (just like in Vanilla)
- **Apothecary\'s Miracle** is now marked as `IsMedical`, causing it to be affected by medical-related settlement situations
- **Antidote** now costs 100 Crowns (down from 150). Crafting it now costs 40 Crowns (down from 50) and 1 Jagged Fang (down from 2). It is now considered `IsMedical` causing it to be affected by medical-related settlement situations
- **Bandage** costs 40 Crowns (up from 25). It is now considered `IsMedical` causing it to be affected by medical-related settlement situations
- **Buckler** appear less common in big settlements
- **Tarnished Full Helm** now grants +5 Threat (similar to Direwolf Pelt). It now only appears in the Full Helm looking variants
- **Decayed Reinforced Mail Hauberk** no longer appears with the Variant 50, which is a skin that looks too similar to **Worn Mail Shirt**
- **Decorated Full Helm** now grants +10 Resolve
- **Gun Powder** now costs 2 **Ammunition Supply** each (up from 1)
- **Fangshire** will no longer spawn at the start of the game
- **Feral Shield** now costs 400 Crowns (up from 50)
- **Fermented Unhold Heart** now has an expiry date of 40 days (up from 20)
- **Goblin Poison** now has a value of 200 (up from 100)
- **Heraldic Cape** attachement now has 20 Condition (up from 5), 0 Weight (down from 1), 1000 Value (up from 200) and grants 10 Resolve (up from 5)
- **Hyena Fur Mantle** now grants 10% more Initiative instead of +15 Initaitive
- **Reinforced Throwing Net** now has a weight of 8 (up from 2)
- **Sergeant's Sash** now only provides the +10 Resolve if its user has the perk **Rally the Troops**
- **Sipar** is now called **Sipar Shield** (just like in Vanilla)
- **Strange Meat** now costs 35 Crowns (down from 50)
- **Smoke Bomb** costs 400 Crowns (up from 275). Smoke now lasts 2 Rounds (up from 1)
- **Throwing Net** now has a weight of 4 (up from 2)
- **Tools and Supplies** are now marked as `IsBuildingSupply`, causing them to be affected by building-supply-related settlement situations
- **Unhold Fur Cloak** now grants 15 Condition (up from 10)
- **Wooden Shields** appear less common in marketplaces
- **Worn Mail Shirt** can now appear in the Variant 50, which is a skin that previously was used by **Decayed Reinforced Mail Hauberk**
- Ammo now has weight. All **Quivers** and **Powder Bags** weigh 0 when empty. When full, regular ones weigh 2, **Large Quivers** weigh 5, and **Large Powder Bags** weigh 4.
- The value of almost all other non-named shields is increased by 50%-100%

## Retinue/Follower

- **Blacksmith** no longer requires you to repair 5 items in a town. It now requires you to use 5 paint or attachements. It no longer grants a tool consumption discount. It now grants +50 storage space for Tools
- **Bount Hunter** costs 2500 Crowns (down from 4000). It now grants +5% for enemies to become champions (up from +3%). It no longer grants Crowns when you kill champions
- **Drill Sergeant** now requires a brother with a permanent injury to be dismissed (just like in Vanilla)
- **Lookout** no longer grants 25% more vision at all times. It now always provides a scouting report for enemies near you, just like "Band of Poachers" origin
- **Quartermaster** now grants 150 Storage for Ammunition (up from 100) and 100 Storage for Tools and Medicine (up from 50)
- **Scout** no longer grants 15% more movement speed. It now grants 20% more movement speed while in Forests and Swamp. It also grants 25% Vision while on hills or mountains
- **Surgeon** now also counts Injuries treated by Bandages for its Requirement
- **Trader** now also makes Trading Goods 100% more common in shop

## Enemies

### Generic Changes

- Introduce a new **Headless** effect. It redirects any attack to hit the body, reduces all other damage targeting the head to 0 (e.g. secondary attack from Split Man), grants immunity to **Distracted** and **Sleep** and sets the headarmor to 0
	- This effect is given to **Ifrits**, **Spider Eggs**, **Headless Zombies**, **Saplings**, **Lindwurm Tails** and **Kraken Tentacles**
	- **Ifrit**, **Saplings** and **Kraken Tentacle** lose the now redundant **Steelbrow** perk
	- **Wiederganger**, which receive this effect, lose **Bite** and gain **Zombie Punch** (which is mostly the same, except without bonus headshot chance)
- Introduce new **Bite Reach** effect, which reduces headshot chance by 10% and increases chance to receive headshot by 10%
	- This effect is given to all **Dogs**, **Wolfs** and **Hyenas**

### Specific Changes

**Brigands:**
- **Scoundrels** no longer spawn with **Wooden Shields**. Instead they can now spawn with **Old Wooden Shields**. They now spawn with a **Knife** instead of **Dagger**/**Woodcutters Axe**. They now have 40 Ranged Skill (down from 45)
- **Vandals** no longer spawn with **Kite Shields**. Instead they can now spawn with **Old Wooden Shields**
- **Raider** lose **Shield Expert**. They no longer spawn with **Kite Shields**. Instead they can now spawn with **Worn Kite/Heater Shields**
- **Highwaymen** can now also spawn with **Worn Kite/Heater Shields**
- **Thug** now spawn with **Tree Limb** instead of **Goedendag**. They now have 40 Ranged Skill (down from 45) and 110 Stamina (up from 100)
- **Pillager** can now also spawn with **Cudgel**. **Pillager** no longer spawn with **Woodcutters Axe**, **Two Handed Mace** or **Two Handed Hammer**
- **Outlaws** now have **Vigorous Assault** and always have **Formidable Approach**. They no longer spawn with **Battle Axe**, **Two Handed Wooden Flail** or **Greatsword**
- **Marauder** no longer spawn with **Two Handed Wooden Flail** and are twice as likely to spawn with a **Greatsword**
- Fast Brigands (**Robber, Bandit, Killer**) now always spawn with a net if they are one-handed, and with a throwing weapon if two-handed. They also have cosmetic face warpaint
- **Robber** no longer spawn with a **Pike** or **Reinforced Wooden Poleflail**. They now have 60 Ranged Skill (up from 55)
- **Bandits** no longer spawn with a **Poleflail**, **Warbrand** or **Throwing Spear**. The can now spawn with a **Reinforced Wooden Poleflail**. They now have 70 Ranged Skill (up from 60)
- **Killer** no longer spawn with **Scramasax**, **Pike**, **Spetum**, **Warbrand** or **Throwing Spear**. They now have 80 Ranged Skill (up from 70). They can now appear as Champions
- **Brigand Poachers** now have 45 Melee Skill (down from 50)
- **Brigand Leader** lose **Shield Expert**
- **Hedge Knights** are now immune to **Disarm** as a result of them having **Savage Strength**
- **Master Archer** now have 110 Initiative (down from 140)
- **Wardogs** now have 50 Melee Skill (down from 55), 20 Melee Defense (down from 25), 25 Ranged Defense (down from 30) and 5 Vision (down from 7)

**Humans:**
- **Assassins** gain **Elusive** and **Scout** and they lose **Footwork** and **Double Strike**. They will now drink a non-droppable nightowl elixir during night fights
- Peasant Parties now drop 0 Crowns (down from 0-50). Peasants killed in battle now randomly drop Crowns, food or tools or a valueable ring
- **Fencer** who spawn with an **Estoc** now have **Formidable Approach** instead of **Duelist**
- **Footmen** lose **Shield Expert** and **Exploit Opening**
- **Heavy Footmen** lose **Exploit Opening**
- **Mercenaries** now use Shields that are colored in their respective Banner colors. They now have a 30% chance to spawn with a Bandage in their bag
- **Swordmaster** now only appear in the variation **Versatile**, **Blade Dancer** or **Metzger**. They will now always spawn with a one-handed swords and never with a shield. Swordmasters gain **Parry** and **Calculated Strikes** and always spawn with **Duelist**. They lose **Dodge**, **Executioner** and **Formidable Approach**. They now have 40 Melee Defense (down from 60) and 40 Ranged Defense (up from 20)

**Undead**
- All **Wiederganger** types gain +5 Melee Skill and take 50% more burning damage to hitpoints. They grant 20% more experience but no longer grant experience after being ressurected. They lose 10 Hitpoints, **Double Grip** and no longer grant experience after being ressurected. They now have a 100% resurrection chance (up from 66%) and resurrect in 1-3 turns (up from 1-2)
- Normal **Wiederganger** lose **Overwhelm**
- All **Skeletons** no longer grant experience after being ressurected
- **Fallen Heroes** no longer spawn with Morning Stars or Handaxes. They now have a 100% resurrection chance (up from 90%) but -10 Hitpoints. Champion variants lose **Nine Lives**
- **Flesh Golems** lose **Full Force** and take 50% more burning damage to hitpoints
- **Geists** lose **Fearsome**. They now have **Backstabber**
- **Necromancer** lose 20 natural body armor and **Inspiring Presence**. **Raise Undead** and **Possess Undead** now cost 15 Fatigue (up from 10)
- **Necrosavants** now require the target to have red blood in order to leech life from them, instead of being able to leech life from anyone
- **Ancient Auxiliary** lose **Battleforged**
- **The Conqueror** now has **Savage Strength**. This has no gameplay impact and is only meant to visualize that he is immune to **Disarm**

**Greenskins:**
- All **Goblins** have -5 Melee Skill and -5 Melee Defense
- All **Goblins** (except **Wolfrider** while riding a wolf) lose **Pathfinder** and gain **Elusive**
- All **Goblins** (except **Goblin Overseer** and **Champion Goblin Ambusher**) lose **Bullseye**
- Add new **Goblin** racial effect that grants 50% increased defenses from equipped shield and allows them to use **Shieldwall** with any shield
- **Champion Goblin Ambusher** lose **Target Practice**
- **Goblin Ambusher** now always spawn with the **Reinforced Boondock Bow** variant
- **Orc Warlords** now have **Savage Strength** which makes them immune to **Disarm**

**Barbarian**
- **Warhounds** now have 100 Initiative (down from 110) and 5 Vision (down from 7)
- **Barbarian Thralls**  lose **Survival Instinct** and now have +5 Melee Defense and +5 Ranged Defense. They now spawn twice as often with **Crude Javelins** and half as often with regular throwing weapons
- **Barbarian Drummer** lose **Survival Instinct** and now have +10 Melee Defense and +10 Ranged Defense. They now have +1 Action Point and grant +150 Experience
- **Barbarian Kings** now have **Savage Strength** which makes them immune to **Disarm**

**Beasts:**
- **Alps** now have **Elusive**
- **Bog Unholds** now recover 20% of their Hitpoints per turn (up from 15%) and they can now use **Split Shield** costing 5 Action Points and dealing 50 Shield Damage. They lose **Dismantle** and **Full Force**
- **Donkeys** now grant 0 XP (down from 50 XP). They can now be rooted, injured, bled and poisoned. Since they are non-combatants this is mostly a cosmetic change
- **Frost Unholds** and **Armored Frost Unholds** now have 150 natural Body and Head Armor (up from 90). They lose **Dismantle** and **Full Force**
- Add new **Hexen** racial effect that increases the duration of debuffs by 1 turn for the Hexe
- All **Ifrits** gain **Man of Steel**. They can now free themselves from nets and roots. They take no Burning Damage (up from 90% less), full damage from blunt ranged attacks (down from 66% less) and 50% less damage from Piercing Damage (down from 50% less against melee and 66% less against ranged). The damage reduction on Ifrits now also affects the armor damage they receive
  - **Small Ifrits** now have 55 Hitpoints (down from 110) and 165 Armor (up from 110)
  - **Medium Ifrits** now have 110 Hitpoints (down from 220) and 220 Armor (up from 110). They lose 10 Damage and gain **Marksmanship**
  - **Large Ifrits** now have 220 Hitpoints (down from 440) and 330 Armor (up from 110). They lose 10 Damage and gain **Marksmanship**
- **Lindwurms Head** and **Tail** no longer share hitpoints and effects but killing the Tail will no longer kill the Head
  - **Lindwurm Heads** now have 1000 Hitpoints (down from 1100), 20 Melee Defense (up from 10) and gain **Exude Confidence**. They lose **Formidable Approach**
  - The **Lindwurm Tail** still inherits most of the stats from the head but has 50% less Hitpoints and Resolve and 50% more Melee Defense. They lose **Fearsome**
  - The **Lindwurm Tail** can now be stunned and netted but those effects are removed whenever the Head moves away
- All **Nachzehrer** lose **Deep Cuts**
  - **Small Nachzehrer** lose 10 Melee Defense and gain **Ghostlike**
  - **Large Nachzehrer** can no longer swallow player characters while in a net. They can now also swallow the last player character who is alive
- **Unholds** and **Armored Unholds** now have 600 Hitpoints (up from 500) and recover 10% of their Hitpoints per turn (down from 15%). They lose **Dismantle** and **Full Force**
- **Schrats** no longer take 70% reduced damage while their shield is up. They now have +200 Hitpoints and gain the **One with the Shield** perk
- **Serpent** can now hook even while rooted. They can no longer hook while engaged in melee

### Dynamic Party Adjustments

- Bandit Parties will now only field at most two of the following unit blocks at the same time: Fast, Tough, Ranged
- Fast Brigands (**Robber** -> **Bandit** -> **Killer**) now upgrade slightly earlier
- Add **Highwayman** as new T1 of the Banditleader Unitblock. Banditleader Unitblock now require a StartingResourceMin of 180 (down from 250)

### AI

- NPCs now know how to use Bandages
- NPC ranged troops attribute a target 80% less score from adjacent potential scatter targets
- Necrosavants are a bit more likely to stay on the same tile and attack twice, rather than teleport to a slightly better tile
- Improve AI targeting for throwing nets: They value the targets melee defense twice as much and prefer isolated targets
- NPCs with **Sergeant** perk are 50% more attractive to other NPCs for target selection purposes
- NPCs are now twice as likely to throw a net or use a throwing pot/bomb while adjacent to an enemy
- NPCs will no longer throw nets while their strategy is defending
- NPCs with **Bolster** are more likely to attack with their polarm as they are surrounded by more allies
- NPCs with **Dismantle** are more likely to target enemies with 100% hitpoints
- NPCs with **Reload Disorientation** are slightly less likely to use a ranged attack
- NPCs with **Supporter** are 100% more likely to use skills, which would recover Action Points
- NPCs with **Sweeping Strikes** are more likely to use an appropriate attack as they are surrounded by more enemies
- NPCs with **Wear them Down** 20% more likely to target someone who is almost fully fatigued
- NPCs are 100% more likely to use **Throw Dirt** for every fleeing ally adjacent to the target
- NPCs are 20% more likely to target enemies with **Formidable Approach** if it has been procced against them
- NPCs are 20% more likely to target someone with **Kingfisher** who is currently netting them and 10% more likely to target them, if they are netting anyone
- NPCs are 10% more likely per **Unstoppable** stack on the target, to use a skill which applies staggered on a hit
- NPCs are 50% less likely to attack into an active **Rebuke**
- NPCs are more likely use **Disarm** onto enemies with **Spearwall** or **Riposte**
- NPCs are 1% less likely to use **Break Free** for every Melee Defense below 20 that they have and 1% more likely per Melee Defense above 20
- NPCs are 20% more likely to try to destroy shields of someone with **Phalanx** perk
- NPCs are 50% more likely to try to destroy shields of someone with **One with the Shield** perk
- NPCs are 1% more likely to focus Nachzehrer sitting on consumable corpses for every % of hitpoints missing on them
- NPCs are 200% more likely to target a fleeing character with **Command**
- NPCs with **Toolbox** are 50% more likely to target a staggered enemy with a blunt throwing attack
- NPCs are 50% more likely to use **Split Shield** when it would destroy a shield on use
- NPCs are 20% more likely to use a throwing spear against shield users and 50% more likely to target shields, that it would destroy on use
- NPCs are 20% more likely to use **Disarm** or **Knock out** on someone who has **Parry**
- NPCs are 100% more likely to use rotating skills onto allied Nachzehrer if that would put them on top of a corpse; and 50% less likely if that would put them away a corpses. And vice versa with hostile nachzehrers

## Combat General

- Every Defender of a Location which was fortified now gets a new **Defenders Advantage** effect for that fight, which grants +2 Vision and +15 Resolve
- **Encumbrance** no longer lowers the fatigue recovery. It now only adds 1 fatigue per tile travelled per encumbrance level. It no longer requires a minimum armor weight of 20
- **Wait** now debuffs the actual Initiative until the start of that brothers next turn
- Equipped Ammo Items can no longer be dropped to the ground or into an empty inventory slot
- **Swamp** tiles no longer reduce Melee Skill by 25%. Instead they now reduce Initiative by 25%
- The **Hidden** effect (granted by certain tiles) now also provides +10 Ranged Defense and it lists enemies that can shoot you despite you are currently revealed to
- Characters can no longer retreat from the battle when standing on a border tile, if they are engaged in melee
- Any fleeing character who rallies, loses 3 Action Points
- All fleeing characters now have +1 Action Point
- All player characters now have +1 Action Point during AutoRetreat
- Armor Penetration is capped at 100%. Any Armor Penetration above 100% has no effect. Reaching 100% Armor Pen still has damage reduction from remaining armor applied
- No characater can receive more than one negative morale check, caused by a fleeing ally, per turn
- Dying or Fleeing characters no longer trigger negative morale checks for their allies if the distance between them is greater than the vision of the receiving ally
- Characters no longer gain +1 additional Resolve against morale checks from fleeing allies, per ally in the battlefield
- Resurrecting Corpses can no longer knock back characters that are rooted or immune to Displacement. Instead they delay their resurrection
- Burning Damage (Fire Pot, Burning Arrow, Burning Ground) now remove all root-like effects from the targets
- Characters which are not visible to the player will no longer produce idle or death sounds
- Weapons no longer drop to the ground when their condition goes to 0. Instead they drop when the condition is lowered, while it was at 0 condition. The weapon break warning is now only displayed while the weapon is at 0 condition
- Weapons with 0 Condition now deal 50% less damage
- The combat map is no longer revealed at the end of a battle

## Crisis

**Undead:**
- Humans now only turn into zombies when the killer is from the Zombie or Undead faction
- Humans now have a resurrect chance of 100 (up from 33) and have a resurrect delay of 1-3 rounds (down from 2-3)

## World Map

- Try out now costs 100% more. You can now dismiss recruits after you tried them out to make room for new recruits
- You can now get up to 6 Tavern Rumors every cycle (up from 4)
- Tavern Rumors now have a linearly scaling cost. Each paid rumor costs an amount based on the standard (vanilla) rumor price, multiplied by the number of the paid rumor you are about to buy
- Named weapons now have a 40% chance to be the chosen item type for camps (up from 25,9%). Named shields, helmets and armor now have a 20% chance to be chosen (down from 24,7%)
- Food Products transported by Caravans now always drop at full stacksize and freshness
- World Parties are no longer stunned, when you cancel the combat dialog with them
- Hostile Locations will no longer spawn roaming parties or defenders while you are within 2 tiles of it
- At the start of each new campaign ~5 additional small bandit camps are spawned in the world
- The legendary Location **Ancient Spire** now reveals an area of 3000 (up from 1900)
- Defeating the Ijirok now also drops **Sword Blade** item, which allows you to do the Rachegeist fight without having to kill the Kraken
- Armorsmiths will now sometimes sell Named Shields
- Small civilian settlements now sell **Old Wooden Shields** and **Lute**
- Big northen settlements now sometimes sell **Worn Kite Shields** and **Worn Heater Shields**
- Weaponsmiths and Armorsmiths now sell **Armor Parts** with a price multiplier of 1.25
- Fletcher now sell roughly 5 times as many **Throwing Spears** but with a price multiplier of 1.5 (up from 1.0)
- Nets sold by Fletcher now have a price multiplier of 2.0 (down from 3.0)

## Contracts

- Necrosavants in the scripted Caravan Contract Ambush now idle during the first round
- **Caravan Contracts** that are declined or which expire now spawn a caravan towards the destination if the town hasn't spawned one in a while
- The **Barbarian King** and **Find Location** contracts no longer spawn a hint directly after loading and display the direction information of your last hint in your bullet points

## Events

- The Retinue-Slot Event will now trigger shortly after you unlock a new slot and will no longer replace a regular event
- The Event **Drunkard loses Item** now has an option where you order the Drunkard to search for the item. This recovers the item, but causes the same mood debuff on the drunkard as if he was flogged
- The Event **Infected Wound** now has a cooldown of 14 days (down from 21 days) and is thrice as likely to trigger, if you have no Medicine left
- The Event-Option to shoot down the bird who shat your brother now costs 5 Ammunition
- The **Orc Slayer** and **Crusader** (temporary Crisis backgrounds) now share 100% of their experience with your remaining party, when they leave you after the Crisis ended

## Other

- Level-Ups for Attribute with 2 stars have -1 to minimum roll and +1 to maximum roll (compared to Vanilla) and are fully randomized in that range (compared to Reforged)
- The **Lone Wolf** and **Gladiator** origins now have a roster size of 13 (up from 12)
- Beginner combat difficulty now grants enemy parties 100% resources (up from 85%)
- Beginner combat difficulty now causes player characters to receive 15% less damage from all sources
- Expert combat difficulty now grants enemy parties 120% resources (up from 115%)
- The Retreat tooltip during combat now also lists the Melee Defense bonus your characters receive during Auto-Retreat

## Quality of Life

### Combat

- Your headshot chance is now displayed in the combat tooltip when targeting enemies
- While previewing movement, tile tooltips show chances and calculations for getting hit by enemies while in zone of control. If not in zone of control tile tooltip instead indicates that
- Introduce a new **Unworthy** effect which prevents the character from granting experience on death. This is given to all non-player controlled characters who grant 0 XP on death or are allied to the player
- Introduce a new cosmetic **Non-Combatant** effect, given to non-combatant characters, which explains that they do not need to be killed in order to win
- Improve restore item after battle logic, to also restore items, which were dropped to the ground or picked up by another brother during battle
- Automatically replace broken (shields) or used (nets) equipment after each battle, if you have replacements in your inventory
- Add Setting (on) to display a glowing red eyes effect on any human-sized character, who is under the effect of **Killing Frenzy** or has 3 stacks of **Decisive**
- Corpses of resurrecting Zombies and Humans now emit a slight purple particle effect
- Fleeing surrounded hostile characters now take 100% more hitpoint damage, after the player has won but chooses to "Run them down"
- When a Brother dies (without getting struck down), a black skull will raise from his corpse
- Add Setting to control the zoom speed during combat to allow for more granular zooming
- Loot that is not equippable in battle no longer appears on the ground (e.g. Beast Trophies/Ingredients)
- Add tooltip for the duration of tile effects (smoke, flames, miasma)
- Hovering over the tile of a any corpse will now differentiate whether they were *struck down* (= survived with a permanent injury) or *slain* (died permanently)
- Increase saturation of ambient light during midnight fights to 70% (up from 50%)
- Improve visibility of Miasma and Burning Ground
- **Knock Back**, **Hook** and **Repel** can no longer be used on enemies which are immune to Displacement or which are Rooted. Using them will now print a combat log with the roll and hitchance of the attack
- **Disarm** can no longer be used on enemies which are immune to disarm
- **Fortified Mind** and **Colossus** on all NPCs are now replaced with an equivalent amount of stats
- **Night Effect**, **Double Grip**, **Pattern Recognition**, **Bulwark** and **Man of Steel** no longer display a Mini-Icon
- The **Reload** skill is now always visible, even if your weapon is fully loaded
- All Unhold variants now use their full name in Tooltips and the Combat Dialog
- Add skill descriptions for all skills from the **Lorekeeper**
- **Fast Adaption** now shows the amount of stacks in brackets behind the effect name
- Add tooltip about remaining duration of **Arrow to the Knee** effect
- Corpses will now display the round, in which they were created
- Print combat log for hitpoint damage dealt, when an attack kills the target and include the hitpoints of the target before the kill
- **Fling Back** (used by Unholds) now has an animation delay of 250ms (down from 750ms)
- The automatic camera level calculation is improved, especially while in mountanious terrain. Your camera level is now automatically adjusted when moving up or down terrain
- Automatically re-equip the accessory that you had previously equiped after an arena fight
- Add Settings to immediately stop the player movement halfway through, when it reveals an enemy (on) or an ally (off)
- Add Setting (on) to prevent combat logs, which are the result of the same skill execution, from producing empty newlines
- Add Setting (on) for preventing tile/enemy tooltips from being generated while it is not your turn
- **Armored Wiederganger** now display their complete name during battle, instead of just **Wiederganger**
- Add Setting (off) for making the hotkeys for **Wait** fire continuously, instead of only when released
- Reduce the Attack sfx volume of Wardogs and Warhounds by 20%
- All **Tough Brigands** now have the Fat body type, all **Balanced Brigands** and **Fast Brigands** now have the Skinny body type. The **Brigand Leader** has the Muscular body type

### World

- List most changes to Relation and Renown during Events and Contracts
- List changes to contract rewards during negotiation
- Display tooltips for the effects for all common settlement Situations
- Items that you bought or sold can now be sold or bought back for the exact same price as long as you didn't leave the town
- Add Setting (on) for displaying and adjusting a Waypoint that indicates, where your character on the world map is currently moving to
- Settlements now display a tooltip showing how many days ago you last visited that location
- The Tavern now displays to you how many rumors you received so far
- Add Setting (on) for displaying forbidden destination ports (even when they are hostile to you or the origin port)
- Dismissing a freshly hired recruit (0 days with the company) will skip the confirmation dialog
- Distance text in rumors and contracts now display the tile distance range in brackets
- Display the current XP Multiplier of the viewed character when hovering over the Experience bar
- World Parties with champions will display an orange skull on top of their socket
- Hostile Locations now display a tooltip line if they hide defender
- Display tooltips for the effects for all common settlement Situations
- Display duplicate Situations in towns
- Relation changes that come with a reason now also show the value in brackets, that you gained or lost from this action
- Subsequent relation changes with the same value and same reason will be combined into a single line with a multiplier in brackets
- Display price multiplier from relation in factions & relations screen
- Add Setting (on) for displaying the exact Relation whenever its indirect term appears anywhere
- Add Setting (on) for displaying the exact Morale Reputation whenever its indirect term appears anywhere
- Add Setting (on) for displaying the exact Renown whenever its indirect term appears anywhere
- Peasants and Caravans on the world map display a banner
- Add tooltip for undesirable food (e.g. Strange Meat) explaining that their are eaten last
- Add Setting (on) for displaying non-settlement location names and numerals while they are within your vision (Lairs, Unique Locations, Attached Locations)
- Brothers that "die" outside of combat (e.g. Events) will now always transfer their equipment into your stash
- List the effects of camping in the camping tooltip
- Attached Locations now list the items they produce in their tooltip
- Destroyed attached locations now display their original name, instead of just being called "Ruins"
- Add Setting (on) for marking named/legendary helmets/armor or armor with attachements as to-be-repaired whenever it enters your inventory
- Add Setting (on) to display food duration, repair duration and minimum medicine cost in brackets behind those supply values
- Add 0.8 second delay, before you can click the buttons in event screens to prevent accidental missclicks
- The Player Banner is no longer hidden while camping
- Add Concept and Tooltip for Day-Night Cycle
- Slightly Lower the volume of the annoying kid sfx in towns

### Misc

- Add setting (on) for displaying silhouettes of items from the bagslots on the character
- Supplies (Crowns, Tools, Medicine, Ammo) are now consumed instantly after buying, looting
- Quiver and Weapons that contain Ammo now display the supply cost for replacing ammunition in them
- Add new Concepts for **Armor Penetration**, **Critical Damage**, **Displacement**, **Hitchance**, **Rally**, **Threat** and **Weight** and and apply these Concepts to existing weapons, items, perks skills
- Improve tooltips of **Battleforged** perk and **Chop** skill
- Improve Concept for **Morale**
- Improve artwork for **Nimble** perk
- Improve artwork for **Tattered Sackcloth** item to make it stand out more from **Sackcloth**
- All effects of the difficulty settings are now listed as tooltips during world generation

## Fixes

### Vanilla

- Vanilla Enemies that have no head are no longer decapitatable or smashable
- Add setting (on) to improve positional sound during combat
- Always reveal the user of a skill to the target of the skill
- Always reveal the user of a skill to the player, if they target a tile that is visible to the player
- Parties on the world map are no longer hidden after loading a game, while the game is still paused
- Spiders will now give up when their team has given up even if there are still eggs on the battlefield
- Remove the hidden "25% more injury threshold" for all characters when receiveing a head hit
- You can no longer do two Arenas during the same day
- Negative changes to faction relation are no longer rounded up and positive changes are no longer rounded down
- The bagslots on the player paperdoll are now centred correctly on characters who have 1 or 3 bagslots
- Retreating NPCs, that are fleeing and in Zone of Control will now seek the border correctly, if possible
- **Repel** can no longer push someone back in a 90° angle
- **Copper Ingot** price is now affected by `BuildingRarityMult`
- Economic Difficulty now affects all prices instead of just some of them
- Other Actors moving in or out of the range of someone with **Lone Wolf** now cause that effect to update instantly
- Allow cut, copy and mark operations in input fields that are full. Limit Ctrl-Combinations, Delete and Arrow Key presses in input fields to one per press
- The price of **Copper Ingots** is not correctly affected by **Rebuilding Efforts**
- Items that you drop during battle are now correctly re-equipped afterwards
- Improve knock back logic for **Spiked Impaler** to behave like the Knock Back skill from shields
- Newly spawned faction parties no longer teleport a few tiles towards their destination during the first tick
- Hitpoint and Armor damage base damage rolls for attacks are no longer separate. The same base damage roll is now used for both damage types
- IdleSounds on higher combat speed are now played less frequently than on lower combat speed
- Hitpoints recovery on brothers is now more accurate (camping recovery fix)
- Fix Armor Damage on Weapon tooltips sometimes being off by 1%
- Fix some positional effects (e.g. Lone Wolf or Entrenched) visually persisting outside of combat
- Dying enemies no longer set the LastCombatResult to `EnemyDestroyed`, unless they were the last one to die. This fixes a rare Sunken Library exploit
- Unique Locations are no longer attackable, if there is a party, hostile to the player, directly next to it (fixes exploit for skipping Goblin City quest)
- **Knock Back** now displays its hitchance bonus correctly in the preview
- Fix Armor Penetration on **Reap** being 5% lower than shown on the weapon
- Fix Quivers needing to re-use the same ID to be correctly identified as ammo
- Releasing a dog within 2 seconds of killing someone no longer skips the dogs turn
- Two entities can no longer accidentally get teleported (e.g. via Knockback) onto the same tile
- Cartographer will no longer pay for "discovering" the Ancient Watchtower a second time when you interact with it
- Every accessory now plays a default sound when moved around in the inventory
- Roads will no longer be generated directly on the map border
- Change the inventory icon of the **Witchhunter's Hat** to look exactly like the sprite on the brother
- Characters under berserker mushroom effect no longer yell when they use ranged attacks
- Prevent the same random human name (e.g. for Leader or Knight) to be generated in succession
- Throw Pot/Flask skills are no longer considered an Attack
- Setting a faction as a temporary enemy now instantly updates the name labels of all their world parties accordingly
- **Throw Net** and **Net Pull** are no longer considered an Attack
- Rewrite `queryActorTurnsNearTarget` from `behavior.nut`, making it more accurate by considering current action points
- Remove a duplicate loading screen

### Reforged

- **Calculated Strikes** now works against stunned enemies
- **Cheap Trick** now works with delayed skill executions (like Lunge or Aimed Shot)
- The perks **Strengh in Numbers** and **Dynamic Duo** now instantly update the actors stats, if another actor moves adjacent to or away from them
- Improve **Shieldwall effect** when viewed as a hyperlink
- Fix Item Swaps sometimes requiring a different amount of Action Points than advertised at first
- Fix `onSpawned` event for player characters only firing for the first battle in each session

## For Modders

- Completely rewrite/overwrite `fillStash` from `building.nut`, making it more moddable:
	- Add `getShopAmountMax()` function for `item.nut`, which can be used to define custom maximas for items being generated for shops
	- Add `getRarityMult(_settlement=null)` for `item.nut`, which can be used to define a custom item-specific rarity multiplier for item generation for shops
	- Add new `HD_IsBuildingSupply = false` for `item.nut` that can be used to mark items as "BuildingSupply". `isBuildingSupply()` can be used to check for this value
	- Add new `HD_IsMedical = false` for `item.nut` that can be used to mark items as "Medicine". `isMedical()` can b used to check for this value
	- Add new `HD_IsMineral = false` for `item.nut` that can be used to mark items as "Mineral". `isMineral()` can b used to check for this value
- Completely rewrite `getBuyPrice` and `getSellPrice` from `item.nut` making it much more compatible and reducing duplicate code
	- Add `getBaseBuyPrice()` for `item.nut`, which returns `::Const.World.Assets.BaseBuyPrice` or any custom alternative value, depending on the item
	- Add `getBaseSellPrice()` for `item.nut`, which returns `::Const.World.Assets.BaseSellPrice` or `::Const.World.Assets.BaseLootSellPrice` or any custom alternative value, depending on the item
	- Add `isBuildingPresent(_settlement)` for `item.nut`, which returns `true`, if there is a building in this town present, that produces this item or makes it otherwise more common
- Add `getProduceList()` for `attached_location.nut` which returns an array of produces produced by this attached location
- Add new `::Math.clamp(_integerValue, _min, _max)` and `::Math.clampf(_floatValue, _min, _max)` functions
- Add simple cooldown framework for skills. E.g. set `this.m.HD_Cooldown = 2` to only allow a skill to be used once every two rounds
- Set `IsNew` to `false` when deserializing injuries
- Add new `::Hardened.Temp.RootSkillCounter = null` variable, which will contain the SkillContainer of the root skill in a delayed skill chain, or `null` while not inside a skill execution
- Entities which have `this.m.IsActingEachTurn = false` (e.g. Donkeys, Phylactery, Spider Eggs) will now trigger `onRoundEnd` after every other entity has triggered it and trigger `onRoundStart` before every other entity has triggered it
- `IsSpecializedInShields` is no longer set to `true` by **Shield Expert**
- `IsTurnStarted` in `actor.nut` and `agent.nut` is no longer set to `false` when a character ends their turn. It is now only set to `false` at the start of a new round
- Introduce new `setWeight` and `getWeight` function for `item.nut` to make code around itemweight more readable. They work on the same underlying StaminaModifier but in a reversed way
- Add `setSkillsIsUsable` for skill.nut, which toggles `IsUsable` of all skills on the actor matching a certain condition
- `onMovementStep` now calls `onUpdateVisibility` for the entity after the `onMovementStep` skill event happened instead of before, allowing you to better implement effects, where vision depend on positioning
- Add new `AffectedBodyPart` member for `injury.nut` (temporary injuries) which specifies which bodypart that injury belongs to. It defaults to -1 and is adjusted depending on the vanilla injury lists
- Add new `IsAlwaysShowingScoutingReport = false` flag for asset_manager. When `true` you will always see defender line-up, even during night, similar to the "Band of Poachers" origin
- Make `getSurroundedCount` function from `actor.nut` more moddable. The new `countsAsSurrounding` function from `actor.nut` controls, what counts as surrounding (ignoring distance). The new `__calculateSurroundedCount` returns the actual number of surrounding enemies, without any clamping or `StartSurroundCountAt`
- Add new `TerrainTypeVisionMult = [1.0, ...]` arra for asset_manager. This can be adjusted similar to the existing `TerrainTypeSpeedMult` array to change vision depending on tile type
- Add new `::Const.World.Assets.TryoutCostPct` value for controlling how much of the hire cost is translated into becoming the try out cost
- Add two new events `onReallyBeforeSkillExecuted` and `onReallyAfterSkillExecuted` for `skill.nut` which guarantee to only trigger when a skill is actually onUsed
- Add two new events `onBeforeShieldDamageReceived` and `onAfterShieldDamageReceived` for `skill.nut`
- Add new `getQueryTargetMultAsUser` and `getQueryTargetMultAsTarget` ai related getter for `skill.nut`
- Add new `isHybridWeapon` helper function for `weapon.nut`
- Parties that are spawned without a banner will be assigned the banner of the faction who owns their faction (mostly relevant for civilian factions)
- Add new `LastSpawnedParty` member for `faction.nut` which always contains the last party spawned by that faction
- Add new `getOwner` function for factions, which returns the owner of this factions first settlement
- Add new `isLootAssignedToPlayer` function for `actor.nut` which should be used, when deciding, whether to drop loot during custom implementations of `getLootForTile`
- Add new `::Hardened.TileReservation` with `function isReserved( _tileID )` which can be used to check whether a targeted tile is about to be filled with an entity from a vanilla `teleport` call
- Add new `IsHidingIconMini` flag for skills (`false` by default), that can be used by modder to force-hide the mini icon
- Add new `onSpawned` event for skills that can be used in place of `onCombatStarted` to more consistently configure entities/skills even if they spawn mid battle
- Add new `isActiveEntity` function for `actor.nut`, which is a more accurate version of MSU's `::Tactical.TurnSequenceBar.isActiveEntity`, as it also returns `true` during the start of that actors turn
- Add new `::Hardened.getFunctionCaller` global function which returns the name of the caller of the function you were in when you called getFunctionCaller
- Add new `::Hardened.mockFunction` global function allowing you to mod vanilla functions in a precise way
- Supplies (Money, Tools, Medicine, Ammunition) are now droppable
- Add new `isNamed` function for `item.nut`
- `IsUsable` in `skill.nut` is now a softreset property. So you can turn it off during `onUpdate` without needing to worry about turning it on again
- Add new `MaximumRumors` member in `tavern_building.nut`, which can be used to change the maximum amount of rumors every cycle
- Add new `isLootAssignedToPlayer(_killer)` function in `actor.nut`, which can be used during custom implementations or adjustments of `getLootForTile` function
- The existing vanilla function `getRumorPrice()` from `tavern_building` is now fully supported and used everywhere
- Add new `HD_IgnoreForCrowded = false` flag for skills. When true, then `Crowded` is never active for them
- Add `MinResurrectDelay` and `MaxResurrectDelay` for zombies
- Add `ResurrectionChance`, `MinResurrectDelay` and `MaxResurrectDelay` for humans
- `getActionPointCost` no longer returns negative values. Instead it returns 0 in those cases
- Print debugLog when entities resume their turn
- Add new `HD_LastsForTurns = null` member for `skill.nut` that can be assigned a number to give effects a turn-based duration
- Add new `HD_LastsForRounds = null` member for `skill.nut` that can be assigned a number to give effects a round-based duration
- Add new `HD_scheduleResurrection(_rounds, _corpse)` for `tactical_entity_manager`, which can be used to schedule a resurrection and spawn a corresponding purpose particle effect on the corpse
- Add `HD_getShelfLifeMult()` function for `food_item.nut` which returns the price multiplier derived from this items shelf life
- Add `HD_MaxAmount = 25` member for `food_item.nut` which defines the maximum amount of stacks this item can have. It is currently only supported within `randomizeAmount` and `getValue` from the same class
- The amount of shield paint used by the player is now counted in the statistics flag `PaintUsedOnShields`
- The amount of helmet paint used by the player is now counted in the statistics flag `PaintUsedOnHelmets`
- The amount of Injuries Treated with Bandages is now counted under the statistics flag `InjuriesTreatedWithBandage`
- The amount of armor attachements used by the player is now counted in the statistics flag `ArmorAttachementsApplie`
- Body Armor and Helmet `Condition` is now always set to `ConditionMax` at the end of the `create` function
- Add new `HD_RecoveredHitpointPct = 0.15` member for `unhold_racial` allowing you to set a variable pct of hitpoints recovered per turn
- NPCs now have 2 bag slots by default (down from 4)
- Add `HD_getBrush` function for `item.nut` which returns the brushname representing that item currently. Or `null`, if the item is not represented by a brush
- Add `::Hardened.util.intToHex(_unsigned)`, which returns a hexstring representation of the passed number
- Add `onBeforeStart(_screen)` function for `contract.nut` which is called directly before the `start()` function of any of its screen is called
- Add `::Hardened.util.findTileToKnockBackTo(_userTile, _targetTile, _knockBackDistance = 1)`, which is a centralized implementation of the knock back logic that also allows to knock someone back multiple times
- Add `findTileToKnockBackTo(userTile, _targetTile)` to `skill.nut` which points towards `::Hardened.util.findTileToKnockBackTo`. This already exists for certain vanilla skills. Now every skill has access to that implemented function
- Add `::Hardened.util.isOnSameAxis(_startTile, _targetTile)`, which returns `true`, if both tiles are on the same hexagonal axis
- Add `actor::getParty()` which returns a reference to the world party that this entitiy belongs to, or `null`, if no world party could be found
- Add `HD_KnockBackDistance` = 1` for `skill.nut`, which determines how many tiles they would knock a target back
- All corpses now have a new `HD_FatalityType` member, which contains the fatalityType that this corpse was created with
- `::Const.Combat.WeaponSpecFatigueMult` is now always `1.0`
- The large quiver variants now use the following new unique ids: `ammo.powder_large`, `ammo.arrows_large` and `ammo.bolts_large`
- `getQueryTargetValueMult` is now also called on the score for non-Attacks, but only after their target is already chosen
- Add `HD_CanSpawnParties = true` for `location.nut`, which causes locations to be ignored for spawning regular roaming parties
- Add `HD_MinPlayerDistanceForSpawn = 0` for `location.nut`, which prevents hostile locations from spawning regular roaming parties if the player is within this many tiles of them
- Add various new helper functions for ranged ammo-using weapons to `weapon.nut`. See `ranged_weapon_hooks.nut` for the details
- Add `HD_RequiredAmmoType = ::Const.Items.AmmoType.None` for `weapon.nut` which determines, which type of ammo a weapon uses
- Add `HD_StartsBattleLoaded = false` for `weapon.nut` which determines, whether this weapon will be reloaded for free at the start of each battle (only works if the correct ammo is equipped)

### New Character Properties

- `CanExertZoneOfControl` (`true` by default) can be set to `false` to force an entity to no longer exert zone of control
- `HeadshotReceivedChance` is a modifier for the incoming headshot chance
- `HeadshotReceivedChanceMult` is a multiplier for the incoming headshot chance
- `ReachAdvantageMult` is a multiplier for melee skill during reach advantage
- `ReachAdvantageBonus` is a flat bonus for melee skill during reach advantage
- `ShieldDamageMult = 1.0` multiplies shield damage dealt via active skills
- `ShieldDamageReceivedMult = 1.0` multiplies incoming shield damage up to a minimum of 1
- `WeightStaminaMult` is an array of multipliers, mirroring `::Const.ItemSlotSpaces`, which control how much the Weight of each Itemslot affects this characters Stamina
- `WeightInitiativeMult` is an array of multipliers, mirroring `::Const.ItemSlotSpaces`, which control how much the Weight of each Itemslot affects this characters Initiative
- `HitpointRecoveryMult` multiplies to anything that would add a flat amount of hitpoints to the character
- `ShowFrenzyEyes = false` displays red eyes on human-like characters
- `BagSlots = 2`, can be changed by skills to add or remove bag slots in a compatible way. Existing sources of extra bag slots are changed accordingly

# Requirements

- Reforged

# Known Issues:

- Loading a game after getting attacked allows you to turn around an ambush into a regular fight

# Compatibility

- Is safe to remove from- and add to any savegame
- Removing or adding this mod will not update existing perk trees.
	- Only after some days you will encounter brothers with the changed perk trees
	- Perk Groups may not be identified correctly on old brothers after adding or removing this mod. This is just visual
- New perks introduced by this mod are refunded and removed from your perk tree, when you remove Hardened mod and re-learned when you add Hardened back in (if you have the available perk points)

## Incompatible with
- [**Cook and Blacksmith Fix**](https://www.nexusmods.com/battlebrothers/mods/668): Hardened ships its own fix for the hitpoint recovery float issue and the rest is fixed in vanilla 1.5.1.4+

# License

This mod is licensed under the **Zero-Money License**, which is a custom license based on the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) License with additional restrictions, see LICENSE.txt.

## Key Differences from CC BY-NC-SA 4.0:

- **No Donations:** Explicitly prohibits soliciting or accepting any form of financial contributions related to the mod.
