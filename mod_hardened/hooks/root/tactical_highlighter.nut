local oldAddOverlayIcon = ::Tactical.getHighlighter().addOverlayIcon;
::Tactical.getHighlighter().addOverlayIcon = function( _iconName, _tile, _tilePosX, _tilePosY )
{
	// Vanilla Fix: Lower the y position of overlay icons when placed on hills which are currently cut-off due to a lower camera level
	local yOffset = ::Math.max(_tile.Level - ::Tactical.getCamera().Level, 0) * 40.0;
	_tilePosY -= yOffset;
	return oldAddOverlayIcon(_iconName, _tile, _tilePosX, _tilePosY);
}
