// We overwrite this vanilla function, because we need to manipulate the callback function that is called inside
WorldTownScreenTavernDialogModule.prototype.notifyBackendQueryRumor = function ()
{
	console.error("WorldTownScreenTavernDialogModule.prototype.notifyBackendQueryRumor");
	var self = this;
	SQ.call(this.mSQHandle, 'onQueryRumor', null, function(data)
	{
		self.mAssets.loadFromData(data.Assets);
		// self.updateDrinking(data.Drink, data.Price);	// We don't need to do this anymore, because this is happening within loadFromData anyways
		console.error("this.mSQHandle");
		self.loadFromData(data);	// In Vanilla this line is: self.updateButtons(data);
	});
};
