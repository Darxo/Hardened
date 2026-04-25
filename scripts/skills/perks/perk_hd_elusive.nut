this.perk_hd_elusive <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		RequiredTileDistance = 2,	// This perks effect becomes active after moving this many tiles during a turn

		// Private
		IsInEffect = false,
		TilesMovedThisTurn = 0,
		PrevTile = null,	// Previous tile, so that we can measure the distance after moving from it
		MovementAPCostBackup = null,	// We save the original value for this character before the addition of this perk, so we can reset it after removal
	},
	function create()
	{
		this.m.ID = "perk.hd_elusive";
		this.m.Name = ::Const.Strings.PerkName.HD_Elusive;
		this.m.Description = "You are impossible to pin down!";
		this.m.Icon = "ui/perks/perk_rf_trip_artist.png";
		this.m.IconMini = "perk_hd_elusive_mini";
		this.m.Overlay = "perk_hd_elusive";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.IsInEffect)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Immune to being [rooted|Concept.Rooted]"),
			});

			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
			});
		}

		return ret;
	}

	function isHidden()
	{
		return !this.m.IsInEffect;
	}

	function onAdded()
	{
		this.m.MovementAPCostBackup = this.getContainer().getActor().m.ActionPointCosts;

		// We need this perk is added during combat, we need to quickly instantiate this.m.PrevTile to prevent a crash from moving
		if (::Tactical.isActive())
		{
			this.m.PrevTile = this.getContainer().getActor().getTile();
		}
	}

	function onUpdate( _properties )
	{
		this.getContainer().getActor().m.ActionPointCosts = clone ::Const.PathfinderMovementAPCost;	// This will not stack with Pathfinder perk
		if (this.m.IsInEffect)
		{
			_properties.IsImmuneToRoot = true;
		}
	}

	function onRemoved()
	{
		if (this.m.MovementAPCostBackup != null)
		{
			this.getContainer().getActor().m.ActionPointCosts = this.m.MovementAPCostBackup;
		}
	}

	function onTurnStart()
	{
		this.m.IsInEffect = false;
		this.m.TilesMovedThisTurn = 0;
		this.m.PrevTile = this.getContainer().getActor().getTile();
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

	function onMovementFinished()
	{
		local tile = this.getContainer().getActor().getTile();
		this.m.TilesMovedThisTurn += tile.getDistanceTo(this.m.PrevTile);
		this.m.PrevTile = tile;

		// Usually we'd want the tile calculation to be more sophisticated, but since we stop counting at 2 tiles, we dont have to deal with curves
		if (this.m.TilesMovedThisTurn >= this.m.RequiredTileDistance)
		{
			this.HD_triggerEffect();
		}
	}

// Hardened Functions
	function onSpawned()
	{
		this.m.PrevTile = this.getContainer().getActor().getTile();
	}

// New Functions
	function HD_triggerEffect()
	{
		if (this.m.IsInEffect) return;

		this.m.IsInEffect = true;

		local actor = this.getContainer().getActor();
		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon(this.m.Overlay, actor.getTile());
		}
	}
});
