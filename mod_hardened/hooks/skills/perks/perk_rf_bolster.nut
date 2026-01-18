::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bolster", function(q) {
	q.m.HD_MaximumConfidentPerAttack <- 1;	// This is the maximum of allies we can make confident with one attack

	q.create = @(__original) function()
	{
		__original();
		this.m.RequiredWeaponType = ::Const.Items.WeaponType.Polearm;
		this.m.RequiredWeaponReach = 0;
	}

	// Overwrite, because we change the condition under which positive morale checks can trigger
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;

		this.triggerBolsterEffect();

	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;		// We must be the _user

		if (_skill != null && this.isSkillValid(_skill))
		{
			foreach (ally in ::Tactical.Entities.getFactionActors(_user.getFaction(), _user.getTile(), 1, true))
			{
				if (ally.getMoraleState() < ally.m.MaxMoraleState)
				{
					ret *= 1.1;		// Every ally, whose morale I could raise with the bolster morale check increases the value of the target
				}
			}
		}

		return ret;
	}

// Reforged
	// Overwrite to remove the condition about Reach
	q.isSkillValid = @() function( _skill )
	{
		if (!_skill.isAttack() || _skill.isRanged()) return false;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(this.m.RequiredWeaponType);
	}

// New Functions
	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;
		if (actor.isEngagedInMelee()) return false;

		return true;
	}

	q.triggerBolsterEffect <- function()
	{
		local triggeredMoraleCheck = false;

		local actor = this.getContainer().getActor();
		local remainingConfident = this.m.HD_MaximumConfidentPerAttack;
		foreach (ally in ::Tactical.Entities.getFactionActors(actor.getFaction(), actor.getTile(), 1, true))
		{
			local moraleState = ally.getMoraleState();
			if (moraleState == ::Const.MoraleState.Confident) continue;
			if (moraleState == ::Const.MoraleState.Steady && remainingConfident == 0) continue;

			if (!triggeredMoraleCheck)
			{
				triggeredMoraleCheck = true;
				::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " tries to bolster his allies");
			}

			ally.checkMorale(1, ::Const.Morale.RallyBaseDifficulty, ::Const.MoraleCheckType.Default, this.m.Overlay);
			if (ally.getMoraleState() == ::Const.MoraleState.Confident) --remainingConfident;
		}
	}
});
