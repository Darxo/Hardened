::Hardened.HooksMod.hook("scripts/items/helmets/decayed_great_helm", function(q) {
	q.m.HD_ThreatModifier <- 5;	// This much Threat is exerted by the character, while this item is equipped
	q.m.HD_Variants <- [	// Array of subset of the original vanilla artwork that we deem fitting for this helmet
		12,
		13,
	];

	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Tarnished Full Helm";	// In Vanilla this is "Decayed Great Helm"
		this.m.Description = "A full helm dulled by age and wear, its once-proud ornamentation now twisted and corroded. It must have once belonged to a renowned knight.";
		this.m.Condition = 240;		// In Vanilla this is 255
		this.m.StaminaModifier = -23; 	// In Vanilla this is -22

		if (this.m.Variant == 11 || this.m.Variant == 14)	// We replace vanilla artwork, that does not actually resemble a full helm
		{
			this.m.Variant = ::MSU.Array.rand(this.m.HD_Variants);
			this.updateVariant();
		}
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
				text = "Adjacent enemies have " + ::MSU.Text.colorizeValue(-1 * threatModifier, {AddSign = true}) + " Resolve during Morale Checks",
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
