::Hardened.wipeClass("scripts/skills/perks/perk_rf_opportunist");

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_opportunist", function(q) {
	// Public
	q.m.ActionPointModifierPerTile <- -1;
	q.m.MovementFatigueCostAdditional <- -2;

	// Private
	q.m.TilesMovedThisTurn <- 0;
	q.m.PrevTile <- null;	// Previous tile, so that we can measure the distance after moving from it

	q.create <- function()
	{
		this.m.ID = "perk.rf_opportunist";
		this.m.Name = ::Const.Strings.PerkName.RF_Opportunist;
		this.m.Description = "Glide over terrain and strike before your enemies even see you coming.";
		this.m.Icon = "ui/perks/perk_rf_opportunist.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Last;
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
		if (this.isEnabled() && this.getActionPointModifier() != 0)
		{
			local actor = this.getContainer().getActor();
			if (!actor.isPreviewing() || actor.getPreviewMovement() != null || !this.isSkillValid(actor.getPreviewSkill()))
			{
				foreach (skill in this.getContainer().m.Skills)
				{
					if (this.isSkillValid(skill))
					{
						skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + this.getActionPointModifier());
					}
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

	q.getActionPointModifier <- function()
	{
		return this.m.TilesMovedThisTurn * this.m.ActionPointModifierPerTile;
	}
});
