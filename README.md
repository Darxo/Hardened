# Description

This submod is a collection of changes to Reforged that I suggested internally that didn't make it into the mod [yet]. In order to still enjoy those ideas/tweaks I made them into this submod for myself; and maybe others.

# List of all Changes

## Major Changes

- Disable Veteran Perks

### Reach Rework

- You have Reach Advantage during any melee attack if your Reach is greater than the Reach of the entity you are attacking
- Reach Advantage always grants 13% increased Melee Skill (it is unaffected by the difference in Reach)
**Removed from Reforged:**
- penalty for Reach Disadvantage
- overcoming Reach Temporarily
- Reach Ignore Stat on Shields

## Additions

- Add new **Battle Song** skill while holding a **Lute** for applying a temporary Resolve buff to nearby allies
- Add face warpaint to all fast bandits

## Balance & Polishing

### Perks

- Change **Dodge** effect is now between 5% and 20% of Initiative (instead of always 15%) depending on the amount of adjacent empty tiles
- Change **Duelist** to only works for one-handed weapons. The Penetration is increased to 30% and is now also halfed with 2 enemies and disabled with 3+
- Rework **Formidable Approach** to only works for Two-Handed weapons, grant 15 Melee Skill instead of Reach and trigger a morale check on being the first to approach an enemy
- Rework **Spear Advantage** to double the effect of Reach Advantage on you
- **Inspiring Presence** no longer requires a banner. It is only active for the brother with the highest resolve among all brothers with that perk and only affects brothers with less resolve than the Leader. It now proccs on Round-Start instead of Turn-Start.
- Relocate the skill **Sprint** from **Pathfinder** to **Footwork**. **Footwork** has been renamed to **Escape Artist**

### Items

- **Wodden Flail** now deals 15-30 damage (up from 10-25) and costs 60 gold (up from 40)
- **Goblin Pikes**, **Ancient Pikes** and **Pikes** are now also of weapontype Spear
- **Fangshire** will no longer spawn at the start of the game

### Other

- **Wait** now debuffs the actual Initiative until the start of that brothers next turn
- **Recover** now applies the same Initiative debuff as using **Wait**
- **Puncture** now requires the target to be surrounded by atleast 2 enemies
- **Stab** now costs 3 Action Points (down from 4)
- **Thrust** now has 0% Hitchance bonus (down from 10%)
- **Slash** now has 0% Hitchance bonus (down from 5%)
- Armor Penetration is capped at 100%. Any Armor Penetration above 100% has no effect. Reaching 100% Armor Pen still has damage reduction from remaining armor applied.
- Level-Ups for Attribute with 2 stars have -1 to minimum roll and +1 to maximum roll (compared to Vanilla) and are fully randomized in that range (compared to Reforged)

## Quality of Life

- Legendary Armor and Armor with an attachement that you un-equip are now automatically marked as to-be-repaired
- **Night Effect**, **Double Grip** and **Pattern Recognition** no longer display a Mini-Icon
- **Brawny**, **Fortified Mind** and **Colossus** on all NPCs are now replaced with an equivalent amount of stats

# Requirements

- Reforged

# Known Issues:

- Enemies may spawn with perks that they can't use anymore (**Duelist**/**Formidable Approach**) because I didn't touch their spawning behaviors in that regard.
- Using Recover will prevent you from using **Wait Round** for the rest of this round

# Compatibility

- Is safe to remove from- and add to any existing savegames
