::Hardened.HooksMod.hook("scripts/entity/tactical/player", function(q) {
	// Overwrite getTryoutCost because we make it slightly more moddable by using more variables
	// Vanilla Fix: We also make sure that a high TryoutPriceMult never makes the tryout cost more than the hiring
	q.getTryoutCost = @() function()
	{
		local tryoutCost = 25 + this.m.HiringCost * ::Const.World.Assets.TryoutCostPct;
		tryoutCost *= ::World.Assets.m.TryoutPriceMult;
		return ::Math.clamp(tryoutCost, 10, this.m.HiringCost - 25);
	}

// New Functions
	// Write hitfactors into _tooltip, when traveling to out of this characters tile
	// This function does many checks itself, so those dont need to be done outside
	q.getZOCHitFactors <- function( _tooltip )
	{
		if (this.getCurrentProperties().IsImmuneToZoneOfControl) return;

		if (!this.isPlacedOnMap()) return;
		if (this.getTile().getZoneOfControlCountOtherThan(this.getAlliedFactions()) == 0) return;
		if (this.getTile().Properties.Effect != null && this.getTile().Properties.Effect.Type == "smoke") return;	// onMovementInZoneOfControl does not check for this, so we do it here now
		if (!this.isPreviewing() || this.getPreviewMovement() == null) return;	// We only show the ZOC hitfactors, if this actor is previewing movement

		local aooInformation = [];
		local expectedChanceToBeHit = 0;
		local childId = 11;

		foreach (tile in ::MSU.Tile.getNeighbors(this.getTile()))
		{
			if (!tile.IsOccupiedByActor) continue;
			if (!tile.getEntity().onMovementInZoneOfControl(this, false)) continue;		// The entity in that tile does not exert zone of control onto us

			local aooSkill = tile.getEntity().getSkills().getAttackOfOpportunity();

			local chanceToBeHit = aooSkill.getHitchance(this);
			if (expectedChanceToBeHit == 0)
			{
				expectedChanceToBeHit = chanceToBeHit;
			}
			else
			{
				local expectedChanceToDodge = (100 - expectedChanceToBeHit) * (100 - chanceToBeHit) / 100;
				expectedChanceToBeHit = 100 - expectedChanceToDodge;
			}

			aooInformation.push({
				id = childId++,
				type = "headerText",
				icon = "ui/icons/hitchance.png",
				children = aooSkill.getHitFactors(this.getTile()),
				text = ::MSU.Text.colorNegative(chanceToBeHit + "%") + ::Reforged.Mod.Tooltips.parseString(" [Chance to be hit|Concept.ZoneOfControl] by " + ::Const.UI.getColorizedEntityName(tile.getEntity())),
			});
		}

		_tooltip.push({
			id = 10,
			type = "headerText",
			icon = "ui/icons/hitchance.png",
			children = aooInformation,
			text = ::MSU.Text.colorNegative(expectedChanceToBeHit + "%") + ::Reforged.Mod.Tooltips.parseString(" [Expected chance to be hit|Concept.ZoneOfControl]"),
		});
	}

	q.getXPMult <- function()
	{
		local oldCombatStatsXP = this.m.CombatStats.XPGained;
		local oldXP = this.m.XP;
		this.addXP(10000);

		local xpDifference = this.m.XP - oldXP;

		this.m.CombatStats.XPGained = oldCombatStatsXP;
		this.m.XP = oldXP;

		return xpDifference / 10000.0;
	}

	q.onSerialize = @(__original) function( _out )
	{
		::Hardened.FlaggedPerks.onSerialize(this);
		__original(_out);
		::Hardened.FlaggedPerks.onDeserialize(this);	// Now we have to return the perks to the player, as he will want to continue playing
	}

	q.onDeserialize = @(__original) function( _in )
	{
		__original(_in);
		::Hardened.FlaggedPerks.onDeserialize(this);
	}
});
