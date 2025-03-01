this.perk_hd_elusive <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		RequiredTileDistance = 2,	// This perks effect becomes active after moving this many tiles during a turn

		// Private
		IsInEffect = false,
		TilesMovedThisTurn = 0,
		PrevTile = null,	// Previous tile, so that we can measure the distance after moving from it
	},
	function create()
	{
		this.m.ID = "perk.hd_elusive";
		this.m.Name = ::Const.Strings.PerkName.HD_Elusive;
		this.m.Description = "You are impossible to pin down!";
		this.m.Icon = "ui/perks/perk_rf_trip_artist.png";
		this.m.IconMini = "perk_hd_elusive_mini";
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
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]"),
			});
		}

		return ret;
	}

	function isHidden()
	{
		return !this.m.IsInEffect;
	}

	function onUpdate( _properties )
	{
		this.getContainer().getActor().m.ActionPointCosts = ::Const.PathfinderMovementAPCost;	// This will not stack with Pathfinder perk
		if (this.m.IsInEffect)
		{
			_properties.IsImmuneToRoot = true;
		}
	}

	function onTurnStart()
	{
		this.m.IsInEffect = false;
		this.m.TilesMovedThisTurn = 0;
		this.m.PrevTile = this.getContainer().getActor().getTile();
	}

	function onSpawned()
	{
		this.m.PrevTile = this.getContainer().getActor().getTile();
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

// MSU Functions
	function onMovementFinished( _tile )
	{
		this.m.TilesMovedThisTurn += _tile.getDistanceTo(this.m.PrevTile);
		this.m.PrevTile = _tile;

		// Usually we'd want the tile calculation to be more sophisticated, but since we stop counting at 2 tiles, we dont have to deal with curves
		if (this.m.TilesMovedThisTurn >= this.m.RequiredTileDistance)
		{
			this.m.IsInEffect = true;
		}
	}
});
