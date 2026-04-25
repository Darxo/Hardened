// We make functions inside ::TacticalHighlighter hookable by introducing a hookable proxyHighlighter squirrel table in between

// Reference to the old getHighlighter function where we the untouched original from
local oldHighlighter = ::Tactical.getHighlighter;

// We use delegation so that we can use the _get and _set metamethods to full effect to emulate reading and writing of member variables of TacticalHighlighter
local proxyDelegate = {
	_get = function(key)
	{
		if (key in oldHighlighter().__getTable)
		{
			return oldHighlighter()[key]; // Get the value from the original highlighter
		}
		return null; // Default case
	},

	_set = function(key, value)
	{
		if (key in oldHighlighter().__setTable)
		{
			oldHighlighter()[key] = value; // Modify the original highlighter object
		}
	},
};

local proxyHighlighter = {
// Overloaded Functions
	function clearOverlayIcons()
	{
		return oldHighlighter().clearOverlayIcons();
	},
	function clear()
	{
		return oldHighlighter().clear();
	},
	function addOverlayIcon( _iconName, _tile, _tilePosX, _tilePosY )
	{
		return oldHighlighter().addOverlayIcon(_iconName, _tile, _tilePosX, _tilePosY);
	},
	function clearHighlights()
	{
		return oldHighlighter().clearHighlights();
	},
	function highlightZoneOfControl( _alliedFactionIDs )
	{
		return oldHighlighter().highlightZoneOfControl(_alliedFactionIDs);
	},
	function highlightRangeOfSkill( _skill, _activeEntity )
	{
		return oldHighlighter().highlightRangeOfSkill(_skill, _activeEntity);
	},
}

proxyHighlighter.setdelegate(proxyDelegate);

::Tactical.getHighlighter = function() {
	return proxyHighlighter;
}
