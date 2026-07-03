local oldAddOverlayIcon = ::Tactical.getHighlighter().addOverlayIcon;
::Tactical.getHighlighter().addOverlayIcon = function( _iconName, _tile, _tilePosX, _tilePosY )
{
	// Vanilla Fix: Lower the y position of overlay icons when placed on hills which are currently cut-off due to a lower camera level
	local yOffset = ::Math.max(_tile.Level - ::Tactical.getCamera().Level, 0) * 40.0;
	_tilePosY -= yOffset;
	return oldAddOverlayIcon(_iconName, _tile, _tilePosX, _tilePosY);
}

local oldHighlightRangeOfSkill = ::Tactical.getHighlighter().highlightRangeOfSkill;
::Tactical.getHighlighter().highlightRangeOfSkill = function( _skill, _activeEntity )
{
	// Vanilla Fix: Tile Preview for skills not working correctly when tile level difference is greater than 1
	// We ignore skills with a MaxRange of 1 or lower, because some vanilla ai scripts will break, if skills suddenly count as IsRanged, they don't strictly enforce range checks
	local oldIsRanged = _skill.m.IsRanged;
	local oldMaxRangeBonus = _skill.m.MaxRangeBonus;
	if (_skill.isActive() && !_skill.isAttack() && _skill.isTargeted() && _skill.getMaxRange() > 1)
	{
		_skill.m.IsRanged = true;		// Required, so that the preview tiles render correctly when more than 1 level difference from targetMaxRangeBonus
		_skill.m.MaxRangeBonus = 0;		// Required, so that this skill does not get bonus range downhills
	}

	local ret = oldHighlightRangeOfSkill(_skill, _activeEntity);

	_skill.m.IsRanged = oldIsRanged;
	_skill.m.MaxRangeBonus = oldMaxRangeBonus;

	return ret;
}
