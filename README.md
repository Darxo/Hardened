# Description

This submod is a collection of changes to Reforged that I suggested internally that didn't make it into the mod [yet]. In order to still enjoy those ideas/tweaks I made them into this submod for myself; and maybe others.

# List of all Changes

## Major Changes

### Reach Rework

- You have Reach Advantage during any melee attack if your Reach is greater than the Reach of the entity you are attacking
- Reach Advantage always grants 15% more Melee Skill (it is unaffected by the difference in Reach)
- Reach is 0 while the character does not emit a zone of control (e.g. stunned, fleeing)

**Removed compared to Reforged:**
- penalty for Reach Disadvantage
- overcoming Reach Temporarily
- Reach Ignore Stat on Shields

### Reworked Day-Night-Cycle

- Each Day now consists of **Sunrise** (2 hours) followed by **Morning** (6 hours), **Midday** (2 hours), **Afternoon** (6 hours) and ending with **Sunset** (2 hours)
- Each Night now consists of **Dusk** (2 hours), followed by **Midnight** (2 hours) and **Dawn** (2 hours)
- Each new day now starts exactly the moment that night changes to day (Double Arena fix)

### Crossbows

- Shooting Crossbows now costs -1 Action Point and has +10% chance to hit
- Reloading Crossbows now costs +1 Action Point
- Reloading Crossbows now applies **Reload Disorientation** to you until the start of your next turn.
- **Reload Disorientation** applies  -10 Ranged Skill and -10 Ranged Defense

### Misc

- Disable Veteran Perks
- When you pay compensation on dismissing a brother, he will share 50% of his experience with all remaining brothers. No more than 5% of his maximum exp each.

## Additions

- Add new **Battle Song** skill while holding a **Lute** for applying a temporary Resolve buff to nearby allies

## Balance & Polishing

### Perks

- Change **Dodge** effect is now between 5% and 20% of Initiative (instead of always 15%) depending on the amount of adjacent empty tiles
- Change **Duelist** to only works for one-handed weapons. The Penetration is increased to 30% and is now also halfed with 2 enemies and disabled with 3+
- **Fortified Mind** now provides 30% Resolve (up from 25%). This Bonus is now reduces by 1% for each Helmet Weight.
- **Battle Forged** no longer provide any Reach Ignore
- **Nimble** is completely reworked: It now always provides a 60% Hitpoint damage reduction but no longer reduces your armor damage taken. It now increases your armor damage taken by a percentage equal to your combined helmet and armor weight
- **Poise** is now called **Flexible** and is completely reworked: It now reduces damage which ignores Armor by 60%. This is reduced by 1% for each combined helmet and body armor weight. It also reduces your armor damage taken by a percentage equal to 40% of your current Initiative (up to a maximum of 40%)
- **Nimble** and **Flexible** (formerly Poise) no longer exclude each other from being picked, after one of them is learned
- **Flail Spinner** now has a 100% chance to procc (up from 50%) but will only target a random different valid enemy.
- Rework **Formidable Approach** to only work for Two-Handed weapons. It now grant 15 Melee Skill instead of Reach but only triggers when you are the one moving next to an enemy. When your maximum Hitpoints are higher than those of your opponent, it removes confident from them.
- **Inspiring Presence** no longer requires a banner. It is only active for the brother with the highest resolve among all brothers with that perk and only affects brothers with less resolve than the Leader. It now proccs on Round-Start instead of Turn-Start.
- **Shield Expert** no longer grants 25% increased shield defenses. Instead it makes it so enemies will never have Reach Advantage over the shield user.
- **Skirmisher** now grants 50% of body armor weight as initiative (previously 30% of body/helmet armor weight) and no longer displays an effect icon
- **Student** is completely reworked: It is now always available on everybody. It grants +1 Perk Point after 3 more levels have been gained.
- **Sweeping Strikes** is completely reworked: It now grants +3 Melee Defense for every adjacent enemy until the start of your next turn whenever you use a melee attack skill. It still requires a two-handed weapon.
- **Through the Gaps** is now always active but now lowers your armor penetration by 10% (down from increasing it by 25%)
- **Wears it well** no grants 50% of combined Mainhand and Offhand weight as Stamina and Initiative (Instead of 20% of Mainhand, Offhand, Helmet and Chest)

### Perk Groups

- **Student** is now available for everyone
- **Bags and Belts** is now part of the **Light Armor** group instead of being available for everyone
- **Dodge** is removed from the **Light Armor** group. It is now only available in the **Medium Armor** group
- **Polearm Mastery** is no longer part of **Leadership** group

### Items

- **Goblin Pikes**, **Ancient Pikes** and **Pikes** are now also of the weapontype Spear
- **Sergeant's Sash** now only provides the +10 Resolve if its user has the perk Rally the Troops
- **Heraldic Cape** attachement now has 20 Condition (up from 5), 0 Weight (down from 1), 1000 Value (up rom 200) and grants 10 Resolve (up from 5)
- **Fangshire** will no longer spawn at the start of the game

### Skills

- **Recover** now applies the same Initiative debuff as using **Wait**
- **Puncture** now requires the target to be surrounded by atleast 2 enemies
- **Stab** now costs 3 Action Points (down from 4)
- **Hand-to-Hand Attack** is now enabled if you carry an empty throwing weapon in your main hand.
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
- **Knock Back**, **Hook** and **Repel** can no longer be used on enemies which are immune to knock back.
- **Distracted** (caused by **Throw Dirt**) now reduces the damage by 20% (down from 35%) and disables the targets Zone of Control during the effect

### Traits

- **Lucky** no longer grants a chance to reroll incoming attacks. It now provides a 5% chance to avoid damage from any source.
- **Weasel** now provides an additional 25 Melee Defense during that brothers turn while fleeing.
- **Irrational** will no longer appear on recruits.

### Enemies

- Zombies no longer have **Double Grip** but gain +5 Melee Skill.
- Nachzehrer can no longer swallow player characters while in a net.
- Necromancer no longer have 20 natural body armor or **Inspiring Presence**. They now have **Soul Link**.
- Add face warpaint to all fast bandits

### Other

- Fatigue no longer has any effect on the defenses granted by shields
- **Wait** now debuffs the actual Initiative until the start of that brothers next turn
- Encumbrance no longer lowers the fatigue recovery. It now only adds 1 fatigue per tile travelled per encumbrance level.
- Armor Penetration is capped at 100%. Any Armor Penetration above 100% has no effect. Reaching 100% Armor Pen still has damage reduction from remaining armor applied.
- The legendary Location Ancient Spire now reveals an area of 3000 (up from 1900). It now also discovers every location in that radius for the player.
- Defeating the Ijirok now also drops **Sword Blade** item, which allows you to do the Rachegeist fight without having to kill the Kraken.
- Level-Ups for Attribute with 2 stars have -1 to minimum roll and +1 to maximum roll (compared to Vanilla) and are fully randomized in that range (compared to Reforged)
- Characters which are not visible to the player will no longer produce idle or death sounds.
- The combat map is no longer revealed at the end of a battle

## Quality of Life

- The Retinue-Slot Event will now trigger shortly after you unlock a new slot and will no longer replace a regular event
- Settlements now display a tooltip showing how many days ago you last visited that location
- Distance text in rumors and contracts now display the tile distance range in brackets
- Brothers that "die" outside of combat will now always transfer their equipment into your stash
- Legendary Armor and Armor with an attachement that you un-equip are now automatically marked as to-be-repaired
- The tooltips of your attributes now display your Base Attribute value and the difference between that Base value and your current value
- **Night Effect**, **Double Grip** and **Pattern Recognition** no longer display a Mini-Icon
- **Brawny**, **Fortified Mind** and **Colossus** on all NPCs are now replaced with an equivalent amount of stats
- Slightly Lower the sfx volume of the annoying kid calling out for his daddy

## Fixes

### Reforged

### Vanilla

- Parties on the world map are no longer hidden after loading a game, while the game is still paused
- Spiders will now give up when their team has given up even if there are still eggs on the battlefield
- You can no longer do two Arenas during the same day
- Newly spawned faction parties no longer teleport a few tiles towards their destination during the first tick
- Hitpoint and Armor damage base damage rolls for attacks are no longer separate. The same base damage roll is now used for both damage types
- Characters spawning mid battle can no longer be morale checked by side-stepping (e.g. Goblin Wolfrider)
- Every accessory now plays a default sound when moved around in the inventory
- Change the inventory icon of the **Witchhunter's Hat** to look exactly like the sprite on the brother
- The id of the item `mouth_piece` is changed to `armor.head.mouth_piece` (it used to be `armor.head.witchhunter_hat`)
- Remove a duplicate loading screen

## For Modders

- Entities which have `this.m.IsActingEachTurn = false` (e.g. Donkeys, Phylactery, Spider Eggs) will now trigger `onRoundEnd` after every other entity has triggered it and trigger `onRoundStart` before every other entity has triggered it
- `IsSpecializedInShields` is no longer set to `true` by **Shield Expert**

### New Character Properties

- `ShieldDamageMult` multiplies incoming shield damage up to a minimum of 1
- `ReachAdvantageMult` is a multiplier for melee skill during reach advantage
- `ReachAdvantageBonus` is a flat bonus for melee skill during reach advantage
- `CanExertZoneOfControl` (`true` by default) can be set to `false` to force an entity to no longer exert zone of control

# Requirements

- Reforged

# Known Issues:

- Enemies may spawn with perks that they can't use anymore (**Duelist**/**Formidable Approach**) because I didn't touch their spawning behaviors in that regard.
- Using Recover will prevent you from using **Wait Round** for the rest of this round
- **Student** will double-dip for the Manhunter Origin for Slaves.

# Compatibility

- Is safe to remove from- and add to any existing savegames
- Removing or adding this mod will not update existing perk trees. Only after some days you will encounter brothers with the changed perk trees.
