::Hardened.HooksMod.hook("scripts/skills/actives/footwork", function(q) {
	// Private
	q.m.TilesMovedThisTurn <- 0;
	q.m.PrevTile <- null;	// Previous tile, so that we can measure the distance after moving from it

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Use skillful footwork to get out of danger.";
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Move to an adjacent tile, ignoring [Zone of Control|Concept.ZoneOfControl] and [Spearwall|Skill+spearwall_effect]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = "Costs " + ::MSU.Text.colorPositive("-1") + ::Reforged.Mod.Tooltips.parseString(" [Action Point|Concept.ActionPoints] (" + ::MSU.Text.colorizeValue(this.getActionPointModifier(), {InvertColor = true, AddSign = true}) + ") for every tile you move during your [turn|Concept.Turn], until you use this skill or end your [turn|Concept.Turn]"),
		});

		local actor = this.getContainer().getActor();
		if (!::Tactical.isActive() || !actor.getTile().hasZoneOfControlOtherThan(actor.getAlliedFactions()))
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because you are not in an opponent\'s [Zone of Control|Concept.ZoneOfControl]"),
			});
		}
		else
		{
			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = ::Reforged.Mod.Tooltips.parseString("Can only be used while in an opponent\'s [Zone of Control|Concept.ZoneOfControl]"),
			});
		}

		if (actor.getCurrentProperties().IsRooted)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because you are [rooted|Concept.Rooted]"),
			});
		}
		else
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cannot be used while [rooted|Concept.Rooted]"),
			});
		}

		return ret;
	}

	q.onAnySkillExecuted = @(__original) function( _skill, _targetTile, _targetEntity, _forFree )
	{
		__original(_skill, _targetTile, _targetEntity, _forFree);

		if (this == _skill)
		{
			this.m.TilesMovedThisTurn = 0;
		}
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (!::Tactical.isActive()) return;

		// QoL: If we preview movement, we pretend like the character actually moves those tiles for the purpose of calculating the new cost of all skills after the movement
		local actor = this.getContainer().getActor();
		local additionalPreviewDistance = actor.isPreviewing() && actor.getPreviewMovement() != null ? actor.getPreviewMovement().Tiles : 0;
		local actionPointModifier = this.getActionPointModifier(this.m.TilesMovedThisTurn + additionalPreviewDistance);

		this.m.ActionPointCost = ::Math.max(0, this.m.ActionPointCost + actionPointModifier);
	}

	q.onMovementStarted = @() function( _tile, _numTiles )
	{
		if (this.getContainer().getActor().isActiveEntity())
		{
			this.m.TilesMovedThisTurn += _numTiles;

			if (_numTiles == 0)	// This is an indicator, that we were "teleported", instead of having moved naturally
			{
				this.m.PrevTile = _tile;
			}
		}
	}

	q.onMovementFinished = @(__original) function()
	{
		__original();

		if (this.m.PrevTile != null)
		{
			this.m.TilesMovedThisTurn += this.getContainer().getActor().getTile().getDistanceTo(this.m.PrevTile);
			this.m.PrevTile = null;
		}
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.TilesMovedThisTurn = 0;
	}

	q.onTurnEnd = @(__original) function()
	{
		__original();
		this.m.TilesMovedThisTurn = 0;
	}

// New Functions
	/// @param _customTilesMoved custom amount of moves tiles for which we want to get the action point discount.
	/// 	If null, this.m.TilesMovedThisTurn will be used instead
	q.getActionPointModifier <- function( _customTilesMoved = null )
	{
		local tilesMoved = this.m.TilesMovedThisTurn;
		if (_customTilesMoved != null) tilesMoved = _customTilesMoved;
		return -1 * tilesMoved;
	}
});
