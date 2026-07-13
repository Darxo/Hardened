::Hardened.HooksMod.hook("scripts/skills/actives/swing", function(q) {
	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 6 && entry.icon == "ui/icons/hitchance.png")
			{
				ret.remove(index);
				break;
			}
		}

		if (!this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords)
		{
			ret.push({
				id = 6,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = "Has " + ::MSU.Text.colorNegative("-10%") + ::Reforged.Mod.Tooltips.parseString(" [chance to hit|Concept.Hitchance]"),
			});
		}

		return ret;
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original(_skill, _targetEntity, _properties);

		if (_skill == this)
		{
			_properties.MeleeSkill -= 5;	// This reverts the vanilla +5 Modifier
			this.m.HitChanceBonus = (this.getContainer().getActor().getCurrentProperties().IsSpecializedInSwords) ? 0 : -10;	// Vanilla never adjusted this variable
		}
	}

	// Overwrite, because we use the new getAffectedTiles function which improves accuracy when using at higher range
	q.onUse = @() function( _user, _targetTile )
	{
		this.spawnAttackEffect(_targetTile, ::Const.Tactical.AttackEffectSwing);

		local ret = false;
		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			if (!this.HD_isUsableOnForFree(tile)) continue;

			ret = this.attackEntity(_user, tile.getEntity()) || ret;
			if (!_user.isAlive()) return ret;
		}
		return ret;
	}

	// Overwrite, because we use the new getAffectedTiles function which improves accuracy when using at higher range
	q.onTargetSelected = @() function( _targetTile )
	{
		foreach (tile in this.getAffectedTiles(_targetTile))
		{
			::Tactical.getHighlighter().addOverlayIcon(::Const.Tactical.Settings.AreaOfEffectIcon, tile, tile.Pos.X, tile.Pos.Y);
		}
	}

// New Functions
	// Similar implementation logic as the vanilla reap skill has
	q.getAffectedTiles <- function( _targetTile )
	{
		local myTile = this.m.Container.getActor().getTile();
		local distance = myTile.getDistanceTo(_targetTile);
		local onQueryTilesHit = function( _tile, _result ) {
			_result.push(_tile);
		}
		local possibleTiles = [];

		::Tactical.queryTilesInRange(myTile, distance, distance, false, [], onQueryTilesHit, possibleTiles);

		local affectedTiles = [];
		for (local i = 0; i != possibleTiles.len(); ++i)
		{
			if (possibleTiles[i].ID != _targetTile.ID) continue;

			affectedTiles.push(possibleTiles[i]);
			if (--i < 0) i += possibleTiles.len();

			affectedTiles.push(possibleTiles[i]);
			if (--i < 0) i += possibleTiles.len();

			affectedTiles.push(possibleTiles[i]);
			break;
		}

		return affectedTiles;
	}
});
