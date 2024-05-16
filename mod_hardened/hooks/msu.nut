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
