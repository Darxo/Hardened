Hardened.Hooks.WorldTownScreenHireDialogModule_updateDetailsPanel = WorldTownScreenHireDialogModule.prototype.updateDetailsPanel;
WorldTownScreenHireDialogModule.prototype.updateDetailsPanel = function(_element)
{
	Hardened.Hooks.WorldTownScreenHireDialogModule_updateDetailsPanel.call(this, _element);

	if (_element === null || _element.length == 0) return;	// Same conditions as vanilla

	// We re-use the try out button so we rename it accordingly after it has been pressed and keep showing it
	var data = _element.data('entry');
	if(data['IsTryoutDone'])
	{
		this.mDetailsPanel.TryoutButton.enableButton(true);
		this.mDetailsPanel.TryoutButton.findButtonText().text("Dismiss");
		this.mDetailsPanel.TryoutButton.addClass('display-block').removeClass('display-none');
		this.mDetailsPanel.TryoutButton.unbindTooltip();
		this.mDetailsPanel.TryoutButton.bindTooltip({ contentType: 'msu-generic', modId: Hardened.ID, elementId: 'TownHireDialogModule.DismissButton' });
	}
	else
	{
		this.mDetailsPanel.TryoutButton.findButtonText().text("Try out");
		this.mDetailsPanel.TryoutButton.unbindTooltip();
		this.mDetailsPanel.TryoutButton.bindTooltip({ contentType: 'ui-element', elementId: TooltipIdentifier.WorldTownScreen.HireDialogModule.TryoutButton });	// Vanilla tooltip
	}
};

Hardened.Hooks.WorldTownScreenHireDialogModule_tryoutRosterEntry = WorldTownScreenHireDialogModule.prototype.tryoutRosterEntry;
WorldTownScreenHireDialogModule.prototype.tryoutRosterEntry = function(_entryID)
{
	// If the tryout is already done, we redirect the tryout-call to our new dissmissRosterEntry function
	if (this.mSelectedEntry !== null && this.mSelectedEntry.data('entry')['IsTryoutDone'])
	{
		this.dismissRosterEntry(this.mSelectedEntry.data('entry')['ID']);
	}
	else
	{
		Hardened.Hooks.WorldTownScreenHireDialogModule_tryoutRosterEntry.call(this, _entryID);
	}
};

// New Functions
WorldTownScreenHireDialogModule.prototype.dismissRosterEntry = function (_entryID)
{
	var self = this;
	this.notifyBackendDismissRosterEntity(_entryID, function (data)
	{
		if (data.Result != 0)	// error?
		{
			console.error("Failed to hire. Error: " + data.Result);
			return;
		}

		// remove entity from list (copied from vanilla)
		for (var i = 0; i < self.mRoster.length; ++i)
		{
			if (self.mRoster[i]['ID'] == _entryID)
			{
				self.removeRosterEntry({ item: self.mRoster[i], index: i });
				break;
			}
		}

		// update assets (copied from vanilla)
		self.mParent.loadAssetData(data.Assets);
		self.updateListEntryValues();
		self.updateDetailsPanel(self.mSelectedEntry);
	});
};

WorldTownScreenHireDialogModule.prototype.notifyBackendDismissRosterEntity = function(_entityID, _callback)
{
	SQ.call(this.mSQHandle, "onDismissButtonPressed", _entityID, _callback);
}
