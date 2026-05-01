local oldIsCombatSimulatorFight = ::CombatSimulator.isCombatSimulatorFight;
::CombatSimulator.isCombatSimulatorFight = function() {
	// Fix: Combat Simulator preventing tactical scenarios from starting
	if (::Tactical.State.isScenarioMode()) return false;

	return oldIsCombatSimulatorFight();
}
