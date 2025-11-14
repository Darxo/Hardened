this.perk_hd_forestbond <- ::inherit("scripts/skills/skill", {
	m = {
		// Public
		HitpointRecoveryPctPerNeighbor = 0.03,	// This many hitpoints are recovered per turn per adjacent
		ApplicableNeighbors = [		// Adjacent Obstacles with these names may trigger the recovery
			"Tree",
		],

		// Private
		SoundOnRecovery = [
			"sounds/enemies/dlc2/schrat_regrowth_01.wav",
			"sounds/enemies/dlc2/schrat_regrowth_02.wav",
			"sounds/enemies/dlc2/schrat_regrowth_03.wav",
			"sounds/enemies/dlc2/schrat_regrowth_04.wav",
		],
	},
	function create()
	{
		this.m.ID = "perk.hd_forestbond";
		this.m.Name = ::Const.Strings.PerkName.HD_Forestbond;
		this.m.Description = "Draw strength from the living forest, letting its lifeblood mend your wounds.";
		this.m.Icon = "skills/terrain_icon_06.png";
		this.m.IconMini = "perk_hd_forestbond_mini";
		this.m.Overlay = "perk_hd_forestbond";
		this.m.Type = ::Const.SkillType.Perk | ::Const.SkillType.StatusEffect;
		this.m.Order = ::Const.SkillOrder.Perk;
	}

	function isHidden()
	{
		return !this.isEnabled();
	}

	function getTooltip()
	{
		local ret = this.skill.getTooltip();

		local recoveredHitpointPct = this.calculateRecoveredHitpointPct();
		if (recoveredHitpointPct > 0.0)
		{
			ret.push({
				id = 10,
				type = "text",
				icon = "ui/icons/health.png",
				text = ::Reforged.Mod.Tooltips.parseString("At the start your [turn,|Concept.Turn] recover " + ::MSU.Text.colorizePct(recoveredHitpointPct) + " of your [Hitpoints|Concept.Hitpoints]"),
			});
		}

		return ret;
	}

	function onTurnStart()
	{
		this.recoverHitpoints();
	}

	function addResources()
	{
		this.skill.addResources();

		foreach (resource in this.m.SoundOnRecovery)
		{
			::Tactical.addResource(resource);	// Make it so these sfx will actually loaded and able to be played
		}
	}

// New Functions
	function recoverHitpoints()
	{
		local actor = this.getContainer().getActor();
		local hitpointsToRecover = this.calculateRecoveredHitpointPct() * actor.getHitpointsMax();
		if (actor.recoverHitpoints(hitpointsToRecover, true) > 0 && !actor.isHiddenToPlayer())
		{
			this.spawnIcon(this.m.Overlay, actor.getTile());
			::Sound.play(::MSU.Array.rand(this.m.SoundOnRecovery), ::Const.Sound.Volume.Skill, actor.getPos());
		}
	}

	function calculateRecoveredHitpointPct()
	{
		return this.getAdjacentTreeAmount() * this.m.HitpointRecoveryPctPerNeighbor;
	}

	function getAdjacentTreeAmount()
	{
		local treeCount = 0;
		foreach (tile in ::MSU.Tile.getNeighbors(this.getContainer().getActor().getTile()))
		{
			if (tile.IsEmpty) continue;
			if (tile.IsOccupiedByActor) continue;	// We are only interested in obstacles

			foreach (applicableName in this.m.ApplicableNeighbors)
			{
				if (tile.getEntity().getName() == applicableName)
				{
					treeCount++;
					break;
				}
			}
		}
		return treeCount;
	}

	// Minimum shared requirements for any of this perks effects to work
	function isEnabled()
	{
		return this.calculateRecoveredHitpointPct() > 0.0;
	}
});
