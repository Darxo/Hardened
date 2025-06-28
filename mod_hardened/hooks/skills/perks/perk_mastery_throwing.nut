// The reforged hook for this perk is being sniped
::Hardened.HooksMod.hook("scripts/skills/perks/perk_mastery_throwing", function(q) {
	// Public
	q.m.DamageTotalMult <- 1.3;	// Damage Multiplier for first throwing attack each turn

	// Private
	q.m.IsQuickSwitchSpent <- false;		// Is quickswitching spent this turn?
	q.m.SkillCounter <- null;	// This is used to bind this perk_mastery_throwing effect to the root skill that it will empower and rediscover it even through delays

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original( _skill, _targetEntity, _properties );
		if (!this.isSkillValidForDamageBonus(_skill)) return;

		// The following condition is a smart way to cover three states
		// 1. both are null. This means perk_mastery_throwing is still available and we are not in the execution of a skill so this skill must provide its effect to adjust tooltips
		// 2. both are the same value: we are in the execution of the empowered skill or a child skill of the empowered one. We apply our effect accordingly
		// 3. SkillCounter is not null: our effect is used up, so we no longer display any tooltip adjustments
		if (this.m.SkillCounter != ::Hardened.Temp.RootSkillCounter) return;

		_properties.DamageTotalMult	*= this.m.DamageTotalMult;
	}

	// Overwrite to turn off Reforged onHit effects
	q.onTargetHit = @() function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor ) {}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsQuickSwitchSpent = false;
		this.m.SkillCounter = null;
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsQuickSwitchSpent = true;
		this.m.SkillCounter = null;
	}

	q.onPayForItemAction = @(__original) function( _skill, _items )
	{
		__original(_skill, _items);
		if (_skill == this) this.m.IsQuickSwitchSpent = true;
	}

	// You can now swap a throwing weapon with an empty slot or an empty throwing weapon
	q.getItemActionCost = @(__original) function( _items )
	{
		if (this.m.IsQuickSwitchSpent) return null;

		// Currently we have no guarantee about how _items actually looks like or whether it contains elements, see https://github.com/MSUTeam/MSU/issues/435
		if (_items.len() == 0) return null;

		local sourceItem = _items[0];
		local targetItem = _items.len() > 1 ? _items[1] : null;

		if (sourceItem == null)		// Fix for when other mods break convention and instead have the first item in the array be the destination item (e.g. Extra Keybinds)
		{
			sourceItem = targetItem;
			targetItem = null;
		}

		if (sourceItem.isItemType(::Const.Items.ItemType.Weapon) && sourceItem.isWeaponType(::Const.Items.WeaponType.Throwing))
		{
			if (targetItem == null)	// Either the target is an empty slot
			{
				return 0;
			}

			if (targetItem.isItemType(::Const.Items.ItemType.Weapon) && targetItem.isWeaponType(::Const.Items.WeaponType.Throwing))
			{
				if ((sourceItem.m.Ammo == 0 && sourceItem.m.AmmoMax != 0) || (targetItem.m.Ammo == 0 && targetItem.m.AmmoMax != 0))	// Or either of the two throwing weapons uses ammunition and is empty
				{
					return 0;
				}
			}
		}

		return null;
	}

// Hardened Functions
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		if (this.isSkillValidForDamageBonus(_skill) && this.m.SkillCounter == null && ::Const.SkillCounter == ::Hardened.Temp.RootSkillCounter)
		{
			this.m.SkillCounter = ::Hardened.Temp.RootSkillCounter;	// We bind this effect to the root skill so that we affect all child executions of this chain
		}
	}

// New Functions
	q.isSkillValidForDamageBonus <- function( _skill )
	{
		return this.isSkillValid(_skill) && skill.isAttack();
	}

	q.isSkillValid <- function( _skill )
	{
		if (_skill == null) return false;
		if (!_skill.isActive()) return false;

		local skillItem = _skill.getItem();
		if (::MSU.isNull(skillItem)) return false;
		if (!skillItem.isItemType(::Const.Items.ItemType.Weapon)) return false;
		if (!skillItem.isWeaponType(::Const.Items.WeaponType.Throwing)) return false;

		return true;
	}
});
