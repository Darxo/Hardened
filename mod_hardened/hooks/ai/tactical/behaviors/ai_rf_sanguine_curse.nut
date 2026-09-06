::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_rf_sanguine_curse", function(q) {
// Public
	q.m.HD_ScoreBasePerTarget <- ::Const.AI.Behavior.Score.RF_SanguineCurse / 5;

	// Overwrite, because we calculate targeting completely differently
	q.onEvaluate = @() function( _entity )
	{
		this.m.Skill = null;
		this.m.TargetTile = null;

		local zero = ::Const.AI.Behavior.Score.Zero;
		if (_entity.getActionPoints() < ::Const.Movement.AutoEndTurnBelowAP) return zero;
		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return zero;

		this.m.Skill = this.selectSkill(this.m.PossibleSkills);
		if (this.m.Skill == null) return zero;

		local bestTarget = this.__findBestTarget(_entity, this.m.Skill);
		this.m.TargetTile = bestTarget.TargetTile;

		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		scoreMult *= this.getFatigueScoreMult(this.m.Skill);

		::Const.AI.Behavior.Score.RF_SanguineCurse

		return bestTarget.Score * scoreMult;
	}

// New Functions
	/// @return table with TargetTile and Score
	function __findBestTarget( _entity, _skill )
	{
		local ret = {
			Score = 0,
			TargetTile = null,
		};

		local myTile = _entity.getTile();
		local tiles = [];
		::Tactical.queryTilesInRange(myTile, _skill.getMinRange(), _skill.getMaxRange(), false, [], this.__onQueryTile, tiles);

		foreach (tile in tiles)
		{
			if (!_skill.isUsableOn(tile)) continue;

			local targets = _skill.HD_getAffectedEntities(tile);
			if (targets == 0) continue;

			local score = 0;
			foreach (target in targets)
			{
				score += __getTargetScore(_entity, target, _skill);
			}

			if (score > ret.Score)
			{
				ret.Score = score;
				ret.TargetTile = tile;
			}
		}

		return ret;
	}

	/// Calculate the score for getting _target afflicted with the acid debuff
	q.__getTargetScore <- function( _entity, _target, _skill )
	{
		local tile = _target.getTile();

		local score = this.m.HD_ScoreBasePerTarget;

		if (_target.getCurrentProperties().IsStunned) score *= 0.5;
		if (_target.getCurrentProperties().IsRooted) score *= 0.5;

		// The targeted tile is affected by something negative, the target is urged to move, triggering our curse
		if (_target.getTile().Properties.Effect != null && !_target.getTile().Properties.Effect.IsPositive) score *= 1.5;

		// If the target is locked in Zone of Control, they can't move to trigger our curse
		if (tile.hasZoneOfControlOtherThan(_target.getAlliedFactions())) score *= 0.8;

		// Target Hitpoitns are within kill-range
		if (_target.getHitpoints() <= 15) score *= 2.0;

		local targetValueMult = this.queryTargetValue(_entity, _target, _skill);
		score *= targetValueMult;

		return score;
	}

	q.__onQueryTile <- function( _tile, _tag )
	{
		_tag.push(_tile);
	}
});
