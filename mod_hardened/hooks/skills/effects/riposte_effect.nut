::Hardened.HooksMod.hook("scripts/skills/effects/riposte_effect", function(q) {
	// Public
	q.m.MeleeDefenseModifier <- 10;
	q.m.IsRemovedWhenHit <- true;
	q.m.OnlyOneCounterAttack <- true;
	q.m.RiposteRange <- 1;

	q.getTooltip = @(__original) function()
	{
		local ret = __original();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/stat_screen_dmg_dealt.png",	// Same Icon as Reach in Reforged
			text = ::Reforged.Mod.Tooltips.parseString("Trigger a free attack on an adjacent enemy whenever they miss an attack against you"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/melee_defense.png",
			text = ::Reforged.Mod.Tooltips.parseString(::MSU.Text.colorizeValue(this.m.MeleeDefenseModifier, {AddSign = true}) + " [Melee Defense|Concept.MeleeDefense]"),
		});

		ret.push({
			id = 20,
			type = "text",
			icon = "ui/icons/action_points.png",
			text = ::Reforged.Mod.Tooltips.parseString("Lasts until the start of your [turn|Concept.Turn]"),
		});

		if (this.m.IsRemovedWhenHit)
		{
			ret.push({
				id = 21,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Is removed when hit by an Attack"),
			});
		}

		if (this.m.OnlyOneCounterAttack)
		{
			ret.push({
				id = 22,
				type = "text",
				icon = "ui/icons/warning.png",
				text = ::Reforged.Mod.Tooltips.parseString("Is removed after one counter-attack"),
			});
		}

		return ret;
	}

	// Override: This effect no longer sets the IsRiposting flag to true. The underlying behavior is now implemented inside this skill instead
	// We now purely rely on RiposteSkillCounter to prevent multiple riposte-like effects to trigger at the same time
	q.onUpdate = @() function( _properties )
	{
		_properties.MeleeDefense += this.m.MeleeDefenseModifier;
	}

	// Overwrite, because we disable the hitchance penalty from not having sword mastery
	q.onAnySkillUsed = @() function( _skill, _targetEntity, _properties ) {}

	// We use onBeforeDamageReceived because it is guaranteed to run just before we receive damage and it also has access to the skill who dealt the damage
	q.onBeforeDamageReceived = @(__original) function( _attacker, _skill, _hitinfo, _properties )
	{
		__original(_attacker, _skill, _hitinfo, _properties);
		if (this.m.IsRemovedWhenHit && !::MSU.isNull(_skill) && _skill.isAttack())
		{
			this.removeSelf();
		}
	}

	q.onMissed = @(__original) function( _attacker, _skill )
	{
		if (_attacker == null) return;
		if (_skill == null) return;

		local actor = this.getContainer().getActor();
		if (!_attacker.isAlliedWith(actor) && _attacker.getTile().getDistanceTo(actor.getTile()) <= this.m.RiposteRange && !_skill.isIgnoringRiposte() && _attacker.isActiveEntity())
		{
			this.onRiposteTriggered(_attacker);
		}
	}

// New Functions
	q.onRiposteTriggered <- function( _attacker )
	{
		local skill = this.getContainer().getAttackOfOpportunity();

		if (skill != null)
		{
			local data = {
				User = this.getContainer().getActor(),
				Skill = skill,
				TargetTile = _attacker.getTile()
			};
			::Time.scheduleEvent(::TimeUnit.Virtual, ::Const.Combat.RiposteDelay, this.onRiposteExecuted.bindenv(this), data);
		}
	}

	q.onRiposteExecuted <- function( _data )
	{
		if (!_data.User.isAlive()) return;
		if (_data.User.m.RiposteSkillCounter == ::Const.SkillCounter) return;	// This is a shared variable used by all riposte effects and ensures that no two riposte effects can trigger from the same attack

		// Check whether our ZOC skill is valid. We can't use isUsableOn because that function checks for skill cost too, which we do not want
		if (!_data.User.getTile().hasLineOfSightTo(_data.TargetTile, _data.User.getCurrentProperties().getVision())) return;
		if (!_data.Skill.verifyTargetAndRange(_data.TargetTile, _data.User.getTile())) return;

		_data.User.m.RiposteSkillCounter = ::Const.SkillCounter;
		_data.Skill.useForFree(_data.TargetTile);

		if (this.m.OnlyOneCounterAttack)
		{
			this.removeSelf();
			_data.User.setDirty(true);
		}
	}
});
