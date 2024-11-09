Hardened.Hooks.CharacterScreenLeftPanelHeaderModule_createDIV = CharacterScreenLeftPanelHeaderModule.prototype.createDIV;
CharacterScreenLeftPanelHeaderModule.prototype.createDIV = function (_parentDiv)
{
	Hardened.Hooks.CharacterScreenLeftPanelHeaderModule_createDIV.call(this, _parentDiv);

	// Remove the previous ImageButton created by Vanilla
	var layout = this.mDismissButton.parent();
	this.mDismissButton.remove();

	// We recreate the DismissButton to slightly adjust its behavior
	var self = this;
	this.mDismissButton = layout.createImageButton(Path.GFX + Asset.BUTTON_DISMISS_CHARACTER, function (_event)
	{
		var data = self.mDataSource.getSelectedBrother();
		if (CharacterScreenIdentifier.Entity.Character.Key in data)
		{
			var brother = data[CharacterScreenIdentifier.Entity.Character.Key];
			if (brother['daysWithCompany'] === 0)
			{
				// Instantly dismiss brothers, who have been just hired today
				self.mDataSource.notifyBackendDismissCharacter(brother['level'] > 1);	// fresh recruits higher than level 1, will grant cheap xp, when compesating them
				return;
			}
		}

		// This is an exact copy of the vanilla dismiss dialog logic
		self.mPayDismissalWage = false;
		self.mDataSource.notifyBackendPopupDialogIsVisible(true);
		self.mCurrentPopupDialog = $('.character-screen').createPopupDialog('Dismiss', null, null, 'dismiss-popup');

		self.mCurrentPopupDialog.addPopupDialogOkButton(function (_dialog)
		{
			self.mDataSource.notifyBackendDismissCharacter(self.mPayDismissalWage);
			self.mCurrentPopupDialog = null;
			_dialog.destroyPopupDialog();
			self.mDataSource.notifyBackendPopupDialogIsVisible(false);
		});

		self.mCurrentPopupDialog.addPopupDialogCancelButton(function (_dialog)
		{
			self.mCurrentPopupDialog = null;
			_dialog.destroyPopupDialog();
			self.mDataSource.notifyBackendPopupDialogIsVisible(false);
		});

		self.mCurrentPopupDialog.addPopupDialogContent(self.createDismissDialogContent(self.mCurrentPopupDialog));
	}, 'display-none', 6);
}

