::Hardened.HooksMod.hook("scripts/skills/actives/rally_the_troops", function(q) {
	// Public
	q.m.HD_ResolveAsDifficultyPct <- 0.4;
	q.m.HD_DifficultyPerDistance <- -15.0;		// Vanilla: 10
	q.m.HD_Radius <- 4;

	q.create = @(__original) function()
	{
		__original();
		this.m.Description = "Raaaaally! Use this character\'s inspirational resolve to push everyone to go the extra mile.";
		this.m.HD_Cooldown = 1;	// We now use the cooldown framework replacing the vanilla way of adding a dummy skill on ourselves
	}

	// Overwrite, because we rewrite all tooltip lines according to the redesign of this skill
	// Our Changes:
	//	- Streamline wording and structure of tooltips
	//	- Use more descriptive icons
	//	- Use nested tooltips for many terms
	//	- Display current morale check bonus gained from resolve
	//	- Support this.m.HD_ResolveAsDifficultyPct for making resolve scaling moddable
	q.getTooltip = @() function()
	{
		local ret = this.skill.getDefaultUtilityTooltip();

		ret.push({
			id = 10,
			type = "text",
			icon = "ui/icons/morale.png",
			text = ::Reforged.Mod.Tooltips.parseString("Trigger a positive [morale check|Concept.Morale] for all members of your company within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles that are [wavering|Skill+hd_dummy_morale_state_wavering] or [breaking|Skill+hd_dummy_morale_state_breaking]"),
		});

		ret.push({
			id = 11,
			type = "text",
			icon = "ui/icons/morale.png",
			text = ::Reforged.Mod.Tooltips.parseString("[Rally|Concept.Rally] all fleeing members of your company within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles"),
		});

		local resolveBonus = this.HD_getResolveBonus();
		ret.push({
			id = 12,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("These [morale check|Concept.Morale] have a bonus of " + ::MSU.Text.colorizePct(this.m.HD_ResolveAsDifficultyPct) + " (" + ::MSU.Text.colorPositive(resolveBonus) + ") of your [Resolve|Concept.Bravery] and " + ::MSU.Text.colorizeValue(this.m.HD_DifficultyPerDistance, {AddSign = true}) + " per tile between the target and you"),
		});

		ret.push({
			id = 13,
			type = "text",
			icon = "ui/icons/special.png",
			text = ::Reforged.Mod.Tooltips.parseString("Remove [$ $|Skill+sleeping_effect] from all members of your company within " + ::MSU.Text.colorPositive(this.m.HD_Radius) + " tiles"),
		});

		return ret;
	}

	// Overwrite, because we rewrite the whole function slightly adjusting the skill and improving moddability
	// Our Changes:
	//	- Rally now affects allies, who already got rallied by someone else
	//	- Use this.HD_getDifficulty() for determining the difficulty of the check
	//	- Use this.HD_applyRallyEffect() for making the resolve effect more moddable
	//	- Support this.m.HD_ResolveAsDifficultyPct for making resolve scaling moddable
	q.onUse = @() function( _user, _targetTile )
	{
		local myTile = _user.getTile();
		foreach (actor in ::Tactical.Entities.getInstancesOfFaction(_user.getFaction()))
		{
			if (actor.getID() == _user.getID()) continue;	// This skill does not affect the user
			if (myTile.getDistanceTo(actor.getTile()) > this.m.HD_Radius) continue;

			this.HD_applyRallyEffect(_user, actor);
		}

		return true;
	}

	// We overwrite this function because we remove the check for hasSkill("effects.rallied")
	q.isUsable = @() function()
	{
		return this.skill.isUsable();
	}

// New Functions
	q.HD_applyRallyEffect <- function( _user, _target )
	{
		_target.getSkills().removeByID("effects.sleeping");

		switch (_target.getMoraleState())
		{
			case ::Const.MoraleState.Fleeing:
			{
				_target.checkMorale(2, this.HD_getDifficulty(_user, _target), ::Const.MoraleCheckType.Default, "status_effect_56");
				break;
			}
			case ::Const.MoraleState.Breaking:
			case ::Const.MoraleState.Wavering:
			{
				_target.checkMorale(1, this.HD_getDifficulty(_user, _target), ::Const.MoraleCheckType.Default, "status_effect_56");
				break;
			}
		}
	}

	q.HD_getDifficulty <- function( _user, _target )
	{
		local difficultyModifier =  this.HD_getResolveBonus();

		local distance = _user.getTile().getDistanceTo(_target.getTile());
		difficultyModifier += ((distance - 1) * this.m.HD_DifficultyPerDistance);

		return difficultyModifier;
	}

	q.HD_getResolveBonus <- function()
	{
		return ::Math.floor(this.getContainer().getActor().getBravery() * this.m.HD_ResolveAsDifficultyPct);
	}
});
