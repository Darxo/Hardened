local reachSkillDescription = ::new("scripts/skills/special/rf_reach").m.Description;

::Reforged.NestedTooltips.Tooltips.Concept.Reach = ::MSU.Class.BasicTooltip("Reach", reachSkillDescription);
::Reforged.NestedTooltips.Tooltips.Concept.ReachAdvantage = ::MSU.Class.BasicTooltip("Reach Advantage", ::Reforged.Mod.Tooltips.parseString("A character is considered to have Reach Advantage when their [Reach|Concept.Reach] is greater than that of the other character during a melee attack."));
::Reforged.NestedTooltips.Tooltips.Concept.ReachDisadvantage = ::MSU.Class.BasicTooltip("Reach Disadvantage", ::Reforged.Mod.Tooltips.parseString("A character is considered to have Reach Disadvantage when their [Reach|Concept.Reach] is lower than that of the other character during a melee attack."));
