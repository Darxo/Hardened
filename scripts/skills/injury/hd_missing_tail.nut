this.hd_missing_tail <- ::inherit("scripts/skills/injury/injury", {
	m = {
		MoraleChangeOnAdd = -1,
	},
	function create()
	{
		this.injury.create();
		this.m.ID = "injury.hd_missing_tail";
		this.m.Name = "Missing Tail";
		this.m.Description = "A missing tail prevents this character from using tail attack.";
		this.m.Icon = "ui/injury/injury_permanent_icon_07.png";
		this.addType(::Const.SkillType.TemporaryInjury);
	}

	function onAdded()
	{
		local actor = this.getContainer().getActor();

		local oldMoraleState = actor.getMoraleState();
		actor.setMoraleState(::Math.max(::Const.MoraleState.Fleeing, oldMoraleState + this.m.MoraleChangeOnAdd));
		if (oldMoraleState != actor.getMoraleState())
		{
			// We manually produce a log for the change of the morale state, as that does not happen automatically when calling setMoraleState
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + ::Const.MoraleStateEvent[actor.getMoraleState()]);
		}
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/morale.png",
			text = ::Reforged.Mod.Tooltips.parseString("When received, lower your [Morale State|Concept.Morale] by " + ::MSU.Text.colorizeValue(this.m.MoraleChangeOnAdd)),
		});

		return ret;
	}
});
