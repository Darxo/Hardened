::Hardened.HooksMod.hook("scripts/entity/world/locations/rf_bandit_fort_location", function(q) {
	q.create = @(__original) function()
	{
		__original();

		this.m.Resources = 250 * ::Hardened.Global.FactionDifficulty.Brigands;		// Reforged: 300
	}

	// Feat: Display the original location name for ruined
	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		// We mock this.dropTreasure, so that it considers additional items, when dropping loot for the player
		local mockObject;
		mockObject = ::Hardened.mockFunction(this, "dropTreasure", function( _num, _items, _lootTable ) {
			_items.push("tools/daze_bomb_item");
			_items.push("tools/smoke_bomb_item");
			return { done = true };
		});

		__original(_lootTable);

		mockObject.cleanup();
	}
});
