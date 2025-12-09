::Hardened.HooksMod.hook("scripts/skills/skill_container", function(q) {
	// Overwrite, because we change some behavior of this function
	q.querySortedByItems = @() function( _filter, _notFilter = 0 )
	{
		local ret = [];
		for (local i = 0; i < ::Const.ItemSlot.COUNT; ++i)
		{
			ret.push([]);
		}

		local omnipresentSkills = [];	// active skills, which are marked to be sorted in front of mainhand skills

		foreach (skill in this.m.Skills)
		{
			if (!skill.isGarbage() && skill.isType(_filter) && !skill.isType(_notFilter) && !skill.isHidden())
			{
				if (skill.m.HD_IsSortedBeforeMainhand)
				{
					omnipresentSkills.push(this.WeakTableRef(skill));
				}
				else if (!::MSU.isNull(skill.getItem()))
				{
					ret[skill.getItem().getCurrentSlotType()].push(this.WeakTableRef(skill));
				}
				else
				{
					// We push this into ItemSlot.Bag (just like Vanilla), so non-item skills will compete with bag-skills with their SkillOrder
					ret[::Const.ItemSlot.Bag].push(this.WeakTableRef(skill));
				}
			}
		}

		// We want omnipresent skills to come first, before regular mainhand weapons
		local mainhandSkills = ret[::Const.ItemSlot.Mainhand];
		ret[::Const.ItemSlot.Mainhand] = omnipresentSkills;
		ret[::Const.ItemSlot.Mainhand].extend(mainhandSkills);

		// Vanilla sorts ::Const.ItemSlot.Free entry here but we need no sorting, because this.m.Skills was sorted by default

		return ret;
	}

// New Events
	/// _skill is the new skill that was just added to this skill_container
	q.onOtherSkillAdded <- function( _skill )
	{
		this.callSkillsFunction("onOtherSkillAdded", [
			_skill
		], false);
	}

	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		this.callSkillsFunction("onReallyBeforeSkillExecuted", [
			_skill,
			_targetTile,
		], false);
	}

	q.onReallyAfterSkillExecuted <- function( _skill, _targetTile, _success )
	{
		this.callSkillsFunction("onReallyAfterSkillExecuted", [
			_skill,
			_targetTile,
			_success,
		], false);
	}

	// This event is called when this entity is spawned and placed on the map
	q.onSpawned <- function()
	{
		this.callSkillsFunction("onSpawned", [], false);
	}

	q.onBeforeShieldDamageReceived <- function( _damage, _shield, _defenderProps, _attacker = null, _attackerProps = null, _skill = null )
	{
		this.callSkillsFunction("onBeforeShieldDamageReceived", [
			_damage,
			_shield,
			_defenderProps,
			_attacker,
			_attackerProps,
			_skill,
		], false);
	}

	q.onAfterShieldDamageReceived <- function( _initialDamage, _damageReceived, _shield, _attacker = null, _skill = null )
	{
		this.callSkillsFunction("onAfterShieldDamageReceived", [
			_initialDamage,
			_damageReceived,
			_shield,
			_attacker,
			_skill,
		], false);
	}
});
