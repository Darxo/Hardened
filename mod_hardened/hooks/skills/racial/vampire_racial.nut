::Hardened.HooksMod.hook("scripts/skills/racial/vampire_racial", function(q) {
// Public
	q.m.HD_FireDamageMult <- 1.5;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// Remove the existing tooltips
		::Hardened.util.HD_deleteBulletPoint(ret, function(_entry) {
			if (_entry.id == 10 && _entry.icon == "ui/icons/regular_damage.png") return true;	// Remove the tooltip about life leech as that is now handled by the hd_life_leech_effect
			if (_entry.id == 22 && _entry.icon == "ui/icons/special.png") return true;			// Remove the tooltip about poison immunity
			return false;
		});

		if (this.m.HD_FireDamageMult != 1.0)
		{
			ret.push({
				id = 25,
				type = "text",
				icon = "ui/icons/campfire.png",
				text = ::Reforged.Mod.Tooltips.parseString("Your [$ $|Concept.Hitpoints] take ") + ::MSU.Text.colorizeMultWithText(this.m.FireDamageMult, {InvertColor = true}) + " Fire Damage",
			});
		}

		return ret;
	}

	q.onAdded = @(__original) { function onAdded()
	{
		// We prevent Reforged from granting poison immunity with this racial effect. Vampires are no longer immune to this
		local baseProperties = this.getContainer().getActor().getBaseProperties();
		local oldIsImmuneToPoison = baseProperties.IsImmuneToPoison;
		__original();
		baseProperties.IsImmuneToPoison = oldIsImmuneToPoison;
	}}.onAdded;

	// Overwrite, because we now handle the life leech within the new hd_life_leech_effect effect
	q.onTargetHit = @() function(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor) {}

	q.onBeforeDamageReceived = @(__original) { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		__original(_attacker, _skill, _hitInfo, _properties);

		switch (_hitInfo.DamageType)
		{
			case ::Const.Damage.DamageType.Burning:
				_properties.DamageReceivedRegularMult *= this.m.HD_FireDamageMult;
				break;
		}
	}}.onBeforeDamageReceived;
});
