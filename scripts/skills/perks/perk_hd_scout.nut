this.perk_hd_scout <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		VisionModifier = 0,	// This much vision is granted at all times
		EmptyTilesRequiredPerVision = 3,	// This perk grants 1 Vision for every this many adjacent empty tiles

		// Private
		CurrentVirtualStepTile = null,	// We remember the virtual tile during movement steps so we are able to calculate Vision, as if we are at that location
		NextVirtualStepTile = null,	// Helper variable to save the next tile in this step-sequence. Required because during the very first step of a sequence should be using the actors current position
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

		local visionModifier = this.getVisionModifier(this.m.CurrentVirtualStepTile);
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
		return this.getVisionModifier(this.m.CurrentVirtualStepTile) <= this.m.VisionModifier;	// We only display this perk if its conditional bonus is active, to reduce overall effect bloat
	}

	function onUpdate( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants vision depending on adjacent objects
		this.getContainer().getActor().m.LevelActionPointCost = 0;
		_properties.Vision += this.getVisionModifier(this.m.CurrentVirtualStepTile);
	}

// MSU Events
	function onMovementStep( _tile, _levelDifference )
	{
		// In Hardened we do a visibility call with the current virtual tile, when the next step is greenlit
		// This is bad because this skills Vision bonus is depending on tile position where we are standing currently
		// To solve that, we utilize a CurrentVirtualStepTile member which holds the expected tile, aswell as forcing a last update() call to calculate the Vision
		this.m.CurrentVirtualStepTile = this.m.NextVirtualStepTile;
		this.m.NextVirtualStepTile = _tile;

		this.getContainer().update();
	}

	function onMovementFinished()
	{
		this.m.CurrentVirtualStepTile = null;
		this.m.NextVirtualStepTile = null;
	}

// New Functions
	// _tile is an optional alternative tile of origin for the calculation. This is important for calculating vision during movement
	function getVisionModifier( _tile = null )
	{
		local ret = this.m.VisionModifier;

		local actor = this.getContainer().getActor();
		if (_tile == null && actor.isPlacedOnMap())
		{
			_tile = actor.getTile();
		}

		if (this.m.EmptyTilesRequiredPerVision == 0 || _tile == null)
		{
			return ret;
		}

		local emptyTiles = 0.0;
		foreach (adjacentTile in ::MSU.Tile.getNeighbors(_tile))
		{
			if (adjacentTile.IsEmpty || adjacentTile.Level + 2 <= _tile.Level || adjacentTile.getEntity().getID() == actor.getID())
			{
				++emptyTiles;
			}
		}

		ret += ::Math.floor(emptyTiles / this.m.EmptyTilesRequiredPerVision);

		return ret;
	}
});
