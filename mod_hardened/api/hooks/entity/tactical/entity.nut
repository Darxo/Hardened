::Hardened.HooksMod.hook("scripts/entity/tactical/entity", function(q) {
	// Public
	q.m.HD_ShakeTypeOnHit <- null;	// If not null, then this object will be shaken as defined by this unigned type, when this non-actor is hit by a projectile
	q.m.HD_SoundOnHit <- [];	// If not empty, than a random sound effect will be played when this non-actor object is hit by a projectile
	q.m.HD_SoundOnHitVolume <- 1.0;	// Custom volume for the sfx played when this non-actor object is hit by a projectile
	q.m.HD_BloodType <- ::Const.BloodType.None;	// When anything else than none, produce this blood effect, when this non-actor object is hit by a projectile
	q.m.HD_BloodQuantityMult <- 1.0;

// New Functions
	// Event, that triggers only when anything calls spawnProjectileEffect targeting the tile that this non-actor object sits on
	q.HD_onHitByProjectile <- function( _attackerTile )
	{
		if (!this.getTile().IsDiscovered) return;

		if (this.m.HD_BloodType != ::Const.BloodType.None)
		{
			foreach (bloodEffect in ::Const.Tactical.BloodEffects[this.m.HD_BloodType])
			{
				::Tactical.spawnParticleEffect(false, bloodEffect.Brushes, this.getTile(), bloodEffect.Delay, ::Math.max(1, bloodEffect.Quantity * this.m.HD_BloodQuantityMult), ::Math.max(1, bloodEffect.LifeTimeQuantity * this.m.HD_BloodQuantityMult), ::Math.max(1, bloodEffect.SpawnRate * this.m.HD_BloodQuantityMult), bloodEffect.Stages);
			}
		}

		if (this.m.HD_ShakeTypeOnHit != null)
		{
			::Tactical.getShaker().shake(this, _attackerTile, this.m.HD_ShakeTypeOnHit);
		}

		if (this.m.HD_SoundOnHit.len() != 0)
		{
			::Sound.play(::MSU.Array.rand(this.m.HD_SoundOnHit), this.m.HD_SoundOnHitVolume, this.getPos(), 1.0);
		}
	}
});
