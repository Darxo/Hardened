// This class managed Bounty Hunter parties on the world map
// It lives in the entity_manager and it is attached to its update() and the global serialize/deserialize events
this.bounty_hunter_manager <- {
	m = {
	// Public
		BaseResources = 180,	// default resources that bounty hunter will use
		PartyMax = 1,			// maximum allowed bounty hunter parties on the world map
		RoamingDistance = [8, 20],	// Bounty Hunter this many tiles away from their employer
		RoamingDuration = 200.0,		// Bounty Hunter roam for their employer for this many BB Seconds

	// Private
		BountyHunters = [],		// weakrefs on all bounty hunter parties existing in the world
		LastUpdateTime = 0,
		UpdateTimeInSeconds = 3.0,		// Every this many virtual seconds, we manage all bounty hunter parties
		WorldFlagName = "HD_BountyHunterIDs",
	},

	function create () {}

	function update()
	{
		this.__collectGarbage()

		// To save performance, we only manage bounty hunters every 3 virtual seconds
		if (!this.__isNewUpdateCycle()) return;

		if (this.getAllBountyHunters().len() < this.m.PartyMax)
		{
			this.__spawnNewParty();
		}

		foreach (bountyHunter in this.getAllBountyHunters())
		{
			bountyHunter.updatePlayerRelation();
			this.__updateOrders(bountyHunter);
		}
	}

	function clear()
	{
		this.m.BountyHunters = [];
		this.m.LastUpdateTime = 0;
	}

	function getAllBountyHunters()
	{
		return this.m.BountyHunters;
	}

	// Because we use WorldFlags, it is important, that this function is called before the World Flags are serialized
	function onSerialize()
	{
		local serializedString = "";
		foreach (party in this.getAllBountyHunters())
		{
			if (::MSU.isNull(party)) continue;
			if (!party.isAlive()) continue;
			serializedString += party.getID() + ";";
		}
		::World.Flags.set(this.m.WorldFlagName, serializedString);
	}

	function onDeserialize()
	{
		if (!::World.Flags.has(this.m.WorldFlagName)) return;

		local deserializedString = ::World.Flags.get(this.m.WorldFlagName);
		foreach (bountyHunterID in split(deserializedString, ";"))
		{
			local party = ::World.getEntityByID(bountyHunterID.tointeger());
			if (party == null) continue;

			this.m.BountyHunters.push(::WeakTableRef(party));
		}
	}

// Private
	function __collectGarbage()
	{
		local garbage = [];
		local bountyHunterArray = this.getAllBountyHunters();
		foreach (i, bountyHunter in bountyHunterArray)
		{
			if (bountyHunter.isNull() || !bountyHunter.isAlive()) garbage.push(i);
		}
		garbage.reverse();
		foreach (g in garbage)
		{
			bountyHunterArray.remove(g);
		}
	}

	function __isNewUpdateCycle()
	{
		if (this.m.LastUpdateTime + this.m.UpdateTimeInSeconds > ::Time.getVirtualTimeF()) return false;

		this.m.LastUpdateTime = ::Time.getVirtualTimeF();
		return true;
	}

	function __spawnNewParty()
	{
		local originSettlement = this.__findStartingSettlement();
		if (originSettlement == null) return;	//  This can happen if there are too few settlements on the map

		local party = ::World.spawnEntity("scripts/entity/world/party", originSettlement.getTile().Coords);
		party.setPos(::createVec(party.getPos().X - 50, party.getPos().Y - 50));

		party.setName(this.__findUnusedMercenaryName());
		party.setDescription("A group of bounty hunters travelling the lands and lending their swords to the highest bidder.");
		party.setFootprintType(::Const.World.FootprintsType.Mercenaries);
		party.getSprite("base").setBrush("world_base_07");
		party.getSprite("body").setBrush("figure_mercenary_0" + ::Math.rand(1, 2));		// Todo: find unique unused world figure??
		party.getSprite("banner").setBrush(::Hardened.util.findUnusedMercenaryBanner());
		if (originSettlement.getFactions().len() == 1)
		{
			party.setFaction(originSettlement.getOwner().getID());
		}
		else
		{
			party.setFaction(originSettlement.getFactionOfType(::Const.FactionType.Settlement).getID());
		}

		this.__refreshTroops(party);

		this.__addLoot(party);

		party.getFlags().set("IsMercenaries", true);		// So that you can kill these for the merc ambition
		party.getFlags().set("HD_IsBountyHunters", true);	// So we can later identify them again

		this.m.BountyHunters.push(::WeakTableRef(party))
	}

	function __findStartingSettlement()
	{
		local playerTile = ::World.State.getPlayer().getTile();
		local candidates = [];
		foreach (settlement in ::World.EntityManager.getSettlements())
		{
			if (settlement.isIsolated()) continue;
			if (settlement.getTile().getDistanceTo(playerTile) <= 10) continue;

			candidates.push(settlement);
		}
		if (candidates.len() == 0) return null;

		return ::MSU.Array.rand(candidates);
	}

	function __refreshTroops( _party )
	{
		_party.clearTroops();
		local resources = this.m.BaseResources * ::Hardened.Global.getWorldDifficultyMult() * ::Hardened.Global.FactionDifficulty.Mercenaries;
		::Const.World.Common.assignTroops(_party, ::Const.World.Spawn.BountyHunters, resources);
	}

	function __addLoot( _party )
	{
		// Currently this is a 1:1 copy of the mercenary party loot
		_party.getLoot().Money = ::Math.rand(300, 600);
		_party.getLoot().ArmorParts = ::Math.rand(0, 25);
		_party.getLoot().Medicine = ::Math.rand(0, 10);
		_party.getLoot().Ammo = ::Math.rand(0, 50);

		local foodLoot = ::MSU.Class.WeightedContainer([
			[12, "supplies/beer_item"],
			[12, "supplies/bread_item"],
			[12, "supplies/dried_fruits_item"],
			[12, "supplies/mead_item"],
		]);
		_party.addToInventory(foodLoot.roll());
		_party.addToInventory(foodLoot.roll());
	}

	function __updateOrders( _party )
	{
		local controller = _party.getController();
		if (controller.getOrders().len() > 2) return;
		// When there are only two orders left, that means the party has done a cycle and are waiting for new orders
		// Should they not receive new orders in time, e.g. because Hardened was removed, then they will despawn after some time

		local newDestinationSettlement = this.__findNewDestination(_party);
		if (newDestinationSettlement == null) return;

		// First thing we need to do is refreshing the units in our party
		local brush = _party.getSprite("body").getBrush().Name;
		this.__refreshTroops(_party);
		_party.getSprite("body").setBrush(brush);	// We preserve the previous brush

		// Replace all existing orders with a fresh set
		local controller = _party.getController();
		controller.clearOrders();
		local wait1 = ::new("scripts/ai/world/orders/wait_order");		// Linger around after turning in last contract
		wait1.setTime(::Math.rand(10, 20) * 1.0);
		local move1 = ::new("scripts/ai/world/orders/move_order");		// Move to a new Settlement
		move1.setDestination(newDestinationSettlement.getTile());
		local wait2 = ::new("scripts/ai/world/orders/wait_order");		// Linger around a bit in the new settlement; accept contract
		wait2.setTime(::Math.rand(10, 60) * 1.0);
		local roam = ::new("scripts/ai/world/orders/roam_order");		// Look for bounty targets
		roam.setAllTerrainAvailable();
		roam.setTerrain(::Const.World.TerrainType.Ocean, false);
		roam.setTerrain(::Const.World.TerrainType.Shore, false);
		roam.setTerrain(::Const.World.TerrainType.Mountains, false);
		roam.setPivot(newDestinationSettlement);
		roam.setMinRange(this.m.RoamingDistance[0]);
		roam.setMaxRange(this.m.RoamingDistance[1]);
		roam.setTime(this.m.RoamingDuration);
		local move2 = ::new("scripts/ai/world/orders/move_order");		// Return to the settlement
		move2.setDestination(newDestinationSettlement.getTile());
		local wait3 = ::new("scripts/ai/world/orders/wait_order");		// Linger around in the settlement (give time to Hardened to refresh orders)
		wait3.setTime(30.0);	// Some arbitruary value, that is long enough to last until the next hardened bounty hunter manager cycle
		local despawn = ::new("scripts/ai/world/orders/despawn_order");		// Despawn, to clean themselves up, when removing Hardened

		controller.addOrder(wait1);
		controller.addOrder(move1);
		controller.addOrder(wait2);
		controller.addOrder(roam);
		controller.addOrder(move2);
		controller.addOrder(wait3);
		controller.addOrder(despawn);
	}

	function __findNewDestination( _party )
	{
		local validSettlements = [];
		foreach (settlement in ::World.EntityManager.getSettlements())
		{
			if (settlement.isIsolated()) continue;
			if (!settlement.isAlliedWith(_party)) continue;
			validSettlements.push(settlement);
		}
		if (validSettlements.len() == 0) return null;

		return ::MSU.Array.rand(validSettlements);
	}

	function __findUnusedMercenaryName()
	{
		local unusedNames = [];

		foreach (mercName in ::Const.Strings.MercenaryCompanyNames)
		{
			if (mercName == ::World.Assets.getName()) continue;

			local skipName = false;
			foreach (worldParty in ::Hardened.util.getAllWorldEntities())
			{
				if (mercName == worldParty.getName())
				{
					skipName = true;
					break;
				}
			}
			if (skipName) continue;

			unusedNames.push(mercName);
		}

		return ::MSU.Array.rand(unusedNames);
	}
}
