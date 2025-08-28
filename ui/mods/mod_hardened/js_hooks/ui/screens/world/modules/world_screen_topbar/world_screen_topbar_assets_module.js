Hardened.Hooks.WorldScreenTopbarAssetsModule_updateAssetValue = WorldScreenTopbarAssetsModule.prototype.updateAssetValue;
WorldScreenTopbarAssetsModule.prototype.updateAssetValue = function (_data, _valueKey, _valueMaxKey, _button)
{
	Hardened.Hooks.WorldScreenTopbarAssetsModule_updateAssetValue.call(this, _data, _valueKey, _valueMaxKey, _button);

	var currentAssetInformation = _data.current;

	var label = _button.find('.assets-secondary-value');
	if (_valueKey === "Food" && "FoodDaysLeft" in currentAssetInformation)
	{
		var value = currentAssetInformation["FoodDaysLeft"];
		label.html(" (" + Helper.numberWithCommas(value) + ")");
	}
	else if (_valueKey == "Supplies" && "RepairHoursLeft" in currentAssetInformation)
	{
		var value = currentAssetInformation["RepairHoursLeft"];
		label.html(" (" + Helper.numberWithCommas(value) + ")");
	}
	else if (_valueKey == "Medicine" && "MedicineRequiredMin" in currentAssetInformation)
	{
		var value = currentAssetInformation["MedicineRequiredMin"];
		label.html(" (" + Helper.numberWithCommas(value) + ")");
	}
}

Hardened.Hooks.WorldScreenTopbarAssetsModule_createImageButton = WorldScreenTopbarAssetsModule.prototype.createImageButton;
WorldScreenTopbarAssetsModule.prototype.createImageButton = function (_parentDiv, _imagePath, _callback)
{
	var layout = Hardened.Hooks.WorldScreenTopbarAssetsModule_createImageButton.call(this, _parentDiv, _imagePath, _callback);

	// Secondary text (smaller, aligned top like a superscript)
	var secondaryText = $('<div class="label text-font-small font-bold font-bottom-shadow font-color-assets-positive-value assets-secondary-value""/>');
	layout.append(secondaryText);

	return layout;
}
