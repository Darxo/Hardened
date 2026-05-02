::Hardened.HooksMod.hookTree("scripts/scenarios/tactical/scenario_template", function(q) {
	q.generate = @(__original) function()
	{
		this.HD_createGlobalDummyObjects();

		::MSU.__canCreateDummyPlayer = true;

		__original();

		// Fix(Vanilla): some enemy configuration (e.g. icy cave-like fight) as Tactical Scenarios not attacking properly
		foreach (index, strategy in ::Tactical.Entities.m.Strategies)
		{
			strategy.setIsAttackingOnWorldmap(true);
		}
	}

// New Functions
	q.HD_createGlobalDummyObjects <- function()
	{
		::World.Assets <- ::new("scripts/states/world/asset_manager");
		::World.FactionManager <- ::new("scripts/factions/faction_manager");
		::World.FactionManager.isAlliedWithPlayer <- function(_f)
		{
			return ::Const.FactionAlliance[_f].find(::Const.Faction.Player) != null;
		}

		::World.Retinue <- ::new("scripts/retinue/retinue_manager");

		// Vanilla Fix: Define CombatProperties during tactical scenarios to improve mod compatibility
		local combatProperties = ::Const.Tactical.CombatInfo.getClone();
		::Tactical.State.setStrategicProperties(combatProperties);
	}
});
