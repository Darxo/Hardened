this.hd_warded_effect <- this.inherit("scripts/skills/skill", {
	m = {
		// Public
		DamageReceivedTotalMult = 0.7,

		// Private
		SourceWarden = null,
	},

	function create()
	{
		this.m.ID = "effects.hd_warded";
		this.m.Name = "Warded";
		this.m.Description = "You are under a wardens watchful presence.";
		this.m.Icon = "ui/perks/perk_rf_phalanx.png";
		this.m.IconMini = "perk_rf_phalanx_mini";
		this.m.Type = ::Const.SkillType.StatusEffect;
		this.m.IsActive = false;
		this.m.IsRemovedAfterBattle = true;
		this.m.IsStacking = true;	// This effect is meant to stack from different warden
	}

	function isHidden()
	{
		return !this.isEnabled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		if (this.getDamageReceivedTotalMult() != 1.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/damage_dealt.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(this.getDamageReceivedTotalMult(), {InvertColor = true}) + " damage from enemies that are adjacent to " + ::MSU.Text.colorNeutral(this.m.SourceWarden.getName()),
			});
		}

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/initiative.png",
			text = ::Reforged.Mod.Tooltips.parseString("Whenever you take damage, move " + ::MSU.Text.colorNeutral(this.m.SourceWarden.getName()) + " to the next position in the [turn|Concept.Turn] sequence"),
		});

		return ret;
	}

	function onUpdate( _properties )
	{
		_properties.UpdateWhenTileOccupationChanges = true;

		if (!this.HD_isAlive()) this.removeSelf();
	}

	function onBeforeDamageReceived( _attacker, _skill, _hitinfo, _properties )
	{
		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;
		if (!this.isAttackerValid(_attacker)) return;

		_properties.DamageReceivedTotalMult *= this.getDamageReceivedTotalMult();
	}

	function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (!this.isEnabled()) return;

		if (_damageHitpoints > 0 || _damageArmor > 0)
		{
			this.triggerCommandEffect();
		}
	}

// MSU Functions
	function onGetHitFactorsAsTarget( _skill, _targetTile, _tooltip )
	{
		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;
		if (!this.isAttackerValid(_skill.getContainer().getActor())) return;

		if (this.getDamageReceivedTotalMult() != 1.0)
		{
			_tooltip.push({
				icon = this.getIconColored(),
				text = "Warded by " + ::MSU.Text.colorNeutral(this.m.SourceWarden.getName()),
			});
		};
	}

// New Functions
	// Is the perk alive. If not, it should probably be cleaned up
	function HD_isAlive()
	{
		if (::MSU.isNull(this.m.SourceWarden)) return false;
		if (!this.m.SourceWarden.isAlive()) return false;
		if (!this.m.SourceWarden.isPlacedOnMap()) return false;

		local actor = this.getContainer().getActor();
		if (!actor.isPlacedOnMap()) return false;
		if (actor.getTile().getDistanceTo(this.m.SourceWarden.getTile()) > 1) return false;

		return true;
	}

	// Is the effect currently enabled or dormant?
	function isEnabled()
	{
		if (!this.HD_isAlive()) return false;
		if (this.m.SourceWarden.getMoraleState() == ::Const.MoraleState.Fleeing) return false;

		return true;
	}

	function isSkillValid( _skill )
	{
		if (::MSU.isNull(_skill)) return false;

		return _skill.isAttack();
	}

	function isAttackerValid( _attacker )
	{
		if (::MSU.isNull(_attacker)) return false;
		if (this.m.SourceWarden.getTile().getDistanceTo(_attacker.getTile()) > 1) return false;

		return true;
	}

	function getDamageReceivedTotalMult()
	{
		return this.m.DamageReceivedTotalMult;
	}

	// Compile a list of enemies against which we gain the damage mitigation
	function getValidEnemies()
	{

	}

	// Trigger the second line of the Warden Perk effect around the turn order manipulation
	// This function assumes, that SourceWarden is not null, alive and placed on map
	function triggerCommandEffect()
	{
		if (this.m.SourceWarden.isTurnDone()) return;
		if (this.m.SourceWarden.isActiveEntity()) return;	// This can happen with AoE attacks and charmed brothers. The latter may brick AI and softlock combat

		::Tactical.TurnSequenceBar.moveEntityToFront(this.m.SourceWarden.getID());

		if (!this.m.SourceWarden.isHiddenToPlayer())
		{
			this.spawnIcon("hd_warden_effect", this.m.SourceWarden.getTile());
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(this.m.SourceWarden) + " moves forward in the turn sequence");
		}
	}
});

