::Hardened.HooksMod.hook("scripts/skills/effects/chilled_effect", function(q) {
	q.m.HD_LastsForTurns = 2;	// Just so that this effect looks correct when viewed in tooltips

// Public
	q.m.DamageTotalPctPerStack <- -0.1;
	q.m.ActionPointsPerStack <- -1;
	q.m.StartingTurnsLeft <- 2;

	q.create = @(__original) function()
	{
		__original();

		this.m.Description = "This character has been chilled to the bone by cold. With their limbs frozen stiff, it takes a great deal of effort to move in a coordinated fashion.";
	}

	q.getName = @(__original) function()
	{
		return __original() + " (x" + this.m.HD_LastsForTurns + ")";
	}

	q.getDescription = @() function()
	{
		return this.skill.getDescription();
	}

	// Overwrite, because we replace the vanilla tooltips with our own ones
	q.getTooltip = @() function()
	{
		local ret = this.skill.getTooltip();

		if (this.getActionPointModifier() != 0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/action_points.png",
				text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.getActionPointModifier(), {AddSign = true}) + " [Action Points|Concept.ActionPoints] (" + ::MSU.Text.colorizeValue(this.m.ActionPointsPerStack, {AddSign = true}) + " per remaining turn)"),
			});
		}

		if (this.getDamageTotalMult() != 1.0)
		{
			ret.push({
				id = 11,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "Deal " + ::MSU.Text.colorizeMultWithText(this.getDamageTotalMult()) + " Damage (" + ::MSU.Text.colorizePct(this.m.DamageTotalPctPerStack) + " per remaining turn)",
			});
		}

		return ret;
	}

	// Overwrite, because we replace the vanilla turn handling and we disable the sprite overlay
	q.onAdded = @() function()
	{
		local actor = this.getContainer().getActor();
		if (actor.getCurrentProperties().HD_ImmuneToChilled)
		{
			this.removeSelf();
			return;
		}

		this.m.HD_LastsForTurns = this.getDefaultTurns();

		// Similar to vanilla, we hijack the "dirt" sprite to display a custom chilled overlay
		if (actor.hasSprite("dirt"))
		{
			local chilled = actor.getSprite("dirt");
			if (!chilled.Visible)
			{
				chilled.setBrush("bust_frozen");
				chilled.Visible = true;
			}
		}

		actor.setDirty(true);
	}

	// Overwrite, because we replace the vanilla effects with our own ones
	q.onUpdate = @() function( _properties )
	{
		_properties.ActionPoints += this.getActionPointModifier();
		_properties.DamageTotalMult *= this.getDamageTotalMult();
	}

	q.onRefresh = @() function()
	{
		local actor = this.getContainer().getActor();
		this.spawnIcon(this.m.Overlay, actor.getTile());
		this.m.HD_LastsForTurns += this.getDefaultTurns();

		// We manually trigger an update(), so that the Action Points are updated immediately
		// Vanilla does not trigger an update() when refreshing a skill
		actor.getSkills().update();
	}

	// Overwrite, because we now handle remaining turns in our own way
	q.onTurnEnd = @() function() {}

// New Functions
	q.getDefaultTurns <- function()
	{
		return ::Math.max(1, this.m.StartingTurnsLeft + this.getContainer().getActor().getCurrentProperties().NegativeStatusEffectDuration);
	}

	q.getActionPointModifier <- function()
	{
		return this.m.ActionPointsPerStack * this.m.HD_LastsForTurns;
	}

	q.getDamageTotalMult <- function()
	{
		return ::Math.maxf(0.0, 1.0 + (this.m.DamageTotalPctPerStack * this.m.HD_LastsForTurns));
	}
});
