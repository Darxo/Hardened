Hardened.Hooks.WorldTownScreenTravelDialogModule_addListEntry = WorldTownScreenTravelDialogModule.prototype.addListEntry;
WorldTownScreenTravelDialogModule.prototype.addListEntry = function (_data)
{
	Hardened.Hooks.WorldTownScreenTravelDialogModule_addListEntry.call(this, _data);

	if ("IsDestinationAllowed" in _data && !_data.IsDestinationAllowed)
	{
		var lastEntry = this.mListScrollContainer.children().last().find('.list-entry');
		if (lastEntry)
		{
			lastEntry.addClass('is-disabled');
		}
	}
}

Hardened.Hooks.WorldTownScreenTravelDialogModule_updateDetailsPanel = WorldTownScreenTravelDialogModule.prototype.updateDetailsPanel;
WorldTownScreenTravelDialogModule.prototype.updateDetailsPanel = function (_element)
{
	Hardened.Hooks.WorldTownScreenTravelDialogModule_updateDetailsPanel.call(this, _element);

	if(_element !== null && _element.length > 0)
	{
		var data = _element.data('entry');
		var isDestinationAllowed = (data !== null && 'IsDestinationAllowed' in data ? data['IsDestinationAllowed'] : true);

		if (!isDestinationAllowed)
		{
			this.mDetailsPanel.TravelButton.enableButton(false);
		}
	}
}
