// Hooks
{
	::Hardened.util.registerCustomUnitFigure(::Reforged.Spawns.Units["Unit.RF.RF_BanditPillagerTough"], "figure_hd_bandit_vandal");		// Reforged: figure_rf_bandit_pillager
	::Hardened.util.registerCustomUnitFigure(::Reforged.Spawns.Units["Unit.RF.RF_BanditRaiderTough"], "figure_hd_bandit_pillager");		// Reforged: figure_bandit_03
	::Hardened.util.registerCustomUnitFigure(::Reforged.Spawns.Units["Unit.RF.RF_BanditMarauderTough"], "figure_hd_bandit_marauder");	// Reforged: figure_rf_bandit_marauder

	// Change world figure for bandit leader from the classic vanilla icon to that of how he actually looks like in Hardened due to equipment
	::Reforged.Spawns.Units["Unit.RF.BanditLeader"].Figure = "figure_bandit_05";	// Reforged: figure_bandit_04

	::Reforged.Spawns.Units["Unit.RF.RF_BanditPillagerTough"].StartingResourceMin = 120;	// Reforged: 140
	::Reforged.Spawns.Units["Unit.RF.RF_BanditVandal"].StartingResourceMin = 120;			// Reforged: 100
	::Reforged.Spawns.Units["Unit.RF.RF_BanditOutlaw"].StartingResourceMin = 185;			// Reforged: 150
	::Reforged.Spawns.Units["Unit.RF.RF_BanditHighwayman"].StartingResourceMin = 250;		// Reforged: 225

	// We enforce a much higher resource value for the robber baron
	::Reforged.Spawns.Units["Unit.RF.RF_BanditBaron"].StartingResourceMin = 500;	// Reforged: 350
}
