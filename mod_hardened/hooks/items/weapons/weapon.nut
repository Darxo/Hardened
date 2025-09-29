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
		}

		return ret;
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

		// All Crossbows now have +10% Armor Penetration as a result of the Crossbow Rework
		if (this.isWeaponType(::Const.Items.WeaponType.Crossbow))
		{
			this.m.DirectDamageAdd += 0.1;
		}
	}
});
