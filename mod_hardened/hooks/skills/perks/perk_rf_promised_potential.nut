::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_promised_potential", function(q) {
// Public
	q.m.HD_AdditionalLevelsRequired <- 4;

// Private
	q.m.HD_StaringLevelTag <- "HD_PromisedPotential_StartingLevel";

	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "The Captain said he\'d take a gamble on you, but you\'d better not disappoint!";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.IsHidden = false;
		this.m.IsRefundable = true;		// Reforged: false
	}

	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Transform into [$ $|Perk+perk_rf_realized_potential] when you reach [Level|Concept.Level] " + ::MSU.Text.colorPositive(this.HD_getTargetedLevel())),
		});

		return ret;
	}

	q.onAdded = @() function()
	{
		if (this.m.IsNew)
		{
			local actor = this.getContainer().getActor();
			actor.getFlags().add("HD_PromisedPotential_StartingLevel", actor.getLevel());
		}
	}

	// Overwrite, because we replace the Reforged effect of this perk with our own logic
	q.onUpdateLevel = @() function()
	{
		if (this.HD_isTriggering())
		{
			this.HD_onSucceed();
		}
	}

// New Functions
	q.HD_isTriggering <- function()
	{
		return this.getContainer().getActor().getLevel() >= this.HD_getTargetedLevel();
	}

	q.HD_getTargetedLevel <- function()
	{
		return this.getContainer().getActor().getFlags().getAsInt("HD_PromisedPotential_StartingLevel") + this.m.HD_AdditionalLevelsRequired;
	}

	q.HD_onSucceed <- function()
	{
		local actor = this.getContainer().getActor();
		local perkTree = actor.getPerkTree();

		this.removeSelf();
		perkTree.removePerk(this.getID());

		perkTree.addPerk("perk.rf_realized_potential", 1);
		this.getContainer().add(::new("scripts/skills/perks/perk_rf_realized_potential"));
	}
});
