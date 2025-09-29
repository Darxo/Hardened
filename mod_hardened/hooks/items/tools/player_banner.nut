::Hardened.HooksMod.hook("scripts/items/tools/player_banner", function(q) {
	// Public
	q.m.RangedDefenseModifier <- -5;

	// Private
	q.m.HD_TriggerUnequipUpdate <- false;	// briefly set to true while unequipping, if we wanna trigger a global update

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/ranged_defense.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.RangedDefenseModifier, {AddSign = true}) + " [Ranged Defense|Concept.RangeDefense]"),
		});

		return ret;
	}

	q.onEquip = @(__original) function()
	{
		__original();
		this.addSkill(::new("scripts/skills/actives/repel"));
	}

	q.onUpdateProperties = @(__original) function(_properties)
	{
		__original(_properties);
		_properties.RangedDefense += this.m.RangedDefenseModifier;
	}

	q.onEquip = @(__original) function()
	{
		__original();

		if (!this.getContainer().getActor().isPlacedOnMap()) return;	// This also filters out the dummy player

		// Feat: we update all actors on the map after swapping away from the player banner to update the buff effect on our allies accordingly
		this.updateAllActors();
	}

	q.onUnequip = @(__original) function()
	{
		__original();

		if (!this.getContainer().getActor().isPlacedOnMap()) return;	// This also filters out the dummy player

		// During HD_onAfterUnEquip we dont know which actor the item belonged, so we need to decide at this point here, whether we trigger an update
		this.m.HD_TriggerUnequipUpdate = true;
	}

// Hardened Functions
	// We need to use this event because during onUnequip the playerbanner is still technically equipped, so updating our aura receiver does nothing
	q.HD_onAfterUnEquip = @(__original) function()
	{
		__original();

		if (this.m.HD_TriggerUnequipUpdate)
		{
			this.m.HD_TriggerUnequipUpdate = false;
			// Feat: we update all actors on the map after swapping away from the player banner to update the buff effect on our allies accordingly
			this.updateAllActors();
		}
	}

// New Functions
	// Helper functions to trigger an update on all actors placed on the map
	// This is useful because this aura is applied by preemtively adding seperate buff effects on those allies
	// And those effects need to be told when something significant happens (like equippin/deequipping the banner)
	q.updateAllActors <- function()
	{
		foreach (factionID, faction in ::Tactical.Entities.getAllInstances())
		{
			foreach (actor in faction)
			{
				actor.getSkills().update();
			}
		}
	}
});
