// Namespace for global functions related to presentation of numbers as numerals or ranges
::Hardened.Numerals <- {
	// Data
	IndefiniteNumerals = [	// Array of Tables, which must contain StartsAt, Name, Suffix and Range
		{
			StartsAt = 0,
			Name = "One",
			Suffix = "",
			Range = "1",
		},
		{
			StartsAt = 2,
			Name = "A few",
			Suffix = "",
			Range = "2-3",
		},
		{
			StartsAt = 4,
			Name = "Some",
			Suffix = "",
			Range = "4-6",
		},
		{
			StartsAt = 7,
			Name = "Several",
			Suffix = "",
			Range = "7-10",
		},
		{
			StartsAt = 11,
			Name = "Many",
			Suffix = "",
			Range = "11-15",
		},
		{
			StartsAt = 16,
			Name = "Lots",
			Suffix = " of",
			Range = "16-21",
		},
		{
			StartsAt = 22,
			Name = "Dozens",
			Suffix = " of",
			Range = "22-37",
		},
		{
			StartsAt = 38,
			Name = "A plethora",
			Suffix = " of",
			Range = "38-69",
		},
		{
			StartsAt = 70,
			Name = "An army",
			Suffix = " of",
			Range = "70+",
		},
	],

// Public Functions
	// @return numeral entry table consisting of StartsAt, Name, Suffix and Range strings
	function getNumeralEntryByAmount( _amount )
	{
		foreach (index, numeralTable in this.IndefiniteNumerals)
		{
			if (_amount < numeralTable.StartsAt)
			{
				return this.IndefiniteNumerals[index - 1];
			}
		}
		return this.IndefiniteNumerals.top();
	}

	// Public Functions
	// Return a string, description the passed _amount, given the state of several settings
	function getNumeralString( _amount, _isWorldParty )
	{
		local numeralEntry = this.getNumeralEntryByAmount(_amount);

		local numeralString = "";
		if (_isWorldParty)
		{
			if (this.isPartyRange())
			{
				numeralString = numeralEntry.Range;
			}
			else	// Alternative option is Numeral
			{
				numeralString = numeralEntry.Name;
			}
		}
		else
		{
			if (this.isDialogRange())
			{
				numeralString = numeralEntry.Range;
			}
			else if (this.isDialogNumeral())
			{
				numeralString = numeralEntry.Name + numeralEntry.Suffix;
			}
			else	// Third option is Numeral (Range)
			{
				numeralString = numeralEntry.Name + numeralEntry.Suffix + " (" + numeralEntry.Range + ")";
			}
		}

		return numeralString;
	}

	// Can be used to force all entities on the map to update their name
	function updateAllParties()
	{
		// I don't know how else to get "every entity on the world map"
		foreach (worldParty in ::World.getAllEntitiesAtPos(::World.State.m.Player.getPos(), 150000.0))
		{
			worldParty.updateStrength();
		}
	}

	function isPartyRange()
	{
		return (::Hardened.Mod.ModSettings.getSetting("WorldPartyRepresentation").getValue() == "Range");
	}

	function isDialogRange()
	{
		return (::Hardened.Mod.ModSettings.getSetting("CombatDialogRepresentation").getValue() == "Range");
	}

	function isDialogNumeral()
	{
		return (::Hardened.Mod.ModSettings.getSetting("CombatDialogRepresentation").getValue() == "Numeral");
	}
}
