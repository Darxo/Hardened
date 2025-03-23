# Introduction

Hardened is a submod for Reforged, offering an alternate vision while staying fully savegame compatible: Players can freely switch between Reforged and Hardened.

While Reforged focuses on realism and polished mechanics, Hardened embraces a simpler, more experimental approach. The submod takes more risks with innovative perk designs and mechanics, unlocking new possibilities for gameplay, though this can occasionally introduce more bugs or incompatibilities than Reforged. Hardened also walks back several of Reforged's more complex or restrictive design choices, opting for streamlined systems that prioritize fluidity and player freedom.

Hardened reflects my personal vision of Battle Brothers — a balanced, varied, and challenging experience, with enough randomness to keep each playthrough fresh and unpredictable.

# Overview

- Reach Mechanic has been simplified
- Almost all shield changes have been reverted
- ~70 perks are reworked or rebalanced
- 5 new perks are introduced
- ~25 skills are tweaked
- ~20 enemies are tweaked
- ~30 QoL features or changes
- ~15 niche vanilla bugs/exploit fixes

# List of all Changes

## Major Changes

### Reach Rework

- You have **Reach Advantage** during any melee attack if your Reach is greater than the Reach of the entity you are attacking
- **Reach Advantage** always grants 15% more Melee Skill (it is unaffected by the difference in Reach)
- **Reach Disadvantage** does nothing
- Goblins, Humans and Orcs now have 0 Reach by default
- **Reach** is 0 while the character does not emit a zone of control (e.g. stunned, fleeing)
- Most attack skills have lost their innate hit chance bonus (see Skills section)
- You can no longer overcome **Reach** temporarily
- **Reach Ignore** stat is removed

### Shield Revert/Rework

- Fatigue no longer has any effect on the defenses granted by shields
- Named shields can roll condition as one of their two buffed properties (just like in Vanilla)
- All reforged changes to Condition, Melee Defense, Ranged Defense and Weight of vanilla shields have been reverted
- Additionally the following balance changes have been made compared to the vanilla stats:
	- **Tower Shields** now have 30 Condition (up from 24) and no longer grant **Knock Back**
	- **Heater Shields** now have 25 Melee Defense (up from 20) and no longer grant **Shieldwall**
	- **Kite Shields** no longer grant **Knock Back**
	- **Reinforced Skirmisher Shields** now have 15 Melee Defense (up from 10), 15 Ranged Defense (up from 10), no longer grants **Shieldwall** and now grants **Knock Back**
	- **Wooden Skirmisher Shield** no longer grants **Shieldwall** and now grants **Knock Back**
	- **Heavy Metal Shields** now have 20 Melee Defense (up from 15) and 20 Ranged Defense (up from 15)
	- **Feral Shields** now have 20 Melee Defense (up from 15), 25 Ranged Defense (up from 20), 20 Weight (up from 12), 24 Condition (up from 16), +5 Fatige on use (up from 0) and they no longer grant **Knock Back**
	- **Adarga Shields** now have 8 Weight (down from 10) and no longer grant **Knock Back**
	- **Old Wooden Shields** now have 13 Melee Defense (down from 15) and 13 Ranged Defense (down from 15)
	- **Worn Heater Shields** now have 23 Melee Defense (up from 20), 13 Ranged Defense (down from 15) and no longer grant **Shieldwall**
	- **Worn Kite Shields** now have 13 Melee Defense (down from 15), 23 Ranged Defense (down from 25) and no longer grant **Knock Back**
	- **Craftable Schrat Shield** no longer spawns saplings

### Throwing Weapon Rework

- Throwing Weapons now have a minimum attack range of 1, just like all other ranged attacks
- Throwing regular **Throwing Weapons** now cost 15 Fatigue (up from 10 for Axes, 14 for Javelins and 12 for Bolas), just like in Vanilla
- Throwing **Heavy Throwing Weapons** now costs 5 Action Points (up from 4) and 18 Fatigue (up from 15)
- Throwing **Crude Javelins** now costs 5 Action Points (up from 4)
- **Heavy Javelin** now deal 40-50 Damage (up from 35-50), have 85% Armor Damage (up from 80%), have +0% Hitchance (up from -5%), 4 Maximum Ammo (down from 5), 0 Weight (down from 8), 3 Weight per Ammo, 4 Ammo Cost (up from 3) and a value of 500 (up from 300)
- **Heavy Throwing Axes** now deal 45-60 Damage (up from 30-50), have 120% Armor Damage (up from 115%), have -10% Hitchance (down from -5%), +10% Headshot Chance (up from +5%), 0 Weight (down from 8), 3 Weight per Ammo and a value of 600 (up from 300)
- **Bolas** now deal 25-40 Damage (up from 20-35), have 0 Weight (down from 3), 1.5 Weight per Ammo and a value of 300 (up from 150)
- **Crude Javelins** now deal 35-45 Damage (up from 30-40), 0 Weight (down from 8) and 3 Weight per Ammo
- **Javelins** now deal 35-45 Damage (up from 30-45), deal 70% Armor Damage (down from 75%), have 0 Weight (down from 6), 2 Weight per Ammo and a value of 350 (up from 200)
- **Throwing Axes** now deal 35-50 Damage (up from 30-50), have -10% Hitchance (down from +0%), +10% Headshot Chance (up from +5%), 0 Weight (down from 4), 2 Weight per Ammo and a value of 400 (up from 200)
- Marketplaces now sell **Crude Javelins** instead of regular **Javelins**
- Crude Javelins on NPCs start with 3/4 ammo and Heavy Throwing Weapons on NPCs start with 4/5 ammo

### Double Grip Rework

- Double Grip no longer provides unique effects for each weapon type
- Double Grip now always grants 20% more damage and 20% reduced fatigue cost of non-attack skills

### Crowded

- **Crowded** debuff for long distance melee attacks now also applies -5% chance to hit for every adjacent ally, ignoring the first two allies
- As a consequence of the **Crowded** mechanic, 2-tile melee attacks lose the penalty to attack adjacent targets

### Crossbows

- Shooting Crossbows now costs -1 Action Point and has +10% chance to hit
- Reloading Crossbows now costs +1 Action Point
- Reloading Crossbows now applies **Reload Disorientation** to you until the start of your next turn.
  - **Reload Disorientation** applies -15 Ranged Skill and 35% less Ranged Defense

### New Perks

- Add new **Hybridization** perk in Tier 3 of **Ranged Group**. It allows swapping two weapons with no shared weapon types for free, once per turn. It grants +5 Melee Defense if you have at least 70 Base Ranged Skill and it grants +5 Ranged Defense, if you have at least 70 Base Melee Skill
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

### Weight on Items

- A new term **Weight** replaces the existing **Maximum Fatigue** property on equippable items but works very similar
- The Stamina penalty from Weight is now applied last (after Stamina Multiplier from effects)
  - Therefor debuffs and injuries affecting Stamina are stronger
- You no longer gain Initiative, when you gain Stamina (e.g. from Strong Trait)
- No Character can ever have less than 10 Stamina

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

### Other Major Changes

- Loot Allocation is reworked: If your company dealt at least 50% of the total damage received by the target, you receive their loot, no matter who killed it. Otherwise you receive no loot from it
- **Night Effect** now grants -3 Vision (down from -2)
- Disable **Veteran Perks**. Your brothers no longer gain perk points after Level 11
- When you pay compensation on dismissing a brother, he will share 50% of his experience with all remaining brothers. Each brother can only receive up to 10% of this shared experience.
- You can now use **Bandages** to treat injuries during battle that were received at most 1 round ago
- Attachements no longer randomly spawn on NPCs
- Add new **Retreat** skill for player characters, which allows you to retreat individual brothers from a battle if they stand on a border tile
- Add new **Battle Song** skill while holding a **Lute** for applying a temporary Resolve buff to nearby allies
- Hostile Locations now hide their Defender Line-Up during night
- You can no longer swap your weapon with a dagger from your bag for free

## Balance & Polishing

### Skills

- **Chop** now has a 50% chance to decapitate (up from 25%)
- **Dazed** no longer reduces the Stamina by 25%. It now increases the fatigue cost of all non-attacks by 25%
- **Distracted** (caused by **Throw Dirt**) now reduces the damage by 20% (down from 35%) and disables the targets Zone of Control during the effect
- **Encourage** (granted by **Supporter**) can no longer make someone confident and it no longer requires the user to have a higher morale than the target per tile distance.
- **Hand-to-Hand Attack** is now enabled if you carry an empty throwing weapon in your main hand.
- **Insect Swarm** now disables the targets Zone of Control during its effect. It no longer reduces the Initiative. It now reduces the combat stats by 30% (down from 50%)
- **Passing Step** (granted by **Tempo**) can now be used no matter the damage type of the attack or whether you have something in your offhand
- **Lunge** now has -10% additional Hitchance (up from -20%)
- **Net Effect** no longer affects the Initiative of the target. It now applies 50% less Melee Defense (up from 25%) and 50% less Ranged Defense (down from 45%)
- **Puncture** now requires the target to be surrounded by atleast 2 enemies. It is now affected by **Double Grip**
- **Recover** now applies the same Initiative debuff as using **Wait**
- **Riposte** now costs 3 Action Points (down from 4), 15 Fatigue (down from 25). It now grants +10 Melee Defense during its effect. It is now disabled when you get hit or after your first counter-attack. Riposte no longer has a penalty to HitChance
- **Shuffle** (granted by **Dynamic Duo**) no longer puts your partner to the next position in the turn order
- **Spider Poison** now also reduces the Hitpoints Recovery of the target by 50%
- **Stab** now costs 3 Action Points (down from 4) and has a 25% higher threshold to inflict injuries
- **Sword Thrust** now has -10% additional Hitchance (up from -20%)
- **Take Aim** (granted by **Crossbow and Firearm Mastery**) now costs 4 Action Points (up from 2) and 20 Fatigue (down from 25)
- **Throw Axe** now has a 50% chance to decapitate (up from 0%) and 25% chance to disembowel (up from 0%)

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
- **Angler** no longer increases the cost of **Break Free** on the target. It now increases the maximum range of **Throw Net** by 1 and it staggers every character that you net. **Net Pull** now has a Range of 3 (up from 2)
- **Anticipation** now also proccs whenever your shield takes damage from an attack
- **Axe Mastery** no longer grants **Hook Shield**. It now causes **Split Shield** to apply **Dazed** for 1 turn
- **Backstabber** is rewritten. It now grants +5% Hitchance per character surrounding your target, except the first one. It now also affects ranged attacks
- **Bags and Belts** now also includes two-handed weapons but no longer grants Initiative
- **Battle Fervor** is reworked. It still grants 10% more Resolve at all times. It now grants 10% more Melee Skill, Melee Defense, Ranged Skill and Ranged Defense while at Steady Morale
- **Battle Forged** no longer has any prerequisites. It no longer provide any Reach Ignore
- **Bear Down** (granted by **Mace Mastery**) is completely reworked. It now causes every headshot to daze the target for 1 turn, or increase the duration of an existing daze by 1 turn
- **Bestial Vigor** is completely reworked. It is now called **Backup Plan** and grants the skill **Backup Plan** which can be used once per battle to recover 7 Action Points and disable all Attack-Skills for the rest of this turn. It has been removed from the **Wildling** perk group and added to the **Tactician** perk group at Tier 2
- **Between the Ribs** no longer requires the attack to be of piercing type. It now also lowers your chance to hit the head by 10% for each surrounding character
- **Blitzkrieg** now costs 9 Action Points (up from 7), 50 Fatigue (up from 30), no longer requires 10 usable fatigue on the targets. It no longer has a shared cooldown. It is now limited to being used once per battle instead of once per day
- **Bloodlust** (granted by **Cleaver Mastery**) is completely reworked. It now grants 10% more damage against bleeding enemies and makes you receive 10% less damage from bleeding enemies
- **Bolster** (granted by **Polearm Mastery**) now requires a Polearm equipped, instead of any weapon with a Reach of 6 or more
- **Bone Breaker** is completely reworked. It now causes Armor Damage you deal to be treated as additional Hitpoint damage for the purpose of inflicting injuries
- **Bow Mastery** no longer grants +1 Vision
- **Bullseye** no longer reduces the penalty for shooting behind cover. It also no longer works with **Take Aim**. It now provides 25% Armor Penetration (up from 10% and 20% resepctively)
- **Bulwark** no longer grants additional Resolve against negative morale checks
- **Brawny** no longer grants Initiative
- **Cheap Trick** now affects all attacks of a skill, when you use it with an AoE skill
- **Colossus** now grants +15 Hitpoints, instead of 25% more Hitpoints
- **Command** can now be used on fleeing allies. In this case it triggers a positive morale check first. Then, if they are not fleeing, they are moved forward in the turn order, like before
- **Combo** is reworked. It now reduces the cost of all skills you haven't used yet this turn by 1 Action Point, except the first skill you use each turn
- **Concussive strikes** is completely reworked. It is now called **Shockwave** and it makes it so your kills or stuns with maces will daze all enemies adjacent to your target for 1 turn
- **Crossbow and Firearm Mastery** now grants +1 Vision while you wear a Helmet with a Vision Penalty. It no longer reduces the reload cost of **Heavy Crossbows** by 1
- **Dagger Mastery** no longer grant any reach ignore. It now reduces the action point cost of the first offhand skill each turn to 0, if your offhand item has a weight lower than 10
- **Death Dealer** is completely reworked. It now grants 5% more damage with AoE-Attacks for every enemy within 2 tiles
- **Deep Impact** is now called **Breakthrough** and has been completely reworked. It grants the **Pummel** skill, which can now be used with any hammer. It also makes it so **Shatter** has a 100% chance to knock targets back on a hit
- **Dismantle** has been completely reworked. It now grants 100% more Shield Damage. It also grants +40% Armor Damage against enemies who have full health
- **Dismemberment** no longer causes any morale checks. It now grants +20% chance to hit the body part with the most temporary injuries
- **Dodge** now grants 5% of Initiative as extra Melee Defense and Ranged Defense for every empty adjacent tile (down from always 15%)
- **Double Strike** now works with ranged attacks and the damage bonus is no longer lost when you swap weapons
- **Duelist** is completely reworked. It now only works for one-handed weapons. It grants 30% Armor Penetration and +2 Reach while adjacent to 0 or 1 enemies and it grants 15% Armor Penetration and +1 Reach while adjacent to 2 enemies
- **Dynamic Duo** no longer grants Melee Skill or Melee Defense. It no longer reduces hitchance and damage when attacking your partner
- **En Garde** is completely reworked. It now grants +10 Melee Skill while it is not your turn. It also makes it so **Riposte** is no longer disabled when you get hit or deal a counter attack (so like in Vanilla), and it recovers 1 Action Point whenever an opponent misses a melee attack against you
- **Entrenched** has been completely reworked. It now grants +5 Resolve per adjacent ally, +5 Ranged Defense per adjacent obstacle and 15% more Ranged Skill if at least 3 adjacent tiles are allies or obstacles
- **Exploit Opening** is completely reworked. It now grants a stacking +10% chance to hit whenever an opponent misses an attack against you. Bonus is reset upon landing a hit (just like Fast Adaptation)
- **Fencer** no longer grants +10% chance to hit or 20% less fatigue cost. It no longer removes the damage type requirement from **Passing Step**. It now causes your fencing swords to lose 50% less durability
- **Flail Mastery** no longer grants +5% HitChance with **Thresh** and it no longer grants the **From all Sides** perk. You now gain the **From all Sides** effect until the start of your next turn, after you use a Flail Skill. This effect makes you count twice for the purpose of surrounding adjacent enemies
- **Flail Spinner** now has a 100% chance to procc (up from 50%) but will only target a random different valid enemy
- **Formidable Approach** is completely reworked. Moving next to an enemy that has less maximum Hitpoints than you, removes Confident from them. Moving next to an enemy grants +15 Melee Skill against them until they damage you
- **Fortified Mind** now grants +25 Resolve (instead of 25% more) and you lose Resolve equal to the Weight of your Helmetweight
- **Footwork** perk no longer grants **Sprint**
- **Fresh and Furious** now has a fatigue threshold of 50% (up from 30%). It now checks your fatige when you end your turn, instead of at the start of your turn. It now also affects skills that cost 1 Action Point. It is now wasted when using a skill that costs 0 Action Points
- **From All Sides** (enemy only perk) is completely reworked. You now gain the **From all Sides** effect until the start of your next turn, after you use a Attack Skill. This effect makes you count twice for the purpose of surrounding adjacent enemies
- **Fruits of Labor** is reworked. It now grants 5% more Hitpoints, Stamina, Resolve and Initiative
- **Ghostlike** has been completely reworked. It no longer has any requirements. It now grants 50% of your Resolve as extra Melee Defense during your turn. When you start or resume your turn not adjacent to enemies, gain +15% Armor Penetration and 15% more damage against adjacent targets until you wait or end your turn
- **Hammer Mastery** no longer grants **Pummel** or increases the Armor Damage dealt by **Crush Armor** and **Demolish Armor**. Now 50% of the Armor Damage you deal to one body part is also dealt to the other body part.
- **Hybridization** is completely reworked. It is now called **Toolbox** and requires a Throwing Weapon. It now causes piercing type hits to the body to inclict **Arrow to the Knee**, cutting type attacks to inflict **Overwhelmed**, blunt type headshots to inflict stagger and any hit with them to stun a staggered opponent and throwing spears to deal 100% more damage to shields
- **Inspiring Presence** no longer requires a banner. At the start of each round it grants adjacent allies of your faction +3 Action Points for this turn, if they are adjacent to an enemy and have less Resolve than you. The same target can't be inspired multiple times per turn.
- **Iron Sights** headshot chance now also works with melee weapons
- **King of all Weapons** is now called **Spear Flurry** and is completely reworked. It now prevents spear attacks from building up any fatigue
- **Kingfisher** is reworked: It grants +2 Reach while you have a net equipped. Netting an adjacent target does not expend your net but prevents you from using or swapping it until that target breaks free or dies. If you move more than 1 tile away from that netted target, lose your equipped net
- **Leverage** is completely reworked. It now reduces the Action Point cost of your first polearm attack each turn by 1 for each adjacent ally.
- **Lone Wolf** is now only active is no ally from your company is within 2 tiles
- **Marksmanship** is completely reworked. It now grants +10 minimum and maximum damage while there are no enemies within 2 tiles
- **Nimble** is completely reworked: It now always provides a 60% Hitpoint damage reduction but no longer reduces your armor damage taken. It now increases your armor damage taken by a percentage equal to your combined helmet and armor weight
- **Offhand Training** is completely reworked. It now reduces the AP cost of tool skills by 1. Wielding a tool in your offhand no longer disables **Double Grip** and while wielding a tool in your offhand, the first successful attack each turn, will stagger your target
- **Onslaught** no longer has a shared cooldown
- **Opportunist** is completely reworked. It now grants throwing attacks -1 Action Point cost per tile moved, until you use a throwing attack, wait or end your turn. Moving on all terrain costs -2 Fatigue, just like the **Athletic** Trait
- **Phalanx** is completely reworked. It grants +1 Reach for every adjacent ally with a shield. **Shieldwall** no longer ends, while an adjacent brother also has **Shieldwall** active
- **Poise** is now called **Flexible** and is completely reworked: It now reduces damage which ignores Armor by 60%. This is reduced by 1% for each combined helmet and body armor weight. It also reduces your armor damage taken by a percentage equal to 40% of your current Initiative (up to a maximum of 40%)
- **Polearm Mastery** no longer reduces the Action Point cost of 2 handed reach weapons by 1. It now grants +15% chance to hit for **Repel** and **Hook**.
- **Professional** now reduces the experience gained by 5%
- **Quickhands** can now also swap two two-handed weapons
- **Rally the Troops** can now also be used even the user was already rallied by someone else this round
- **Rattle** is now called **Full Force** and has been completely reworked. It now causes you to spend all remaining Action Points whenever you attack and gain 10% more damage per Action Point spent. The effect is double for one-handed weapons
- **Rebuke** is completely reworked. It now grants the **Rebuke Effect** whenever an opponent misses a melee attack against you while it's not your turn, until the start of your next turn. This effect reduces your damage by 25% but will make you retaliate every melee attack miss against you.
- **Savage Strength** now reduces fatigue cost of weapon skills by 20% (down from 25%). It now grants Immunity to Disarm
- **Shield Expert** no longer grants 25% increased shield defenses and no longer prevents fatigue build-up when you dodge attacks. It now grants 50% less shield damage taken and it makes it so enemies will never have Reach Advantage over the shield user
- **Shield Sergeant** is mostly reworked. It still grants **Shieldwall** to all allies at the start of each combat. It now causes allies to imitate shield skills for free that you use during your turn. It also allows you to use **Knock Back** on empty tiles
- **Skirmisher** now grants 50% of body armor weight as initiative (previously 30% of body/helmet armor weight) and no longer displays an effect icon
- **Spear Mastery** no longer provides a free spear attack each turn. Instead it now grants 15% more Melee Skill while you have Reach Advantage
- **Survival Instinct** is completely reworked. It now grants 1 stack, when you get hit by an attack, and you lose 1 stack when you dodge an attack. Every stack grants 10 Melee Defense and 10 Ranged Defense
- **Student** no longer grants any experience. It now grants +1 Perk Point when you reach level 8 instead of level 11
- **Sweeping Strikes** is completely reworked. It now grants +5 Melee Defense for every adjacent enemy until the start of your next turn the first time you use a melee attack skill on an adjacent enemy. It still requires a two-handed weapon
- **Swift Stabs** has been completely reworked. It's now called **Hit and Run**. It makes it so all dagger attacks can be used at 2 tiles and will move the user one tile closer before the attack. When the attack hits the enemy, the user is moved back to the original tile
- **Sword Mastery** no longer grants **Passing Step** and it no longer increases the HitChance with **Riposte**. It now causes your attacks against enemies whose turn has already started to lower their Initaitive by a stacking 15% (up to a maximum of 90%) until the start of their next turn
- **Target Practice** has been completely reworked. It now makes it 50% less likely for your arrows to hit the cover, when you have no clear line of fire (stronger than vanilla Bullseye)
- **Tempo** is completely reworked. It grants +15 Initiative until the start of your next turn whenever you move a tile during your turn. It also grants **Passing Step**
- **Through the Gaps** is completely reworked. It grants -10% Armor Penetration but causes your piercing spear attacks to always target the body part with the lowest total armor
- **Throwing Mastery** is mostly completely reworked. It now grants 30% more damage for your first throwing attack each turn, no matter the range. It now allows swapping a throwing weapon with an empty throwing weapon or empty slot for free, once per turn
- **Trick Shooter** no longer causes your **Aimed Shot** to trigger a morale check on the main target hit
- **Underdog** is rewritten. It now grants +5 Melee Defense for every character surrounding you, except the first one. Compared to the vanilla implementation this defense is now affected by defense multiplier and by the softcap for defense
- **Unstoppable** no longer loses all Stacks when you use **Wait** if you spent at least half of your action points by that time
- **Vigorous Assault** discount is no longer removed when switching items
- **Weapon Master** no longer works with hybrid weapons. When you learn **Weapon Master** you now gain a new random weapon perk group
- **Wears it well** now grants 50% of combined Mainhand and Offhand Weight as Stamina and Initiative (Instead of 20% of Mainhand, Offhand, Helmet and Chest Weight)
- **Wear them Down** is completely reworked. It now causes your hits to apply an additional 10 Fatigue on the target and your misses to apply 5 Fatigue. After your attack, if your target is fully fatigued, apply **Worn Down** effect until the end of their turn, which prevents them from using **Recover** and applies 20% less Melee Defense and 20% less Ranged Defense
- **Whirling Death** is completely reworked. It now grants a new active skill which creates a buff for two turns granting 30% more damage, 2 Reach and 10 Melee Defense to the user

### Perk Groups

- **Bags and Belts** is added to **Light Armor** group and removed from **General** group
- **Bone Breaker** moved to Tier 5 (down from Tier 7)
- **Bullseye** moved to Tier 6 (up from Tier 3)
- **Cheap Trick** moved to Tier 1 (down from Tier 2)
- **Colossus** is added to **Wildling** group
- **Combo** moved to Tier 5 (down from Tier 7)
- **Calculated Strikes** moved Tier 7 (up from Tier 5)
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
- **Leverage** moved to Tier 6 perk (up from Tier 3)
- **Long Reach** moved to Tier 3 perk (down from Tier 7)
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
- **Indebted** no longer roll **Pauper Perk Group**. Instead they randomly roll any one of the other exclusive perk groups (except swordmaster)
- **Oathtaker** now spawn with +1 Weapon Group (down from +2)
- **Pimp** now has 0 to minimum Melee Skill (up from -5) and +5 to maximum Melee Skill (up from -5)
- **Swordmaster** no longer has **Sword Mastery** unlocked by default. This perk is now moved to Tier 3 (down from 4) for them. They now have a hiring cost of 400 Crowns (down from 2400), just like in Vanilla

### Weapons

- **Ancient Pikes**, **Goblin Pikes** and **Pikes** are now also of the weapontype Spear
- **Berserk Chain** now has 4 Reach (down from 5)
- **Cruel Falchion** are now a Sword/Dagger hybrid. They now also grant **Stab**. **Slash** and **Rispote** lose any discount
- **Cudgel** now deals 40-60 damage (up from 30-50), has an armor penetration of 110% (up from 90%), a Reach of 5 (up from 3), a value of 400 (up from 300). **Bash** now costs 5 AP (up from 4) and 15 Fatigue (down from 18). **Knock Out** now has a 100% chance to stun
- **Estoc** now has 6 Reach (up from 5)
- **Goblin Skewer** are now a Spear/Dagger hybrid. **Thrust** is replaced with **Stab**. **Spearwall** no longer has any discount. **Riposte** is removed
- **Goedendag** no longer grants **Cudgel** skill. It now has a 100% chance to stun with **Knock Out** (up from 75%)
- **Fighting Axe** now has a value of 2300 (down from 2800)
- **Firelance** now also has the **Firearm** weapontype
- **Flail** now deals 30-55 damage (up from 25-55) and has 3 Reach (down from 4)
- **Halberd** now has 6 Reach (down from 7)
- **Heavy Crossbow** now has +2 Fatigue Cost for its weapon skills
- **Hooked Blade** now deals 40-60 Damage (down from 40-70) and costs 550 Crowns (down from 700)
- **Lute** now has a 100% chance to stun with **Knock Out** (up from 30%)
- **Player Banner** now grants -5 to Ranged Defense and it comes with **Repel**
- **Poleflail** now has 5 Reach (down from 6)
- **Reinforced Wooden Poleflail** now has 5 Reach (down from 6)
- **Spetum** now has a Reach of 7 (up from 6) and costs 900 crowns (up from 750)
- **Spiked Impaler** now has +2 Fatigue Cost for its weapon skills
- **Thorned Whip** now deals 20-35 Damage (up from 15-25), has a Weight of 10 (up from 6), has a Condition of 25 (down from 40) and a value of 600 (up from 400)
- **Three-Headed Flail** now has 3 Reach (down from 4)
- **Throwing Spears** no longer inflict any fatigue when hitting a shield and have a value of 60 (down from 80)
- **Tree Limb** now deals 30-50 damage (up from 25-40), has an armor penetration of 90% (up from 75%), a Reach of 5 (up from 3), a weight of 15 (down from 20), a value of 300 (up from 150). **Bash** now costs 5 AP (up from 4) and 15 Fatigue (down from 18). **Knock Out** now has a 100% chance to stun
- **Two-handed Flail** now has 4 Reach (down from 5)
- **Two-handed Wooden Flail** now has 4 Reach (down from 5)
- **Warbow** now has a Weight of 8 (up from 6) and +2 Fatigue Cost for its weapon skills
- **Warfork** now deals 90% Armor Damage (down from 100%) and costs 550 Crowns (up from 400)
- **Woodcutters Axe** now deals 35-60 damage (down from 35-70)
- **Zweihander** now has 6 Reach (down from 7)

### Other Items

- **Adorned Mail Shirt** now has a Weight of 16 (up from 11), Condition of 150 (up from 130) and Value of 1050 (up from 800); just like in Vanilla
- **Bandage** now costs 40 crowns (up from 25)
- **Gun Powder** now costs 2 **Ammunition Supply** each (up from 1)
- **Buckler** appear less common in big settlements
- **Feral Shield** now has a value of 400 (up from 50)
- **Fangshire** will no longer spawn at the start of the game
- **Fermented Unhold Heart** now has an expiry date of 40 days (up from 20)
- **Heraldic Cape** attachement now has 20 Condition (up from 5), 0 Weight (down from 1), 1000 Value (up from 200) and grants 10 Resolve (up from 5)
- **Sergeant's Sash** now only provides the +10 Resolve if its user has the perk **Rally the Troops**
- **Smoke Bomb** now costs 400 Crowns (up from 275). Smoke now lasts 2 Rounds (up from 1)
- **Wooden Shields** appear less common in marketplaces
- Ammo now has weight. All **Quivers** and **Powder Bags** weigh 0 when empty. When full, regular ones weigh 2, **Large Quivers** weigh 5, and **Large Powder Bags** weigh 4.
- The value of almost all other non-named shields is increased by 50%-100%
- Small civilian settlements now sell **Old Wooden Shields**
- Big non-southern settlements now sometimes sell **Worn Kite Shields** and **Worn Heater Shields**
- Weaponsmiths and Armorsmiths now sell **Armor Parts** but for a higher price

### Traits

- **Ailing** now also makes temporary injuries you receive during combat last 50% longer
- **Lucky** no longer grants a chance to reroll incoming attacks. It now provides a 5% chance to avoid damage from any source.
- **Weasel** now provides an additional 25 Melee Defense during that brothers turn while fleeing.
- **Huge** no longer increases the Reach by 1
- **Night Blind** now grants -2 Vision during night (down from -1)
- **Night Owl** now grants +2 Vision during night (up from +1)
- **Tiny** no longer reduces the Reach by 1
- **Irrational** will no longer appear on recruits.

### Injuries

- **Collapsed Lung** no longer reduces the Stamina. Instead it now disables the use of **Recover**
- **Crushed Windpipe** no longer reduces the Stamina. Instead it now disables the use of **Recover**
- **Pierced Lung** now reduces Stamina by 30% (down from 60%) and disables the use of **Recover**
- **Grazed Neck**, **Cut Artery** and **Cut Throat** are no longer removed, when bandaged
- **Grazed Neck**, **Cut Artery** and **Cut Throat** no longer deals damage over time
- **Grazed Neck** now applies 1 stack of bleed when inflicted
- **Cut Artery** now applies 3 stack of bleed when inflicted
- **Cut Throat** now applies 6 stack of bleed when inflicted

### Retinue/Follower

- **Bount Hunter Follower** now costs 2500 Crowns (down from 4000). It now grants +5% for enemies to become champtions (up from +3%). It no longer grants crowns when you kill champions
- **Lookout Follower** no longer grants 25% more vision at all times. It now always provides a scouting report for enemies near you, just like "Band of Poachers" origin
- **Scout Follower** no longer grants 15% more movement speed. It now grants 20% more movement speed while in Forests and Swamp. It also grants 25% Vision while on hills or mountains

### Enemies

- Introduce a new **Headless** effect, which sets the headarmor to 0 and redirects any attack to hit the body and grants immunity to **Distracted**
	- This effect is given to Ifrits, Spider Eggs, Headless Zombies, Saplings and Kraken Tentacles
	- Remove the now redundant perk **Steelbrow** from Ifrit, Sapling and Kraken Tentacle
	- Wiederganger, which receive this effect, lose **Bite** and gain **Zombie Punch**, which is mostly the same, except with no bonus headshot chance

**Brigands:**
- **Scoundrels** no longer spawn with **Wooden Shields**. Instead they can now spawn with **Old Wooden Shields**. They now spawn with a **Knife** instead of **Dagger**/**Woodcutters Axe**
- **Vandals** no longer spawn with **Kite Shields**. Instead they can now spawn with **Old Wooden Shields**
- **Raider** lose **Shield Expert**. They no longer spawn with **Kite Shields**. Instead they can now spawn with **Worn Kite/Heater Shields**
- **Highwaymen** can now also spawn with **Worn Kite/Heater Shields**
- **Thug** now spawn with **Tree Limb** instead of **Goedendag**
- **Pillager** can now also spawn with **Cudgel**. **Pillager** no longer spawn with **Woodcutters Axe**, **Two Handed Mace** or **Two Handed Hammer**
- **Outlaws** no longer spawn with **Two Handed Wooden Flail** or **Greatsword**
- **Marauder** no longer spawn with **Two Handed Wooden Flail** and are twice as likely to spawn with a **Greatsword**
- Fast Brigands (Robber, Bandit, Killer) now always spawn with a net if they are one-handed, and with a throwing weapon if two-handed. They also have cosmetic face warpaint
- **Robber** no longer spawn with a **Pike** or **Reinforced Wooden Poleflail**. They now have 60 Ranged Skill (up from 55)
- **Bandits** no longer spawn with a **Poleflail**, **Warbrand** or **Throwing Spear**. The can now spawn with a **Reinforced Wooden Poleflail**. They now have 70 Ranged Skill (up from 60)
- **Killer** no longer spawn with **Scramasax**, **Pike**, **Spetum**, **Warbrand** or **Throwing Spear**. They now have 80 Ranged Skill (up from 70). They can no appear as Champions
- **Brigand Leader** lose **Shield Expert**
- **Hedge Knights** are now immune to **Disarm** as a result of them having **Savage Strength**
- **Wargdogs** now have 5 Vision (down from 7)

**Humans:**
- Peasant Parties now drop 0 Crowns (down from 0-50). Peasants killed in battle now randomly drop crowns, food or tools or a valueable ring
- **Noble Footmen** lose **Shield Expert**
- **Swordmaster** with **Blade Dancer** perk now only spawn with **Noble Swords**

**Undead**
- All **Wiederganger** types gain +5 Melee Skill and grant 20% more experience. They lose **Double Grip** and no longer grant experience after being ressurected. They now have a 100% resurrection chance (up from 66%) but -10 Hitpoints
- Normal **Wiederganger** lose **Overwhelm**
- All **Skeletons** grant 20% more experience. They no longer grant experience after being ressurected
- **Fallen Heroes** no longer spawn with Morning Stars or Handaxes. They now have a 100% resurrection chance (up from 90%) but -10 Hitpoints. Champion variants lose **Nine Lives**
- **Geists** lose **Fearsome**. They now have **Backstabber**
- **Necromancer** lose 20 natural body armor and **Inspiring Presence**
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
- Introduce new **Bite Reach** effect, which reduces headshot chance by 10% and increases chance to receive headshot by 10%
	- This effect is given to all Dogs, Wolfs and Hyenas
- All **Ifrits** gain **Man of Steel**
  - **Small Ifrits** now have 55 Hitpoints (down from 110) and 165 Armor (up from 110)
  - **Medium Ifrits** now have 110 Hitpoints (down from 220) and 220 Armor (up from 110). They lose 10 Damage and gain **Marksmanship**
  - **Large Ifrits** now have 220 Hitpoints (down from 440) and 330 Armor (up from 110). They lose 10 Damage and gain **Marksmanship**
- Lindwurms Head and Tail no longer share hitpoints and effects but killing the Tail will no longer kill the Head
  - Lindwurm Heads now have 1000 Hitpoints (down from 1100), 20 Melee Defense (up from 10) and gain **Exude Confidence**. They lose **Survival Instinct**
  - The Lindwurm Tail still inherits most of the stats from the head but has 50% less Hitpoints and Resolve and 50% more Melee Defense. They lose **Fearsome**
  - The Lindwurm Tail can now be stunned and netted but those effects are removed whenever the Head moves away
- All **Nachzehrere** lose **Deep Cuts**
  - **Small Nachzehrer** lose 10 Melee Defense and gain **Ghostlike**
  - **Large Nachzehrer** can no longer swallow player characters while in a net. They can now also swallow the last player character who is alive
- **Donkeys** now grant 0 XP (down from 50 XP)
- **Schrats** no longer take 70% reduced damage while their shield is up. They now have +200 Hitpoints and gain the **One with the Shield** perk

### Dynamic Party Adjustments

- Fast Brigands (**Robber** -> **Bandit** -> **Killer**) now upgrade slightly earlier
- Add **Highwayman** as new T1 of the Banditleader Unitblock. Banditleader Unitblock now require a StartingResourceMin of 200 (down from 250)

### Enemy AI

- NPC ranged troops attribute a potential target 80% less score from adjacent potential scatter targets
- Necrosavants are a bit more likely to stay on the same tile and attack twice, rather than teleport to a slightly better tile
- Improve AI targeting for throwing nets: They value the targets melee defense twice as much and prefer isolated targets
- NPCs are now twice as likely to throw a net or use a throwing pot/bomb while adjacent to an enemy
- NPCs will no longer throw nets while their strategy is defending
- NPCs with **Bolster** are more likely to attack with their polarm as they are surrounded by more allies
- NPCs with **Dismantle** are more likely to target enemies with 100% hitpoints
- NPCs with **Sweeping Strikes** are more likely to use an appropriate attack as they are surrounded by more enemies
- NPCs are more likely to target enemies with **Formidable Approach** if it has been procced against them
- NPCs are far less likely to attack into an active **Rebuke**
- NPCs are more likely use **Disarm** onto enemies with **Spearwall** or **Riposte**
- NPCs are now less likely to use Break Free if they have almost no Melee Defense to begin with and more likely if they have a lot of Melee Defense
- NPCs are 20% more likely to try to destroy shields of someone with **Phalanx** perk
- NPCs are 50% more likely to try to destroy shields of someone with **One with the Shield** perk
- NPCs are 1% more likely to focus Nachzehrer sitting on consumable corpses for every % of hitpoints missing on them
- NPCs with **Toolbox** are 50% more likely to target a staggered enemy with a blunt throwing attack
- NPCs are 50% more likely to use **Split Shield** when it would destroy a shield on use
- NPCs are 20% more likely to use a throwing spear against shield users and 50% more likely to target shields, that it would destroy on use

### World Map

- At the start of each new campaign ~5 additional small bandit camps are spawned in the world
- World Parties are no longer stunned, when you cancel the combat dialog with them
- The legendary Location Ancient Spire now reveals an area of 3000 (up from 1900)

### Events

- The Retinue-Slot Event will now trigger shortly after you unlock a new slot and will no longer replace a regular event
- The Event-Option to shoot down the bird who shat your brother now costs 5 Ammunition

### Other

- You can now get up to 6 Tavern Rumors every cycle (up from 4)
- Tavern Rumors now have a linearly scaling cost. Each paid rumor costs an amount based on the standard (vanilla) rumor price, multiplied by the number of the paid rumor you are about to buy
- All fleeing characters now have +1 Action Point
- All player characters now have +1 Action Point during AutoRetreat
- Try out now costs 100% more. You can now dismiss recruits after you tried them out to make room for new recruits
- **Wait** now debuffs the actual Initiative until the start of that brothers next turn
- **Swamp** tiles no longer reduce Melee Skill by 25%. Instead they now reduce Initiative by 25%
- The **Hidden** effect (granted by certain tiles) now also provides +10 Ranged Defense
- Resurrecting Corpses can no longer knock back characters that are immune to knock back or rooted. Instead they delay their resurrection
- Encumbrance no longer lowers the fatigue recovery. It now only adds 1 fatigue per tile travelled per encumbrance level
- Armor Penetration is capped at 100%. Any Armor Penetration above 100% has no effect. Reaching 100% Armor Pen still has damage reduction from remaining armor applied
- Dying or Fleeing characters no longer trigger negative morale checks for their allies if the distance between them is greater than the vision of the receiving ally
- Burning Damage (Fire Pot, Burning Arrow, Burning Ground) now remove all root-like effects from the targets
- Defeating the Ijirok now also drops **Sword Blade** item, which allows you to do the Rachegeist fight without having to kill the Kraken
- The **Orc Slayer** and **Crusader** (temporary Crisis backgrounds) now share 100% of their experience with your remaining party, when they leave you after the Crisis ended
- Level-Ups for Attribute with 2 stars have -1 to minimum roll and +1 to maximum roll (compared to Vanilla) and are fully randomized in that range (compared to Reforged)
- The **Lone Wolf** and **Gladiator** origins now have a roster size of 13 (up from 12)
- Beginner combat difficulty now grants enemy parties 100% resources (up from 85%)
- Beginner combat difficulty now causes player characters to receive 15% less damage from all sources
- Expert combat difficulty now grants enemy parties 120% resources (up from 115%)
- Caravan Contracts that are declined or which expire now spawn a caravan towards the destination if they haven't spawned one in a while
- Characters which are not visible to the player will no longer produce idle or death sounds.
- The combat map is no longer revealed at the end of a battle

## Quality of Life

### Combat

- Your headshot chance is now displayed in the combat tooltip when targeting enemies
- Introduce a new **Unworthy** effect which prevents the character from granting experience on death. This is given to all non-player controlled characters who grant 0 XP on death or are allied to the player
- Introduce a new cosmetic **Non-Combatant** effect, to non-combatant characters, which explains that they do not need to be killed in order to win
- Add Setting to control the zoom speed during combat to allow for more granular zooming
- Loot that is not equippable in battle no longer appears on the ground (e.g. Beast Trophies/Ingredients)
- Add tooltip for the duration of tile effects (smoke, flames, miasma)
- Improve visibility of Miasma and Burning Ground
- **Knock Back**, **Hook** and **Repel** can no longer be used on enemies which are immune to knock back or which are rooted
- **Disarm** can no longer be used on enemies which are immune to disarm
- **Fortified Mind** and **Colossus** on all NPCs are now replaced with an equivalent amount of stats
- **Night Effect**, **Double Grip**, **Pattern Recognition**, **Bulwark** and **Man of Steel** no longer display a Mini-Icon
- Add skill descriptions for all skills from the **Lorekeeper**
- Corpses will now display the round, in which they were created
- The automatic camera level calculation is improved
- Add Setting (on) to prevent combat logs, which are the result of the same skill execution, from producing empty newlines
- Add Setting (on) for preventing tile/enemy tooltips from being generated while it is not your turn
- **Armored Wiederganger** now display their complete name during battle, instead of just **Wiederganger**
- Add Setting (off) for making the hotkeys for **Wait** fire continuously, instead of only when released
- Reduce the Attack sfx volume of Wardogs and Warhounds by 20%

### World

- List most changes to Relation and Renown during Events and Contracts
- Settlements now display a tooltip showing how many days ago you last visited that location
- The Tavern now displays to you how many rumors you received so far
- Add Setting (on) for displaying forbidden destination ports (even when they are hostile to you or the origin port)
- Dismissing a freshly hired recruit (0 days with the company) will skip the confirmation dialog
- Distance text in rumors and contracts now display the tile distance range in brackets
- Display the current XP Multiplier of the viewed character when hovering over the Experience bar
- World Parties with champions will display an orange skull on top of their socket
- Hostile Locations now display a tooltip line if they hide defender
- Display price multiplier from relation in factions & relations screen
- Add Setting (on) for displaying the exact Relation whenever its indirect term appears anywhere
- Add Setting (on) for displaying the exact Morale Reputation whenever its indirect term appears anywhere
- Add Setting (on) for displaying the exact Renown whenever its indirect term appears anywhere
- Peasants and Caravans on the world map display a banner
- Add Setting (on) for displaying non-settlement location names of nearby locations (Lairs, Unique Locations, Attached Locations)
- Brothers that "die" outside of combat (e.g. Events) will now always transfer their equipment into your stash
- List the effects of camping in the camping tooltip
- Add Setting (on) for marking named/legendary helmets/armor or armor with attachements as to-be-repaired whenever it enters your inventory
- Add Setting (on) to display food duration, repair duration and minimum medicine cost in brackets behind those supply values
- Add 1 second delay, before you can click the buttons in event screens to prevent accidental missclicks
- Add Concept and Tooltip for Day-Night Cycle
- Slightly Lower the volume of the annoying kid sfx in towns

### Misc

- Add new Concepts for **Armor Penetration** and **Weight** and apply these Concepts to existing weapons and items
- Add new Concept for **Hitchance** and apply it to reworked perk- and skill descriptions
- Supplies (Crowns, Tools, Medicine, Ammo) are now consumed instantly after buying, looting
- Quiver and Weapons that contain Ammo now display the supply cost for replacing ammunition in them
- Improve artwork for **Nimble** perk
- All effects of the difficulty settings are now listed as tooltips during world generation

## Fixes

### Vanilla

- Vanilla Enemies that have no head are no longer decapitatable or smashable
- Add setting to improve positional sound during combat
- Parties on the world map are no longer hidden after loading a game, while the game is still paused
- Spiders will now give up when their team has given up even if there are still eggs on the battlefield
- Remove the hidden "25% more injury threshold" for all characters when receiveing a head hit
- You can no longer do two Arenas during the same day
- Other Actors moving in or out of the range of someone with **Lone Wolf** now cause that effect to update instantly
- Allow cut, copy and mark operations in input fields that are full. Limit Ctrl-Combinations, Delete and Arrow Key presses in input fields to one per press
- Improve knock back logic for Spiked Impaler to behave like the Knock Back skill from shields
- Newly spawned faction parties no longer teleport a few tiles towards their destination during the first tick
- Hitpoint and Armor damage base damage rolls for attacks are no longer separate. The same base damage roll is now used for both damage types
- Hitpoints recovery on brothers is now more accurate (camping recovery fix)
- Fix some positional effects (e.g. Lone Wolf or Entrenched) visually persisting outside of combat
- Dying enemies no longer set the LastCombatResult to `EnemyDestroyed`, unless they were the last one to die. This fixes a rare Sunken Library exploit
- Releasing a dog within 2 seconds of killing someone no longer skips the dogs turn
- Two entities can no longer accidentally get teleported (e.g. via Knockback) onto the same tile
- Every accessory now plays a default sound when moved around in the inventory
- Change the inventory icon of the **Witchhunter's Hat** to look exactly like the sprite on the brother
- Characters under berserker mushroom effect no longer yell when they use ranged attacks
- Prevent the same random human name (e.g. Leader or Knight) to be generated in succession
- Throw Pot/Flask skills are no longer considered an attack
- Remove a duplicate loading screen

### Reforged

- **Calculated Strikes** now works against stunned enemies
- **Cheap Trick** and **Retribution** now work with delayed skill executions (like Lunge or Aimed Shot)
- The perks **Strengh in Numbers** and **Dynamic Duo** now instantly update the actors stats, if another actor moves adjacent to or away from them

## For Modders

- Add new `::Math.clamp(_integerValue, _min, _max)` and `::Math.clampf(_floatValue, _min, _max)` functions
- Add simple cooldown framework for skills. E.g. set `this.m.HD_Cooldown = 2` to only allow a skill to be used once every two rounds
- Set `IsNew` to `false` when deserializing injuries
- Add new `::Hardened.Temp.RootSkillCounter = null` variable, which will contain the SkillContainer of the root skill in a delayed skill chain, or `null` while not inside a skill execution
- Entities which have `this.m.IsActingEachTurn = false` (e.g. Donkeys, Phylactery, Spider Eggs) will now trigger `onRoundEnd` after every other entity has triggered it and trigger `onRoundStart` before every other entity has triggered it
- `IsSpecializedInShields` is no longer set to `true` by **Shield Expert**
- `IsTurnStarted` in `actor.nut` and `agent.nut` is no longer set to `false` when a character ends their turn. It is now only set to `false` at the start of a new round
- Introduce new `setWeight` and `getWeight` function for `item.nut` to make code around itemweight more readable. They work on the same underlying StaminaModifier but in a reversed way
- Add `setSkillsIsUsable` for skill.nut, which toggles `IsUsable` of all skills on the actor matching a certain condition
- `onMovementStep` now calls `onUpdateVisibility` for the entity after the MSU events happen instead of before, allowing you to better implement effects, whose vision effects depend on positioning
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
- Add new `isActiveEntity` function for `actor.nut`, which is a shorter version of ::Tactical.TurnSequenceBar.isActiveEntity
- Add new `::Hardened.getFunctionCaller` global function which returns the name of the caller of the function you were in when you called getFunctionCaller
- Add new `::Hardened.mockFunction` global function allowing you to mod vanilla functions in a precise way
- Supplies (Money, Tools, Medicine, Ammunition) are now droppable
- Add new `isNamed` function for `item.nut`
- `IsUsable` in `skill.nut` is now a softreset property. So you can turn it off during `onUpdate` without needing to worry about turning it on again
- Add new `MaximumRumors` member in `tavern_building.nut`, which can be used to change the maximum amount of rumors every cycle
- Add new `isLootAssignedToPlayer(_killer)` function in `actor.nut`, which can be used during custom implementations or adjustments of `getLootForTile` function
- The existing vanilla function `getRumorPrice()` from `tavern_building` is now fully supported and used everywhere
- Add new `HD_IgnoreForCrowded = false` flag for skills. When true, then `Crowded` is never active for them

### New Character Properties

- `CanExertZoneOfControl` (`true` by default) can be set to `false` to force an entity to no longer exert zone of control
- `HeadshotReceivedChance` is a modifier for the incoming headshot chance
- `HeadshotReceivedChanceMult` is a multiplier for the incoming headshot chance
- `ReachAdvantageMult` is a multiplier for melee skill during reach advantage
- `ReachAdvantageBonus` is a flat bonus for melee skill during reach advantage
- `ShieldDamageMult` multiplies shield damage dealt via active skills
- `ShieldDamageReceivedMult` multiplies incoming shield damage up to a minimum of 1
- `WeightStaminaMult` is an array of multipliers, mirroring `::Const.ItemSlotSpaces`, which control how much the Weight of each Itemslot affects this characters Stamina
- `WeightInitiativeMult` is an array of multipliers, mirroring `::Const.ItemSlotSpaces`, which control how much the Weight of each Itemslot affects this characters Initiative
- `HitpointRecoveryMult` multiplies to anything that would add a flat amount of hitpoints to the characters

# Requirements

- Reforged

# Known Issues:

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
