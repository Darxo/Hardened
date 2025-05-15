::Hardened.wipeClass("scripts/skills/perks/perk_rf_kingfisher", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_rf_kingfisher", function(q) {
	// Public
	q.m.ReachModifier <- 2;
	q.m.TargetAttractionMult <- 1.1;	// We are this much more "attractive" as a target, while we are netting someone

	// Private
	q.m.SoundOnBreakFree <- [
		"sounds/combat/break_free_net_01.wav",
		"sounds/combat/break_free_net_02.wav",
		"sounds/combat/break_free_net_03.wav",
	];
	q.m.IsNetLocked <- false;
	q.m.ConnectedNetEffect <- null;
	q.m.Temp_NetItemScript <- "";	// Script name for the replacement net. This doubles as a "flag" so we know, when this perk potentially got triggered

	q.onUpdate <- function( _properties )
	{
		if (this.isEnabled())
		{
			_properties.Reach += this.m.ReachModifier;

			local net = this.getContainer().getActor().getOffhandItem();
			local isNetLocked = this.checkLocked();
			net.m.IsChangeableInBattle = !isNetLocked;	// Prevent the user from switching away from the net if the net is currently locked
			if (isNetLocked)
			{
				_properties.TargetAttractionMult *= this.m.TargetAttractionMult;
				foreach (skill in net.m.SkillPtrs)
				{
					skill.m.IsUsable = false;	// The net can't be used, while it is locked
				}
			}
		}
	}

	q.onCombatFinished = @(__original) function()
	{
		__original();
		this.setNetLocked(false);
	}

// MSU Events
q.onQueryTooltip <- function( _skill, _tooltip )
{
	if (this.checkLocked() && !::MSU.isNull(_skill.getItem()) && _skill.getItem().getID() == this.getContainer().getActor().getOffhandItem().getID())
	{
		_tooltip.push({
			id = 100,
			type = "text",
			icon = "ui/icons/warning.png",
			text = ::Reforged.Mod.Tooltips.parseString("Cannot be used because of " + ::Reforged.NestedTooltips.getNestedSkillName(this)),
		});
	}
}

// Hardened Events
	q.onReallyBeforeSkillExecuted <- function( _skill, _targetTile )
	{
		this.m.Temp_NetItemScript = "";

		// If the the target had a net effect already before, we do nothing
		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;
		if (_targetTile.getEntity().getSkills().getSkillByID("effects.net") != null) return;

		local actor = this.getContainer().getActor();
		if (actor.isPlacedOnMap() && actor.getTile().getDistanceTo(_targetTile) > 1) return;	// This perk only works for adjacent targets

		this.m.Temp_NetItemScript = ::IO.scriptFilenameByHash(actor.getOffhandItem().ClassNameHash);
	}

	q.onReallyAfterSkillExecuted <- function( _skill, _targetTile, _success )
	{
		if (this.m.Temp_NetItemScript == "") return;
		if (!::MSU.isNull(this.getContainer().getActor().getOffhandItem())) return;	// If we still have something in our offhand, something went unexpected and we abort

		local netEffect = _targetTile.getEntity().getSkills().getSkillByID("effects.net");
		if (netEffect == null) return;	// Make sure target is actually netted. In vanilla net can be thrown on targets which are immune to it causing it to miss

		this.m.ConnectedNetEffect = ::MSU.asWeakTableRef(netEffect);

		// The original net is unequipped during use of throw net skill, so we equip a "new" net of the same type
		// We should not add items during "IsUpdating" / skill executions, because they can't add their skills during that time
		// 	that might throw off onEquip events of certain other perks, like for example that of perk_rf_angler
		::Time.scheduleEvent(::TimeUnit.Virtual, 1, function( _perk ) {
			local replacementNet = ::new(_perk.m.Temp_NetItemScript)
			_perk.getContainer().getActor().getItems().equip(replacementNet);
			_perk.setNetLocked(true);
		}.bindenv(this), this);
	}

// New Functions
	// Do we have a net equipped in our offhand?
	q.isEnabled <- function()
	{
		return this.isNet(this.getContainer().getActor().getOffhandItem());
	}

	// Is the skil valid for triggering a net-replacement?
	q.isSkillValid <- function( _skill )
	{
		return (_skill.getID() == "actives.throw_net");
	}

	q.setNetLocked <- function( _locked )
	{
		this.m.IsNetLocked = _locked;
		if (!_locked)
		{
			this.m.ConnectedNetEffect = null;
		}
		this.getContainer().getActor().setDirty(true);	// This is necessary so that the skills are no longer greyed out when the target dies
		return _locked;
	}

	/// Check whether the net would still be locked
	/// If we realize that the net is no longer locked this function will clean it up correctly
	/// @return true if the net is still locked or false if it is no longer locked
	q.checkLocked <- function()
	{
		if (this.m.IsNetLocked)
		{
			if (::MSU.isNull(this.m.ConnectedNetEffect) || ::MSU.isNull(this.m.ConnectedNetEffect.getContainer()))
			{
				return this.setNetLocked(false);
			}

			local connectedActor = this.m.ConnectedNetEffect.getContainer().getActor();
			if (::MSU.isNull(connectedActor) || connectedActor.isDying() || !connectedActor.isAlive())
			{
				return this.setNetLocked(false);
			}

			local actor = this.getContainer().getActor();
			if (actor.isPlacedOnMap() && connectedActor.isPlacedOnMap() && actor.getTile().getDistanceTo(connectedActor.getTile()) > 1)
			{
				// If we are no longer adjacent to our connected net, we delete the equipped net
				local net = actor.getOffhandItem();
				if (this.isNet(net))
				{
					actor.getItems().unequip(net);	// We remove the currently equipped net as part of this perks downside
					::Sound.play(::MSU.Array.rand(this.m.SoundOnBreakFree), ::Const.Sound.Volume.Skill * this.m.SoundVolume, actor.getPos(), actor.getSoundPitch());
					::Tactical.EventLog.log(::Const.UI.getColorizedEntityName(actor) + " leaves his net behind");
				}
				return this.setNetLocked(false);
			}
		}

		return this.m.IsNetLocked;
	}

	// Return true, if _item is a net, as per our definition
	q.isNet <- function( _item )
	{
		if (::MSU.isNull(_item)) return false;

		foreach (skill in _item.getSkills())
		{
			if (skill.getID() == "actives.throw_net") return true;	// An item must grant the skill "actives.throw_net" to be considered a net
		}

		return false;
	}
});
