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

	q.onAfterUpdate = @(__original) function( _properties )
	{
		__original(_properties);

		if (this.getContainer().getActor().getCurrentProperties().IsStunned && !_properties.IsStunned)
		{
			// This perk triggers its immunity, whenever our actor loses stunned
			// We do that by checking whether our previous character properties determined us being stunned, but the new properties have us no longer stunned
			this.triggerStunImmunity();
		}
	}

	q.onTurnStart = @(__original) { function onTurnStart()
	{
		__original();
		this.m.HD_IsActive = false;
	}}.onTurnStart;

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
