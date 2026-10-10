Hardened.Hooks.TooltipModule_addContentTextDiv = TooltipModule.prototype.addContentTextDiv;
TooltipModule.prototype.addContentTextDiv = function (_parentDiv, _data)
{
	var result = Hardened.Hooks.TooltipModule_addContentTextDiv.call(this, _parentDiv, _data);

	if (result !== null && 'iconOverlay' in _data && 'icon' in _data)
	{
		var leftColumn = result.find('.l-left-column:first');
		var label = leftColumn.find('.label:first');

		if (label.length > 0)
		{
			var overlay = $('<img class="HD-tooltip-icon-overlay"/>');
			overlay.attr('src', Path.GFX + _data.iconOverlay);
			label.append(overlay);
		}
	}

	return result;
};
