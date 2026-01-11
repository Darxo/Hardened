::Hardened.HooksMod.hook("scripts/items/weapons/weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();

		// Hardened values
		this.m.HD_ConditionValueThreshold = 0.5;	// Condition now only scales the price of this down to 50% of its normal value
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (entry in ret)
		{
			if (entry.id == 64 && entry.icon == "ui/icons/direct_damage.png")
			{
				// Improve wording and add Hyperlink for Armor Penetration
				entry.text = ::MSU.String.replace(entry.text, "of damage ignores armor", ::Reforged.Mod.Tooltips.parseString("[Armor Penetration|Concept.ArmorPenetration]"));
			}
			else if (entry.id == 10 && entry.icon == "ui/icons/ammo.png")
			{
				// Vanilla does not show the maximum ammunition. We now also color the remaining ammunition in the negative color if it is 0
				entry.text = "Remaining Ammo: " + ::MSU.Text.colorizeValue(this.getAmmo(), {CompareTo = 1}) + " / " + this.getAmmoMax();
			}
			else if (entry.id == 5 && entry.icon == "ui/icons/armor_damage.png")
			{
				// Improve wording for Armor Damage
				entry.text = ::MSU.String.replace(entry.text, "effective against armor", "Armor Damage");

				// Vanilla Fix: Improve accuracy of shown values by removing rounding and flooring
				entry.text = entry.text.slice(entry.text.find("%[/color]") + 9, entry.text.len());	// Remove the vanilla damage number representation at the start
				entry.text = ::MSU.Text.colorizePct(this.m.ArmorDamageMult, {InvertColor = true}) + entry.text;
			}
			else if (entry.id == 8 && entry.icon == "ui/icons/fatigue.png" && entry.text.find("Weapon skills build up") != null)
			{
				// Vanilla: Weapon skills build up +-X more/less fatigue
				// We shorten the tooltip a bit and add a hyperlink
				entry.text = "Weapon Skills cost " + ::MSU.Text.colorizeValue(this.m.FatigueOnSkillUse, {AddSign = true, InvertColor = true}) + ::Reforged.Mod.Tooltips.parseString(" [Fatigue|Concept.Fatigue]");
			}
			else if (entry.id == 20 && entry.icon == "ui/icons/rf_reach.png")
			{
				entry.text = ::Reforged.Mod.Tooltips.parseString("[Reach|Concept.Reach]: ") + this.m.Reach;
			}
		}

		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];
			// We delete the Reforged entry about "Applicable masteries" as that whole system is no longer relevant under Hardened
			if (entry.id == 20 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);
			}
			// We delete the Reforged entry about "Free Dagger Swaps" as that whole system is no longer relevant under Hardened
			if (entry.id == 30 && entry.icon == "ui/icons/special.png")
			{
				ret.remove(index);
			}
		}

		return ret;
	}

	q.onDamageDealt = @(__original) function( _target, _skill, _hitInfo )
	{
		// We switcheroo the lowerCondition function so that the Vanilla call will not cause it to trigger
		local oldLowerCondition = this.lowerCondition;
		this.lowerCondition = function() {};
		__original(_target, _skill, _hitInfo);
		this.lowerCondition = oldLowerCondition;

		// Feat: We completely rework the vanilla weapon damage calculation.
		// We remove the following vanilla conditions:
		// - Targeted Armor must have at least 50 maximum armor
		// - Attack must deal at least 5 Armor Damage
		// - Weapon must have at least 2 maximum condition
		// And we add the following new conditions:
		// - Targeted Armor must have at least 1 Condition after the hit

		if (_skill.isRanged()) return;
		if (this.getConditionMax() == 1) return;	// 1 is the default value for weapons and is considered as a weapon ignoring condition completely and being indestructable
		if (!::MSU.isEqual(_skill.getItem(), this)) return;

		if (_skill.getDirectDamage() == 1.0) return;	// e.g. puncture

		local actor = this.getContainer().getActor();
		if (::MSU.isNull(actor)) return;
		if (!actor.isPlayerControlled()) return;	// NPC weapons don't lose condition
		if (_target.getArmor(_hitInfo.BodyPart) <= 0) return;	// The targeted Armor must have at least 1 Condition left after the attack

		this.lowerCondition();
	}

	q.onPutIntoBag = @(__original) function()
	{
		__original();
		// Feat: Weapons in the bag slots of NPCs now also start the combat damaged
		// This is exactly the same as how Vanilla does it during onEquip
		if (this.m.Condition == this.m.ConditionMax && !::MSU.isKindOf(this.getContainer().getActor(), "player"))
		{
			this.m.Condition = ::Math.rand(1, ::Math.max(1, this.m.ConditionMax - 2)) * 1.0;
		}
	}

	q.consumeAmmo = @(__original) function()
	{
		__original();

		local actor = this.getContainer().getActor();
		if (this.getAmmo() == 0 && actor.isPlayerControlled() && actor.isPlacedOnMap())
		{
			local tile = actor.getTile();
			if (tile.IsVisibleForPlayer)
			{
				::Tactical.spawnIconEffect("status_effect_63", tile, ::Const.Tactical.Settings.SkillIconOffsetX, ::Const.Tactical.Settings.SkillIconOffsetY, ::Const.Tactical.Settings.SkillIconScale, ::Const.Tactical.Settings.SkillIconFadeInDuration, ::Const.Tactical.Settings.SkillIconStayDuration, ::Const.Tactical.Settings.SkillIconFadeOutDuration, ::Const.Tactical.Settings.SkillIconMovement);
			}
		}
	}

	q.lowerCondition = @(__original) function( _value = ::Const.Combat.WeaponDurabilityLossOnHit )
	{
		// We only drop the weapon when it has 0 condition BEFORE the condition loss
		local actor = this.getContainer().getActor();
		if (this.m.Condition == 0)
		{
			if (!actor.isHiddenToPlayer())
			{
				::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + "\'s " + this.getName() + " has broken!");
				::Tactical.spawnIconEffect("status_effect_36", actor.getTile(), ::Const.Tactical.Settings.SkillIconOffsetX, ::Const.Tactical.Settings.SkillIconOffsetY, ::Const.Tactical.Settings.SkillIconScale, ::Const.Tactical.Settings.SkillIconFadeInDuration, ::Const.Tactical.Settings.SkillIconStayDuration,::Const.Tactical.Settings.SkillIconFadeOutDuration, ::Const.Tactical.Settings.SkillIconMovement);
				::Sound.play(this.m.BreakingSound, 1.0, actor.getPos());
			}

			::Time.scheduleEvent(::TimeUnit.Virtual, 150, this.onDelayedRemoveSelf, null);	// In Vanilla this delay is 300. I find it a bit too long
		}

		// We mock the next isHiddenToPlayer call to return true, so that the vanilla weapon break/drop mechanic is skipped
		local mockObject = ::Hardened.mockFunction(actor, "isHiddenToPlayer", function() {
			return { done = true, value = true };
		});

		__original(_value);

		mockObject.cleanup();
	}
});

::Hardened.HooksMod.hookTree("scripts/items/weapons/weapon", function(q) {
	q.create = @(__original) function()
	{
		__original();

		if (this.isWeaponType(::Const.Items.WeaponType.Crossbow))
		{
			// All Crossbows now have +10% Armor Penetration as a result of the Crossbow Rework
			this.m.DirectDamageAdd += 0.1;
		}
		else if (this.isWeaponType(::Const.Items.WeaponType.Bow))
		{
			// All Bows now have -5% Armor Penetration to solidify their role as anti-low-armor
			// We subtract a tiny extra bit less to fix float rounding errors that would manifest in off-by-one values in weapon and skill tooltips
			this.m.DirectDamageAdd -= 0.0499;
		}
	}

	q.onEquip = @(__original) function()
	{
		if (!("IsLoaded" in this)) return __original();

		local oldIsLoaded = this.m.IsLoaded;
		if (_item.isWeaponType(::Const.Items.WeaponType.Crossbow) || _item.isWeaponType(::Const.Items.WeaponType.Firearm))
		{
			// Setting this to true prevents Vanilla and any mod from adding an additional redundant reload_bolt skill to this actor
			this.m.IsLoaded = true;
		}

		__original();

		this.m.IsLoaded = oldIsLoaded;
	}
});
