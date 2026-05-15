::Hardened.HooksMod.hook("scripts/scenarios/world/cultists_scenario", function(q) {
	q.onGetBackgroundTooltip = @(__original) function( _background, _tooltip )
	{
		__original(_background, _tooltip);
		local actor = _background.getContainer().getActor();
		if (this.HD_isConvertable(actor))
		{
			_tooltip.push({
				id = 20,
				type = "text",
				icon = "ui/icons/unlocked_small.png",
				text = "Can be converted into a Cultist",
			});
		}
		else
		{
			_tooltip.push({
				id = 20,
				type = "text",
				icon = "ui/icons/warning.png",
				text = "Cannot be converted into a Cultist",
			});
		}
	}

// New Functions
	// Determine, whether a passed player can be converted into a cultist during `cultist_origin_vs_uneducated_event`
	// This is a replication of the conditions in that event and must be kept up-to-date should the original conditions ever change
	q.HD_isConvertable <- function( _player )
	{
		if (!(::MSU.isKindOf(_player, "player"))) return false;

		local background = _player.getBackground();
		// We can't convert someone, who was already converted
		if (background.getID() == "background.cultist") return false;
		if (background.getID() == "background.converted_cultist") return false;

		// There are some special exceptions to being converted
		if (_player.getFlags().get("IsSpecial")) return false;
		if (_player.getFlags().get("IsPlayerCharacter")) return false;
		if (background.getID() == "background.slave") return false;

		if (_player.getSkills().hasSkill("injury.brain_damage")) return true;						// Characters with Braindamage can always be converted
		if (background.isLowborn() && !_player.getSkills().hasSkill("trait.bright")) return true;	// A lowborn must not be bright in order to be converted
		if (!background.isNoble() && _player.getSkills().hasSkill("trait.dumb")) return true;		// A non-Noble must be dumb in order to be converted

		return false;
	}
});
