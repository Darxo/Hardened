# Description

This submod is a collection of changes to Reforged that I suggested internally that didn't make it into the mod [yet]. In order to still enjoy those ideas/tweaks I made them into this submod for myself; and maybe others.

# List of all Changes

## Major Changes

### Reach Rework

- You have Reach Advantage during any melee attack if your Reach is greater than the Reach of the entity you are attacking
- Reach Advantage always grants 13% increased Melee Skill (it is unaffected by the difference in Reach)
- Reach is 0 while the character does not emit a zone of control (e.g. stunned, fleeing)
- Reach is halved while the character is rooted

**Removed from Reforged:**
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

## Additions

- Add new **Battle Song** skill while holding a **Lute** for applying a temporary Resolve buff to nearby allies
- Add face warpaint to all fast bandits

## Balance & Polishing

### Perks

- Change **Dodge** effect is now between 5% and 20% of Initiative (instead of always 15%) depending on the amount of adjacent empty tiles
- Change **Duelist** to only works for one-handed weapons. The Penetration is increased to 30% and is now also halfed with 2 enemies and disabled with 3+
- **Fortified Mind** now provides 30% Resolve (up from 25%). This Bonus is now reduces by 1% for each Helmet Weight.
- **Battle Forged** no longer provide any Reach Ignore
- **Nimble** is completely reworked: It now always provides a 60% Hitpoint damage reduction but no longer reduces your armor damage taken. It now increases your armor damage taken by a percentage equal to your combined helmet and armor weight
- **Poise** is now called **Flexible** and is completely reworked: It now reduces damage which ignores Armor by 60%. This is reduced by 1% for each combined helmet and body armor weight. It also increases your Ranged Defense by the percentage of your missing total armor.
- **Nimble** and **Flexible** (formerly Poise) no longer exclude each other from being picked, after one of them is learned
- **Flail Spinner** now has a 100% chance to procc (up from 50%) but will only target a random different valid enemy.
- Rework **Formidable Approach** to only work for Two-Handed weapons. It now grant 15 Melee Skill instead of Reach but only triggers when you are the one moving next to an enemy. When your maximum Hitpoints are higher than those of your opponent, it removes confident from them.
- **Inspiring Presence** no longer requires a banner. It is only active for the brother with the highest resolve among all brothers with that perk and only affects brothers with less resolve than the Leader. It now proccs on Round-Start instead of Turn-Start.
- Rework **Spear Advantage** to double the effect of Reach Advantage on you
- Relocate the skill **Sprint** from **Pathfinder** to **Footwork**. **Footwork** has been renamed to **Escape Artist**

### Items

- **Wodden Flail** now deals 15-30 damage (up from 10-25) and costs 60 gold (up from 40)
- **Goblin Pikes**, **Ancient Pikes** and **Pikes** are now also of the weapontype Spear
- **Sergeant's Sash** now only provides the +10 Resolve if its user has the perk Rally the Troops
- **Fangshire** will no longer spawn at the start of the game

### Skills

- **Recover** now applies the same Initiative debuff as using **Wait**
- **Puncture** now requires the target to be surrounded by atleast 2 enemies
- **Stab** now costs 3 Action Points (down from 4)
- **Hand-to-Hand Attack** now has 0% Hitchance bonus (up from -10%)
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

### Traits

- **Lucky** no longer grants a chance to reroll incoming attacks. It now provides a 5% chance to avoid damage from any source.
- **Weasel** now provides an additional 25 Melee Defense during that brothers turn while fleeing.
- **Irrational** will no longer appear on recruits.

### Enemies

- Zombies no longer have **Double Grip** but gain +5 Melee Skill in return.

### Other

- **Wait** now debuffs the actual Initiative until the start of that brothers next turn
- Armor Penetration is capped at 100%. Any Armor Penetration above 100% has no effect. Reaching 100% Armor Pen still has damage reduction from remaining armor applied.
- Level-Ups for Attribute with 2 stars have -1 to minimum roll and +1 to maximum roll (compared to Vanilla) and are fully randomized in that range (compared to Reforged)
- **Bags and Belts** is now part of the **Light Armor** group instead of being available for everyone
- **Dodge** is removed from the **Light Armor** group. It is now only available in the **Medium Armor** group
- Characters which are not visible to the player will no longer produce idle or death sounds.
- The combat map is no longer revealed at the end of a battle
- Every accessory now plays a default sound when moved around in the inventory

## Quality of Life

- Legendary Armor and Armor with an attachement that you un-equip are now automatically marked as to-be-repaired
- **Night Effect**, **Double Grip** and **Pattern Recognition** no longer display a Mini-Icon
- **Brawny**, **Fortified Mind** and **Colossus** on all NPCs are now replaced with an equivalent amount of stats
- Improve formatting of **Nimble** and **Poise** perk desriptions
- The tooltips of your attributes now display your Base Attribute value and the difference between that Base value and your current value
- Settlements now display a tooltip showing how many days ago you last visited that location

## Fixes

### Reforged

### Vanilla

- Parties on the world map are no longer hidden after loading a game, while the game is still paused
- You can no longer do two Arenas during the same day
- Newly spawned faction parties no longer teleport a few tiles towards their destination during the first tick

# Requirements

- Reforged

# Known Issues:

- Enemies may spawn with perks that they can't use anymore (**Duelist**/**Formidable Approach**) because I didn't touch their spawning behaviors in that regard.
- Using Recover will prevent you from using **Wait Round** for the rest of this round
- Famed Shields can still roll shieldignore stat even though that is now hidden and doesn't do anything

# Compatibility

- Is safe to remove from- and add to any existing savegames
- Removing or adding this mod will not update existing perk trees. Only after some days you will encounter brothers with the changed perk trees.
