// We wipe many reforged functions as we rework this perk for something different
::Hardened.wipeClass("scripts/skills/perks/perk_rf_rebuke", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_rebuke", function(q) {
	q.m.RebukeTriggerSounds <- [
		"sounds/combat/return_favor_01.wav",
	];

	q.create = @(__original) function()
	{
		__original();
		this.m.Type = ::Const.SkillType.Perk;
	}

	q.addResources = @(__original) function()
	{
		__original();
		foreach (r in this.m.RebukeTriggerSounds)
		{
			::Tactical.addResource(r);
		}
	}

	q.onMissed = @() function( _attacker, _skill )
	{
		if (this.canProc(_attacker, _skill) && !this.getContainer().hasSkill("effects.hd_rebuke"))
		{
			local rebukeEffect = ::new("scripts/skills/effects/hd_rebuke_effect");
			rebukeEffect.m.ParentPerk = ::MSU.asWeakTableRef(this);
			this.getContainer().add(rebukeEffect);
			::Sound.play(::MSU.Array.rand(this.m.RebukeTriggerSounds), ::Const.Sound.Volume.Skill * this.m.SoundVolume, this.getContainer().getActor().getPos());
		}
	}

	// Overwrite, becaue we no longer add the rebuke effect at the start of the combat
	q.onCombatStarted = @() function() {}

// New Functions
	// Checks all conditions at once
	q.canProc <- function ( _attacker, _skill )
	{
		if (!isEnabled()) return false;
		if (!isSkillValid(_skill)) return false;

		local actor = this.getContainer().getActor();
		if (!_attacker.isAlive() || !_attacker.isPlacedOnMap()) return false;

		return true;
	}

	q.isEnabled <- function()
	{
		local actor = this.getContainer().getActor();
		if (actor.isActiveEntity()) return false;	// This perk only works while it is not our turn
		if (actor.getMoraleState() == ::Const.MoraleState.Fleeing || actor.getCurrentProperties().IsStunned) return false;
		if (actor.getCurrentProperties().IsRiposting) return false;
		if (this.getContainer().getAttackOfOpportunity() == null) return false;

		return true;
	}

	q.isSkillValid <- function( _skill )
	{
		return _skill.isAttack() && !_skill.isRanged() && !_skill.isIgnoringRiposte();
	}
});
