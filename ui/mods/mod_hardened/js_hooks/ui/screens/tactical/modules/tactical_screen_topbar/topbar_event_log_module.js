
// Vanilla Fix: We reduce the scroll speed of the combat log to 0.5 (down from 15)
Hardened.Hooks.TacticalScreenTopbarEventLogModule_createDIV = TacticalScreenTopbarEventLogModule.prototype.createDIV;
TacticalScreenTopbarEventLogModule.prototype.createDIV = function ( _parentDiv )
{
	// We switcheroo the jquery createList function as that is the simplest way to switch out the high vanilla delta with a smaller one
	var oldCreateList = $.fn.createList;
	$.fn.createList = function(_scrollDelta, _classes, _withoutFrame)
	{
		return oldCreateList.call(this, 0.5, _classes, _withoutFrame);
	};

	Hardened.Hooks.TacticalScreenTopbarEventLogModule_createDIV.call(this, _parentDiv);

	$.fn.createList = oldCreateList;
}
