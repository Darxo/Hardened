::Hardened.HooksMod.hook("scripts/contracts/contracts/return_item_contract", function(q) {
	q.m.HD_possibleItemNames <- [
		"Rare Coin Collection",
		"Ceremonial Staff",
		"Idol of Fertility",
		"Golden Talisman",
		"Tome of Arcane Knowledge",
		"Lockbox",
		"Demonic Statuette",
		"Crystal Skull",
		// Feat: Increase pool of possible item names
		"Ancestral Heirloom",
		"Black Mirror",
		"Engraved Chalice",
		"Ivory Chess Set",
		"Ivory Figurine",
		"Golden Signet Ring",
		"Ornate Astrolabe",
		"Ornate Casket",
		"Sealed Manuscript",
	];

	q.start = @(__original) { function start()
	{
		__original();

		// Feat: Make item name pool moddable
		this.m.Flags.set("Item", ::MSU.Array.rand(this.m.HD_possibleItemNames));
	}}.start;

	q.createStates = @(__original) { function createStates()
	{
		__original();

		foreach (state in this.m.States)
		{
			if (state.ID == "Offer")
			{
				local oldEnd = state.end;
				state.end = function()
				{
					oldEnd();
					if (this.HD_getDifficultyTier() == 3 && this.Flags.has("IsBandits") && ::Math.rand(1, 70) <= 20)
					{
						this.Flags.set("HD_IsHexen", true);
						this.Flags.remove("IsBandits");
					}
				}
			}

			if (state.ID == "Running")
			{
				local oldOnTargetAttacked = state.onTargetAttacked;
				state.onTargetAttacked = function( _dest, _isPlayerAttacking )
				{
					if (!this.Flags.get("IsAttackDialogTriggered") && this.Flags.get("HD_IsHexen"))
					{
						this.Flags.set("IsAttackDialogTriggered", true);
						this.Contract.m.IsPlayerAttacking = _isPlayerAttacking;
						this.Contract.setScreen("HD_Hexen");
						::World.Contracts.showActiveContract();
					}
					else
					{
						oldOnTargetAttacked(_dest, _isPlayerAttacking);
					}
				}
			}
		}
	}}.createStates;

	q.createScreens = @(__original) { function createScreens()
	{
		__original();

		foreach (screen in this.m.Screens)
		{
			if (screen.ID == "Necromancer" && ::Hooks.hasMod("mod_crock_pot"))
			{
				// Feat: When Crock Pot is present, we spawn the hooded man at tier 2 and the necromancer only at tier 3
				screen.Options[0].getResult = function()
				{
					if (this.Contract.HD_getDifficultyTier() <= 2)
					{
						::Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = ::Const.World.Spawn.Troops.CP_HoodedMan,
						});
					}
					else
					{
						::Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = ::Const.World.Spawn.Troops.Necromancer,
						});
					}

					this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
					return 0;
				}
			}
		}

		this.m.Screens.push({
			ID = "HD_Hexen",
			Title = "As you approach...",
			Text = "[img]gfx/ui/events/event_106.png[/img]{There are brigands here, just as expected, but they are handing the %itemLower% to a hideous old woman. Your presence brings the transaction to a halt, and both the thugs and the hag turn to face you. | You catch brigands trading %employer%\'s property to what appears to be a Hexe! Whatever she wants with the item, it can\'t be good. Then again, the man is paying you to get it back. Charge! | %employer%\'s property is being handed over to a gaunt old woman, her skin hanging loosely from her bones. She turns to look at you, revealing a mouth full of crooked teeth. The brigands reach for their weapons, and the hag begins to mutter something under her breath.}",
			Image = "",
			List = [],
			Options = [
				{
					Text = "To Arms!",
					function getResult()
					{
						::Const.World.Common.addTroop(this.Contract.m.Target, {
							Type = ::Const.World.Spawn.Troops.Hexe,
						});
						this.Contract.getActiveState().onTargetAttacked(this.Contract.m.Target, true);
						return 0;
					}
				}
			],
			function start()
			{
			}
		});
	}}.createScreens;
});
