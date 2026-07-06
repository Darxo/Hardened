// Ijirok Charge skill
::Hardened.HooksMod.hook("scripts/skills/actives/gore_skill", function(q) {
// Public
	q.m.HD_MaximumAdjacentEnemies <- 3;

	// This skill can no longer be used while engaged in melee
	q.m.HD_UsableWhileEngagedInMelee = false;
	q.m.HD_Cooldown = 2;		// So that it is only used every second turn

	q.create = @(__original) function()
	{
		__original();

		this.m.MaxRange = 7;	// Vanilla: 6
		this.m.HD_KnockBackDistance = 2;
	}

	// Overwrite, because we remove the vanilla condition where the line from us to the target must be "free"/"empty"
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.getDefaultTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = "Target an empty tile that is adjacent to at most 3 enemies. Charge to that tile and attack all adjacent characters",
		});

		if (this.m.HD_KnockBackDistance > 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Knock all attacked characters back " + ::MSU.Text.colorPositive(this.m.HD_KnockBackDistance) + " tile",
			});

			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Apply [$ $|Skill+staggered_effect] to anyone who was knocked back"),
			});
		}

		return ret;
	}}.getTooltip;

	// Overwrite, because we remove the vanilla condition where the line from us to the target must be "free"/"empty"
	q.onVerifyTarget = @() { function onVerifyTarget( _originTile, _targetTile )
	{
		if (!this.skill.onVerifyTarget(_originTile, _targetTile)) return false;
		if (!_targetTile.IsEmpty) return false;

		local adjacentEnemies = 0;

		foreach (nextTile in ::MSU.Tile.getNeighbors(_targetTile))
		{
			if (!nextTile.IsOccupiedByActor) continue;
			if (nextTile.getEntity().isAlliedWith(this.getContainer().getActor())) continue;

			adjacentEnemies++;
		}

		return adjacentEnemies <= this.m.HD_MaximumAdjacentEnemies;
	}}.onVerifyTarget;

	// Overwrite, because we only stagger the targets, if they were actually pushed back
	q.applyEffectToTarget = @() { function applyEffectToTarget( _user, _target, _targetTile )
	{
		if (this.m.HD_KnockBackDistance == 0) return;
		if (_target.getCurrentProperties().IsImmuneToKnockBackAndGrab) return;
		if (_target.getCurrentProperties().IsRooted) return;

		local knockToTile = this.findTileToKnockBackTo(_user.getTile(), _targetTile);
		if (knockToTile != null)
		{
			// Todo: Interruption
			local skills = _target.getSkills();

			skills.removeByID("effects.shieldwall");
			skills.removeByID("effects.spearwall");
			skills.removeByID("effects.riposte");

			_target.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			::Tactical.State.handleInvoluntaryMovement(_target, _user, _targetTile, knockToTile, this, null, null);
		}
	}}.applyEffectToTarget;

	// Overwrite, because we
	//	- remove the vanilla hard-coded damage values
	//	- remove the 75% Armor Damage mult
	// 	- prevent its range to be raise to 10 tiles during the first turn
	q.onUpdate = @() { function onUpdate( _properties )
	{
	}}.onUpdate;

// New Functions
	q.onMovementCallback <- function( _tag )
	{
		if (_tag.TargetTile.IsEmpty)
		{
			_tag.Actor.setCurrentMovementType(this.Const.Tactical.MovementType.Default);
			this.Tactical.getNavigator().teleport(_tag.Actor, _tag.TargetTile, null, null, false);
		}
	}
});

