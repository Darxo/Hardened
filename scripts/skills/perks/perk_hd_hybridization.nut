this.perk_hd_hybridization <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		HitchanceModifier = 5,	// This much hitchance is granted to this character for attacks after switching weapons

		// Private
		IsSpent = true,		// While this is false, this character can still swap two different weapontypes for free
		IsInEffect = false,	// This indicates, whether the next attack on this character will be buffed
		SkillCounter = null,	// Skillcounter of the skill, buffed by this perks hitchance bonus
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
		return this.m.IsSpent && !this.m.IsInEffect;
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.IsInEffect && this.m.HitchanceModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/hitchance.png",
				text = ::MSU.Text.colorizeValue(this.m.HitchanceModifier, {AddSign = true, AddPercent = true}) + ::Reforged.Mod.Tooltips.parseString(" [Hitchance|Concept.Hitchance] for your next attack"),
			});

			ret.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Will expire when you [wait|Concept.Wait] or end your [turn|Concept.Turn]"),
			});
		}

		if (!this.m.IsSpent)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/special.png",
				text = "Can switch two weapons with no shared weapon type for free",
			});
		}

		return ret;
	}

	function onAnySkillUsed( _skill, _targetEntity, _properties )
	{
		if (!this.isSkillValid(_skill)) return;

		if (this.m.IsInEffect && ::Hardened.Temp.RootSkillCounter == null)	// We are previewing a skill
		{
			_properties.MeleeSkill += this.m.HitchanceModifier;
			_properties.RangedSkill += this.m.HitchanceModifier;
		}
		else if (!this.m.IsInEffect && this.m.SkillCounter != null && this.m.SkillCounter == ::Hardened.Temp.RootSkillCounter)	// A skill, that was buffed by us, is calculating hitchance
		{
			_properties.MeleeSkill += this.m.HitchanceModifier;
			_properties.RangedSkill += this.m.HitchanceModifier;
		}
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

		local foundWeapons = 0;
		foreach (item in _items)
		{
			if (item == null) continue;	// Some swaps contain 2 weapons and a third null item (usually offhand), so we can't make a decision just yet
			if (!item.isItemType(::Const.Items.ItemType.Weapon)) continue;	// We only count weapons

			foundWeapons++;
		}

		if (foundWeapons == 2)
		{
			this.m.IsInEffect = true;
			this.m.SkillCounter = null;
		}
	}

	function onTurnStart()
	{
		this.m.IsSpent = false;
	}

	function onTurnEnd()
	{
		this.m.IsInEffect = false;
	}

	function onWaitTurn()
	{
		this.m.IsInEffect = false;
	}

	function onCombatFinished()
	{
		this.skill.onCombatFinished();
		this.m.IsSpent = true;
	}

// MSU Functions
	function onGetHitFactors( _skill, _targetTile, _tooltip )
	{
		if (this.m.IsInEffect && this.m.SkillCounter == null && this.m.HitchanceModifier != 0 && this.isSkillValid(_skill))
		{
			_tooltip.push({
				icon = "ui/tooltips/positive.png",
				text = ::MSU.Text.colorPositive(this.m.HitchanceModifier + "% ") + this.getName(),
			});
		}
	}

// Hardened Functions
	function onReallyBeforeSkillExecuted( _skill, _targetTile )
	{
		if (this.m.IsInEffect && this.isSkillValid(_skill))
		{
			this.m.IsInEffect = false;
			this.m.SkillCounter = ::Hardened.Temp.RootSkillCounter;
		}
	}

// New Functions
	function isSkillValid( _skill )
	{
		return _skill.isAttack();
	}
});
