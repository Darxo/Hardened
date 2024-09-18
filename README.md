# Description

Hardened is a submod for Reforged, offering an alternate vision while staying fully savegame compatible: Players can freely switch between Reforged and Hardened.

While Reforged focuses on realism and polished mechanics, Hardened embraces a simpler, more experimental approach. The submod takes more risks with innovative perk designs and mechanics, unlocking new possibilities for gameplay, though this can occasionally introduce more bugs or incompatibilities than Reforged. Hardened also walks back several of Reforged's more complex or restrictive design choices, opting for streamlined systems that prioritize fluidity and player freedom.

Hardened reflects my personal vision of Battle Brothers — a balanced, varied, and challenging experience, with enough randomness to keep each playthrough fresh and unpredictable.

# List of all Changes

## Major Changes

### Reach Rework

- You have **Reach Advantage** during any melee attack if your Reach is greater than the Reach of the entity you are attacking
- **Reach Advantage** always grants 15% more Melee Skill (it is unaffected by the difference in Reach)
- **Reach** is 0 while the character does not emit a zone of control (e.g. stunned, fleeing)
- Most attack skills have lost their innate hit chance bonus (see Skills section)
- **Reach Disadvantage** does nothing
- You can no longer overcome **Reach** temporarily
- **Reach Ignore** is removed

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

### Double Grip Rework

- Double Grip no longer provides unique effects for each weapon type
- Double Grip now always grants 20% more damage and 20% reduced cost of non-attack skills

### Reworked Day-Night-Cycle

- Each Day now consists of **Sunrise** (2 hours) followed by **Morning** (6 hours), **Midday** (2 hours), **Afternoon** (6 hours) and ending with **Sunset** (2 hours)
- Each Night now consists of **Dusk** (2 hours), followed by **Midnight** (2 hours) and **Dawn** (2 hours)
- Each new day now starts exactly the moment that night changes to day (Double Arena fix)

### Crossbows

- Shooting Crossbows now costs -1 Action Point and has +10% chance to hit
- Reloading Crossbows now costs +1 Action Point
- Reloading Crossbows now applies **Reload Disorientation** to you until the start of your next turn.
  - **Reload Disorientation** applies -10 Ranged Skill and -10 Ranged Defense

### Misc

- Disable **Veteran Perks**. Your brothers no longer gain perk points after Level 11
- When you pay compensation on dismissing a brother, he will share 50% of his experience with all remaining brothers. No more than 5% of his maximum exp each.

## Balance & Polishing

### Skills

- Add new **Battle Song** skill while holding a **Lute** for applying a temporary Resolve buff to nearby allies
- **Bandage Ally** now also treats any injury which was received at most 1 round ago
- **Distracted** (caused by **Throw Dirt**) now reduces the damage by 20% (down from 35%) and disables the targets Zone of Control during the effect
- **Recover** now applies the same Initiative debuff as using **Wait**
- **Puncture** now requires the target to be surrounded by atleast 2 enemies
- **Riposte** now costs 3 Action Points (down from 4), 15 Fatigue (down from 25). It now grants +10 Melee Defense during its effect. It is now disabled when you get hit or after your first counter-attack
- **Stab** now costs 3 Action Points (down from 4)
- The hireable **Nomad Background** no longer grants the **Throw Dirt** skill
- **Hand-to-Hand Attack** is now enabled if you carry an empty throwing weapon in your main hand.
- **Sword Thrust** now has -10% Hitchance bonus (up from -20%)
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
- **Lunge** now have -10% Hitchance bonus (up from -20%)

### Perks

- **Axe Mastery** no longer grants **Hook Shield**. It now causes **Split Shield** to apply **Dazed** for 1 turn.
- **Dodge** now grants 4% of Initiative as extra Melee Defense and Ranged Defense for every empty adjacent tile (down from always 15%)
- **Duelist** is completely reworked. It now only works for one-handed weapons. It grants 30% Armor Penetration and +2 Reach while adjacent to 0 or 1 enemies and it grants 15% Armor Penetration and +1 Reach while adjacent to 2 enemies.
- **Fortified Mind** now grants 30% more Resolve (up from 25%). This Bonus is now reduces by 1% for each point of Weight on your Helmet.
- **Battle Forged** no longer provide any Reach Ignore
- **Between the Ribs** no longer requires the attack to be of piercing type. It now also lowers your chance to hit the head by 10% for each surrounding character
- **Dagger Mastery** now allows free swapping of any items once per turn (while a dagger is equipped)
- **Dismantle** has been completely reworked. It now grants +40% Armor Damage and 100% more Shield Damage against enemies who have full health.
- **En Garde** is completely reworked. It now grants +15 Melee Skill while it is not your turn. It also makes it so **Riposte** is no longer disabled when you get hit or deal a counter attack (so like in Vanilla).
- **Exploit Opening** is completely reworked. It now grants a stacking +10% chance to hit whenever an opponent misses an attack against you. Bonus is reset upon landing a hit (just like Fast Adaptation)
- **Fencer** no longer grants +10% chance to hit or 20% less fatigue cost. It now causes your fencing swords to lose 50% less durability.
- **Flail Spinner** now has a 100% chance to procc (up from 50%) but will only target a random different valid enemy.
- **Hybridization** is completely reworked. It still grants 10% of your base Ranged Skill as Melee Skill/Defense. It now causes piercing type hits to the body to inclict **Arrow to the Knee**, cutting type hits to inflict **Overwhelmed**, blunt type headshots to inflict stagger and any hit with them to stun a staggered opponent and throwing spears to deal 50% more damage to shields
- **Inspiring Presence** no longer requires a banner. It is only active for the brother with the highest resolve among all brothers with that perk and only affects brothers with less resolve than the Leader. It now proccs on Round-Start instead of Turn-Start.
- **Formidable Approach** is completely reworked. It now only works for Two-Handed weapons. It now grant 15 Melee Skill instead of Reach but only triggers when you are the one moving next to an enemy. When your maximum Hitpoints are higher than those of your opponent, it removes confident from them.
- **King of all Weapons** is now called **Spear Flurry** and is completely reworked. It now reduces your damage by 10% but prevents spear attacks from building up any fatigue.
- **Leverage** is completely reworked. It now reduces the Action Point cost of your first polearm attack each turn by 1 for each adjacent ally.
- **Nimble** is completely reworked: It now always provides a 60% Hitpoint damage reduction but no longer reduces your armor damage taken. It now increases your armor damage taken by a percentage equal to your combined helmet and armor weight
- **Offhand Training** no longer raises your Reach to 4
- **Phalanx** now works even with a **Buckler** and it now also counts allies with a **Buckler** for the effect
- **Poise** is now called **Flexible** and is completely reworked: It now reduces damage which ignores Armor by 60%. This is reduced by 1% for each combined helmet and body armor weight. It also reduces your armor damage taken by a percentage equal to 40% of your current Initiative (up to a maximum of 40%)
- **Polearm Mastery** no longer reduces the Action Point cost of 2 handed reach weapons by 1. It now grants +15% chance to hit for **Repel** and **Hook**.
- **Shield Expert** no longer grants 25% increased shield defenses. It now grants 50% less shield damage taken and it makes it so enemies will never have Reach Advantage over the shield user.
- **Shield Sergeant** is mostly reworked. It still grants **Shieldwall** to all allies at the start of each combat. It now causes allies to imitate shield skills for free that you use. It also allows you to use **Knock Back** on empty tiles.
- **Skirmisher** now grants 50% of body armor weight as initiative (previously 30% of body/helmet armor weight) and no longer displays an effect icon
- **Spear Mastery** no longer provides a free spear attack each turn. Instead of now grants 15% more Melee Skill while you have Reach Advantage
- **Student** no longer grants any experience. It now grants +1 Perk Point when you reach level 8 instead of level 11.
- **Sweeping Strikes** is completely reworked: It now grants +3 Melee Defense for every adjacent enemy until the start of your next turn whenever you use a melee attack skill. It still requires a two-handed weapon.
- **Swift Stabs** has been completely reworked. It's now called **Hit and Run**. It makes it so all dagger attacks can be used at 2 tiles and will move the user one tile closer before the attack. When the attack hits the enemy, the user is moved back to the original tile.
- **Through the Gaps** is now always active but now lowers your armor penetration by 10% (down from increasing it by 10%)
- **Throwing Mastery** is mostly completely reworked. It now grants 30% more damage for your first throwing attack each turn, no matter the range. It now allows swapping a throwing weapon with an empty throwing weapon or empty slot for free, once per turn
- **Unstoppable** no longer loses all Stacks when you use **Wait** if you spent at least half of your action points by that time.
- **Wears it well** now grants 50% of combined Mainhand and Offhand Weight as Stamina and Initiative (Instead of 20% of Mainhand, Offhand, Helmet and Chest Weight)
- **Whirling Death** is completely reworked. It now grants a new active skill which creates a buff for two turns granting 30% more damage, 2 Reach and 10 Melee Defense to the user.

### Perk Groups

- **Student** is now available for everyone
- **Bags and Belts** is now part of the **Light Armor** group instead of being available for everyone
- **Dodge** is removed from the **Light Armor** group. It is now only available in the **Medium Armor** group
- **Polearm Mastery** is no longer part of **Leadership** group

### Items

- **Tree Limb** now deals 30-50 damage (up from 25-40), has an armor penetration of 90% (up from 75%), a weight of 15 (down from 20), a value of 300 (up from 150). **Bash** now costs 5 AP (up from 4) and 15 Fatigue (down from 18). **Knock Out** now has a 100% chance to stun
- **Cudgel** now deals 40-60 damage (up from 30-50), has an armor penetration of 110% (up from 90%), a value of 400 (up from 300). **Bash** now costs 5 AP (up from 4) and 15 Fatigue (down from 18). **Knock Out** now has a 100% chance to stun
- **Woodcutters Axe** now deals 35-60 damage (down from 35-70)
- Throwing Spears no longer inflict any fatigue when hitting a shield
- Ammo now has weight. All **Quivers** and **Powder Bags** weigh 0 when empty. When full, regular ones weigh 2, **Large Quivers** weigh 5, and **Large Powder Bags** weigh 4.
- Gun Powder now costs 2 Ammunition Supply each (up from 1)
- **Feral Shield** now has a value of 400 (up from 50)
- The value of almost all other non-named shields is increased by 50%-100%
- **Wooden Shields** appear less common im marketplaces
- **Buckler** appear less common in big settlements
- Small civilian settlements now sell **Old Wooden Shields**
- Big settlements now sometimes sell **Worn Kite Shields** and **Worn Heater Shields**
- **Goblin Pikes**, **Ancient Pikes** and **Pikes** are now also of the weapontype Spear
- **Smoke Bomb** now costs 400 Crowns (up from 275). Smoke now lasts 2 Rounds (up from 1)
- **Sergeant's Sash** now only provides the +10 Resolve if its user has the perk **Rally the Troops**
- **Heraldic Cape** attachement now has 20 Condition (up from 5), 0 Weight (down from 1), 1000 Value (up rom 200) and grants 10 Resolve (up from 5)
- **Fangshire** will no longer spawn at the start of the game

### Traits

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
- **Scoundrels** will no longer spawn with **Wooden Shields**. Instead they can now spawn with **Old Wooden Shields**
- **Vandals** will no longer spawn with **Kite Shields**. Instead they can now spawn with **Old Wooden Shields**
- **Raider** will no longer spawn with **Kite Shields**. Instead they can now spawn with **Worn Kite/Heater Shields**
- **Highwaymen** can now also spawn with **Worn Kite/Heater Shields**
- **Thug** now spawn with **Tree Limb** instead of **Goedendag**
- **Pillager** can now also spawn with **Cudgel**. **Pillager** no longer spawn with **Woodcutters Axe**, **Two Handed Mace** or **Two Handed Hammer**
- **Brigand Leader**, **Brigand Raider** and **Noble Footmen** no longer have **Shield Expert**
- **Zombies** no longer have **Double Grip** but gain +5 Melee Skill.
- **Zombies** and **Skeletons** grant 20% more experience
- **Zombies** and **Skeletons** no longer grant experience after resurrecting
- **Barbarian Drummer** now have +1 Action Point and grant +150 Experience
- **Nachzehrer** can no longer swallow player characters while in a net.
- **Necromancer** no longer have 20 natural body armor or **Inspiring Presence**
- **Donkeys** now grant 0 XP (down from 50 XP)
- Add face warpaint to all **Fast Bandits**
- Remove **Steelbrow** from Ifrit, Sapling and Kraken Tentacle
- Enemies which spawn with **Spear Flurry** now automatically gain **Double Strike** (to balance out how bad that perk is by itself)

### Other

- **Wait** now debuffs the actual Initiative until the start of that brothers next turn
- Encumbrance no longer lowers the fatigue recovery. It now only adds 1 fatigue per tile travelled per encumbrance level.
- Armor Penetration is capped at 100%. Any Armor Penetration above 100% has no effect. Reaching 100% Armor Pen still has damage reduction from remaining armor applied.
- Burning Damage (Fire Pot, Burning Arrow, Burning Ground) now remove all root-like effects from the targets.
- The legendary Location Ancient Spire now reveals an area of 3000 (up from 1900). It now also discovers every location in that radius for the player.
- Defeating the Ijirok now also drops **Sword Blade** item, which allows you to do the Rachegeist fight without having to kill the Kraken.
- Level-Ups for Attribute with 2 stars have -1 to minimum roll and +1 to maximum roll (compared to Vanilla) and are fully randomized in that range (compared to Reforged)
- Beginner combat difficulty difficulty now grants enemy parties 100% resources (up from 85%)
- Beginner combat difficulty difficulty now causes player characters to receive 15% less damage from all sources
- Expert combat difficulty difficulty now grants enemy parties 120% resources (up from 115%)
- Characters which are not visible to the player will no longer produce idle or death sounds.
- The combat map is no longer revealed at the end of a battle

## Quality of Life

- Your headshot chance is now displayed in the combat tooltip when targeting enemies
- Introduce a new **Headless** effect, which signalizes that certain enemies can never receive hits to the head. Ifrits, Spider Eggs, Headless Zombies, Saplings and Kraken Tentacles receive this new effect
- The Retinue-Slot Event will now trigger shortly after you unlock a new slot and will no longer replace a regular event
- Settlements now display a tooltip showing how many days ago you last visited that location
- Distance text in rumors and contracts now display the tile distance range in brackets
- Brothers that "die" outside of combat (e.g. Events) will now always transfer their equipment into your stash
- Legendary Armor and Armor with an attachement that you un-equip are now automatically marked as to-be-repaired
- Quiver now display the supply cost for replacing ammunition in them
- Improve artwork for **Nimble** perk
- Add tooltip for the duration of tile effects (smoke, flames, miasma)
- **Night Effect**, **Double Grip** and **Pattern Recognition** no longer display a Mini-Icon
- **Brawny**, **Fortified Mind** and **Colossus** on all NPCs are now replaced with an equivalent amount of stats
- All effects of the difficulty settings are now listed as tooltips during world generation
- Slightly Lower the sfx volume of the annoying kid sfx in towns
- **Knock Back**, **Hook** and **Repel** can no longer be used on enemies which are immune to knock back

## Fixes

### Reforged

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

### New Character Properties

- `HeadshotReceivedChance` is a modifier for the incoming headshot chance
- `HeadshotReceivedChanceMult` is a multiplier for the incoming headshot chance
- `ShieldDamageMult` multiplies shield damage dealt via active skills
- `ShieldDamageReceivedMult` multiplies incoming shield damage up to a minimum of 1
- `ReachAdvantageMult` is a multiplier for melee skill during reach advantage
- `ReachAdvantageBonus` is a flat bonus for melee skill during reach advantage
- `CanExertZoneOfControl` (`true` by default) can be set to `false` to force an entity to no longer exert zone of control


# Requirements

- Reforged

# Known Issues:

- Using Recover will prevent you from using **Wait Round** for the rest of this round
- **Student** will double-dip for the Manhunter Origin for Slaves.

# Compatibility

- Is safe to remove from- and add to any savegame
- Removing or adding this mod will not update existing perk trees. Only after some days you will encounter brothers with the changed perk trees.

# License

This mod is licensed under the **Zero-Money License**, which is a custom license based on the Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0) License with additional restrictions, see LICENSE.txt.

## Key Differences from CC BY-NC-SA 4.0:

- **No Donations:** Explicitly prohibits soliciting or accepting any form of financial contributions related to the mod.
