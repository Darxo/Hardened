::Hardened.HooksMod.hook("scripts/skills/effects/rf_covering_ally_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This character is currently covering an ally with their shield causing them to neglect their own defenses.";

		// We turn off these Reforged values as we apply them ourselves
		this.m.SelfSkillMalus = 0;
		this.m.SelfDefenseMalus = 0;
	}

	// Overwrite, because that is simpler than adjusting all reforged tooltip lines
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
				text = ::MSU.Text.colorizeValue(meleeDefenseModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Melee Defense|Concept.MeleeDefense]"),
			});
		}

		local rangedDefenseModifier = this.getRangedDefenseModifier();
		if (rangedDefenseModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = ::MSU.Text.colorizeValue(rangedDefenseModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Ranged Defense|Concept.RangeDefense]"),
			});
		}

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your next [turn|Concept.Turn]"),
		});

		ret.push({
			id = 21,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Is removed when you get stunned or start [fleeing|Skill+hd_dummy_morale_state_fleeing]"),
		});

		return ret;
	}

	// Overwrite, because we apply different conditions for when this effect gets removed: This effect is no longer removed when the user gets rooted
	q.onUpdate = @() function( _properties )
	{
		if (::MSU.isNull(this.m.Ally) || !this.m.Ally.isPlacedOnMap() || _properties.IsStunned || this.getContainer().getActor().getMoraleState() == ::Const.MoraleState.Fleeing)
		{
			this.removeSelf();
			this.onRemoved();
			return;
		}

		if (!this.isGarbage())
		{
			_properties.MeleeDefense += this.getMeleeDefenseModifier();
			_properties.RangedDefense += this.getRangedDefenseModifier();
		}
	}

// New Functions
	q.getMeleeDefenseModifier <- function()
	{
		local shield = this.getContainer().getActor().getOffhandItem();
		if (shield != null && shield.isItemType(::Const.Items.ItemType.Shield))
		{
			return -1 * shield.getMeleeDefense();
		}
		return 0;
	}

	q.getRangedDefenseModifier <- function()
	{
		local shield = this.getContainer().getActor().getOffhandItem();
		if (shield != null && shield.isItemType(::Const.Items.ItemType.Shield))
		{
			return -1 * shield.getRangedDefense();
		}
		return 0;
	}
});
