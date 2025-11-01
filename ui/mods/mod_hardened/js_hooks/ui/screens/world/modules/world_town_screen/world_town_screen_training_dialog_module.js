// Vanilla Fix: We reduce the scroll speed of the origin list to 1.0 (down from 8.85)
Hardened.Hooks.WorldTownScreenTrainingDialogModule_createDIV = WorldTownScreenTrainingDialogModule.prototype.createDIV;
WorldTownScreenTrainingDialogModule.prototype.createDIV = function (_parentDiv)
{
	// We switcheroo the jquery createList function as that is the simplest way to switch out the high vanilla delta with a smaller one
	var oldCreateList = $.fn.createList;
	$.fn.createList = function(_scrollDelta, _classes, _withoutFrame)
	{
		return oldCreateList.call(this, 1.0, _classes, _withoutFrame);
	};

	Hardened.Hooks.WorldTownScreenTrainingDialogModule_createDIV.call(this, _parentDiv);

	$.fn.createList = oldCreateList;
}

Hardened.Hooks.WorldTownScreenTrainingDialogModule_createTrainingControlDIV = WorldTownScreenTrainingDialogModule.prototype.createTrainingControlDIV;
WorldTownScreenTrainingDialogModule.prototype.createTrainingControlDIV = function (_i, _parentDiv, _entityID, _data, _money)
{
	Hardened.Hooks.WorldTownScreenTrainingDialogModule_createTrainingControlDIV.call(this, _i, _parentDiv, _entityID, _data, _money);
	if (!("HD_isBuyablPerkGroup" in _data)) return;

	var row = _parentDiv.children().last();
	var icon = row.find('.is-icon');
	var name = row.find('.is-name');

	// We don't need to call unbindTooltip, because the internal bindToElement function already removes all previous callbacks
	icon.bindTooltip({contentType: 'msu-generic', modId: DynamicPerks.ID, elementId: _data.tooltip});
	name.bindTooltip({contentType: 'msu-generic', modId: DynamicPerks.ID, elementId: _data.tooltip});
}
