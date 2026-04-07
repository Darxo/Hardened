::Hardened.wipeClass("scripts/skills/perks/perk_anticipation", [
	"create",
]);

::Hardened.HooksMod.hook("scripts/skills/perks/perk_anticipation", function(q) {
	// Public
	q.m.UsesMax <- 2;

	q.m.DamageReceivedTotalPctBase <- 0.0;
	q.m.DamageReceivedTotalPctPerTile <- 0.1;
	q.m.DamageReceivedTotalPctPerRangedDefense <- 0.01;

	// Private
	q.m.UsesRemaining <- 2;
	q.m.Temp_DamageReceivedTotalMult <- 0.0;		// This is used to keep track of the current damage reduction so that it can be later displayed in the combat log
	q.m.IsAboutToConsumeUse <- false;

	q.create = @(__original) { function create()
	{
		__original();
		this.m.Description = "Use your fast senses to anticipate attacks against you or your shield, taking reduced damage from the first few attacks each battle.";
		this.m.Overlay = "perk_anticipation";
		this.m.IconMini = "rf_anticipation_mini";

		this.addType(::Const.SkillType.StatusEffect);	// We now want this effect to show up on entities
	}}.create;

	q.isHidden = @() { function isHidden()
	{
		return (this.isEnabled() == false);
	}}.isHidden;

	q.getTooltip = @() { function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local damageReduction = this.getDamageReceivedTotalMult();
		ret.extend([
			{
				id = 10,
				type = "text",
				icon = "ui/icons/melee_defense.png",
				text = "Take " + ::MSU.Text.colorizeMultWithText(damageReduction, {InvertColor = true}) + " damage from all attacks",
			},
			{
				id = 11,
				type = "text",
				icon = "ui/icons/ranged_defense.png",
				text = "Take an additional " + ::MSU.Text.colorizePct(this.m.DamageReceivedTotalPctPerTile) + " less damage from all attacks for every tile between the attacker and you",
			},
			{
				id = 15,
				type = "text",
				icon = "ui/icons/special.png",
				text = ::MSU.Text.colorPositive(this.m.UsesRemaining) + " uses remaining",
			}
		]);

		return ret;
	}}.getTooltip;

	// Before we receive the damage, we need to calculate whether this perk triggered, as we dont have access to the skill during onDamageReceived
	// So that we can later give feedback to the player (combat log and icon)
	q.onBeforeDamageReceived = @() { function onBeforeDamageReceived( _attacker, _skill, _hitinfo, _properties )
	{
		this.m.IsAboutToConsumeUse = false;

		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;

		this.m.Temp_DamageReceivedTotalMult = this.getDamageReceivedTotalMult(_attacker);	// We save this so that we can later display it in the combat log
		_properties.DamageReceivedTotalMult *= this.m.Temp_DamageReceivedTotalMult;

		this.m.IsAboutToConsumeUse = true;	// We need this variable to notify "onDamageReceived" that this skill has triggered
	}}.onBeforeDamageReceived;

	q.onDamageReceived = @() { function onDamageReceived( _attacker, _damageHitpoints, _damageArmor )
	{
		if (!this.m.IsAboutToConsumeUse) return;	// We only consume one use for each registered attack. But a single attack that deals damage multiple times will have the damage of all instances reduced
		this.m.IsAboutToConsumeUse = false;

		this.m.UsesRemaining = ::Math.max(0, this.m.UsesRemaining - 1);

		local actor = this.getContainer().getActor();
		if (actor.isHiddenToPlayer()) return;

		this.spawnIcon(this.m.Overlay, actor.getTile());

		if (_attacker == null)	// This can for example happen when this character receives a mortar attack.
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " anticipated an attack, taking " + ::MSU.Text.colorizeMultWithText(this.m.Temp_DamageReceivedTotalMult, {InvertColor = true}) + " damage");
		}
		else
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " anticipated the attack of " + ::Const.UI.getColorizedEntityName(_attacker) + ", taking " + ::MSU.Text.colorizeMultWithText(this.m.Temp_DamageReceivedTotalMult, {InvertColor = true}) + " damage");
		}
	}}.onDamageReceived;

	q.onCombatStarted = @() { function onCombatStarted()
	{
		this.m.UsesRemaining = this.m.UsesMax;
	}}.onCombatStarted;

	q.onCombatFinished = @() { function onCombatFinished()
	{
		this.m.UsesRemaining = this.m.UsesMax;	// So that for the purposes of the tooltip everything looks good
	}}.onCombatFinished;

// Hardened Events
	q.onBeforeShieldDamageReceived = @() function( _damage, _shield, _defenderProps, _attacker = null, _attackerProps = null, _skill = null )
	{
		this.m.IsAboutToConsumeUse = false;

		if (!this.isEnabled()) return;
		if (!this.isSkillValid(_skill)) return;

		this.m.Temp_DamageReceivedTotalMult = this.getDamageReceivedTotalMult(_attacker);	// We save this so that we can later display it in the combat log
		_defenderProps.ShieldDamageReceivedMult *= this.m.Temp_DamageReceivedTotalMult;

		this.m.IsAboutToConsumeUse = true;	// We need this variable to notify "onAfterShieldDamageReceived" that this skill has triggered
	}

	q.onAfterShieldDamageReceived = @() function( _initialDamage, _damageReceived, _shield, _attacker = null, _skill = null )
	{
		if (!this.m.IsAboutToConsumeUse) return;	// We only consume one use for each registered attack. But a single attack that deals damage multiple times will have the damage of all instances reduced and use multiple stacks
		this.m.IsAboutToConsumeUse = false;

		this.m.UsesRemaining = ::Math.max(0, this.m.UsesRemaining - 1);

		local actor = this.getContainer().getActor();
		actor.setDirty(true);
		if (actor.isHiddenToPlayer()) return;

		this.spawnIcon(this.m.Overlay, actor.getTile());
		if (_attacker == null)	// This can for example happen when this character receives a mortar attack.
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " anticipated an attack, causing their shield to take " + ::MSU.Text.colorizeMultWithText(this.m.Temp_DamageReceivedTotalMult, {InvertColor = true}) + " damage");
		}
		else
		{
			::Tactical.EventLog.logEx(::Const.UI.getColorizedEntityName(actor) + " anticipated the attack of " + ::Const.UI.getColorizedEntityName(_attacker) + ", causing their shield to take " + ::MSU.Text.colorizeMultWithText(this.m.Temp_DamageReceivedTotalMult, {InvertColor = true}) + " damage");
		}
	}

// New Functions
	q.isEnabled <- { function isEnabled()
	{
		return this.m.UsesRemaining > 0;
	}}.isEnabled;

	q.isSkillValid <- { function isSkillValid( _skill )
	{
		return _skill != null && _skill.isAttack()
	}}.isSkillValid;

	// calculate the damage mitigation
	// If no _attacker is passed, then tile-distance based reduction is ignored
	q.getDamageReceivedTotalMult <- { function calculateDamageReduction( _attacker = null )
	{
		local actor = this.getContainer().getActor();

		local rangedDefenseBasePct = actor.getCurrentProperties().getRangedDefense() * this.m.DamageReceivedTotalPctPerRangedDefense;

		local tileBasedDamagePct = 0.0;
		if (_attacker != null && _attacker.isPlacedOnMap() && actor.isPlacedOnMap())
		{
			// -1 because adjacent entities count as a distance of 1 but we want only the number of tiles between the entities
			tileBasedDamagePct = (_attacker.getTile().getDistanceTo(actor.getTile()) - 1) * this.m.DamageReceivedTotalPctPerTile;
		}

		local damageReceivedTotalMult = 1.0 - (this.m.DamageReceivedTotalPctBase + rangedDefenseBasePct + tileBasedDamagePct);
		return ::Math.clampf(damageReceivedTotalMult, 0.0, 1.0);
	}}.calculateDamageReduction;
});
