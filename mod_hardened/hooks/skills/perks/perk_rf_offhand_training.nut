::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_offhand_training", function(q) {
	// Public
	q.m.ActionPointModifier <- -1;	// Tool skill AP Cost is reduced by this

	// Private
	q.m.IsStaggerSpent <- true;

	q.create = @(__original) function()
	{
		__original();
		this.m.Order = ::Const.SkillOrder.Perk;		// A order sooner than Any is mandatory in order to correctly influence DoubleGrips effect
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		foreach (index, entry in ret)
		{
			if (entry.id == 10)
			{
				ret.remove(index);	// Remove the mention of the now removed free offhand use effect
				break;
			}
		}

		if (!this.m.IsStaggerSpent)
		{
			local tooltip = {
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Your next hit will [stagger|Skill+staggered_effect] your target"),
			}

			if (!this.isEnabledForStagger())
			{
				tooltip.icon = "ui/icons/warning.png";
				tooltip.text += ::MSU.Text.colorNegative(" (Requires a tool in your offhand)");
			}

			ret.push(tooltip);
		}

		return ret;
	}

	q.isHidden = @() function()
	{
		return this.m.IsStaggerSpent;
	}

	// Overwrite because we no longer add the trip_artist effect
	q.onAdded = @() function()
	{
		this.getContainer().removeByID("effects.rf_trip_artist");	// We delete this here, because this effect is serialized. Even if we don't add it outselves, it will be there because of Reforged
	}

	q.onUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		// If we notice that the actor holds a one-handed double grippable weapon and an offhand tool, we force-enable Double Grip on them
		local actor = this.getContainer().getActor();
		local doubleGripSkill = actor.getSkills().getSkillByID("special.double_grip");
		if (doubleGripSkill != null)
		{
			local main = actor.getItems().getItemAtSlot(::Const.ItemSlot.Mainhand);
			if (main != null && main.isDoubleGrippable())
			{
				local off = actor.getItems().getItemAtSlot(::Const.ItemSlot.Offhand);
				if (off != null && off.isItemType(::Const.Items.ItemType.Tool))
				{
					doubleGripSkill.m.HD_ForceActive = true;	// For this update cycle, the Double Grip will always be active (unless actor is disarmed)
				}
			}
		}
	}

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		foreach (skill in this.getContainer().m.Skills)
		{
			if (this.isSkillValid(skill))
			{
				skill.m.ActionPointCost = ::Math.max(0, skill.m.ActionPointCost + this.m.ActionPointModifier);
			}
		}
	}

	q.onTargetHit = @(__original) function( _skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor )
	{
		__original(_skill, _targetEntity, _bodyPart, _damageInflictedHitpoints, _damageInflictedArmor);

		if (_targetEntity.isAlive() && !_targetEntity.isDying() && this.isEnabledForStagger() && _skill.isAttack())
		{
			this.m.IsStaggerSpent = true;
			_targetEntity.getSkills().add(::new("scripts/skills/effects/staggered_effect"));
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(this.getContainer().getActor()) + " has staggered " + ::Const.UI.getColorizedEntityName(_targetEntity));
		}
	}

	q.onTurnStart = @(__original) function()
	{
		__original();
		this.m.IsStaggerSpent = false;	// enable stagger each turn
		this.m.IsSpent = true;	// We always set IsSpent on true to permanently disable the free offhand use part
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.m.IsStaggerSpent = false;
	}

// New Functions
	// Returns true, if this character can theoretically still stagger
	q.isEnabledForStagger <- function()
	{
		if (this.m.IsStaggerSpent) return;

		// Ensure that the actor has an offhand tool
		local offhandItem = this.getContainer().getActor().getOffhandItem();
		if (offhandItem == null) return false;
		if (!offhandItem.isItemType(::Const.Items.ItemType.Tool)) return false;

		return true;
	}

	// @return true if _skill is valid for the Action Point discount
	q.isSkillValid <- function( _skill )
	{
		local item = _skill.getItem();
		return (!::MSU.isNull(item) && item.isItemType(::Const.Items.ItemType.Tool))
	}

	q.isEnabledForFreeUse <- function()
	{
		// Ensure that the actor has an offhand item with the throw_net skill
		local offhandItem = this.getContainer().getActor().getOffhandItem();
		return (offhandItem != null && offhandItem.getStaminaModifier() > this.m.StaminaModifierThreshold)
	}
});
