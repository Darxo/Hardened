::Hardened.Global.lastGeneratedNames <- array(5, "");	// Array of the last 5 generated names from the generateName of a human

::Hardened.HooksMod.hookTree("scripts/entity/tactical/human", function(q) {
	q.m.HD_BagSlotSpriteName <- "HD_BagSlotSprite_";

	q.create = @(__original) function()
	{
		__original();
		this.m.ResurrectionChance = 100;	// In Vanilla this is 33 (hard-coded)
		this.m.MinResurrectDelay = 1;	// In Vanilla this is 2 (hard-coded)
	}

	// We reroll generateName until it produces a name that has not been rolled by any generateName function the last 5 times
	q.generateName = @(__original) function()
	{
		local uniqueName = "";

		for (local i = 0; i < 10; ++i)	// We try 10 times to find a unique name that hasn't been chosen the last 5 times
		{
			uniqueName = __original();
			if (::Hardened.Global.lastGeneratedNames.find(uniqueName) == null)
			{
				break;
			}
		}

		::Hardened.Global.lastGeneratedNames.insert(0, uniqueName);
		::Hardened.Global.lastGeneratedNames.pop();

		return uniqueName;
	}

// Hardened Functions
	// Determines, whether this character will resurrect as a zombie
	q.isTurningIntoZombie = @(__original) function( _killer, _corpse, _fatalityType )
	{
		if (!__original(_killer, _corpse, _fatalityType)) return false;

		// We now also require the killer to be a zombie or undead for the resurrection to happen
		if (::MSU.isNull(_killer)) return false;
		local killerFaction = ::World.FactionManager.getFaction(_killer.getFaction());
		local killerFactionType = killerFaction == null ? null : killerFaction.getType();	// The first three factionIDs do not have a faction object behind them
		return (killerFactionType == ::Const.FactionType.Zombies || killerFactionType == ::Const.FactionType.Undead);
	}
});

::Hardened.HooksMod.hook("scripts/entity/tactical/human", function(q) {
	/// Return a randomly generated name for this human
	q.generateName <- function()
	{
		return "";
	}
});
