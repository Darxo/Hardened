::Hardened.wipeClass("scripts/skills/perks/perk_rf_trip_artist");

// This now redundant (after the Offhadn Training change) Reforged perk is hijacked an renamed into "Elusive"
::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_trip_artist", function(q) {
	// Public
	q.m.RequiredTileDistance <- 2;	// This perks effect becomes active after moving this many tiles during a turn

	// Private
	q.m.IsInEffect <- false;
	q.m.TilesMovedThisTurn <- 0;
	q.m.PrevTile <- null;	// Previous tile, so that we can measure the distance after moving from it

	q.create <- function()
	{
		this.m.ID = "perk.rf_trip_artist";
		this.m.Name = ::Const.Strings.PerkName.RF_TripArtist;

		this.m.Description = "You are impossible to pin down!";
		this.m.Icon = "ui/perks/perk_rf_trip_artist.png";
		this.m.IconMini = "";	// TODO
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	q.isHidden <- function()
	{
		return !this.m.IsInEffect;
	}

	q.getTooltip <- function()
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
				text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]."),
			});
		}

		return ret;
	}

	q.onUpdate <- function( _properties )
	{
		this.getContainer().getActor().m.ActionPointCosts = ::Const.PathfinderMovementAPCost;	// This will not stack with Pathfinder perk
		if (this.m.IsInEffect)
		{
			_properties.IsImmuneToRoot = true;
		}
	}

	q.onTurnStart <- function()
	{
		this.m.IsInEffect = false;
		this.m.TilesMovedThisTurn = 0;
		this.m.PrevTile = this.getContainer().getActor().getTile();
	}

	q.onSpawned <- function()
	{
		this.m.PrevTile = this.getContainer().getActor().getTile();
	}

	q.onCombatFinished <- function()
	{
		this.skill.onCombatFinished();
		this.m.IsInEffect = false;
	}

	q.onMovementFinished <- function( _tile )
	{
		this.m.TilesMovedThisTurn += _tile.getDistanceTo(this.m.PrevTile);
		this.m.PrevTile = _tile;

		if (this.m.TilesMovedThisTurn >= this.m.RequiredTileDistance)
		{
			this.m.IsInEffect = true;
		}
	}
});
