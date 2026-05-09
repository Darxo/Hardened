// We remove the reforged build script for bandit T4 locations, as we now handle those in the build_bandit_camp_action script
::MSU.Array.removeByValue(::Const.FactionTrait.Actions[::Const.FactionTrait.Bandit], "scripts/factions/actions/rf_build_bandit_camp_action");
