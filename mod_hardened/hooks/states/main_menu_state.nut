::Hardened.HooksMod.hook("scripts/states/main_menu_state", function(q) {
	q.onInit = @(__original) function()
	{
		__original();

		::Hardened.util.registerScenario("scripts/scenarios/tactical/scenario_hd_kraken");
		::Hardened.util.registerScenario("scripts/scenarios/tactical/scenario_hd_ijirok");
		::Hardened.util.registerScenario("scripts/scenarios/tactical/scenario_hd_sunken_library");
		::Hardened.util.registerScenario("scripts/scenarios/tactical/scenario_hd_icy_cave");
		::Hardened.util.registerScenario("scripts/scenarios/tactical/scenario_hd_witch_hut");
		::Hardened.util.registerScenario("scripts/scenarios/tactical/scenario_hd_black_monolith");
		::Hardened.util.registerScenario("scripts/scenarios/tactical/scenario_hd_abandoned_village");
	}
});
