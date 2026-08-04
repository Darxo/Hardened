::Hardened.HooksMod.hook("scripts/skills/actives/charm_skill", function(q) {
// Public
	q.m.HD_NumberOfMoraleChecks <- 3;
	q.m.HD_MoraleCheckDifficulty <- 20;		// Vanilla: 35
	q.m.HD_onUseDelay <- 500;

// Private
	q.create = @(__original) function()
	{
		__original();

		// We turn off attack flag to make this skill produce a combat log on-use
		this.m.IsAttack = false;
	}

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Trigger " + ::MSU.Text.colorPositive(this.m.HD_NumberOfMoraleChecks) + " [Mental Attacks|Concept.Morale] on the target with an additional difficulty of " + ::MSU.Text.colorizeValue(this.HD_getMentalAttackDifficulty())),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("If any are successful, apply [$ $|Skill+stunned_effect] to the target"),
		});

		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("If any are successful, apply [$ $|Skill+charmed_effect] to the target, lasting " + ::MSU.Text.colorPositive("1") + " [turn|Concept.Turn] for every successful Mental Attack"),
		});

		return ret;
	}}.getTooltip;

	q.onVerifyTarget = @(__original) function( _originTile, _targetTile )
	{
		return __original(_originTile, _targetTile) && !_targetTile.getEntity().getSkills().hasSkill("effects.hd_headless");
	}

	// Overwrite, because we make the use-delay moddable
	q.onUse = @() function( _user, _targetTile )
	{
		local tag = {
			User = _user,
			TargetTile = _targetTile
		};
		::Time.scheduleEvent(::TimeUnit.Virtual, this.m.HD_onUseDelay, this.onDelayedEffect.bindenv(this), tag);
		return true;
	}

	// Overwrite, because we extract the impact effect into its own function
	q.onDelayedEffect = @() function( _tag )
	{
		local targetTile = _tag.TargetTile;
		local user = _tag.User;
		local time = ::Tactical.spawnProjectileEffect("effect_heart_01", user.getTile(), targetTile, 0.33, 2.0, false, false);
		::Time.scheduleEvent(::TimeUnit.Virtual, time, this.HD_onImpact.bindenv(this), _tag);
	}

// New Functions
	// Effect, after the charm projectile landed on the target
	q.HD_onImpact <- function( _tag )
	{
		local target = _tag.TargetTile.getEntity();
		local successfulMentalAttacks = 0;
		for (local i = 1; i <= this.m.HD_NumberOfMoraleChecks; ++i)
		{
			if (!target.checkMorale(0, -this.HD_getMentalAttackDifficulty(), ::Const.MoraleCheckType.MentalAttack))
			{
				++successfulMentalAttacks;
			}
		}

		if (successfulMentalAttacks == 0)
		{
			if (!this.getContainer().getActor().isHiddenToPlayer() && !target.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " resists being charmed thanks to their resolve");
			}
		}
		else
		{
			this.HD_onCharmed(target, successfulMentalAttacks);
		}
	}

	// Effect, when at least one Mental Attack succeeds
	q.HD_onCharmed <- function( _target, _successfulMentalAttacks )
	{
		this.m.Slaves.push(_target.getID());

		local charmed = ::new("scripts/skills/effects/charmed_effect");
		charmed.m.HD_LastsForTurns = _successfulMentalAttacks;
		local actor = this.getContainer().getActor();
		charmed.setMasterFaction(actor.getFaction() == ::Const.Faction.Player ? ::Const.Faction.PlayerAnimals : actor.getFaction());
		charmed.setMaster(this);
		_target.getSkills().add(charmed);

		_target.getSkills().add(::new("scripts/skills/effects/stunned_effect"));
	}

	q.HD_getMentalAttackDifficulty <- function()
	{
		return this.m.HD_MoraleCheckDifficulty;
	}
});
