::Hardened.HooksMod.hook("scripts/entity/world/attached_location", function(q) {
// Private
	q.m.IsAutoDetectedRaidableLocation <- false;

	// Feat: Display the original location name for ruined
	q.getName = @() function()
	{
		return this.world_entity.getName() + (!this.isActive() ? " (Ruins)" : "");
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local childrenElements = [];
		local childrenId = 41;
		foreach (produce in this.getProduceList())
		{
			local item = ::new("scripts/items/" + produce);
			childrenElements.push({
				id = childrenId,
				type = "text",
				icon = "ui/items/" + item.getIcon(),
				text = item.getName(),
			});
			++childrenId;
		}

		if (childrenElements.len() != 0)
		{
			ret.push({
				id = 40,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Produces:",
				children = childrenElements,
			});
		}

		return ret;
	}

	q.setActive = @(__original) function( _active )
	{
		// Feat: Attached Locations that get rebuilt, roll named items again
		if (!this.isActive() && _active && !::MSU.Serialization.isLoading())	// During deserialization, this is also called, so we need to ignore those calls
		{
			this.m.Loot.clear();	// First we clear the existing items/named items
			this.onSpawned();
		}
		// Feat: Attached Locations that are destroyed, will get their troops wiped
		else if (!_active)
		{
			this.clearTroops();
		}

		__original(_active);
	}

	q.onDropLootForPlayer = @(__original) function( _lootTable )
	{
		__original(_lootTable);

		if (this.m.IsAutoDetectedRaidableLocation)
		{
			// Peasants already drop supply and food loot themselves, so we don't drop any additional here
			local paintList = [
				"misc/paint_remover_item",
				"misc/paint_black_item",
				"misc/paint_red_item",
				"misc/paint_orange_red_item",
				"misc/paint_white_blue_item",
				"misc/paint_white_green_yellow_item",
			];
			this.dropTreasure(1, paintList, _lootTable);

			local produce = this.getProduceList();
			this.dropTreasure(::Math.rand(1, 2), produce, _lootTable);
		}
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);

		// Fix: attached locations having too many named items after saving and loading multiple times
		// This is a retro-active fix for existing saves. It is not required for new saves and should eventually be removed from Hardened
		if (this.m.Loot.len() > 2)
		{
			this.m.Loot.clear();
			this.onSpawned();
		}

		if (this.m.IsAutoDetectedRaidableLocation && this.m.Resources == 0)
		{
			this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Civilians;
		}
	}


// New Function
	q.getProduceList <- function()
	{
		local produceList = [];
		this.onUpdateProduce(produceList);
		return produceList;
	}

	q.autodetectRaidableCivilians <- function()
	{
		if (this.m.IsRaidable) return;

		local produce = [];
		this.onUpdateProduce(produce);
		if (produce.len() == 0) return;

		this.m.IsAttackable = true;
		this.m.IsScalingDefenders = true;

		this.m.IsAutoDetectedRaidableLocation = true;
		this.m.IsRaidable = true;
		this.m.GoesIntoLockdown = true;

		// Tactical Map
		this.m.CombatLocation.Template[0] = "tactical.human_camp";
		this.m.CombatLocation.Fortification = ::Const.Tactical.FortificationType.None;
		this.m.CombatLocation.CutDownTrees = true;
		this.m.CombatLocation.AdditionalRadius = 1;

		// Defender
		this.m.Resources = 150 * ::Hardened.Global.FactionDifficulty.Civilians;
		this.setDefenderSpawnList(::Const.World.Spawn.HD_AttachedProduction);
	}
});

::Hardened.HooksMod.hookTree("scripts/entity/world/attached_location", function(q) {
	// Feat: Display the original location name for ruined
	q.create = @(__original) function()
	{
		__original();
		this.autodetectRaidableCivilians();
	}
});
