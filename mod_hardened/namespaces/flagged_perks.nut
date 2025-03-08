// Namespace for Framework that serializes newly introduced perks with flags to guarantee savegame compatibility
// This framework will get into trouble, if a newly introduced perk is not refundable or if it serializes additional data. It is undefined, what should happen in this case

/*
Problem:
- If this perk introduces new perks, that will prevent it from being removable without corrupting savegames, but we want to keep the ability to remove Hardened

Goal:
- When we serialize a save, we temporarily refund all perks newly introduced by Hardened from the player but also from the perk tree of the player
- We save the IDs of those perks as a long string
- When we deserialize a save with hardened and we have enough
- Every perk serialized this way will provide a single perk id, which can be used to locate its perk def
*/
::Hardened.FlaggedPerks <- {
// Private
	FlagString = "Hardened_FlaggedPerks",	// Name of the flag used to store the serialized perks on this player
	PerkIDPrefix = "perk.hd_",	// We define "New Hardened Perks" as any perk who's ID starts with this string
	SerializeSeparatorMajor = ";",
	SerializeSeparatorMinor = ",",

// Public
	// Remove all new Hardened Perks from the perktree of _player and refund them from _player if he unlocked them
	/// Call just before anything else about the player serializes
	function onSerialize( _player )
	{
		local serializedString = "";

		foreach (perkID, perkInfo in _player.getPerkTree().getPerks())
		{
			if (this.isHardenedPerk(perkID))
			{
				serializedString += this.serializePerk(_player, perkID, perkInfo) + this.SerializeSeparatorMajor;
			}
		}

		if (serializedString != "")
		{
			_player.getFlags().set(this.FlagString, serializedString);
		}
	}

	// Remove all new Hardened Perks from the perk tree of _player and refund them from _player
	/// Call just after anything else about the player deserializes
	function onDeserialize( _player )
	{
		if (!_player.getFlags().has(this.FlagString)) return false;

		local deserializedString = _player.getFlags().get(this.FlagString);
		foreach (perkString in split(deserializedString, this.SerializeSeparatorMajor))
		{
			this.deserializePerk(_player, perkString);
		}
		_player.getFlags().remove(this.FlagString);
	}

// Private
	// Determines, whether _skill is a new perk introduced by Hardened
	function isHardenedPerk( _perkID )
	{
		return ::MSU.String.startsWith(_perkID, this.PerkIDPrefix);
	}

	// Remove the _perk from the perkTree of _player and refund that perk
	/// @return string representation of _perk for storage inside a flag in the format: perkID,perkTier,hasPerk
	function serializePerk( _player, _perkID, _perkInfo )
	{
		local perkTree = _player.getPerkTree();

		local perkTier = _perkInfo.Row + 1;
		local perkRow = perkTier;
		local perkPosition = 0;
		foreach (rowIndex, row in perkTree.getTree())
		{
			foreach (perkIndex, perk in row)
			{
				if (perk.ID == _perkID)
				{
					perkRow = rowIndex;
					perkPosition = perkIndex;
					break;
				}
			}
		}

		// Remove the perk from the perk tree
		perkTree.removePerk(_perkID);

		local ret = _perkID + this.SerializeSeparatorMinor + perkTier + this.SerializeSeparatorMinor + perkRow + this.SerializeSeparatorMinor + perkPosition + this.SerializeSeparatorMinor;

		if (_player.hasPerk(_perkID))
		{
			ret += "1";	// "1" means, that the player knew the perk before
			// Refund the perk from the player, even if it was marked as non-refundable. We just hope that by setting IsNew to false during deserialization, everything will go alright
			_player.m.PerkPoints++;
			_player.m.PerkPointsSpent--;
			_player.setPerkTier(::Math.max(_player.getPerkTier() - 1, ::DynamicPerks.Const.DefaultPerkTier));
			_player.getSkills().removeByID(_perkID);
		}
		else
		{
			ret += "0";	// "0" means, that the player didn't know the perk before
		}

		return ret;
	}

	// Add the perk from _perkString to the perkTree of _player and optionally (_hasEnoughPerks) unlock that perk for him
	function deserializePerk( _player, _perkString )
	{
		local splitArray = split(_perkString, this.SerializeSeparatorMinor);
		local perkID = splitArray[0];
		local perkTier = splitArray[1].tointeger();
		local perkRow = splitArray[2].tointeger();
		local perkPosition = splitArray[3].tointeger();
		local isUnlocked = (splitArray[4] == "1");

		// Add perk to perk tree

		local perkDef = ::Const.Perks.findById(perkID);
		if (perkDef == null)
		{
			::logError("Hardened: No perkdef with ID: " + perkID);
			return;
		}

		// Add the perk at the exact position he was before that
		this.addPerk(_player.getPerkTree(), perkDef, perkTier, perkRow, perkPosition);

		// Unlock the perk for the player
		if (isUnlocked && _player.getPerkPoints())
		{
			// We can't use unlockPerk function from player.nut, because we need to set IsNew to false
			local skill = ::Reforged.new(perkDef.Script, function(o) {
				o.m.IsNew = false;	// Prevents one-time perk effects from applying again and again
			});
			_player.getSkills().add(skill);

			_player.m.PerkPoints--;
			_player.m.PerkPointsSpent++;
			_player.setPerkTier(_player.getPerkTier() + 1);
		}
	}

	// Add _perkDef into _perkTree with Tier _tier, at a specific _row and _position
	function addPerk( _perkTree, _perkDef, _tier, _row, _position )
	{
		try {
			local perk = {
				Row = _tier - 1,
				Unlocks = _tier - 1,
			}.setdelegate(_perkDef);

			_perkTree.getPerks()[_perkDef.ID] <- perk;
			_perkTree.getTree()[_row].insert(_position, perk);
		}
		catch ( _e )
		{
			::logWarning("Hardened: addPerk _tier " + _tier + " _row " + _row + " _position " + _position);
			::MSU.Log.printData(_perkTree.getTree(), 2);
		}
	}
}
