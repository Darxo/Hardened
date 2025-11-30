::Hardened.wipeClass("scripts/skills/perks/perk_rf_rattle", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_rattle", function(q) {	// We redesign this perk under the name of "Full Force"
	// Public
	q.m.DamagePctPerActionPoint <- 0.1;	// This much extra damage is dealt for each spent action point
	q.m.OneHandedMultiplier <- 2.0;		// One Handed weapons gain this much more damage

	// Private
	q.m.CurrentDamageMult <- 1.0;	// Damage bonus so its preserved throughout multiple skill uses
	q.m.SkillCounter <- null;	// This is used to bind this damage effect to the root skill so that it will empower and rediscover it even through delays
	q.m.SpentActionPoints <- 0;	// We save this so we can scale our impact animation to the amount of spent action points
	q.m.HD_LastTileTargeted <- null;	// We save the last tile that was targeted by our boosted attack so that we have it available after the hit, as then the actor might be dead

// Hardened Events
	q.onReallyBeforeSkillExecuted = @(__original) function( _skill, _targetTile )
	{
		__original(_skill, _targetTile);

		if (this.isSkillValid(_skill) && ::Const.SkillCounter == ::Hardened.Temp.RootSkillCounter)
		{
			local actor = this.getContainer().getActor();
			if (actor.isActiveEntity())		// This perk only works while we are the active entity
			{
				local spendableActionPoints = actor.getActionPoints();
				if (spendableActionPoints > 0)	// Full Force requires at least 1 AP to even trigger
				{
					this.m.SpentActionPoints = spendableActionPoints;
					this.m.SkillCounter = ::Hardened.Temp.RootSkillCounter;	// We bind this effect to the root skill so that we affect all child executions of this chain

					local damagePct = spendableActionPoints * this.m.DamagePctPerActionPoint;
					if (_skill.getItem().isItemType(::Const.Items.ItemType.OneHanded))
					{
						damagePct *= this.m.OneHandedMultiplier;
					}

					this.m.CurrentDamageMult = 1.0 + damagePct;
					actor.setActionPoints(0);
				}
			}
		}
	}

	q.onAnySkillUsed = @(__original) function( _skill, _targetEntity, _properties )
	{
		__original( _skill, _targetEntity, _properties );
		if (!this.isSkillValid(_skill)) return;
		if (this.m.SkillCounter != ::Hardened.Temp.RootSkillCounter) return;

		_properties.DamageTotalMult *= this.m.CurrentDamageMult;
		_properties.ShieldDamageMult *= this.m.CurrentDamageMult;
	}

	q.onBeforeTargetHit = @(__original) function( _skill, _targetEntity, _hitInfo )
	{
		__original(_skill, _targetEntity, _hitInfo);
		if (!this.isSkillValid(_skill)) return;
		if (this.m.SkillCounter != ::Hardened.Temp.RootSkillCounter) return;

		this.m.HD_LastTileTargeted = _targetEntity.getTile();
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);
		if (!this.isSkillValid(_skill)) return;
		if (this.m.SkillCounter != ::Hardened.Temp.RootSkillCounter) return;

		// Some valid skills don't trigger regular attacks and instead call onTargetHit manually (e.g. split shield)
		// For those we don't have the information about the last targeted tile so we don't play any animation
		if (this.m.HD_LastTileTargeted == null) return;

		// this.displayImpactEffect(this.m.HD_LastTileTargeted, this.m.SpentActionPoints);
		this.displayImpactEffect(this.m.HD_LastTileTargeted, this.m.SpentActionPoints);
		this.m.HD_LastTileTargeted = null;
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.SkillCounter = null;
		this.m.SpentActionPoints = 0;
	}

// New Functions
	q.isSkillValid <- function( _skill )
	{
		if (!_skill.isAttack()) return false;
		if (this.getContainer().getActor().isDisarmed()) return false;

		local weapon = _skill.getItem();
		return !::MSU.isNull(weapon) && weapon.isItemType(::Const.Items.ItemType.Weapon) && weapon.isWeaponType(::Const.Items.WeaponType.Hammer);
	}

	q.displayImpactEffect <- function( _tile, _spentActionPoints )
	{
		if (::Hardened.Mod.ModSettings.getSetting("FullForceCameraShake").getValue())
		{
			local cameraDistance = ::Math.max(_spentActionPoints, 7);	// We cap the camera shake as it does not look at a certain point anymore
			::Tactical.getCamera().quake(this.createVec(0, -1.0), cameraDistance, 0.16, 0.35);
		}

		foreach (entry in ::Const.Tactical.HD_FullForce)
		{
			local quantity = entry.Quantity * _spentActionPoints;
			local lifeTimeQuantity = entry.LifeTimeQuantity * _spentActionPoints;
			local spawnRate = entry.SpawnRate * _spentActionPoints;
			::Tactical.spawnParticleEffect(false, entry.Brushes, _tile, entry.Delay, quantity, lifeTimeQuantity, spawnRate, entry.Stages, ::createVec(0, 0));
		}
	}
});
