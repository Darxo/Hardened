{	// Functions
	::MSU.Table.merge(::Hardened.Comp, {
		// Anything that uses spawntables to spawn/add troops, will have its available resources adjusted by this value
		isCombatSimulatorFight = function()
		{
			if (!::Hooks.hasMod("mod_combat_simulator")) return false;
			return ::CombatSimulator.isCombatSimulatorFight();
		}
	});
}
