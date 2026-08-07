local oldEnumerateFiles = ::IO.enumerateFiles;
::IO.enumerateFiles = function ( _path )
{
	// We can only change classes, if they have not been inherited from, or instantiated yet
	// That's why we do our changes to AbstractSetting directly before all of its child classes are created
	if (_path == "msu/systems/mod_settings/elements/")
	{
		::MSU.Class.AbstractSetting.HD_Hidden <- false;
		local oldGetUIData = ::MSU.Class.AbstractSetting.getUIData;
		::MSU.Class.AbstractSetting.getUIData <- function( _flags = [] )
		{
			local ret = oldGetUIData.call(this, _flags);
			if (this.HD_Hidden) ret.hidden = true;
			return ret;
		}

		::MSU.Class.AbstractSetting.HD_ValueOverwrite <- null;
		local oldGetValue = ::MSU.Class.AbstractSetting.getValue;
		::MSU.Class.AbstractSetting.getValue <- function()
		{
			if (this.HD_ValueOverwrite != null) return this.HD_ValueOverwrite;
			return oldGetValue.call(this);
		}

		::MSU.Class.AbstractSetting.HD_hide <- function( _defaultValue )
		{
			this.HD_Hidden = true;
			this.HD_ValueOverwrite = _defaultValue;
		}
	}

	return oldEnumerateFiles(_path);
}
