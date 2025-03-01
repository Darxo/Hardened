::Hardened.wipeClass("scripts/skills/perks/perk_rf_through_the_ranks");

// This rarely used Reforged perk is hijacked an renamed into "Scout"
::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_through_the_ranks", function(q) {
	// Public
	q.m.EmptyTilesRequiredPerVision <- 3;	// This perk grants 1 Vision for every this many adjacent empty tiles

	// Private
	q.m.DestinationTile <- null;	// We remember the destination tile during movement so we are able to calculate Vision, as if we are already at the destination

	q.create <- function()
	{
		this.m.ID = "perk.rf_through_the_ranks";
		this.m.Name = ::Const.Strings.PerkName.RF_ThroughTheRanks;
		this.m.Description = "High ground and a clear view are your greatest assets.";
		this.m.Icon = "ui/perks/perk_hd_scout.png";
		this.m.Type = ::Const.SkillType.Perk | this.Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.getTooltip <- function()
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

	q.isHidden <- function()
	{
		return this.getVisionModifier(this.m.DestinationTile) == 0;
	}

	q.onUpdate <- function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants vision depending on adjacent objects
		this.getContainer().getActor().m.LevelActionPointCost = 0;
		_properties.Vision += this.getVisionModifier(this.m.DestinationTile);
	}

// MSU Events
	q.onMovementStep <- function( _tile, _levelDifference )
	{
		// Vanilla does an updateVisibility with the destination tile directly after this call.
		// This is bad because this skills Vision bonus is depending on tile position.
		// To solve that, we utilize a DestinationTile member which holds the expected tile, aswell as forcing a last update() call to calculate the Vision
		this.m.DestinationTile = _tile;
		this.getContainer().update();
	}

	q.onMovementFinished <- function( _tile )
	{
		this.m.DestinationTile = null;
	}

// New Functions
	// _tile is an optional alternative tile of origin for the calculation. This is important for calculating vision during movement
	q.getVisionModifier <- function( _tile = null )
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
