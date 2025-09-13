::Hardened.HooksMod.hook("scripts/skills/racial/golem_racial", function(q) {
	// Public
	q.m.PiercingDamageMult <- 0.50;
	q.m.FireDamageMult <- 0.0;		// Since this character is immune to burning
	q.m.InitiativeBonusPerAdjacentAlly <- 5;	// Gain this much Initiative per adjacent ally

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		// We delete the additional, no longer needed damage reduction entries
		for (local index = (ret.len() - 1); index >= 0; index--)
		{
			local entry = ret[index];
			if (entry.id == 11 && entry.icon == "ui/icons/ranged_defense.png")
			{
				ret.remove(index);
			}
			else if (entry.id == 12 && entry.icon == "ui/icons/campfire.png")
			{
				ret.remove(index);
			}
		}

		// Adjust the one remaining damage reduction tooltip according to our standardized reduction
		foreach (entry in ret)
		{
			if (entry.id == 10 && entry.icon == "ui/icons/melee_defense.png")
			{
				entry.text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.PiercingDamageMult, {InvertColor = true}) + " Piercing Damage";
			}
		}

		local initiativeModifier = this.getInitiativeBonus();
		if (initiativeModifier != 0)
		{
			ret.push({
				id = 13,
				type = "text",
				icon = "ui/icons/initiative.png",
				text = ::MSU.Text.colorizeValue(initiativeModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Initiative|Concept.Initiative] (" + ::MSU.Text.colorizeValue(this.m.InitiativeBonusPerAdjacentAlly, {AddSign = true}) + " for each adjacent ally)"),
			});
		}

		return ret;
	}

	// Overwrite, because we completely change the damage reductions chosen by Reforged
	q.onBeforeDamageReceived = @() { function onBeforeDamageReceived( _attacker, _skill, _hitInfo, _properties )
	{
		// Same as Vanilla/Reforged
		if (_skill != null && _skill.getID() == "actives.throw_golem")
		{
			_properties.DamageReceivedTotalMult = 0.0;
			return;
		}

		// We remove Reforged blunt reduction and combine the verbose piercing reduction
		switch (_hitInfo.DamageType)
		{
			case null:
				break;

			case ::Const.Damage.DamageType.Burning:
				_properties.DamageReceivedTotalMult *= this.m.FireDamageMult;
				break;

			case ::Const.Damage.DamageType.Piercing:
			_properties.DamageReceivedTotalMult *= this.m.PiercingDamageMult;
				break;
		}
	}}.onBeforeDamageReceived;

	// Overwrite, because so many vanilla effects are removed as they are now handled via setting base stats during transformations
	q.onUpdate = @() function( _properties )
	{
		_properties.Initiative += this.getInitiativeBonus();
	}

// New Functions
	q.getInitiativeBonus <- function()
	{
		local actor = this.getContainer().getActor();
		return this.m.InitiativeBonusPerAdjacentAlly * ::Tactical.Entities.getAlliedActors(actor.getFaction(), actor.getTile(), 1, true).len();
	}
});
