::Hardened.HooksMod.hook("scripts/skills/effects/rf_decanus_command_effect", function(q) {
// Public
	q.m.HD_ShieldWallAPModifier <- -2;
	q.m.DamageReceivedTotalMult <- 0.85;

// Private
	q.m.HD_AuraSource <- null;
	q.m.HD_SourcePerkID <- "";

	// Overwrite, because we apply different effects from Reforged
	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.m.HD_ShieldWallAPModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::Reforged.Mod.Tooltips.parseString("[$ $|Skill+shieldwall] costs " + ::MSU.Text.colorizeValue(this.m.HD_ShieldWallAPModifier, {AddSign = true, InvertColor = true}) + " [$ $|Concept.ActionPoints]"),
			});
		}

		if (this.m.DamageReceivedTotalMult != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(this.m.DamageReceivedTotalMult, {InvertColor = true}) + " Damage",
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

	q.onUpdate = @(__original) { function onUpdate( _properties )
	{
		__original(_properties);

		if (!this.HD_isSourceValid()) this.removeSelf();

		_properties.DamageReceivedTotalMult *= this.m.DamageReceivedTotalMult;
		_properties.UpdateWhenTileOccupationChanges = true;
	}}.onUpdate;

	// Overwrite, because we replace a costly and hard-coded check
	q.onAfterUpdate = @() { function onAfterUpdate( _properties )
	{
		local shieldwall = this.getContainer().getSkillByID("actives.shieldwall");
		if (shieldwall == null) return;

		shieldwall.m.ActionPointCost = ::Math.max(0, shieldwall.m.ActionPointCost + this.m.HD_ShieldWallAPModifier);
	}}.onAfterUpdate;

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
