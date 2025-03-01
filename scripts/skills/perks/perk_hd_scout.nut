this.perk_hd_scout <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		EmptyTilesRequiredPerVision = 3,	// This perk grants 1 Vision for every this many adjacent empty tiles

		// Private
		DestinationTile = null,	// We remember the destination tile during movement so we are able to calculate Vision, as if we are already at the destination
	},
	function create()
	{
		this.m.ID = "perk.hd_scout";
		this.m.Name = ::Const.Strings.PerkName.HD_Scout;
		this.m.Description = "High ground and a clear view are your greatest assets.";
		this.m.Icon = "ui/perks/perk_hd_scout.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local visionModifier = this.getVisionModifier(this.m.DestinationTile);
		if (visionModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/vision.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(visionModifier, {AddSign = true}) + " [Vision|Concept.SightDistance]"),
			});
		}

		return ret;
	}

	function isHidden()
	{
		return this.getVisionModifier(this.m.DestinationTile) == 0;
	}

	function onUpdate( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants vision depending on adjacent objects
		this.getContainer().getActor().m.LevelActionPointCost = 0;
		_properties.Vision += this.getVisionModifier(this.m.DestinationTile);
	}

// MSU Events
	function onMovementStep( _tile, _levelDifference )
	{
		// Vanilla does an updateVisibility with the destination tile directly after this call.
		// This is bad because this skills Vision bonus is depending on tile position.
		// To solve that, we utilize a DestinationTile member which holds the expected tile, aswell as forcing a last update() call to calculate the Vision
		this.m.DestinationTile = _tile;
		this.getContainer().update();
	}

	function onMovementFinished( _tile )
	{
		this.m.DestinationTile = null;
	}

// New Functions
	// _tile is an optional alternative tile of origin for the calculation. This is important for calculating vision during movement
	function getVisionModifier( _tile = null )
	{
		local actor = this.getContainer().getActor();
		if (_tile == null && actor.isPlacedOnMap())
		{
			_tile = actor.getTile();
		}

		if (this.m.EmptyTilesRequiredPerVision == 0 || _tile == null)
		{
			return 0;
		}

		local emptyTiles = 0.0;
		for (local i = 0; i < 6; ++i)
		{
			if (!_tile.hasNextTile(i)) continue;

			local adjacentTile = _tile.getNextTile(i);
			if (adjacentTile.IsEmpty || adjacentTile.Level + 2 <= _tile.Level || adjacentTile.getEntity().getID() == actor.getID())
			{
				++emptyTiles;
			}
		}

		return ::Math.floor(emptyTiles / this.m.EmptyTilesRequiredPerVision);
	}
});
