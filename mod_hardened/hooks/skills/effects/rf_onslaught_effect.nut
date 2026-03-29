::Hardened.wipeClass("scripts/skills/effects/rf_onslaught_effect", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/effects/rf_onslaught_effect", function(q) {
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
			text = ::Reforged.Mod.Tooltips.parseString("Gain [$ $|Perk+perk_pathfinder]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [$ $|Perk+perk_rf_vigorous_assault]"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Gain [$ $|Perk+perk_hd_elusive]"),
		});

		return ret;
	}

	q.onAdded = @() function()
	{
		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_pathfinder", function(o) {
			o.m.IsSerialized = false;
		}));

		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_rf_vigorous_assault", function(o) {
			o.m.IsSerialized = false;
		}));

		this.getContainer().add(::Reforged.new("scripts/skills/perks/perk_hd_elusive", function(o) {
			o.m.IsSerialized = false;
		}));
	}

	q.onRemoved = @() function()
	{
		// We need to use "removeByStackByID" (added by Stack-Based-Skills), because its hook of the vanilla removeByID , used on perks, only remove the serialized version of them
		this.getContainer().removeByStackByID("perk.pathfinder", false);
		this.getContainer().removeByStackByID("perk.rf_vigorous_assault", false);
		this.getContainer().removeByStackByID("perk.hd_elusive", false);
	}

	q.onRefresh = @() function()
	{
		this.m.HD_LastsForRounds = this.m.LastsForRounds;
		this.spawnIcon(this.m.Overlay, this.getContainer().getActor().getTile());
	}
});
