::Hardened.HooksMod.hook("scripts/skills/perks/perk_hold_out", function(q) {	// Resilient
	// Public
	q.m.HD_NegativeStatusEffectDuration <- -1;	// Vanilla: -5

	// Private
	q.m.HD_IsActive <- false;	// If true, we will be immune to stuns

	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "Keep it together!";
		this.m.IconMini = "hd_resilient_effect_mini";
		this.m.Overlay = "hd_resilient_effect";

		this.addType(::Const.SkillType.StatusEffect);	// We add StatusEffect so that this perk can produce a status effect icon
	}

	q.isHidden = @() function()
	{
		return !this.m.HD_IsActive;
	}

	q.getTooltip = @(__original) { function getTooltip()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Immune to being [$ $|Skill+stunned_effect]"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
		});

		return ret;
	}}.getTooltip;

	// Overwrite, because we change the vanilla effect and disable the Reforged effect
	q.onUpdate = @() { function onUpdate( _properties )
	{
		_properties.NegativeStatusEffectDuration += this.m.HD_NegativeStatusEffectDuration;

		if (this.m.HD_IsActive)
		{
			_properties.IsImmuneToStun = true;
		}
	}}.onUpdate;

	q.onTurnStart = @(__original) { function onTurnStart()
	{
		__original();
		this.m.HD_IsActive = false;
	}}.onTurnStart;

	q.onTurnEnd = @(__original) { function onTurnEnd()
	{
		__original();

		// This perk triggers its immunity, whenever our actor loses stunned
		// Since the only source of stunned is the stunned_effect, we can just look for that one
		// There is no onSkillRemoved event yet, so instead we check for the existance of that effect and how many turns it has left
		// Depending on timing, isGarbage of the stunned_effect might already be set. So we need to iterate over .m.Skills directly
		foreach (skill in this.getContainer().getActor().getSkills().m.Skills)
		{
			if (skill.getID() != "effects.stunned") continue;
			if (skill.m.TurnsLeft != 1) continue;	// Our SkillOrder is lower than that of the stunned effect, so our onTurnEnd triggers sooner, so we check for TurnsLeft being equal to 1

			this.triggerStunImmunity();
		}
	}}.onTurnEnd;

	q.onCombatFinished = @(__original) { function onCombatFinished()
	{
		__original();
		this.m.HD_IsActive = false;
	}}.onCombatFinished;

// New Functions
	q.triggerStunImmunity <- function()
	{
		this.m.HD_IsActive = true;

		local actor = this.getContainer().getActor();
		this.spawnIcon(this.m.Overlay, actor.getTile());

		actor.setDirty(true);
	}
});
