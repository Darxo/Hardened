::DynamicSpawns.Class.Party.__IdealSize <- 12;	// This is calculated at the start of a party generation
// Return the number of troops up until that one, no upgrading may happen
::DynamicSpawns.Class.Party.getIdealSize <- function()
{
	return this.__IdealSize;
}

::DynamicSpawns.Class.Party.IdealSizeMult <- 1.0;	// This is meant to be adjusted by the party definition
::DynamicSpawns.Class.Party.__generateIdealSize <- function()
{
	this.__IdealSize = ::Hardened.util.genericGenerateIdealSize(this.IdealSizeMult);
}

::DynamicSpawns.Class.Party.HD_isLocation <- function()
{
	return this.getWorldEntity() != null && this.getWorldEntity().isLocation();
}

// Remove a spawnable, no matter how deep it is hiding within this spawnable
::DynamicSpawns.Class.Party.removeSpawnable <- function( _id, _all = true )
{
	return base.removeSpawnable(_id, _all);
}

::DynamicSpawns.Class.Party.__getUpgradeChance <- function() { return 100; }

{	// Hooks
	local oldSpawn = ::DynamicSpawns.Class.Party.spawn;
	::DynamicSpawns.Class.Party.spawn <- function( _resources = null )
	{
		this.__generateIdealSize();
		return oldSpawn.call(this, _resources);
	}
}
