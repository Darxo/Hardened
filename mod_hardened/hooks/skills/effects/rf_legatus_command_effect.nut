::Hardened.HooksMod.hook("scripts/skills/effects/rf_legatus_command_effect", function(q) {
// Public
	q.m.HD_ThreadModifier <- 5;

// Private
	q.m.HD_AuraSource <- null;
	q.m.HD_SourcePerkID <- "";

	// Overwrite, because we apply different effects from Reforged
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.DamageMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "Deal " + ::MSU.Text.colorizeMultWithText(this.m.DamageMult) + " Damage",
			});
		}

		if (this.m.HD_ThreadModifier != 0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/kills.png",
				text = ::MSU.Text.colorizeValue(this.m.HD_ThreadModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [$ $|Concept.Threat]"),
			});
		}

		if (!::MSU.isNull(this.m.HD_AuraSource))
		{
			ret.push({
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("Provided by " + ::Reforged.NestedTooltips.getNestedEntityName(this.m.HD_AuraSource)),
			});
		}

		return ret;
	}}.getTooltip;

	// Overwrite, because we replace a costly and hard-coded check
	q.onUpdate = @() { function onUpdate( _properties )
	{
		if (!this.HD_isSourceValid()) this.removeSelf();

		_properties.DamageTotalMult *= this.m.DamageMult;
		_properties.Threat += this.m.HD_ThreadModifier;
		_properties.UpdateWhenTileOccupationChanges = true;
	}}.onUpdate;

// New Functions
	// Is the source of the aura still providing it to us?
	q.HD_isSourceValid <- function()
	{
		local sourcePerk = this.HD_getSourcePerk();
		if (sourcePerk == null) return false;

		if (!sourcePerk.HD_isEnabled()) return false;

		local actor = this.getContainer().getActor();
		if (!sourcePerk.HD_isTargetValid(actor)) return false;

		return true;
	}

	q.HD_getSourcePerk <- function()
	{
		if (::MSU.isNull(this.m.HD_AuraSource)) return null;
		if (!this.m.HD_AuraSource.isAlive()) return null;

		return this.m.HD_AuraSource.getSkills().getSkillByID(this.m.HD_SourcePerkID);
	}

	// This effect might be removed when its source is gone, but another source might still be nearby
	// In such a case we briefly lose this effect and only regain it, once an update is called on that other source. e.g. when anyone moves
	// Todo: find solution to this
});
