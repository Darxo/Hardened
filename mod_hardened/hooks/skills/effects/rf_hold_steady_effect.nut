::Hardened.wipeClass("scripts/skills/effects/rf_hold_steady_effect", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/effects/rf_hold_steady_effect", function(q) {
	q.m.LastsForRounds <- 2;

	q.create = @(__original) function()
	{
		__original();

		this.m.HD_LastsForRounds = this.m.LastsForRounds;
	}

	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [$ $|Perk+perk_rf_entrenched]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immune to being [$ $|Skill+stunned_effect]")
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immune to [Displacement|Concept.Displacement]")
		});

		return ret;
	}

	q.onAdded = @() function()
	{
		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_rf_entrenched", function(o) {
			o.m.IsRefundable = false;
			o.m.IsSerialized = false;
		}));
	}

	q.onUpdate = @() function( _properties )
	{
		_properties.IsImmuneToStun = true;
		_properties.IsImmuneToKnockBackAndGrab = true;
	}

	q.onRemoved = @() function()
	{
		// We need to use "removeByStackByID" (added by Stack-Based-Skills), because its hook of the vanilla removeByID , used on perks, only remove the serialized version of them
		this.getContainer().removeByStackByID("perk.rf_entrenched", false);
	}

	q.onRefresh = @(__original) function()
	{
		__original();
		this.m.HD_LastsForRounds = this.m.LastsForRounds;
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}
});
