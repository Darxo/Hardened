::Hardened.HooksMod.hook("scripts/skills/actives/drums_of_war_skill", function(q) {
	q.m.HD_InitiativeAsFatiguePct <- 0.05;
	q.m.HD_AdditionalFatigueReceovery <- 0;
	q.m.HD_Radius <- 5;
	q.m.HD_RemoveDazed <- false;

	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "The steady beat of war drums carries across the battlefield, stirring the blood of those who hear it.";
		this.m.FatigueCost = 30;	// Vanilla: 15
		this.m.HD_UsableWhileEngagedInMelee = false;
	}

	// Vanilla doesn't have a getTooltip function defined for this skill
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		local exactFatigueRecovery = "";
		if (this.getContainer().getActor().getID() != ::MSU.getDummyPlayer().getID())
		{
			exactFatigueRecovery = " (" + ::MSU.Text.colorizeValue(this.HD_getFatigueRecoveryFromInitiative()) + ")";
		}
		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/fatigue.png",
			text = ::Reforged.Mod.Tooltips.parseString("Cause all allies from your company within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles to recover [Fatigue|Concept.Fatigue] equal to " + ::MSU.Text.colorizePct(this.m.HD_InitiativeAsFatiguePct) + exactFatigueRecovery + " of your [$ $|Concept.Initiative]"),
		});

		if (this.m.HD_AdditionalFatigueReceovery > 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/fatigue.png",
				text = ::Reforged.Mod.Tooltips.parseString("Cause all allies from your company within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles to recover " + ::MSU.Text.colorizeValue(this.m.HD_AdditionalFatigueReceovery) + " [Fatigue|Concept.Fatigue]"),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Remove [$ $|Skill+sleeping_effect] from all allies within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles"),
		});

		if (this.m.HD_RemoveDazed)
		{
			ret.push({
				id = 12,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Remove [$ $|Skill+dazed_effect] from all allies from your faction within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles"),
			});
		}
		return ret;
	}}.getTooltip;

	// Overwrite because we completely rework the vanilla skill
	q.onUse = @() { function onUse( _user, _targetTile )
	{
		local fatigueToRecover = this.HD_getFatigueRecovery();
		foreach (actor in this.HD_getAlliesInRange())
		{
			local playAnimation = false;

			if (actor.getSkills().hasSkill("effects.sleeping"))
			{
				actor.getSkills().removeByID("effects.sleeping");
				playAnimation = true;
			}

			if (_user.getFaction() == actor.getFaction())
			{
				local recoveredFatigue = actor.HD_recoverFatigue(fatigueToRecover);
				if (recoveredFatigue > 0) playAnimation = true;
			}

			if (this.m.HD_RemoveDazed && actor.getSkills().hasSkill("effects.dazed"))
			{
				actor.getSkills().removeByID("effects.dazed");
				playAnimation = true;
			}

			if (playAnimation && !actor.isHiddenToPlayer())
			{
				this.spawnIcon("status_effect_105", actor.getTile());
			}
		}

		return true;
	}}.onUse;

// MSU Functions
	q.softReset = @(__original) function()
	{
		__original();
		this.resetField("HD_AdditionalFatigueReceovery");
		this.resetField("HD_Radius");
		this.resetField("HD_RemoveDazed");
	}

// New Functions
	q.HD_getFatigueRecovery <- function()
	{
		return this.HD_getFatigueRecoveryFromInitiative() + this.m.HD_AdditionalFatigueReceovery;
	}

	q.HD_getFatigueRecoveryFromInitiative <- function()
	{
		local fatigueRecovery = this.getContainer().getActor().getInitiative() * this.m.HD_InitiativeAsFatiguePct;
		return ::Math.max(0, fatigueRecovery);
	}

	q.HD_getAlliesInRange <- function()
	{
		local targets = [];

		local user = this.getContainer().getActor();
		local myTile = user.getTile();
		foreach (actor in ::Tactical.Entities.getAllInstancesAsArray())
		{
			if (actor.getID() == user.getID()) continue;
			if (actor.getTile().getDistanceTo(myTile) > this.m.HD_Radius) continue;
			if (!actor.isAlliedWith(user)) continue;
			targets.push(actor);
		}

		return targets;
	}
});
