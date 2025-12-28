::Hardened.HooksMod.hook("scripts/entity/world/world_entity", function(q) {
	// For names of world parties
	q.updateStrength = @(__original) function()
	{
		__original();

		if (!this.isAlive()) return;	// Included just for safety reasons because it is also part of the original function

		if (!this.hasLabel("name")) return;
		if (this.isPlayerControlled()) return;
		if (this.m.Troops.len() == 0) return;
		if (!this.m.IsShowingStrength) return;

		this.getLabel("name").Text = this.getName() + " (" + ::Hardened.Numerals.getNumeralString(this.m.Troops.len(), true) + ")";
	}

	q.updatePlayerRelation = @(__original) function()
	{
		// Feat: Allies factions that are close to the threshold for becoming hostile are now colored orange
		// Switcheroo of NeutralColor, so that world factions, who are close to becoming hostile to the player, are colored in a new yellow-ish color
		local oldNeutralColor = ::Const.Factions.NeutralColor;

		local faction = ::World.FactionManager.getFaction(this.getFaction());
		if (faction != null)
		{
			local playerRelation = faction.getPlayerRelation();
			if (playerRelation >= 20.0 && playerRelation < 30.0)	// This is exactly the portion called "Unfriendly"
			{
				::Const.Factions.NeutralColor = ::Const.Factions.HD_AlmostHostileColor;
			}
		}

		__original();

		::Const.Factions.NeutralColor = oldNeutralColor;
	}

	// For the tooltip of world entities
	q.getTroopComposition = @(__original) function()
	{
		local oldEngageEnemyNumbers = clone ::Const.Strings.EngageEnemyNumbers;

		// We must retrieve the original enemy troop amount, that we want to display the amount for
		// The only time that number is ever passed outside of 'getTroopComposition' is, when it's divided by 14 and passed to minf. So that's where we fetch it from
		// We decide that this is also the place, where we change, which string is shown to the player for this enemy amount, by changing the values of every single EngageEnemyNumbers entry to that
		local mockObjectMinf = ::Hardened.mockFunction(::Math, "minf", function( _first, _second ) {
			if (_first == 1.0)
			{
				local originalEnemyNumber = ::Math.round(_second * 14.0);	// the 14.0 is hard-coded and needs to be adjusted if vanilla changes it
				local newText = ::Hardened.Numerals.getNumeralString(originalEnemyNumber, false);
				foreach (index, entry in ::Const.Strings.EngageEnemyNumbers)
				{
					::Const.Strings.EngageEnemyNumbers[index] = newText;
				}
			}
		});

		local ret = __original();

		local oldEngageEnemyNumbers = ::Const.Strings.EngageEnemyNumbers = oldEngageEnemyNumbers;
		mockObjectMinf.cleanup();

		return ret;
	}
});
