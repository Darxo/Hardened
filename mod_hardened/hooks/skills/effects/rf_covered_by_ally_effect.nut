::Hardened.HooksMod.hook("scripts/skills/effects/rf_covered_by_ally_effect", function(q) {
	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This character has received temporary cover from a shield-wielding ally";
	}

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

		return ret;
	}

	// We overwrite this, because this effect no longer grants rf_move_under_cover_skill
	q.onAdded = @() function() {}

	q.onUpdate = @(__original) function( _properties )
	{
		// We revert any reforged changes to turn order initiative
		local oldInitiativeForTurnOrder = _properties.InitiativeForTurnOrderAdditional;
		__original(_properties);
		_properties.InitiativeForTurnOrderAdditional = oldInitiativeForTurnOrder;

		if (!this.isGarbage())
		{
			_properties.MeleeDefense += this.getMeleeDefenseModifier();
			_properties.RangedDefense += this.getRangedDefenseModifier();
		}
	}

// New Functions
	q.getMeleeDefenseModifier <- function()
	{
		if (!::MSU.isNull(this.m.CoverProvider) && this.m.CoverProvider.isAlive())
		{
			local shield = this.m.CoverProvider.getOffhandItem();
			if (shield.isItemType(::Const.Items.ItemType.Shield))
			{
				return shield.getMeleeDefense();
			}
		}
		return 0;
	}

	q.getRangedDefenseModifier <- function()
	{
		if (!::MSU.isNull(this.m.CoverProvider) && this.m.CoverProvider.isAlive())
		{
			local shield = this.m.CoverProvider.getOffhandItem();
			if (shield.isItemType(::Const.Items.ItemType.Shield))
			{
				return shield.getRangedDefense();
			}
		}
		return 0;
	}
});
