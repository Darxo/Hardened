::Hardened.HooksMod.hook("scripts/skills/actives/drink_antidote_skill", function(q) {
	q.m.CurablePoisonIds <- [	// These skills will be removed, when the antidote is used
		"effects.goblin_poison",
		"effects.spider_poison",
	];

	q.create = @(__original) function()
	{
		__original();
		this.m.Name = "Use Antidote";	// In Vanilla this is "Drink or Give Antidote"
		this.m.Description = "Save yourself or another character from poisons. Can not be used while engaged in melee.";	// We remove any mention of "giving it to allies"
	}

	// Overwrite, because we no longer produce a custom icon for when we highlight an ally
	q.getCursorForTile = @() function( _tile )
	{
		return ::Const.UI.Cursor.Drink;
	}

	// We replace the vanilla function because we replace the "give antidote to ally" part and replace it with a direct administering of it
	q.onUse = @() function( _user, _targetTile )
	{
		local target = _targetTile.getEntity();

		this.spawnIcon("status_effect_97", _targetTile);
		this.curePoisons(target);
		target.getSkills().add(::new("scripts/skills/effects/antidote_effect"));
		if (!::MSU.isNull(this.m.Item))
		{
			this.m.Item.removeSelf();
		}
		// We no longer checkDrugEffect, compared to vanilla

		if (!target.isHiddenToPlayer())
		{
			::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(target) + " drinks Antidote");
		}

		return true;
	}

// New Functions
	// Remove all poison (as defined in CurablePoisonIds) from _target
	q.curePoisons <- function( _target )
	{
		foreach (poisonId in this.m.CurablePoisonIds)
		{
			_target.getSkills().removeAllByID(poisonId);
		}
	}
});
