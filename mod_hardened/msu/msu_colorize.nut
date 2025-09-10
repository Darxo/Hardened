// Feat: We implement a new "HD_UseEventColors" kwargs element into colorizeValue, with which you can switch to the lighter color theme that fit better for vanilla event backgrounds
local oldColorizeValue = ::MSU.Text.colorizeValue;
::MSU.Text.colorizeValue = function( _value, _kwargs = null )
{
	if (_kwargs != null && "HD_UseEventColors" in _kwargs && _kwargs["HD_UseEventColors"] == true)
	{
		_kwargs.rawdelete("HD_UseEventColors");

		// Switcheroo of colors, because MSU will always use the darker tooltip-colors for text coloring, but the darker eventbackgrounds need a lighter color
		local oldPositiveValue = ::Const.UI.Color.PositiveValue;
		::Const.UI.Color.PositiveValue = ::Const.UI.Color.PositiveEventValue;
		local oldNegativeValue = ::Const.UI.Color.NegativeValue;
		::Const.UI.Color.NegativeValue = ::Const.UI.Color.NegativeEventValue;

		local ret = oldColorizeValue(_value, _kwargs);

		::Const.UI.Color.PositiveValue = oldPositiveValue;
		::Const.UI.Color.NegativeValue = oldNegativeValue;

		return ret;
	}

	return oldColorizeValue(_value, _kwargs);
}
