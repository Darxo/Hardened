this.perk_hd_hybridization <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		MeleeSkillThreshold = 70,	// This much base melee skill is required to gain the ranged defense bonus
		RangedSkillThreshold = 70,	// This much base ranged skill is required to gain the melee defense bonus
		MeleeDefenseModifier = 5,
		RangedDefenseModifier = 5,

		// Private
		IsSpent = true,		// While this is false, this character can still swap two different weapontypes for free
	},
	function create()
	{
		this.m.ID = "perk.hd_hybridization";
		this.m.Name = ::Const.Strings.PerkName.HD_Hybridization;
		this.m.Description = "\'Hatchet, throwing axe, spear, javelin... they all kill just the same!\'";
		this.m.Icon = "ui/perks/perk_rf_hybridization.png";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return this.m.IsSpent;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (!this.m.IsSpent)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can switch two weapons with no shared weapon type for free",
			});
		}

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.MeleeDefense += this.getMeleeDefenseModifier();
		_properties.RangedDefense += this.getRangedDefenseModifier();
	}

	// If the player wants to swap exactly two weapons with different shared weapontypes,
	function getItemActionCost( _items )
	{
		if (this.m.IsSpent) return null;

		local foundValidWeapons = 0;
		local involvedWeaponTypes = 0;
		foreach (item in _items)
		{
			if (item == null) continue;	// Some swaps contain 2 weapons and a third null item (usually offhand), so we can't make a decision just yet
			if (!item.isItemType(::Const.Items.ItemType.Weapon)) return null;	// We dont allow a free swap if a non-weapon is involved

			if (item.isWeaponType(involvedWeaponTypes)) return null;		// No weapon type may appear multiple times in this swap
			involvedWeaponTypes = involvedWeaponTypes | item.m.WeaponType;
			foundValidWeapons++;
		}

		if (foundValidWeapons == 2)
		{
			return 0;
		}
		else
		{
			return null;
		}
	}

	// If we swap two or more weapons, this perk becomes in effect
	function onPayForItemAction( _skill, _items )
	{
		if (_skill == this) this.m.IsSpent = true;
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

// New Functions
	function getMeleeDefenseModifier()
	{
		if (this.getContainer().getActor().getBaseProperties().RangedSkill >= this.m.RangedSkillThreshold)
		{
			return this.m.MeleeDefenseModifier;
		}

		return 0;
	}

	function getRangedDefenseModifier()
	{
		if (this.getContainer().getActor().getBaseProperties().MeleeSkill >= this.m.MeleeSkillThreshold)
		{
			return this.m.RangedDefenseModifier;
		}

		return 0;
	}
});
