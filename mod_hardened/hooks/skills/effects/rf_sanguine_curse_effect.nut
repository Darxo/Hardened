::Hardened.HooksMod.hook("scripts/skills/effects/rf_sanguine_curse_effect", function(q) {
// Public
	q.m.HD_DamageAfterMoving <- 15;

// Private
	q.m.HD_HasMovedThisRound <- false;

// Hardened
	q.m.HD_IsBleed = true;
	q.m.HD_PreventedByProperties = ["IsImmuneToBleeding"];
	q.m.HD_LastsForRounds = 2;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "This character has received a curse that drains their blood whenever they move.";

	// Reforged
		this.m.Damage = 0;
		this.m.FatigueRecoveryAdd = 0;
		this.m.StaminaMult = 1.0;
	}

	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HD_DamageAfterMoving > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = ::Reforged.Mod.Tooltips.parseString("Once per round, if you move a tile, transfer " + ::MSU.Text.colorNegative(this.m.HD_DamageAfterMoving) + " [Hitpoints|Concept.Hitpoints] to " + (::MSU.isNull(this.m.Caster) ? " the caster" : this.m.Caster.getName()))
			});
		}

		return ret;
	}

	q.onMovementStarted = @(__original) function( _tile, _numTiles )
	{
		__original(_tile, _numTiles);
/*
		if (!this.m.HD_HasMovedThisRound && _numTiles == 0)		// Only happens if the player teleports the character
		{
			this.m.HD_HasMovedThisRound = true;
			this.transferBlood(this.m.HD_DamageAfterMoving);
		}*/
	}

	q.onMovementFinished = @(__original) function()
	{
		__original();

		if (!this.m.HD_HasMovedThisRound)
		{
			this.m.HD_HasMovedThisRound = true;
			this.transferBlood(this.m.HD_DamageAfterMoving);
		}
	}

	// Overwrite, because we replace the reforged turn-based damage transfer and duration handling
	q.onTurnEnd = @() function() {}

	q.onNewRound = @(__original) function()
	{
		__original();
		this.m.HD_HasMovedThisRound = false;
	}

// New Functions
	q.transferBlood <- function( _damage )
	{
		local hitInfo = clone ::Const.Tactical.HitInfo;
		hitInfo.DamageRegular = _damage;
		hitInfo.DamageDirect = 1.0;
		hitInfo.BodyPart = ::Const.BodyPart.Body;
		hitInfo.BodyDamageMult = 1.0;
		hitInfo.FatalityChanceMult = 0.0;

		local actor = this.getContainer().getActor();
		local oldHitpoints = actor.getHitpoints();
		actor.onDamageReceived(this.m.Caster, this, hitInfo);
		local stolenHitpoints = oldHitpoints - actor.getHitpoints();
		if (stolenHitpoints <= 0) return;

		if (!actor.isHiddenToPlayer())
		{
			this.spawnIcon("rf_sanguine_curse_effect", actor.getTile());
			if (this.m.SoundOnUse.len() != 0)
			{
				::Sound.play(::MSU.Array.rand(this.m.SoundOnUse), ::Const.Sound.Volume.RacialEffect, actor.getPos());
			}
		}

		this.m.Caster.recoverHitpoints(stolenHitpoints, true)
	}
});
