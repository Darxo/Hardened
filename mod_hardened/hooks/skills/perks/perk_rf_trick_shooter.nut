::Hardened.wipeClass("scripts/skills/perks/perk_rf_trick_shooter", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_trick_shooter", function(q) {
	// Public
	q.m.ActionPointModifier <- -2;

	// Private
	q.m.UsedSkills <- {};	// Table of skill IDs and their skill name, that have been used this battle

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Never repeat the same trick twice!";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
	}

	q.getTooltip = @(__original) function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = format("All Bow Skills that you have not used yet this battle, cost %s %s", ::MSU.Text.colorizeValue(this.m.ActionPointModifier, {InvertColor = true, AddSign = true}), ::Reforged.Mod.Tooltips.parseString("[Action Points|Concept.ActionPoints]")),
		});

		if (this.m.UsedSkills.len() != 0)
		{

			local childrenElements = [];
			local childrenId = 1;
			foreach (index, name in this.m.UsedSkills)
			{
				childrenElements.push({
					id = childrenId,
					type = "text",
					icon = "ui/icons/unlocked_small.png",
					text = name,
				});
				++childrenId;
			}

			ret.push({
				id = 11,
				type = "text",
				icon = "ui/tooltips/warning.png",
				text = "Skills used already:",
				children = childrenElements,
			});
		}

		return ret;
	}

	q.onAdded = @(__original) function()
	{
		local equippedItem = this.getContainer().getActor().getMainhandItem();
		if (equippedItem != null) this.onEquip(equippedItem);
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);
		// Apply the Action Point Discount
		foreach (skill in this.getContainer().m.Skills)
		{
			if (this.isSkillValid(skill))
			{
				skill.m.ActionPointCost += this.m.ActionPointModifier;
			}
		}
	}

	q.onEquip = @(__original) function( _item )
	{
		__original( _item );
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Bow))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_flaming_arrows_skill"));
		}
	}

	q.onRemoved = @(__original) function()
	{
		local actor = this.getContainer().getActor();
		local equippedItem = actor.getMainhandItem();
		if (equippedItem != null)
		{
			actor.getItems().unequip(equippedItem);
			actor.getItems().equip(equippedItem);
		}
	}

	q.onCombatFinished = @(__original) function()
	{
		this.m.UsedSkills.clear();
	}

// Hardened Events
	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);
		if (this.isSkillValid(_skill))
		{
			this.m.UsedSkills[_skill.getID()] <- _skill.getName();
		}
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (_skill.getID() in this.m.UsedSkills)
		{
			return false;
		}

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Bow);
	}
});
