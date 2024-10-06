::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_rebuke", function(q) {
	q.m.RebukeTriggerSounds <- [
		"sounds/combat/return_favor_01.wav",
	];

	q.addResources = @(__original) function()
	{
		__original();
		foreach (r in this.m.RebukeTriggerSounds)
		{
			::Tactical.addResource(r);
		}
	}

	q.onQueryTooltip = @(__original) function( _skill, _tooltip )
	{
		local ret = __original(_skill, _tooltip);

		if (_skill.getID() == "actives.aimed_shot")
		{
			ret.push({
				id = 102,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Burns away any [rooted|Rooted.StatusEffect] effects on the target"),
			});
		}

		return ret;
	}

	q.onMissed <- function( _attacker, _skill )
	{
		if (this.canProc(_attacker, _skill))
		{
			local rebukeEffect = ::new("scripts/skills/effects/hd_rebuke_effect");
			rebukeEffect.m.ParentPerk = ::MSU.asWeakTableRef(this);
			this.getContainer().add(rebukeEffect);
			::Sound.play(::MSU.Array.rand(this.m.ReturnFavorSounds), ::Const.Sound.Volume.Skill * this.m.SoundVolume, this.getContainer().getActor().getPos());
		}
	}

	// Overwrite, becaue we no longer add the rebuke effect at the start of the combat
	q.onCombatStarted = @() function() {}

// New Functions
	// Checks all conditions at once
	q.canProc <- function ( _attacker, _skill )
	{
		if (!isEnabled()) return false;
		if (!isValidSkill(_skill)) return false;

		local actor = this.getContainer().getActor();
		if (!_attacker.isAlive() || !_attacker.isPlacedOnMap()) return false;

		return true;
	}

	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;
		if (::Tactical.TurnSequenceBar.isActiveEntity(actor)) return false;
		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing || actor.getCurrentProperties().IsStunned) return false;
		if (actor.getCurrentProperties().IsRiposting) return false;
		if (this.getContainer().getAttackOfOpportunity() == null) return false;

		return true;
	}

	q.isValidSkill <- function( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged() && !_skill.isIgnoringRiposte();
	}
});
