::Hardened.HooksMod.hook("scripts/ai/tactical/behaviors/ai_switchto_melee", function(q) {
	q.onEvaluate = @() function( _entity )
	{
		this.m.WeaponToEquip = null;
		this.m.IsNegatingDisarm = false;

		local zeroScore = ::Const.AI.Behavior.Score.Zero;

		if (_entity.getMoraleState() == ::Const.MoraleState.Fleeing) return zeroScore;
		if (_entity.getCurrentProperties().IsStunned) return zeroScore;
		if (!this.getAgent().hasVisibleOpponent()) return zeroScore;

		local items = _entity.getItems().getAllItemsAtSlot(::Const.ItemSlot.Bag);
		if (items.len() == 0) return zeroScore;

		local mainhandItem = _entity.getMainhandItem();
		local scoreMult = this.getProperties().BehaviorMult[this.m.ID];
		// Vanilla logic for determining, whether we rather wanna keep our ranged weapon equipped
		if (mainhandItem != null && mainhandItem.isItemType(::Const.Items.ItemType.RangedWeapon))
		{
			local isGoodReason = false;
			local myTile = _entity.getTile();

			if (mainhandItem.getAmmoMax() > 0 && mainhandItem.getAmmo() == 0)
			{
				this.logInfo("switching to melee weapon - no ammo!");
				isGoodReason = true;
				scoreMult = scoreMult * ::Const.AI.Behavior.SwitchToOutOfAmmoMult;
			}

			if (this.getAgent().getBehavior(::Const.AI.Behavior.ID.EngageRanged) == null)
			{
				if (this.getStrategy().isDefending() && (this.getStrategy().getStats().EnemyRangedFiring > 0 || this.getStrategy().getStats().AllyRangedFiring > 0))
				{
				}
				else
				{
					local targets = this.queryTargetsInMeleeRange(this.Math.min(mainhandItem.getRangeMin(), _entity.getCurrentProperties().Vision), this.Math.min(mainhandItem.getRangeMax(), _entity.getCurrentProperties().Vision) + myTile.Level, 3);
					local bestTarget = this.queryBestRangedTarget(_entity, null, targets, this.Math.min(mainhandItem.getRangeMax(), _entity.getCurrentProperties().Vision));

					if (bestTarget.Target == null || bestTarget.Score < 0)
					{
						this.logInfo("switching to melee weapon - noone to hit from here!");
						isGoodReason = true;
						scoreMult = scoreMult * ::Const.AI.Behavior.SwitchToEnemyInRangeMult;
					}
				}
			}

			if (!isGoodReason && this.getAgent().getIntentions().IsChangingWeapons)
			{
				return zeroScore;
			}

			if (!isGoodReason)
			{
				local hasReducedRangedEffectiveness = !::World.getTime().IsDaytime && _entity.getCurrentProperties().IsAffectedByNight;
				local targets = this.queryTargetsInMeleeRange(1, hasReducedRangedEffectiveness || !this.isRangedUnit(_entity) ? 1 : 1);

				if (targets.len() == 0)
				{
					return zeroScore;
				}
			}
		}

		local bestWeapon;
		if (mainhandItem != null && mainhandItem.isItemType(::Const.Items.ItemType.MeleeWeapon))
		{
			bestWeapon = mainhandItem;
		}

		foreach (it in items)
		{
			if (!it.isItemType(::Const.Items.ItemType.MeleeWeapon)) continue;

			if (bestWeapon == null || mainhandItem == null && it.getValue() > bestWeapon.getValue() || mainhandItem != null && it.getValue() > bestWeapon.getValue() + 1000)
			{
				bestWeapon = it;
			}
		}

		if (bestWeapon == null || mainhandItem != null && bestWeapon.getID() == mainhandItem.getID())
		{
			return zeroScore;
		}

		local actionPointCost = _entity.getItems().getActionCost([mainhandItem, bestWeapon]);
		if (actionPointCost > _entity.getActionPoints()) return zeroScore;

		this.m.WeaponToEquip = bestWeapon;

		if (mainhandItem == null)
		{
			scoreMult *= ::Const.AI.Behavior.SwitchToCurrentlyUnarmedMult;
		}

		if (!_entity.getCurrentProperties().IsAbleToUseWeaponSkills)
		{
			scoreMult *= ::Const.AI.Behavior.SwitchWeaponBecauseDisarmedMult;
		}

		if (_entity.getSkills().hasSkill("special.night"))
		{
			scoreMult *= ::Const.AI.Behavior.SwitchToMeleeAtNightMult;
		}

		return ::Const.AI.Behavior.Score.SwitchToMelee * scoreMult;
	}

	q.onExecute = @(__original) function( _entity )
	{
		local oldWeaponToEquip = this.m.WeaponToEquip;
		local ret = __original(_entity);

		if (ret && !this.m.IsNegatingDisarm)
		{
			// Feat: we now play a position-based inventory sound when NPCs equip weapons during combat
			oldWeaponToEquip.playInventorySoundWithPosition(::Const.Items.InventoryEventType.Equipped, _entity.getTile());
		}

		return ret;
	}
});
