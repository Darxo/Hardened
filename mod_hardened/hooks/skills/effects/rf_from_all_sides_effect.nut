::Hardened.wipeClass("scripts/skills/effects/rf_from_all_sides_effect", [
	"create",
	"onTurnStart",	// The effect is still removed on turn start
]);

::Hardened.HooksMod.hook("scripts/skills/effects/rf_from_all_sides_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This character is dishing out attacks which seem to come from all sides. Very confusing!"
	}

	q.getTooltip <- function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("You [surround|Concept.Surrounding] adjacent enemies an additional time"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
		});

		return ret;
	}

// New Functions
	// Is called from actor.__calculateSurroundedCount to check if the character has a valid skill to apply the surround bonus
	// This function expects our actor and _target to be isPlacedOnMap
	q.getSurroundedModifier <- function( _target )
	{
		if (_target.countsAsSurrounding(this.getContainer().getActor()))
		{
			return 1;
		}
		else
		{
			return 0;
		}
	}
});
