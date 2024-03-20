::logInfo("Hardened::MSU -- adding ::MSU.Text.colorPositive");
::MSU.Text.colorPositive <- function( _string )
{
	return this.colorGreen(_string);
}

::logInfo("Hardened::MSU -- adding ::MSU.Text.colorNegative");
::MSU.Text.colorNegative <- function( _string )
{
	return this.colorRed(_string);
}

::logInfo("Hardened::MSU -- adding ::MSU.Text.colorizeFraction");
::MSU.Text.colorizeFraction <- function( _value, _options = null )	// A fraction is a value between -1.0 and 1.0 and they resemble a percentage value. It is a bit similar to multipliers
{
	if (_options == null) _options = {};
	if (!("AddSign" in _options)) _options.AddSign <- false;
	_options.AddPercent <- true;
	return this.colorizeValue(::Math.floor(_value * 100.0), _options);
}
