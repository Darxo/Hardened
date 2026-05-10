::Hardened.HooksMod.hook("scripts/skills/traits/impatient_trait", function(q) {
	q.m.InitiativeForTurnOrderAdditional = 0;	// Reforged: 20

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Using [Wait|Concept.Wait] delays your [turn|Concept.Turn] by 6 [turns|Concept.Turn] instead of until the end of the current [round|Concept.Round]"),
		});

		return ret;
	}}.getTooltip;

	q.onWaitTurn = @(__original) function()
	{
		__original();

		// We were only pushed back at most 6 positions. We don't need to do anything
		if (::Tactical.TurnSequenceBar.m.CurrentEntities.len() <= ::Tactical.TurnSequenceBar.m.MaxVisibleEntities)
		{
			return;
		}

		::Tactical.TurnSequenceBar.m.CurrentEntities.pop();
		local actor = this.getContainer().getActor();
		::Tactical.TurnSequenceBar.m.CurrentEntities.insert(::Tactical.TurnSequenceBar.m.MaxVisibleEntities - 1, actor);

		local entityToAddIndex = ::Math.min(::Tactical.TurnSequenceBar.m.CurrentEntities.len() - 1, ::Tactical.TurnSequenceBar.m.MaxVisibleEntities - 1);
		local mockObject;
		mockObject = ::Hardened.mockFunction(::Tactical.TurnSequenceBar, "convertEntityToUIData", function( _entity, _isLastEntity = false ) {
			if (_entity.getID() == actor.getID())
			{
				return { done = true, value = mockObject.original(actor, true) };
			}
		});
		// We have no chance to manually clean up from inside this skill
		// But we don't need to clean up, because "convertEntityToUIData" is guaranteed to run, directly after the onWaitTurn event triggers and then the mockObject cleans up itself
	}

	// Overwrite, because we want to disable both the Vanilla and Reforged effects
	q.onUpdate = @() function( _properties ) {}
});
