# Introduction

Hardened is a submod for Reforged, offering an alternate vision while staying fully savegame compatible: Players can freely switch between Reforged and Hardened.

While Reforged focuses on realism and polished mechanics, Hardened embraces a simpler, more experimental approach. The submod takes more risks with innovative perk designs and mechanics, unlocking new possibilities for gameplay, though this can occasionally introduce more bugs or incompatibilities than Reforged. Hardened also walks back several of Reforged's more complex or restrictive design choices, opting for streamlined systems that prioritize fluidity and player freedom.

Hardened reflects my personal vision of Battle Brothers — a balanced, varied, and challenging experience, with enough randomness to keep each playthrough fresh and unpredictable.

# Overview

- Reach Mechanic has been simplified
- Almost all shield changes have been reverted
- A huge amount of perks are reworked or rebalanced
- Some skills are tweaked
- Some enemies are tweaked
- Several smaller QoL features have been added
- Several niche vanilla bugs are fixed

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
- All reforged changes to Condition, Melee Defense, Ranged Defense and Weight of vanilla shields have been reverted.
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

### Throwing Weapon Rework

- Throwing regular **Throwing Weapons** now cost 15 Fatigue (up from 10 for Axes, 14 for Javelins and 12 for Bolas), just like in Vanilla
- Throwing **Heavy Throwing Weapons** now costs 5 Action Points (up from 4) and 18 Fatigue (up from 15)
- Throwing **Crude Javelins** now costs 5 Action Points (up from 4)
- **Heavy Javelin** now deal 40-50 Damage (up from 35-50), have 85% Armor Damage (up from 80%), have +0% Hitchance (up from -5%), 4 Maximum Ammo (down from 5), 0 Weight (down from 8), 4 Weight per Ammo, 4 Ammo Cost (up from 3) and a value of 500 (up from 300)
- **Heavy Throwing Axes** now deal 45-60 Damage (up from 30-50), have 120% Armor Damage (up from 115%), have -10% Hitchance (down from -5%), +10% Headshot Chance (up from +5%), 4 Maximum Ammo (down from 5), 0 Weight (down from 8), 3 Weight per Ammo and a value of 600 (up from 300)
- **Bolas** now deal 25-40 Damage (up from 20-35), has 0 Weight (down from 3), 1.5 Weight per Ammo and a value of 300 (up from 150)
- **Crude Javelins** now deal 35-45 Damage (up from 30-40), have 4 Maximum Ammo (down from 5), 0 Weight (down from 8) and 3 Weight per Ammo
- **Javelins** now deal 35-45 Damage (up from 30-45), have 0 Weight (down from 6), 2 Weight per Ammo and a value of 350 (up from 200)
- **Throwing Axes** now deal 35-50 Damage (up from 30-50), have -10% Hitchance (down from +0%), +10% Headshot Chance (up from +5%), 0 Weight (down from 4), 2 Weight per Ammo and a value of 400 (up from 200)
- Marketplaces now sell **Crude Javelins** instead of regular **Javelins**

### Double Grip Rework

- Double Grip no longer provides unique effects for each weapon type
- Double Grip now always grants 20% more damage and 20% reduced fatigue cost of non-attack skills

### Reworked Day-Night-Cycle

- Each Day now consists of **Sunrise** (2 hours) followed by **Morning** (6 hours), **Midday** (2 hours), **Afternoon** (6 hours) and ending with **Sunset** (2 hours)
- Each Night now consists of **Dusk** (2 hours), followed by **Midnight** (2 hours) and **Dawn** (2 hours)
- Each new day now starts exactly the moment that night changes to day (Double Arena fix)
- The Day-Night disk on the world map now aligns correctly with the current time

### Crossbows

- Shooting Crossbows now costs -1 Action Point and has +10% chance to hit
- Reloading Crossbows now costs +1 Action Point
- Reloading Crossbows now applies **Reload Disorientation** to you until the start of your next turn.
  - **Reload Disorientation** applies -10 Ranged Skill and -10 Ranged Defense

### Weight on Items

- A new term **Weight** replaces the existing **Maximum Fatigue** property on equippable items but works very similar
- The Stamina penalty from Weight is now applied last (after Stamina Multiplier from effects)
  - Therefor debuffs and injuries affecting Stamina are stronger
- You no longer gain Initiative, when you gain Stamina (e.g. from Strong Trait)
- No Character can ever have less than 10 Stamina

### Misc

- Disable **Veteran Perks**. Your brothers no longer gain perk points after Level 11
- When you pay compensation on dismissing a brother, he will share 50% of his experience with all remaining brothers. No more than 5% of his maximum exp each.
- Add new **Parry** perk in Tier 3 of **Swift Group**. It requires a one handed melee weapon. It grants Melee Defense equal to your base Ranged Defense against weapon attacks. While engage with someone wielding a melee weapon, you have 70% less Ranged Defense. Does not work with shields, while stunned, fleeing or disarmed.
- Add new **Battle Song** skill while holding a **Lute** for applying a temporary Resolve buff to nearby allies

## Balance & Polishing

### Skills

- **Bandage Ally** now also treats any injury which was received at most 1 round ago
- **Dazed** no longer reduces the Stamina by 25%. It now increases the fatigue cost of all non-attacks by 25%
- **Distracted** (caused by **Throw Dirt**) now reduces the damage by 20% (down from 35%) and disables the targets Zone of Control during the effect
- **Encourage** (granted by **Supporter**) can no longer make someone confident and it no longer requires the user to have a higher morale than the target per tile distance.
- **Hand-to-Hand Attack** is now enabled if you carry an empty throwing weapon in your main hand.
- **Puncture** now requires the target to be surrounded by atleast 2 enemies. It is now affected by **Double Grip**
- **Recover** now applies the same Initiative debuff as using **Wait**
- **Riposte** now costs 3 Action Points (down from 4), 15 Fatigue (down from 25). It now grants +10 Melee Defense during its effect. It is now disabled when you get hit or after your first counter-attack
- **Sprint** now costs 1 Action Point (up from 0) but no longer increases the fatigue cost per tile while sprinting
- **Stab** now costs 3 Action Points (down from 4)
- **Lunge** now have -10% Hitchance bonus (up from -20%)
- **Sword Thrust** now has -10% Hitchance bonus (up from -20%)

Skill nerfs as a result of the Reach system:
- **Lightbringer** now has 0% Hitchance bonus (down from 10%)
- **Thrust** now has 0% Hitchance bonus (down from 10%)
- **Slash** now has 0% Hitchance bonus (down from 5%)
- **Gash** now has 0% Hitchance bonus (down from 5%)
- **Overhead Strike** now has 0% Hitchance bonus (down from 5%)
- **Swing** now has -10% Hitchance bonus (down from -5%)
- **Split** now has -10% Hitchance bonus (down from -5%)
- **Impale** now has 0% Hitchance bonus (down from 10%)
- **Prong** now has 0% Hitchance bonus (down from 10%)
- **Rupture** now has 0% Hitchance bonus (down from 5%)
- **Strike** now has 0% Hitchance bonus (down from 5%)

### Perks

Just the images side-by-side: https://github.com/Darxo/Hardened/wiki/Perk-changes-Side‐By‐Side

- **Anticipation** now also proccs whenever your shield takes damage from an attack
- **Axe Mastery** no longer grants **Hook Shield**. It now causes **Split Shield** to apply **Dazed** for 1 turn
- **Bags and Belts** now also includes two-handed weapons but no longer grants Initiative
- **Battle Forged** no longer has any prerequisites. You can pick it alongside **Nimble** or **Poise**
- **Bloodlust** is completely reworked. It now grants 10% more damage against bleeding enemies and makes you receive 10% less damage from bleeding enemies
- **Bolster** now requires a Polearm equipped, instead of any weapon with a Reach of 6 or more
- **Bullseye** no longer reduces the penalty for shooting behind cover. It also no longer works with **Take Aim**
- **Concussive strikes** is completely reworked. It is now called **Shockwave** and it makes it so your kills or stuns with maces will daze all enemies adjacent to your target for 1 turn
- **Dodge** now grants 4% of Initiative as extra Melee Defense and Ranged Defense for every empty adjacent tile (down from always 15%)
- **Duelist** is completely reworked. It now only works for one-handed weapons. It grants 30% Armor Penetration and +2 Reach while adjacent to 0 or 1 enemies and it grants 15% Armor Penetration and +1 Reach while adjacent to 2 enemies
- **Fortified Mind** now grants 30% more Resolve (up from 25%). This Bonus is now reduces by 1% for each point of Weight on your Helmet
- **Battle Forged** no longer provide any Reach Ignore
- **Between the Ribs** no longer requires the attack to be of piercing type. It now also lowers your chance to hit the head by 10% for each surrounding character
- **Brawny** no longer grants Initiative
- **Dagger Mastery** now allows free swapping of any items once per turn (while a dagger is equipped)
- **Dismantle** has been completely reworked. It now grants +40% Armor Damage and 100% more Shield Damage against enemies who have full health.
- **Dismemberment** no longer causes any morale checks. It now grants +20% chance to hit the body part with the most temporary injuries
- **En Garde** is completely reworked. It now grants +15 Melee Skill while it is not your turn. It also makes it so **Riposte** is no longer disabled when you get hit or deal a counter attack (so like in Vanilla)
- **Entrenched** has been completely reworked. It now grants +5 Resolve per adjacent ally, +5 Ranged Defense per adjacent obstacle and 15% more Ranged Skill if at least 3 adjacent tiles are allies or obstacles
- **Exploit Opening** is completely reworked. It now grants a stacking +10% chance to hit whenever an opponent misses an attack against you. Bonus is reset upon landing a hit (just like Fast Adaptation)
- **Fencer** no longer grants +10% chance to hit or 20% less fatigue cost. It now causes your fencing swords to lose 50% less durability
- **Flail Spinner** now has a 100% chance to procc (up from 50%) but will only target a random different valid enemy
- **Formidable Approach** is completely reworked. Moving next to an enemy that has less maximum Hitpoints than you, removes Confident from them. Moving next to an enemy grants +15 Melee Skill against them until they damage you
- **Fresh and Furious** now has a fatigue threshold of 50% (up from 30%). It now checks your fatige when you end your turn, instead of at the start of your turn
- **Ghostlike** has been completely reworked. It no longer has any requirements. It now grants 50% of your Resolve as extra Melee Defense during your turn. When you start or resume your turn not adjacent to enemies, gain +15% Armor Penetration and 15% more damage against adjacent targets until you wait or end your turn
- **Hybridization** is completely reworked. It still grants 10% of your base Ranged Skill as Melee Skill/Defense. It now causes piercing type hits to the body to inclict **Arrow to the Knee**, cutting type hits to inflict **Overwhelmed**, blunt type headshots to inflict stagger and any hit with them to stun a staggered opponent and throwing spears to deal 50% more damage to shields
- **Inspiring Presence** no longer requires a banner. At the start of each round it grants adjacent allies of your faction +3 Action Points for this turn, if they are adjacent to an enemy and have less Resolve than you. The same target can't be inspired multiple times per turn.
- **King of all Weapons** is now called **Spear Flurry** and is completely reworked. It now reduces your damage by 10% but prevents spear attacks from building up any fatigue.
- **Leverage** is completely reworked. It now reduces the Action Point cost of your first polearm attack each turn by 1 for each adjacent ally.
- **Nimble** is completely reworked: It now always provides a 60% Hitpoint damage reduction but no longer reduces your armor damage taken. It now increases your armor damage taken by a percentage equal to your combined helmet and armor weight
- **Offhand Training** no longer raises your Reach to 4
- **Opportunist** is completely reworked. It now grants throwing attacks -1 Action Point cost per tile moved, until you use a throwing attack, wait or end your turn. Changing height levels also no longer has an additional Action Point cost.
- **Phalanx** now works even with a **Buckler** and it now also counts allies with a **Buckler** for the effect. It no longer requires you to have a shield equipped for it to work
- **Poise** is now called **Flexible** and is completely reworked: It now reduces damage which ignores Armor by 60%. This is reduced by 1% for each combined helmet and body armor weight. It also reduces your armor damage taken by a percentage equal to 40% of your current Initiative (up to a maximum of 40%)
- **Polearm Mastery** no longer reduces the Action Point cost of 2 handed reach weapons by 1. It now grants +15% chance to hit for **Repel** and **Hook**.
- **Quickhands** can now also swap two two-handed weapons
- **Rattle** is now called **Full Force** and has been completely reworked. It now causes you to spend all remaining Action Points whenever you attack and gain 10% more damage per Action Point spent. The effect is double for one-handed weapons
- **Rebuke** is completely reworked. It now grants the **Rebuke Effect** whenever an opponent misses a melee attack against you while it's not your turn, until the start of your next turn. This effect reduces your damage by 25% but will make you retaliate every melee attack miss against you.
- **Shield Expert** no longer grants 25% increased shield defenses and no longer prevents fatigue build-up when you dodge attacks. It now grants 50% less shield damage taken and it makes it so enemies will never have Reach Advantage over the shield user
- **Shield Sergeant** is mostly reworked. It still grants **Shieldwall** to all allies at the start of each combat. It now causes allies to imitate shield skills for free that you use. It also allows you to use **Knock Back** on empty tiles.
- **Skirmisher** now grants 50% of body armor weight as initiative (previously 30% of body/helmet armor weight) and no longer displays an effect icon
- **Spear Mastery** no longer provides a free spear attack each turn. Instead of now grants 15% more Melee Skill while you have Reach Advantage
- **Student** no longer grants any experience. It now grants +1 Perk Point when you reach level 8 instead of level 11
- **Sweeping Strikes** is completely reworked: It now grants +3 Melee Defense for every adjacent enemy until the start of your next turn whenever you use a melee attack skill. It still requires a two-handed weapon
- **Swift Stabs** has been completely reworked. It's now called **Hit and Run**. It makes it so all dagger attacks can be used at 2 tiles and will move the user one tile closer before the attack. When the attack hits the enemy, the user is moved back to the original tile
- **Target Practice** has been completely reworked. It now makes it 50% less likely for your arrows to hit the cover, when you have no clear line of fire (stronger than vanilla Bullseye)
- **Through the Gaps** is now always active but now lowers your armor penetration by 10% (down from increasing it by 10%)
- **Throwing Mastery** is mostly completely reworked. It now grants 30% more damage for your first throwing attack each turn, no matter the range. It now allows swapping a throwing weapon with an empty throwing weapon or empty slot for free, once per turn
- **Trick Shooter** no longer causes your **Aimed Shot** to trigger a morale check on the main target hit
- **Unstoppable** no longer loses all Stacks when you use **Wait** if you spent at least half of your action points by that time
- **Weapon Master** no longer works with hybrid weapons. When you learn **Weapon Master** you now gain a new random weapon perk group
- **Wears it well** now grants 50% of combined Mainhand and Offhand Weight as Stamina and Initiative (Instead of 20% of Mainhand, Offhand, Helmet and Chest Weight)
- **Whirling Death** is completely reworked. It now grants a new active skill which creates a buff for two turns granting 30% more damage, 2 Reach and 10 Melee Defense to the user

### Perk Groups

- **Bags and Belts** is now part of the **Light Armor** group instead of being available for everyone
- **Deep Impact** is now a T3 perk and **Rattle** (now **Full Force**) is now a T6 perk
- **Dodge** is removed from the **Light Armor** group. It is now only available in the **Medium Armor** group
- **Duelist** is no longer part of **Shield** group
- **Inspiring Presence** is now also part of the **Noble** group at Tier 7
- **Polearm Mastery** is no longer part of **Leadership** group
- **Quickhands** from the perk group **Trained** is now a Tier 1 perk (was Tier 2 before)
- **Resilient** is now Tier 2 of the **Tough** perk group (was Tier 2 in **Vigorous** before)
- **Steelbrow** is now Tier 2 of the **Vigorous** perk group (was Tier 2 in **Tough** before)
- **Student** is now available for everyone
- **Vigorous Assault** is no longer part of **Swift Strikes** group

### Backgrounds

- **Assassin** now has +5 to minimum Ranged Skill (up from 0) and +10 to maximum Ranged Skill (up from 0)
- **Nomad** no longer grants the **Throw Dirt** skill
- **Swordmaster** no longer has **Sword Mastery** unlocked by default. This perk is now moved to Tier 3 (down from 4) for them

### Items

- **Cudgel** now deals 40-60 damage (up from 30-50), has an armor penetration of 110% (up from 90%), a Reach of 5 (up from 3), a value of 400 (up from 300). **Bash** now costs 5 AP (up from 4) and 15 Fatigue (down from 18). **Knock Out** now has a 100% chance to stun
- **Estoc** now has 6 Reach (up from 5)
- **Fighting Axe** now has a value of 2300 (down from 2800)
- **Flail** now deals 30-55 damage (up from 25-55)
- **Hooked Blade** now deals 40-60 Damage (down from 40-70) and costs 550 Crowns (down from 700)
- **Player Banner** now grants -5 to Ranged Defense
- **Thorned Whip** now deals 20-35 Damage (up from 15-25), has a Weight of 10 (up from 6), has a Condition of 25 (down from 40) and a value of 600 (up from 400)
- **Tree Limb** now deals 30-50 damage (up from 25-40), has an armor penetration of 90% (up from 75%), a Reach of 5 (up from 3), a weight of 15 (down from 20), a value of 300 (up from 150). **Bash** now costs 5 AP (up from 4) and 15 Fatigue (down from 18). **Knock Out** now has a 100% chance to stun
- **Warfork** now deals 90% Armor Damage (down from 100%) and costs 550 Crowns (up from 400)
- **Woodcutters Axe** now deals 35-60 damage (down from 35-70)
- **Throwing Spears** no longer inflict any fatigue when hitting a shield and have a value of 60 (down from 80)
- Ammo now has weight. All **Quivers** and **Powder Bags** weigh 0 when empty. When full, regular ones weigh 2, **Large Quivers** weigh 5, and **Large Powder Bags** weigh 4.
- Gun Powder now costs 2 Ammunition Supply each (up from 1)
- **Feral Shield** now has a value of 400 (up from 50)
- The value of almost all other non-named shields is increased by 50%-100%
- **Wooden Shields** appear less common in marketplaces
- **Buckler** appear less common in big settlements
- Small civilian settlements now sell **Old Wooden Shields**
- Big non-southern settlements now sometimes sell **Worn Kite Shields** and **Worn Heater Shields**
- **Goblin Pikes**, **Ancient Pikes** and **Pikes** are now also of the weapontype Spear
- **Smoke Bomb** now costs 400 Crowns (up from 275). Smoke now lasts 2 Rounds (up from 1)
- **Sergeant's Sash** now only provides the +10 Resolve if its user has the perk **Rally the Troops**
- **Heraldic Cape** attachement now has 20 Condition (up from 5), 0 Weight (down from 1), 1000 Value (up rom 200) and grants 10 Resolve (up from 5)
- **Fermented Unhold Heart** now has an expiry date of 40 days (up from 20)
- **Fangshire** will no longer spawn at the start of the game

### Traits

- **Aisling** now also makes all temporary injuries last 50% longer
- **Lucky** no longer grants a chance to reroll incoming attacks. It now provides a 5% chance to avoid damage from any source.
- **Weasel** now provides an additional 25 Melee Defense during that brothers turn while fleeing.
- **Huge** no longer increases the Reach by 1
- **Tiny** no longer reduces the Reach by 1
- **Irrational** will no longer appear on recruits.

### Injuries

- **Grazed Neck**, **Cut Artery** and **Cut Throat** are no longer removed, when bandaged
- **Grazed Neck**, **Cut Artery** and **Cut Throat** no longer deals damage over time
- **Grazed Neck** now applies 1 stack of bleed when inflicted
- **Cut Artery** now applies 3 stack of bleed when inflicted
- **Cut Throat** now applies 6 stack of bleed when inflicted

### Enemies

- All Goblins have -5 Melee Skill and -5 Melee Defense
- Add new **Goblin** racial effect that grants 50% increased defenses from equipped shield and allows them to use **Shieldwall** with any shield
- All ifrits have 50% less Hitpoints and 50% more Armor
- **Scoundrels** no longer spawn with **Wooden Shields**. Instead they can now spawn with **Old Wooden Shields**. They now spawn with a **Knife** instead of **Dagger**/**Woodcutters Axe**
- **Vandals** no longer spawn with **Kite Shields**. Instead they can now spawn with **Old Wooden Shields**
- **Raider** no longer have **Shield Expert**. They no longer spawn with **Kite Shields**. Instead they can now spawn with **Worn Kite/Heater Shields**
- **Highwaymen** can now also spawn with **Worn Kite/Heater Shields**
- **Thug** now spawn with **Tree Limb** instead of **Goedendag**
- **Pillager** can now also spawn with **Cudgel**. **Pillager** no longer spawn with **Woodcutters Axe**, **Two Handed Mace** or **Two Handed Hammer**
- **Outlaws** no longer spawn with **Two Handed Wooden Flail** or **Greatsword**
- **Marauder** no longer spawn with **Two Handed Wooden Flail** and are twice as likely to spawn with a **Greatsword**
- Fast Brigands (Robber, Bandit, Killer) now always spawn with a net if they are one-handed, and with a throwing weapon if two-handed
- **Robber** no longer spawn with a **Pike** or **Reinforced Wooden Poleflail**
- **Bandits** no longer spawn with a **Poleflail**, **Warbrand** or **Throwing Spear**. The can now spawn with a **Reinforced Wooden Poleflail**
- **Killer** no longer spawn with **Scramasax**, **Pike**, **Spetum**, **Warbrand** or **Throwing Spear**
- **Brigand Leader** no longer have **Shield Expert**
- **Noble Footmen** no longer have **Shield Expert**
- **Zombies** no longer have **Double Grip** but gain +5 Melee Skill.
- **Zombies** and **Skeletons** grant 20% more experience
- **Zombies** and **Skeletons** no longer grant experience after resurrecting
- **Geists** no longer have **Fearsome**. They now have **Backstabber**
- **Barbarian Drummer** now have +1 Action Point and grant +150 Experience
- **Nachzehrer** can no longer swallow player characters while in a net.
- **Necromancer** no longer have 20 natural body armor or **Inspiring Presence**
- **Ancient Auxiliary** no longer have **Battleforged**
- **Donkeys** now grant 0 XP (down from 50 XP)
- Add face warpaint to all **Fast Bandits**
- Peasant Parties now drop 0 Crowns (down from 0-50). Peasants killed in battle now randomly drop crowns, food or tools or a valueable ring.
- Remove **Steelbrow** from Ifrit, Sapling and Kraken Tentacle
- Enemies which spawn with **Spear Flurry** now automatically gain **Fresh and Furious** (to balance out how bad that perk is by itself)

### Enemy AI
- Enemy archers are 66% less likely to target someone because of how many potential scatter targets are adjacent
- Improve AI targeting for throwing nets: They value the targets melee defense twice as much. They now also value the targets initiative and prefer isolated targets.
- AI is now twice as likely to throw a net or use a throwing pot/bomb while adjacent to an enemy

### World Map
- At the start of each new campaign ~5 additional small bandit camps are spawned in the world
- World Parties are no longer stunned, when you cancel the combat dialog with them
- The legendary Location Ancient Spire now reveals an area of 3000 (up from 1900). It now also discovers every location in that radius for the player.

### Other
- All fleeing characters now have +1 Action Point
- All player characters now have +1 Action Point during AutoRetreat
- **Wait** now debuffs the actual Initiative until the start of that brothers next turn
- **Swamp** tiles no longer reduce Melee Skill by 25%. Instead they now reduce Initiative by 25%
- Encumbrance no longer lowers the fatigue recovery. It now only adds 1 fatigue per tile travelled per encumbrance level.
- Armor Penetration is capped at 100%. Any Armor Penetration above 100% has no effect. Reaching 100% Armor Pen still has damage reduction from remaining armor applied.
- Burning Damage (Fire Pot, Burning Arrow, Burning Ground) now remove all root-like effects from the targets.
- Defeating the Ijirok now also drops **Sword Blade** item, which allows you to do the Rachegeist fight without having to kill the Kraken.
- Level-Ups for Attribute with 2 stars have -1 to minimum roll and +1 to maximum roll (compared to Vanilla) and are fully randomized in that range (compared to Reforged)
- The **Lone Wolf** and **Gladiator** origins now have a roster size of 13 (up from 12)
- Beginner combat difficulty difficulty now grants enemy parties 100% resources (up from 85%)
- Beginner combat difficulty difficulty now causes player characters to receive 15% less damage from all sources
- Expert combat difficulty difficulty now grants enemy parties 120% resources (up from 115%)
- Characters which are not visible to the player will no longer produce idle or death sounds.
- The combat map is no longer revealed at the end of a battle

## Quality of Life

### Combat

- Your headshot chance is now displayed in the combat tooltip when targeting enemies
- Introduce a new **Headless** effect, which sets the headarmor to 0 and redirects any attack to hit the body and grants immunity to **Distracted**. Ifrits, Spider Eggs, Headless Zombies, Saplings and Kraken Tentacles receive this new effect
- Add tooltip for the duration of tile effects (smoke, flames, miasma)
- **Knock Back**, **Hook** and **Repel** can no longer be used on enemies which are immune to knock back
- **Brawny**, **Fortified Mind** and **Colossus** on all NPCs are now replaced with an equivalent amount of stats
- **Night Effect**, **Double Grip** and **Pattern Recognition** no longer display a Mini-Icon
- All Skills from the **Lorekeeper** now have skill descriptions

### World

- The Retinue-Slot Event will now trigger shortly after you unlock a new slot and will no longer replace a regular event
- Settlements now display a tooltip showing how many days ago you last visited that location
- Distance text in rumors and contracts now display the tile distance range in brackets
- World Parties with champions will display an orange skull on top of their socket
- Peasants and Caravans on the world map display a banner
- Brothers that "die" outside of combat (e.g. Events) will now always transfer their equipment into your stash
- Slightly Lower the volume of the annoying kid sfx in towns

### Misc

- Add new concepts for **Armor Penetration** and **Weight** and apply these concept to existing weapons and items
- Supplies (Crowns, Tools, Medicine, Ammo) are now consumed instantly after buying, looting
- Legendary Armor and Armor with an attachement that you un-equip are now automatically marked as to-be-repaired
- Quiver and Weapons that contain Ammo now display the supply cost for replacing ammunition in them
- Improve artwork for **Nimble** perk
- All effects of the difficulty settings are now listed as tooltips during world generation

## Fixes

### Vanilla

- Vanilla Enemies that have no head (except Lindwurm Tail) are no longer decapitatable or smashable
- Vanilla Enemies that have no head (except Lindwurm Tail) no longer take bonus damage from headshots
- Parties on the world map are no longer hidden after loading a game, while the game is still paused
- Spiders will now give up when their team has given up even if there are still eggs on the battlefield
- You can no longer do two Arenas during the same day
- Newly spawned faction parties no longer teleport a few tiles towards their destination during the first tick
- Hitpoint and Armor damage base damage rolls for attacks are no longer separate. The same base damage roll is now used for both damage types
- Bandaging allies now updates their overlay ui correctly
- Brothers no longer gain any XP when allies die
- Releasing a dog within 2 seconds of killing someone no longer skips the dogs turn
- Every accessory now plays a default sound when moved around in the inventory
- Change the inventory icon of the **Witchhunter's Hat** to look exactly like the sprite on the brother
- The id of the item `mouth_piece` is changed to `armor.head.mouth_piece` (it used to be `armor.head.witchhunter_hat`)
- Remove a duplicate loading screen

## For Modders

- Entities which have `this.m.IsActingEachTurn = false` (e.g. Donkeys, Phylactery, Spider Eggs) will now trigger `onRoundEnd` after every other entity has triggered it and trigger `onRoundStart` before every other entity has triggered it
- `IsSpecializedInShields` is no longer set to `true` by **Shield Expert**
- Introduce new `setWeight` and `getWeight` function for `item.nut` to make code around itemweight more readable. They work on the same underlying StaminaModifier but in a reversed way
- Add new `AffectedBodyPart` member for `injury.nut` (temporary injuries) which specifies which bodypart that injury belongs to. It defaults to -1 and is adjusted depending on the vanilla injury lists
- Add two new events `onReallyBeforeSkillExecuted` and `onReallyAfterSkillExecuted` for `skill.nut` which guarantee to only trigger when a skill is actually onUsed
- Add two new events `onBeforeShieldDamageReceived` and `onAfterShieldDamageReceived` for `skill.nut`
- Add new `isHybridWeapon` helper function for `weapon.nut`
- **Nomad Sling** and **Staff Sling** no longer have the weapontype **Sling**
- Parties that are spawned without a banner will be assigned the banner of the faction who owns their faction (mostly relevant for civilian factions)
- Introduce new `LastSpawnedParty` member for `faction.nut` which always contains the last party spawned by that faction
- Introduce new `getOwner` function for factions, which returns the owner of this factions first settlement
- Introduce new virtual `getDroppedLoot` function for `actor.nut` returning an array of created items, which will be dropped when that actor dies
- Supplies (Money, Tools, Medicine, Ammunition) are now droppable

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

# Requirements

- Reforged

# Known Issues:

- Using **Line Breaker** as a **Shield Sergeant** can sometimes push multiple enemies into the same tile
- Using Recover will prevent you from using **Wait Round** for the rest of this round
- **Student** will double-dip in the Manhunter Origin for Slaves

# Compatibility

- Is safe to remove from- and add to any savegame
- Removing or adding this mod will not update existing perk trees. Only after some days you will encounter brothers with the changed perk trees
- Removing this mod will replace **Parry** with the vanilla perk **Reach Advantage**

# License

This mod is licensed under the **Zero-Money License**, which is a custom license based on the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) License with additional restrictions, see LICENSE.txt.

## Key Differences from CC BY-NC-SA 4.0:

- **No Donations:** Explicitly prohibits soliciting or accepting any form of financial contributions related to the mod.
