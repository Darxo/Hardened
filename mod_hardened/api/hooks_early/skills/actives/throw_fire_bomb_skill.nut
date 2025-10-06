::Hardened.HooksMod.hook("scripts/skills/actives/throw_fire_bomb_skill", function(q) {
	// Vanilla Fix: Make impact delay of fire bomb use virtual time and trigger directly after the projectile effect
	// Overwrite, because we need the vanilla effect is simply enough to just write from scratch
	q.onUse = @() function( _user, _targetTile )
	{
		local effectDelay = 1;
		if (this.m.IsShowingProjectile && this.m.ProjectileType != 0)
		{
			if (_user.getTile().getDistanceTo(_targetTile) >= ::Const.Combat.SpawnProjectileMinDist)
			{
				local flip = !this.m.IsProjectileRotated && _targetTile.Pos.X > _user.getPos().X;
				effectDelay = ::Tactical.spawnProjectileEffect(::Const.ProjectileSprite[this.m.ProjectileType], _user.getTile(), _targetTile, 1.0, this.m.ProjectileTimeScale, this.m.IsProjectileRotated, flip);
			}
		}

		_user.getItems().unequip(_user.getItems().getItemAtSlot(::Const.ItemSlot.Offhand));
		::Time.scheduleEvent(::TimeUnit.Virtual, effectDelay, this.onApply.bindenv(this), {
			Skill = this,
			TargetTile = _targetTile,
			User = _user,
		});
	}
});
