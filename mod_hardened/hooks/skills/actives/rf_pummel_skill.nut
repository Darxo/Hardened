::Hardened.HooksMod.hook("scripts/skills/actives/rf_pummel_skill", function(q) {
	// Public
	q.m.OneHandedActionPointCost <- 4;
	q.m.SoundOnPummel <- [
		"sounds/combat/indomitable_01.wav",
		"sounds/combat/indomitable_02.wav",
	];

	q.create = @(__original) function()
	{
		__original();

		// Using this skill now plays a regular attack sfx instead of a indomitable cry
		this.m.SoundOnUse = [
			"sounds/combat/smash_01.wav",
			"sounds/combat/smash_02.wav",
			"sounds/combat/smash_03.wav",
		];

		this.m.IsAttack = true;		// This skill inherits from line_breaker, which we made into a non-attack. Since this skill is now an actual attack, we need to re-enable it
	}

	q.onAdded = @(__original) function()
	{
		__original();

		if (!::MSU.isNull(this.getItem()) && this.getItem().isItemType(::Const.Items.ItemType.OneHanded))
		{
			this.setBaseValue("ActionPointCost", this.m.OneHandedActionPointCost);
		}
	}

	// Overwrite, because we want to play a pummel sound in certain situations only
	q.onPummel = @() function( _tag )
	{
		if (_tag.TargetTile.IsEmpty)
		{
			this.playPummelSound();
			::Tactical.getNavigator().teleport(_tag.User, _tag.TargetTile, null, null, false);
		}
		else
		{
			this.m.RequireTileToKnockBackTo = true;
			if (this.line_breaker.onVerifyTarget(_tag.User.getTile(), _tag.TargetTile))
			{
				this.playPummelSound();
				this.line_breaker.onUse(_tag.User, _tag.TargetTile);
			}
			this.m.RequireTileToKnockBackTo = false;
		}
	}

// New Functions
	q.playPummelSound <- function()
	{
		local actor = this.getContainer().getActor();
		if (!this.m.IsAudibleWhenHidden && actor.isHiddenToPlayer()) return;

		local pitch = this.m.IsUsingActorPitch ? actor.getSoundPitch() : 1.0;
		::Sound.play(::MSU.Array.rand(this.m.SoundOnPummel), ::Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos(), actor.getSoundPitch());
	}
});
