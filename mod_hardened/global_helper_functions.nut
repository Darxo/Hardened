::Hardened.util <- {};

// If the offhand item worn by _entity is equal to any of the IDs inside _existingShieldIDArray, then it is unEquipped and instead _newShieldPath is added
// If _existingShieldIDArray is not given/null, the ID check is ignored and the offhand is always replaced
// Returns true if the offhand item was replaced, return false otherwise
::Hardened.util.replaceOffhand <- function( _entity, _newShieldPath, _existingShieldIDArray = null )
{
	local shield = _entity.getOffhandItem();
	if (shield != null)
	{
		if (_existingShieldIDArray == null)
		{
			_entity.getItems().unequip(shield);
			_entity.getItems().equip(::new(_newShieldPath));
			return true;
		}
		else
		{
			foreach (existingShieldID in _existingShieldIDArray)
			{
				if (shield.getID() == existingShieldID)
				{
					_entity.getItems().unequip(shield);
					_entity.getItems().equip(::new(_newShieldPath));
					return true;
				}
			}
		}
	}
	return false;
}