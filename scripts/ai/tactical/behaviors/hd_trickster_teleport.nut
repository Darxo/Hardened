/*
Goal:
- Consider using Teleport with a low priority (only if no other option is possible)
- Find target for teleport
	- Target should be closer to the closest hostile, than our origin tile
	- Or it should be 6 tiles or less to the nearest enemy
*/

this.hd_trickster_teleport <- this.inherit("scripts/ai/tactical/behavior", {
	m = {
		// Public
		PossibleSkills = [
			"actives.teleport",
		],

		// Private
		SelectedSkill = null,
		Target = null,
	},
	function create()
	{
		this.m.ID = ::Const.AI.Behavior.ID.HD_Trickster_Teleport;
		this.m.Order = ::Const.AI.Behavior.Order.HD_Trickster_Teleport;
		this.m.IsThreaded = true;
		this.behavior.create();
	}

	function onEvaluate( _entity )
	{
		// Function is a generator.
		this.m.SelectedSkill = null;
		this.m.Target = null;
		local zeroScore = ::Const.AI.Behavior.Score.Zero;

		foreach (otherBehavior in this.getAgent().m.Behaviors)
		{
			if (otherBehavior.getID() == this.getID()) continue;
			if (otherBehavior.getID() == ::Const.AI.Behavior.ID.Idle) continue;
			if (otherBehavior.getScore() == ::Const.AI.Behavior.Score.Zero) continue;

			// If there is any other behavior in the current evaluation, which has a non-zero score, then we skip our own evaluation
			// This is possible, because we have a very late Order value
			// We want teleport to always be the last resort for this boss fight
			return ::Const.AI.Behavior.Score.Zero;
		}

		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return zeroScore;

		this.m.SelectedSkill = this.selectSkill(this.m.PossibleSkills);
		if (this.m.SelectedSkill == null) return zeroScore;		// Not affordable/usable

		local func = this.findGoodTile(_entity, this.m.SelectedSkill);
		while (resume func == null)
		{
			yield null;
		}
		if (this.m.Target == null) return zeroScore;		// No Valid Tile found

		return ::Const.AI.Behavior.Score.HD_Trickster_Teleport;
	}

	function onExecute( _entity )
	{
		if (::Const.AI.VerboseMode)
		{
			this.logInfo("* " + _entity.getName() + ": Using " + this.m.SelectedSkill.getName() + " on some tile!");
		}

		this.m.SelectedSkill.use(this.m.Target);

		if (!_entity.isHiddenToPlayer())
		{
			this.getAgent().declareAction();
		}

		this.m.SelectedSkill = null;
		this.m.Target = null;
		return true;
	}

// New Functions
	// Check randomly and deterministically every possible tile on the map until a "good tile" is found that is either
	//	- within 6 tiles of an enemy
	//	- closer to the nearest enemy than our current tile
	// @param _entity the actor whose current position is used to determine a good target
	// @param _skill that we target with
	// @return first good tile found
	function findGoodTile( _entity, _skill )
	{
		// Function is a generator.
		local time = ::Time.getExactTime();
		local validTiles = [];
		local size = ::Tactical.getMapSize();
		for (local x = 0; x < size.X; ++x)
		{
			for( local y = 0; y < size.Y; ++y )
			{
				local tile = ::Tactical.getTileSquare(x, y);
				if (!tile.IsEmpty) continue;

				validTiles.push(tile);
			}
		}

		if (this.isAllottedTimeReached(time))
		{
			yield null;
		}

		// We randomize validTiles, so that we have a fresh random list of tiles to iterate over for trying to find a valid tile
		::MSU.Array.shuffle(validTiles);

		local myClosestHostileDistance = this.closestHostileDistance(_entity, _entity.getTile());
		foreach (tile in validTiles)
		{
			if (this.isAllottedTimeReached(time)) yield null;

			if (!_skill.HD_isUsableOnForFree(tile)) continue;

			local closestHostileDistance = this.closestHostileDistance(_entity, tile);
			if (closestHostileDistance <= 6 || closestHostileDistance < myClosestHostileDistance)
			{
				this.m.Target = tile;
				return true;
			}
		}

		return true;
	}

	// Return the distance to the closest hostile of _user, from the tile _tile
	function closestHostileDistance( _user, _tile )
	{
		local closestHostileDistance = 9999;

		foreach (otherActor in ::Tactical.Entities.getAllInstancesAsArray())
		{
			if (!otherActor.isPlacedOnMap()) continue;
			if (_user.isAlliedWith(otherActor)) continue;

			local distance = _tile.getDistanceTo(otherActor.getTile())
			if (distance < closestHostileDistance)
			{
				closestHostileDistance = distance;
			}
		}

		return closestHostileDistance;
	}
});
