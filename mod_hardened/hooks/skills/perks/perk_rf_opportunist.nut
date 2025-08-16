::Hardened.wipeClass("scripts/skills/perks/perk_rf_opportunist", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_opportunist", function(q) {
	// Public
	q.m.ActionPointModifierTile <- -5;
	q.m.TilesNeededForDiscount <- 3;	// This character gets the AP discount after moving this many tiles during their turn
	q.m.MovementFatigueCostAdditional <- -2;

	// Private
	q.m.TilesMovedThisTurn <- 0;
	q.m.PrevTile <- null;	// Previous tile, so that we can measure the distance after moving from it
	q.m.NoDiscountBeforeMovement <- true;	// Used to determine, whether a certain movement flipped over the effect from NoDiscount -> Discount

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Glide over terrain and strike before your enemies even see you coming.";
		this.m.Overlay = "perk_rf_opportunist";
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		if (this.getActionPointModifier() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = "Your next throwing attack costs " + ::MSU.Text.colorizeValue(this.getActionPointModifier(), {InvertColor = true, AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Action Point|Concept.ActionPoints]"),
			});

			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Will expire upon using a throwing attack, [waiting|Concept.Wait] or ending the turn."),
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return (this.getActionPointModifier() == 0);
	}

	q.onAnySkillExecuted <- function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (this.isSkillValid(_skill))
		{
			this.m.TilesMovedThisTurn = 0;
		}
	}

	q.onUpdate <- function( _properties )
	{
		if (this.isEnabled())
		{
			_properties.MovementFatigueCostAdditional += this.m.MovementFatigueCostAdditional;
		}
	}

	q.onAfterUpdate <- function( _properties )
	{
		if (!this.isEnabled()) return;

		local actor = this.getContainer().getActor();
		// The effect of this skill expires upon using any skill, so we reflect that in the preview
		if (actor.isPreviewing() && actor.getPreviewSkill() != null && this.isSkillValid(actor.getPreviewSkill())) return;

		// QoL: If we preview movement, we pretend like the character actually moves those tiles for the purpose of calculating the new cost of all skills after the movement
		local additionalPreviewDistance = actor.isPreviewing() && actor.getPreviewMovement() != null ? actor.getPreviewMovement().Tiles : 0;
		local actionPointModifier = this.getActionPointModifier(this.m.TilesMovedThisTurn + additionalPreviewDistance);

		if (actionPointModifier == 0) return;

		foreach (skill in this.getContainer().m.Skills)
		{
			if (this.isSkillValid(skill))
			{
				skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + actionPointModifier);
			}
		}
	}

	q.onMovementStarted = @() function( _tile, _numTiles )
	{
		this.m.NoDiscountBeforeMovement = (this.getActionPointModifier() == 0);

		if (this.getContainer().getActor().isActiveEntity())
		{
			this.m.TilesMovedThisTurn += _numTiles;

			if (_numTiles == 0)	// This is an indicator, that we were "teleported", instead of having moved naturally
			{
				this.m.PrevTile = _tile;
			}
		}
	}

	q.onMovementFinished <- function()
	{
		if (this.m.PrevTile != null)
		{
			this.m.TilesMovedThisTurn += this.getContainer().getActor().getTile().getDistanceTo(this.m.PrevTile);
			this.m.PrevTile = null;
		}

		if (this.m.NoDiscountBeforeMovement && this.getActionPointModifier() != 0) this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}

	q.onTurnStart <- function()
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

// New Functions
	// Overwrite because we can't remove that individual condition that easy
	q.isEnabled <- function()
	{
		if (this.getContainer().getActor().isDisarmed()) return false;

		local weapon = this.getContainer().getActor().getMainhandItem();
		if (weapon == null || !weapon.isWeaponType(::Const.Items.WeaponType.Throwing))
		{
			return false;
		}

		return true;
	}

	q.isSkillValid <- function( _skill )
	{
		if (!_skill.isAttack()) return false;
		if (!_skill.isRanged()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Throwing)) return false;

		return true;
	}

	/// @param _customTilesMoved custom amount of moves tiles for which we want to get the action point discount.
	/// 	If null, this.m.TilesMovedThisTurn will be used instead
	q.getActionPointModifier <- function( _customTilesMoved = null )
	{
		if (_customTilesMoved != null && _customTilesMoved < this.m.TilesNeededForDiscount) return 0;
		if (this.m.TilesMovedThisTurn < this.m.TilesNeededForDiscount) return 0;

		return this.m.ActionPointModifierTile;
	}
});
