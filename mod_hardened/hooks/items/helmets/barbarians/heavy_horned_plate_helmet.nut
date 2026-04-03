::Hardened.HooksMod.hook("scripts/items/helmets/barbarians/heavy_horned_plate_helmet", function(q) {
	q.m.HD_ThreatModifier <- 10;	// This much Threat is exerted by the character, while this item is equipped

	q.create = @(__original) function()
	{
		__original();
		this.m.Value = 2500;			// Vanilla: 1300
		this.m.ConditionMax = 250;		// Vanilla: 250
		this.m.StaminaModifier = -23;	// Vanilla: -23
		this.m.Vision = -3;				// Vanilla: -3
	}

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		local threatModifier = this.HD_getThreatModifier();
		if (threatModifier != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/kills.png",
				text = ::MSU.Text.colorizeValue(threatModifier, {AddSign = true}) + ::Reforged.Mod.Tooltips.parseString(" [Threat|Concept.Threat]"),
			});
		}

		return ret;
	}

	q.onUpdateProperties = @(__original) function( _properties )
	{
		__original(_properties);
		_properties.Threat += this.HD_getThreatModifier();
	}

// New Functions
	q.HD_getThreatModifier <- function()
	{
		if (this.getCondition() == 0) return 0;

		// Some effects might set the armor to 0 despite the helmet not having 0 condition left. E.g. hd_headless_effect
		if (this.isEquipped())
		{
			local actor = this.getContainer().getActor();
			if (!::MSU.isNull(actor) && actor.getArmor(::Const.BodyPart.Head) == 0)
			{
				return 0;
			}
		}

		return this.m.HD_ThreatModifier;
	}
});
