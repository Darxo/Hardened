::Hardened.HooksMod.hook("scripts/skills/actives/rf_sanguine_curse_skill", function(q) {
// Public
	q.m.HD_Radius <- 1;		// Radius of the affected tiles around the targeted tile
	q.m.HD_MentalCheckDifficulty <- 30;

// Hardened
	q.m.HD_Cooldown = 2;

	q.create = @(__original) function()
	{
		__original();

		this.m.IsAttack = false;	// Reforged: true
		this.m.IsAOE = true;		// Reforged: false
	}

	q.getTooltip = @() function()
	{
		local ret = this.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Target a tile. Trigger a negative mental morale check with an additional difficulty of " + ::MSU.Text.colorPositive(this.m.HD_MentalCheckDifficulty) + " on all enemies within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tile(s) of that target"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Any enemy, who fails that mental morale check, gains [$ $|Skill+rf_sanguine_curse_effect]"),
		});

		return ret;
	}


	// Overwrite, because we implemet our skill in a different way
	q.onUse = @() function( _user, _targetTile )
	{
		// Unlike the Reforged version, we don't set IsSpent to true here, as this skill can be used multiple times per combat

		foreach (affectedEntity in this.HD_getAffectedEntities(_targetTile))
		{
			if (affectedEntity.checkMorale(0, -this.m.HD_MentalCheckDifficulty, ::Const.MoraleCheckType.MentalAttack)) continue;

			local curse = ::new("scripts/skills/effects/rf_sanguine_curse_effect");
			curse.setCaster(_user);
			affectedEntity.getSkills().add(curse);
		}

		return true;
	}

	// Overwrite, because we allow targeting someone who already has this curse
	q.onVerifyTarget = @() function( _originTile, _targetTile )
	{
		return this.skill.onVerifyTarget(_originTile, _targetTile);
	}

	q.onTargetSelected = @() function( _targetTile )
	{
		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

// New Functions
	q.HD_getAffectedEntities <- function( _targetTile )
	{
		local affectedEntities = [];

		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			if (!tile.IsOccupiedByActor) continue;

			local entity = tile.getEntity()
			if (!this.HD_isValidTarget(entity)) continue;

			affectedEntities.push(entity);
		}

		return affectedEntities;
	}

	// Determine, whether _target is a valid entity to be affected by this skills
	q.HD_isValidTarget <- function( _target )
	{
		if (_target.isAlliedWith(this.getContainer().getActor())) return false;
		if (_target.isNonCombatant()) return false;
		if (_target.getCurrentProperties().IsImmuneToBleeding) return false;
		if (_target.getSkills().hasSkill("effects.rf_sanguine_curse")) return false;

		return true;
	}

	// Return all affected tiles
	q.getAffectedTiles <- function( _targetTile )
	{
		return ::MSU.Tile.HD_getRadiusTiles(_targetTile, this.m.HD_Radius);
	}
});
