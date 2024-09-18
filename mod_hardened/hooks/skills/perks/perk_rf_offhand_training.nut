::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_offhand_training", function(q) {
	// Private
	q.m.IsTripArtistSpent <- true;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10)
			{
				if (this.m.IsSpent)
				{
					ret.remove(index);	// Remove the Reforged tooltip, when spent
				}
				else
				{
					entry.text = ::Reforged.Mod.Tooltips.parseString("The next use of your offhand item costs no [Action Points|Concept.ActionPoints]");
					if (!this.isEnabledForFreeUse())
					{
						entry.icon = "ui/icons/warning.png";
						entry.text += ::MSU.Text.colorNegative(" (Requires an offhand item weighing less than " + -this.m.StaminaModifierThreshold + ")");
					}
				}
				break;
			}
		}

		if (!this.m.IsTripArtistSpent)
		{
			if (this.isEnabledForTripArtist())
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/special.png",
					text = ::Reforged.Mod.Tooltips.parseString("The next melee hit against an adjacent target will [stagger|Skill+staggered_effect] them"),
				});
			}
			else
			{
				ret.push({
					id = 11,
					type = "text",
					icon = "ui/icons/warning.png",
					text = ::Reforged.Mod.Tooltips.parseString("The next melee hit against an adjacent target will [stagger|Skill+staggered_effect] them " + ::MSU.Text.colorNegative("(Requires an equipped net)")),
				});
			}
		}

		return ret;
	}

	q.isHidden = @(__original) function()
	{
		return __original() && this.m.IsTripArtistSpent;
	}

	// Overwrite because we no longer add the trip_artist effect
	q.onAdded = @() function()
	{
		this.getContainer().removeByID("effects.rf_trip_artist");	// We delete this here, because this effect is serialized. Even if we don't add it outselves, it will be there because of Reforged
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor );

		if (this.m.IsTripArtistSpent || !_skill.isAttack() || _skill.isRanged() || !_targetEntity.isAlive() || _targetEntity.getTile().getDistanceTo(this.getContainer().getActor().getTile()) > 1 || !this.isEnabledForTripArtist())
			return;

		this.m.IsTripArtistSpent = true;

		_targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
		::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " has staggered " + ::Const.UI.getColorizedEntityName(_targetEntity));
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsTripArtistSpent = false;	// enable TripArtist each turn
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsTripArtistSpent = false;
	}

// New Functions
	q.isEnabledForTripArtist <- function()
	{
		// Ensure that the actor has an offhand item with the throw_net skill
		local offhandItem = this.getContainer().getActor().getOffhandItem();
		if (offhandItem == null)
			return false;

		foreach (skill in offhandItem.getSkills())
		{
			if (skill.getID() == "actives.throw_net" && !skill.isHidden())
				return true;
		}

		return false;
	}

	q.isEnabledForFreeUse <- function()
	{
		// Ensure that the actor has an offhand item with the throw_net skill
		local offhandItem = this.getContainer().getActor().getOffhandItem();
		return (offhandItem != null && offhandItem.getStaminaModifier() > this.m.StaminaModifierThreshold)
	}
});
