
# Debugging

## Unbrick End-of-combat Screen

::Tactical.State.m.TacticalCombatResultScreen.show();

::Tactical.State.tactical_retreat_screen_onYesPressed();

## Check, who is fighting on the world map atm

foreach (combat in ::World.Combat.m.Combats)
{
	::logWarning("Combat ID: " + combat.ID);
	foreach (faction in combat.Factions)
	{
		if (::MSU.isNull(faction)) continue;

		::MSU.Log.printData(combatant);
	}
}

## Play Animation at the last hovered tile

local tile = ::Tactical.State.m.LastTileHovered;
if (tile != null)
{
	for( local i = 0; i < this.Const.Tactical.HD_PlayerDeath.len(); i = ++i )
	{
		local effect = this.Const.Tactical.HD_PlayerDeath[i];
		this.Tactical.spawnParticleEffect(false, effect.Brushes, tile, effect.Delay, effect.Quantity, effect.LifeTimeQuantity, effect.SpawnRate, effect.Stages, this.createVec(0, 0));
	}
}

## Print Stacktrace
::MSU.Log.printStackTrace();

## Fire Event

::World.Events.fire("event.religious_peasants", true);

## Show current combats on world map

::World.Combat.m.Combats.len()

foreach (combat in ::World.Combat.m.Combats)
{
	::logWarning("Combat ID: " + combat.ID);
	::logWarning("combat.IsResolved: " + combat.IsResolved.tostring());
	foreach (index, faction in combat.Factions)
	{
		if (faction.len() == 0) continue;

		::logWarning("Faction.getName() " + ::World.FactionManager.getFaction(index).getName());

		foreach (party in faction)
		{
			::logWarning("party.getName() " + party.getName());
		}
	}
}

## Calculate a path on the world map between player/town

local navSettings = this.World.getNavigator().createSettings();
navSettings.ActionPointCosts = this.Const.World.TerrainTypeNavCost;
navSettings.RoadMult = 1.0;
// local firstTown = ::getTown("Horum");
local firstTown = ::World.State.getPlayer();
local secondTown = ::getTown("Kahlenberg");
local path = ::World.getNavigator().findPath(firstTown.getTile(), secondTown.getTile(), navSettings, 0);
::logWarning("path.getSize() " + path.getSize());
::MSU.Log.printData(path, 2);
::MSU.Log.printData(path.getNext(), 2);

## See stats of nearby units

foreach (factionID, faction in ::World.FactionManager.m.Factions)
{
	if (faction == null) continue;
	foreach (unit in faction.m.Units)
	{
		if (unit.getTile().getDistanceTo(::World.State.getPlayer().getTile()) > 6) continue;
		// ::logWarning("Hardened: factionID " + factionID + " faction " + faction.getType());
		::logWarning("Hardened: unit.getName() " + unit.getName() + " unit.getBaseMovementSpeed() " + unit.getBaseMovementSpeed());
	}
}

## Check states of neighbors on battle field

foreach (tile in ::MSU.Tile.getNeighbors(::getBro("Thorben").getTile()))
{
	if (!tile.IsOccupiedByActor) continue;
	local neighbor = tile.getEntity();
	::logWarning("Hardened: Neighbor: " + neighbor.getName());
}
