::Hardened.wipeClass("scripts/skills/perks/perk_rf_vigorous_assault", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_vigorous_assault", function(q) {
	// Public
	q.m.TilesPerSet <- 2;	// This perk deals in sets of X tiles. Its bonus is handed out for every these tiles you move
	q.m.ActionPointModifierPerSet <- -1;
	q.m.FatigueCostPctPerSet <- -0.1;

	// Private
	q.m.TilesMovedThisTurn <- 0;
	q.m.PrevTile <- null;	// Previous tile, so that we can measure the distance after moving from it

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		if (this.getActionPointModifier() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Your next attack costs " + ::MSU.Text.colorizeValue(this.getActionPointModifier(), {InvertColor = true, AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Action Point(s)|Concept.ActionPoints]"),
			});
		}

		if (this.getFatigueCostMultiplier() != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = "Your next attack costs " + ::MSU.Text.colorizeMultWithText(this.getFatigueCostMultiplier(), {InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Fatigue|Concept.Fatigue]"),
			});
		}

		// TOdo: look over this after everything else
		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Will expire upon using a throwing attack, [waiting|Concept.Wait] or ending the turn."),
		});

		return ret;
	}

	q.isHidden <- function()
	{
		return this.getActionPointModifier() == 0 && this.getFatigueCostMultiplier() == 1.0;
	}

	// Overwrite because we rewrite the original effect so it works with TilesMovedThisTurn and improving modability
	q.onAfterUpdate = @() function( _properties )
	{
		local actor = this.getContainer().getActor();
		if (!actor.isActiveEntity()) return;

		// The effect of this skill expires upon using any skill, so we reflect that in the preview
		if (actor.isPreviewing() && actor.getPreviewSkill() != null) return;

		// QoL: If we preview movement, we pretend like the character actually moves those tiles for the purpose of calculating the new cost of all skills after the movement
		local additionalPreviewDistance = actor.isPreviewing() && actor.getPreviewMovement() != null ? actor.getPreviewMovement().Tiles : 0;

		local actionPointModifier = this.getActionPointModifier(this.m.TilesMovedThisTurn + additionalPreviewDistance);
		local fatigueCostMult = this.getFatigueCostMultiplier(this.m.TilesMovedThisTurn + additionalPreviewDistance);

		if (actionPointModifier != 0 || fatigueCostMult != 1.0)
		{
			foreach (skill in this.getContainer().m.Skills)
			{
				if (this.isSkillValid(skill))
				{
					skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + actionPointModifier);
					skill.m.FatigueCostMult *= fatigueCostMult;
				}
			}
		}
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

	q.onMovementFinished <- function( _tile )
	{
		if (this.m.PrevTile != null)
		{
			this.m.TilesMovedThisTurn += _tile.getDistanceTo(this.m.PrevTile);
			this.m.PrevTile = null;
		}
	}

	q.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		this.m.TilesMovedThisTurn = 0;
	}

	q.onWaitTurn <- function()
	{
		this.m.TilesMovedThisTurn = 0;
	}

	q.onTurnEnd <- function()
	{
		this.m.TilesMovedThisTurn = 0;
	}

	q.onCombatFinished <- function()
	{
		this.m.TilesMovedThisTurn = 0;
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (!_skill.isAttack()) return false;

		local weapon = _skill.getItem();
		if (::MSU.isNull(weapon) || !weapon.isItemType(::Const.Items.ItemType.Weapon)) return false;

		return weapon.isItemType(::Const.Items.ItemType.MeleeWeapon) || weapon.isWeaponType(::Const.Items.WeaponType.Throwing);
	}

	/// @param _tilesMoved custom amount of moves tiles for which we want to get the action point discount.
	/// 	If null, this.m.TilesMovedThisTurn will be used instead
	q.getActionPointModifier <- function( _tilesMoved = null )
	{
		if (_tilesMoved == null) _tilesMoved = this.m.TilesMovedThisTurn;
		_tilesMoved += this.getNPCVirtualTilesMoved();

		// We need to floor, to get the rounding we advertise in the perk description
		local twoTileSets = ::Math.floor(_tilesMoved / this.m.TilesPerSet);

		return twoTileSets * this.m.ActionPointModifierPerSet;
	}

	/// @param _tilesMoved custom amount of moves tiles for which we want to get the action point discount.
	/// 	If null, this.m.TilesMovedThisTurn will be used instead
	q.getFatigueCostMultiplier <- function( _tilesMoved = null )
	{
		if (_tilesMoved == null) _tilesMoved = this.m.TilesMovedThisTurn;
		_tilesMoved += this.getNPCVirtualTilesMoved();

		// We need to floor, to get the rounding we advertise in the perk description
		local twoTileSets = ::Math.floor(_tilesMoved / this.m.TilesPerSet);

		return ::Math.maxf(0.0, 1.0 + twoTileSets * this.m.FatigueCostPctPerSet);
	}

	// We potentially cook the numbers in the NPCs favor, so we can teach it in a dirty way, to plan its turn with Vigorous Assault in mind
	q.getNPCVirtualTilesMoved <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isPlayerControlled()) return 0;

		// Reduce the AP cost preemptively by assuming a movement of tilesRequiredForAPBonus for AI to allow for
		// AI behaviors which check for AP cost of attacks for setting tile scores when calculating where to go
		local aoo = this.getContainer().getAttackOfOpportunity();
		if (aoo != null)
		{
			local actors = ::Tactical.Entities.getAllInstancesAsArray();
			local canReachSomeoneWithVigorousAssault = false;
			foreach (a in actors)
			{
				if (a.isAlliedWith(actor)) continue;

				local distance = a.getTile().getDistanceTo(actor.getTile());
				if (distance <= aoo.getMaxRange())
				{
					return 0;	// If the NPC has someone attackable, we do not give it any virtual discount from this perk
				}

				if (distance <= this.m.TilesPerSet + aoo.getMaxRange())
				{
					canReachSomeoneWithVigorousAssault = true;
				}
			}

			if (canReachSomeoneWithVigorousAssault) return this.m.TilesPerSet;
		}

		return 0;
	}
});
