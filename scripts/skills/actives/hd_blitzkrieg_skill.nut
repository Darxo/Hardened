this.hd_blitzkrieg_skill <- this.inherit("scripts/skills/actives/rf_blitzkrieg_skill", {
	m = {
		HD_Radius = 1,		// Radius of the affected tiles around the targeted tile
	},
	function create()
	{
		this.rf_blitzkrieg_skill.create();

		this.m.ID = "actives.hd_blitzkrieg";
		this.m.ActionPointCost = 9;		// Reforged: 7; Hardened: 9
		this.m.FatigueCost = 50;		// Reforged: 30; Hardened: 50
		this.m.AIBehaviorID = null;		// There is currently no AI script, that knows how to handle this iteration of the reforged skill

		this.m.MaxRange = 4;				// Reforged: unspecified; Hardened: 4
		this.m.IsTargeted = true;			// Reforged: unspecified
		this.m.IsTargetingActor = false;	// Reforged: unspecified
		this.m.MaxLevelDifference = 3;		// Reforged: unspecified
	}

	function getTooltip()
	{
		local ret = this.rf_blitzkrieg_skill.getTooltip();

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Target a tile. All allies of your faction within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tile(s) of that target gain the [Adrenaline|Skill+adrenaline_effect] effect until they start their turn in the next round");
			}
		}

		ret.push({
			id = 15,
			type = "text",
			icon = "ui/icons/vision.png",
			text = "Has a range of " + ::MSU.Text.colorizeValue(this.getMaxRange()) + " tiles",
		});

		return ret;
	}

	function onTargetSelected( _targetTile )
	{
		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

	function onUse( _user, _targetTile )
	{
		this.m.IsSpent = true;

		foreach (affectedEntity in this.HD_getAffectedEntities(_targetTile))
		{
			local effect = ::new("scripts/skills/effects/adrenaline_effect");
			if (!affectedEntity.isTurnStarted() && !affectedEntity.isTurnDone())
			{
				effect.m.TurnsLeft++;
			}
			affectedEntity.getSkills().add(effect);
		}

		return true;
	}

// New Functions
	function HD_getAffectedEntities( _targetTile )
	{
		local affectedEntities = [];

		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			if (!tile.IsOccupiedByActor) continue;

			local entity = tile.getEntity()
			if (!this.HD_isValidTarget(entity)) continue;

			affectedEntities.push(entity);
		}

		return affectedEntities;
	}

	// Determine, whether _target is a valid entity to be affected by this skills
	function HD_isValidTarget( _target )
	{
		if (_target.getFaction() != ::Const.Faction.Player) return false;;
		if (_target.getMoraleState() == ::Const.MoraleState.Fleeing) return false;
		if (_target.getCurrentProperties().IsStunned) return false;
		if (_target.isNonCombatant()) return false;

		return true;
	}

	// Return all affected tiles
	function getAffectedTiles( _targetTile )
	{
		return ::MSU.Tile.HD_getRadiusTiles(_targetTile, this.m.HD_Radius);
	}
});
