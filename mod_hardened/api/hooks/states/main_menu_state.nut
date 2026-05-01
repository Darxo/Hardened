::Hardened.HooksMod.hook("scripts/states/main_menu_state", function(q) {
	q.scenario_menu_module_onQueryData = @(__original) function()
	{
		local ret = __original();

		ret.extend(::Hardened.Private.CustomTacticalScenarios);

		return ret;
	}

	q.onSiblingAdded = @(__original) function( _stateName )
	{
		if (_stateName != "TacticalState") return __original(_stateName);

		local tacticalState = ::RootState.get("TacticalState");
		if (tacticalState == null) return __original(_stateName);

		foreach (customScenario in ::Hardened.Private.CustomTacticalScenarios)
		{
			if (this.m.SelectedScenarioID == customScenario.id)
			{
				tacticalState.setScenario(::new(customScenario.script));
				return;
			}
		}

		return __original(_stateName);
	}
});
