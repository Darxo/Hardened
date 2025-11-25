
# Debugging

::MSU.Log.printData(_table, 2);

## Cause End-of-combat Freeze

::Tactical.State.m.TacticalDialogScreen.m.Animating = true;
::Tactical.State.m.TacticalDialogScreen.hide();

## Unbrick End-of-combat Screen

::Tactical.State.m.TacticalCombatResultScreen.show();

::Tactical.State.tactical_retreat_screen_onYesPressed();

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
	local firstParty = null;
	foreach (index, faction in combat.Factions)
	{
		if (faction.len() == 0) continue;

		::logWarning("Faction.getName() " + ::World.FactionManager.getFaction(index).getName());

		foreach (party in faction)
		{
			if (firstParty == null)
			{
				firstParty = party;
			}
			else
			{
				::logWarning("IsAllied: " + firstParty.getName() + " " + party.getName() + " isAllied: " + firstParty.isAlliedWith(party));
			}

			::logWarning("party.getName() " + party.getName());

			foreach (knownOpponent in party.getController().getKnownOpponents())
			{
				::logWarning("Hardened: Known Opponents:");
				::MSU.Log.printData(knownOpponent, 2);
			}

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

## Check current contract/world difficulties

::logWarning("World Difficulty: " + ::Hardened.Global.getWorldDifficultyMult());
::logWarning("Contract Difficulty: " + ::Hardened.Global.getWorldContractMult());

::DynamicSpawns.Const.Logging = true;
::DynamicSpawns.Const.DetailedLogging = false;

## Check states of dynamic unit blocks

:MSU.Log.printData(::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.BarbarianBeastmaster").DynamicDefs.Units, 2)
foreach (unitBlock in ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.NecromancerWithBodyguards").DynamicDefs.Units)
{
	// ::logWarning("unitBlock " + unitBlock.BaseID + " getCost " + unitBlock.Class.getPredictedWorth());
	local unit = ::DynamicSpawns.Public.getUnit(unitBlock.BaseID);
	::MSU.Log.printData(unit);
}

## Test Dynamic Spawn Framework parties

// first true is fixedResources; second true is detailedLogging
::DynamicSpawns.Tests.printSpawn("HexenAndMore", 900, true, true);
::DynamicSpawns.Tests.printSpawn("Necromancer", 200, true, true);

foreach (unitBlock in ::DynamicSpawns.Public.getUnitBlock("UnitBlock.RF.NecromancerWithBodyguards").DynamicDefs.Units)
{
	// ::logWarning("unitBlock " + unitBlock.BaseID + " getCost " + unitBlock.Class.getPredictedWorth());
	local unit = clone ::DynamicSpawns.Public.getUnit(unitBlock.BaseID);
	unit.init();
	::logWarning("Hardened: " + unit.getID() + " minCost " + unit.getMinCost());
	// ::MSU.Log.printData(unit);
}

## Focus on an entity, given an ID

::World.getCamera().moveTo(::World.getEntityByID(6577174));

## Inspect neighboring tiles and do something to them

local bro = ::getBro("Gernot");
foreach (nextTile in ::MSU.Tile.getNeighbors(bro.getTile()))
{
	if (nextTile.IsEmpty) continue;
	if (nextTile.IsOccupiedByActor) continue;

	::Tactical.getShaker().shake(nextTile.getEntity(), bro.getTile(), 3);
}


::MSU.Log.printData(::Tactical.getCamera().queryEntityOverlays(), 2);


::MSU.Log.printData(::Tactical.getCamera().zoomTo(2.0, 2.0))
::MSU.Log.printData(::Tactical.getCamera().queryEntityOverlays(), 2);

default y offset is 40 but it is divided by ::Tactical.getCamera().Zoom

## Super Speed Swifter World Map

::World.setSpeedMult(400.0);

return ::World.FactionManager.isGreaterEvil();
return ::World.FactionManager.m.GreaterEvil.Phase;

