::MSU.Text.Color.HD_Blue <- "#1e468f";

::MSU.Text.colorNeutral <- function( _string )
{
	return this.color(::MSU.Text.Color.HD_Blue, _string);
}

// Feat: improve formatting of minus signs in front of negative numbers
// Vanilla and every mod only ever use the hyphen-minus that is most common on keyboards
// This one however is only half as wide as the plus sign. And it is also missing a built-in space left and right of it
// As a result this minus sign is really small and hard to spot, compared to the plus sign
// We fix this by replacing such a minus sign with the "en dash" (U+2013) and put additional non-breaking spaces on either side of it
// note: Ideally we would use the "minus sign" (U+2212), but this one causes glitches when followed by other formatting
// note: We also fix this over on the js side by hooking XBBCODE.process.
//	The only reason we still need this hook on the squirrel side is for the tactical tooltips, so that we can clean the non-breaking spaces, see ::Reforged.TacticalTooltip.getTooltipAttributesSmall
local oldColor  = ::MSU.Text.color;
::MSU.Text.color = function( _color, _string )
{
	_string = _string.tostring();
	if (_string.find("-") == 0)
	{
		_string = "&nbsp–&nbsp" + _string.slice(1);
	}

	return oldColor(_color, _string);
}
