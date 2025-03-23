Hardened.Hooks.WorldTownScreenAssets_updateAssetValue = WorldTownScreenAssets.prototype.updateAssetValue;
WorldTownScreenAssets.prototype.updateAssetValue = function (_container, _value, _valueMax, _valueDifference)
{
	Hardened.Hooks.WorldTownScreenAssets_updateAssetValue.call(this, _container, _value, _valueMax, _valueDifference);

	// In Hardened _value can also contain a string. That will however break the vanilla check which decides whether to color that value negative or positive
	// The first number of that string is always the current value of this asset, so we check whether that is 0
    var label = _container.find('.label:first');
    if(label.length > 0)
	{
		if (typeof _value === "string" && _value[0] === "0")
		{
			label.removeClass('font-color-assets-positive-value').addClass('font-color-assets-negative-value');
		}
	}
};
