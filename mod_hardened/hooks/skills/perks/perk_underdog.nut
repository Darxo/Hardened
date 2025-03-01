::Hardened.HooksMod.hook("scripts/skills/perks/perk_underdog", function(q) {
	// Public
	q.m.MeleeDefensePerSurround <- 5;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "I\'m used to it.";
		this.addType(::Const.SkillType.StatusEffect);	// We add StatusEffect so that this perk can produce a status effect icon
	}

	// Overwrite because vanilla does not implement this function
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		local meleeDefenseModifier = this.getMeleeDefenseModifier();
		if (meleeDefenseModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = ::Reforged.Mod.Tooltips.parseString("Gain " + ::MSU.Text.colorizeValue(meleeDefenseModifier, {AddSign = true}) + " [Melee Defense|Concept.MeleeDefense]"),
			});
		}

		return ret;
	}

	q.isHidden = @() function()
	{
		return this.getMeleeDefenseModifier() == 0;
	}

	// Overwrite, because we replace the vanilla effect with our own
	q.onUpdate = @() function( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;	// Because this perk grants melee defense depending on adjacent enemies
		_properties.MeleeDefense += this.getMeleeDefenseModifier();
	}

// New Functions
	q.getMeleeDefenseModifier <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return 0;

		local surroundedCount = actor.getSurroundedCount();	// This function already subtracts one, so we dont have to do it here
		return surroundedCount * this.m.MeleeDefensePerSurround;
	}
});
