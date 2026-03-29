this.hd_onslaught_skill <- this.inherit("scripts/skills/actives/rf_onslaught_skill", {
	m = {
		HD_Radius = 1,		// Radius of the affected tiles around the targeted tile
	},
	function create()
	{
		this.rf_onslaught_skill.create();

		this.m.ID = "actives.hd_onslaught";
		this.m.ActionPointCost = 7;		// Reforged: 7; Hardened: 7
		this.m.FatigueCost = 40;		// Reforged: 30; Hardened: 30
		this.m.AIBehaviorID = null;		// There is currently no AI script, that knows how to handle this iteration of the reforged skill

		this.m.MaxRange = 4;				// Reforged: unspecified; Hardened: 4
		this.m.IsTargeted = true;			// Reforged: unspecified
		this.m.IsTargetingActor = false;	// Reforged: unspecified
		this.m.MaxLevelDifference = 3;		// Reforged: unspecified
	}

	function getTooltip()
	{
		local ret = this.rf_onslaught_skill.getTooltip();

		foreach (entry in ret)
		{
			if (entry.id == 10)
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("Target a tile. All allies of your faction within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tile(s) of that target gain the [$ $|Skill+rf_onslaught_effect] effect for two [rounds|Concept.Round]");
			}
		}

		foreach (key, entry in ret)
		{
			// This skill is no longer restricted to be used once per battle
			if (entry.id == 21)
			{
				ret.remove(key);
				break;
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
		// Unlike the Reforged version, we don't set IsSpent to true here, as this skill can be used multiple times per combat

		foreach (affectedEntity in this.HD_getAffectedEntities(_targetTile))
		{
			affectedEntity.getSkills().add(::new("scripts/skills/effects/rf_onslaught_effect"));
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
