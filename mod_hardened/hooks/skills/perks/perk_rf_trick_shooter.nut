::Hardened.wipeClass("scripts/skills/perks/perk_rf_trick_shooter", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_trick_shooter", function(q) {
	// Public
	q.m.HitChanceModifier <- 15;

	// Private
	q.m.UsedSkills <- {};	// Table of skill IDs and their skill name, that have been used this battle
	q.m.SkillCounter <- null;	// This is used to bind this perk_rf_trick_shooter effect to the root skill that it will empower and rediscover it even through delays

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Never repeat the same trick twice!";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
	}

	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = format("All Bow Skills that you have not used yet this battle, have %s %s", ::MSU.Text.colorizeValue(this.m.HitChanceModifier, {AddSign = true, AddPercent = true}), ::Reforged.Mod.Tooltips.parseString("[Hitchance|Concept.Hitchance]")),
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

	q.onAdded = @() function()
	{
		local equippedItem = this.getContainer().getActor().getMainhandItem();
		if (equippedItem != null) this.onEquip(equippedItem);
	}

	// Overwrite because we need to add additional condition
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties )
	{
		// The following condition cover two states
		// 1. isSkillValid == true. This means trick_shooter is still available for this skill so this skill must provide its effect to adjust tooltips
		// 2. both SkillCounter are the same value: we are in the execution of the empowered skill or a child skill of the empowered one. We apply our effect accordingly
		if (this.isSkillValid(_skill) || this.m.SkillCounter == ::Hardened.Temp.RootSkillCounter)
		{
			_properties.MeleeSkill += this.m.HitChanceModifier;
			_properties.RangedSkill += this.m.HitChanceModifier;
		}
	}

	q.onEquip = @() function( _item )
	{
		if (_item.isItemType(::Const.Items.ItemType.Weapon) && _item.isWeaponType(::Const.Items.WeaponType.Bow))
		{
			_item.addSkill(::new("scripts/skills/actives/rf_flaming_arrows_skill"));
		}
	}

	q.onRemoved = @() function()
	{
		local actor = this.getContainer().getActor();
		local equippedItem = actor.getMainhandItem();
		if (equippedItem != null)
		{
			actor.getItems().unequip(equippedItem);
			actor.getItems().equip(equippedItem);
		}
	}

	q.onCombatFinished = @() function()
	{
		this.m.UsedSkills.clear();
	}

// MSU Functions
	// Overwrite because we no longer remove ourselves once a valid skill is executed
	q.onGetHitFactors = @() function( _skill, _targetTile, _tooltip )
	{
		if (_targetTile.IsOccupiedByActor && this.isSkillValid(_skill))
		{
			_tooltip.push({
				icon = "ui/tooltips/positive.png",
				text = ::MSU.Text.colorizeValue(this.m.HitChanceModifier, {AddSign = true, AddPercent = true}) + " " + this.getName()
			});
		}
	}

	q.onQueryTooltip = @() function( _skill, _tooltip )
	{
		if (this.isSkillValid(_skill))
		{
			local extraData = "entityId:" + this.getContainer().getActor().getID();
			_tooltip.push({
				id = 100,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = ::MSU.Text.colorizeValue(this.m.HitChanceModifier, {AddSign = true, AddPercent = true}) + ::Reforged.Mod.Tooltips.parseString(" [Hitchance|Concept.Hitchance] because of " + ::Reforged.NestedTooltips.getNestedSkillName(this, extraData)),
			});
		}
	}

// Hardened Events
	q.onReallyBeforeSkillExecuted = @() function( _skill, _targetTile )
	{
		if (this.isSkillValid(_skill))
		{
			this.m.SkillCounter = ::Hardened.Temp.RootSkillCounter;	// We bind this effect to root skill so that we only affect child executions of this chain
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
