::Hardened.wipeClass("scripts/skills/perks/perk_rf_entrenched", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_entrenched", function(q) {
	// Public
	q.m.ResolvePerAlly <- 5;
	q.m.RangedDefensePerObstacle <- 5;
	q.m.RangedSkillMult <- 1.15;
	q.m.RequiredAdjacentObjects <- 3;	// At least this many adjacent tiles must be allies/obstacles for the ranged skill bonus to activate

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This character\'s confidence in combat is increased due to support from adjacent allies and cover.";
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		local resolveModifier = this.getResolveModifier();
		if (resolveModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/bravery.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(resolveModifier, {AddSign = true}) + " [Resolve|Concept.Bravery]"),
			});
		}

		local rangedDefenseModifier = this.getRangedDefenseModifier();
		if (rangedDefenseModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(rangedDefenseModifier, {AddSign = true}) + " [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		local rangedSkillMult = this.getRangedSkillMult();
		if (rangedSkillMult != 1.0)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/ranged_skill.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeMultWithText(rangedSkillMult) + " [Ranged Skill|Concept.RangeSkill]"),
			});
		}

		return ret;
	}

	q.isHidden <- function()
	{
		return this.getRangedDefenseModifier() == 0 && this.getResolveModifier() == 0;
	}

	q.onUpdate <- function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants resolve, ranged defense and ranged skill depending on adjacent objects
		_properties.Bravery += this.getResolveModifier();
		_properties.RangedDefense += this.getRangedDefenseModifier();
		_properties.RangedSkillMult *= this.getRangedSkillMult();
		this.updateMiniIcon();
	}

// MSU Events
	q.onMovementFinished = @(__original) function()
	{
		__original();
		this.updateMiniIcon();
	}

// New Functions
	q.updateMiniIcon <- function()
	{
		local oldIsHidingIconMini = this.m.IsHidingIconMini;
		this.m.IsHidingIconMini = (this.getRangedSkillMult() == 1.0);	// Mini-Icon is only shown while the ranged skill bonus is active
		if (oldIsHidingIconMini != this.m.IsHidingIconMini)
		{
			this.getContainer().getActor().setDirty(true);	// Update UI overlay
		}
	}

	q.getResolveModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap())
		{
			local adjacentAllies = ::Tactical.Entities.getAlliedActors(actor.getFaction(), actor.getTile(), 1, true).len();
			return adjacentAllies * this.m.ResolvePerAlly;
		}
		else
		{
			return 0;
		}
	}

	q.getRangedDefenseModifier <- function()
	{
		if (this.getContainer().getActor().isPlacedOnMap())
		{
			local adjacentObstacles = 0;
			foreach (nextTile in ::MSU.Tile.getNeighbors(this.getContainer().getActor().getTile()))
			{
				if (!nextTile.IsEmpty && !nextTile.IsOccupiedByActor)
				{
					++adjacentObstacles;
				}
			}
			return adjacentObstacles * this.m.RangedDefensePerObstacle;
		}
		else
		{
			return 0;
		}
	}

	q.getRangedSkillMult <- function()
	{
		local adjacentValidObjects = (this.getResolveModifier() / this.m.ResolvePerAlly) + (this.getRangedDefenseModifier() / this.m.RangedDefensePerObstacle);
		return (adjacentValidObjects >= this.m.RequiredAdjacentObjects) ? this.m.RangedSkillMult : 1.0;
	}
});
