::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_bolster", function(q) {
	q.m.HD_MaximumConfidentPerAttack <- 1;	// This is the maximum of allies we can make confident with one attack

	// Private
	q.m.IsSpent <- false;

	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "Your battle brothers feel confident when you\'re there backing them up!";
		this.addType(::Const.SkillType.StatusEffect);	// We add StatusEffect so that this perk can produce a status effect icon

		this.m.RequiredWeaponType = ::Const.Items.WeaponType.Polearm;
		this.m.RequiredWeaponReach = 0;
	}

	// Overwrite, because Vanilla defines no tooltips for this perk
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();


		local weaponTypeName = this.m.RequiredWeaponType == null ? "" : ::Const.Items.getWeaponTypeName(this.m.RequiredWeaponType) + " ";
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString(format("Your next %sAttack, triggers a Positive [Morale Check|Concept.Morale] for adjacent members of your company, who are not fleeing. This Attack can make at most one adjacent ally [Confident|Skill+hd_dummy_morale_state_confident]", weaponTypeName)),
		});

		return ret;
	}

	q.isHidden = @() function()
	{
		return !this.isEnabled();
	}

	// Overwrite, because we change the condition under which positive morale checks can trigger
	q.onAnySkillExecuted = @() function( _skill, _targetTile, _targetEntity, _forFree )
	{
		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;

		this.triggerBolsterEffect();
	}

	q.onNewRound = @(__original) function()
	{
		__original();
		this.m.IsSpent = false;
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsSpent = false;
	}

// Modular Vanilla Functions
	q.getQueryTargetValueMult = @(__original) function( _user, _target, _skill )
	{
		local ret = __original(_user, _target, _skill);

		if (this.getContainer().getActor().getID() != _user.getID()) return ret;		// We must be the _user

		if (_skill != null && this.isEnabled() && this.isSkillValid(_skill))
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

		return !this.m.IsSpent;
	}

	q.triggerBolsterEffect <- function()
	{
		this.m.IsSpent = true;
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
