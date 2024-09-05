local oldIsDuelistValid = ::Reforged.Items.isDuelistValid;
::Reforged.Items.isDuelistValid = function( _weapon )
{
	local ret = oldIsDuelistValid;

	if (_weapon.isItemType(::Const.Items.ItemType.MeleeWeapon) && _weapon.isItemType(::Const.Items.ItemType.OneHanded))
	{
		return ret;
	}
	else
	{
		return false;
	}
}
