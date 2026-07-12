::Hardened.HooksMod.hook("scripts/skills/racial/ghost_racial", function(q) {
	// We save the original value for this character before the addition of this effect, so we can reset it after removal
	q.m.HD_MovementAPCostBackup <- null,
	q.m.HD_MovementLevelCostBackup <- null,

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10)
			{
				ret.remove(index);
				break;
			}
		}

		ret.push({
			id = 30,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Ignore movement penalty on any terrain"),
		});

		ret.push({
			id = 31,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immune to [$ $|Skill+chilled_effect] and [$ $|Skill+rf_frostbound_effect]"),
		});

		return ret;
	}

	// Overwrite, because this racial effect no longer grants its defenses inherently
	q.onBeingAttacked = @() { function onBeingAttacked( _attacker, _skill, _properties ) {}}.onBeingAttacked;

	q.onAdded = @(__original) function()
	{
		__original();

		// Since this racial is never meant to be removed and only exists on NPCs, we dont need to handle the removal of this perk
		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_hd_ethereal", function(o) {
			o.m.IsRefundable = false;
			o.m.IsSerialized = false;
		}));

		// Since this racial is never meant to be removed and only exists on NPCs, we dont need to handle the removal of this perk
		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_hd_ethereal", function(o) {
			o.m.IsRefundable = false;
			o.m.IsSerialized = false;
		}));

		local actor = this.getContainer().getActor();
		this.m.HD_MovementAPCostBackup = actor.m.ActionPointCosts;
		this.m.HD_MovementLevelCostBackup = actor.m.LevelActionPointCost;

		actor.m.ActionPointCosts = clone ::Const.SameMovementAPCost;
		actor.m.LevelActionPointCost = 0;

		actor.getBaseProperties().HD_ImmuneToChilled = true;
	}

	q.onRemoved = @(__original) function()
	{
		__original();

		local actor = this.getContainer().getActor();
		if (this.m.HD_MovementAPCostBackup != null)
		{
			actor.m.ActionPointCosts = this.m.HD_MovementAPCostBackup;
		}

		if (this.m.HD_MovementLevelCostBackup != null)
		{
			actor.m.LevelActionPointCost = this.m.HD_MovementLevelCostBackup;
		}
	}
});
