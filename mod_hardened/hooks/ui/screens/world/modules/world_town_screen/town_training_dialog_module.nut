::Hardened.Const.TrainablePGCAmount <- 1;	// Maximum Perk Groups allowed to be bought per brother
::Hardened.Const.TrainablePGC <- [	// Perk Group Collection
	{
		Id = "pgc.rf_weapon",
		Excluded = [],	// Array of PerkGroup Ids that should never be offered
		Price = 2500,
	},
	{
		Id = "pgc.rf_armor",
		Excluded = [],	// Array of PerkGroup Ids that should never be offered
		Price = 4000,
	}
];

::Hardened.HooksMod.hook("scripts/ui/screens/world/modules/world_town_screen/town_training_dialog_module", function(q)
{
	// Private
	q.m.HD_PerkGroupsBoughtFlag <- "HD_perkGroupsBought";

	q.queryRosterInformation = @(__original) function()
	{
		local ret = __original();

		// First we add Perk Training Options to any Bro-Entry who already exists in the vanilla ret
		local alreadyIn = [];
		foreach (broEntry in ret.Roster)
		{
			local bro = ::Tactical.getEntityByID(broEntry.ID);
			alreadyIn.push(bro.getID());

			// QoL: We show the trained effect for trained brothers so the player wonders less, why they dont have the train option anymore
			broEntry.Effects.extend(this.HD_getRelevantEffects(bro));

			if (bro.getFlags().getAsInt(this.m.HD_PerkGroupsBoughtFlag) >= ::Hardened.Const.TrainablePGCAmount) continue;		// limit of 1 group right now
			broEntry.Training.extend(this.HD_getPerkGroupEntries(bro));
		}

		// Then we add brother entries for anyone, who has any Training option available
		foreach (bro in ::World.getPlayerRoster().getAll())
		{
			if (alreadyIn.find(bro.getID()) != null) continue;
			if (bro.getFlags().getAsInt(this.m.HD_PerkGroupsBoughtFlag) >= ::Hardened.Const.TrainablePGCAmount) continue;		// limit of 1 group right now

			local perkGroupOptions = this.HD_getPerkGroupEntries(bro);
			if (perkGroupOptions.len() == 0) continue;		// the brother can't learn any new perk groups

			local background = bro.getBackground();
			local broEntry = {
				ID = bro.getID(),
				Name = bro.getName(),
				Level = bro.getLevel(),
				ImagePath = bro.getImagePath(),
				ImageOffsetX = bro.getImageOffsetX(),
				ImageOffsetY = bro.getImageOffsetY(),
				BackgroundImagePath = background.getIconColored(),
				BackgroundText = background.getDescription(),
				Training = [],
				Effects = [],
			};

			broEntry.Training.extend(perkGroupOptions);

			// QoL: We show the trained effect for trained brothers so the player wonders less, why they dont have the train option anymore
			broEntry.Effects.extend(this.HD_getRelevantEffects(bro));

			ret.Roster.push(broEntry);
		}

		return ret;
	}

	q.onTrain = @(__original) function( _data )
	{
		local entityID = _data[0];
		local trainingID = _data[1];

		local brother = ::Tactical.getEntityByID(entityID);
		local wasOneOfOurOptions = false;
		foreach (perkGroupOption in this.HD_getPerkGroupEntries(brother))
		{
			if (perkGroupOption.id != trainingID) continue;
			wasOneOfOurOptions = true;
			this.HD_processPerkGroupOption(brother, perkGroupOption);
			break;
		}

		if (!wasOneOfOurOptions)
		{
			// We disregard the vanilla return value and instead construct our own more accurate one
			__original(_data);
		}

		/*
		// With this logic, you wouldn't have to leave the training screen, if you want to learn multiple perk groups or training lessons
		// However, it also introduces the possibility of accidental missclicks, when you click too fast on a training lesson
		local rosterInfo = this.queryRosterInformation();
		foreach (broEntry in rosterInfo.Roster)
		{
			if (broEntry.ID != entityID) continue;
			return {
				Entity = broEntry,
				Assets = this.m.Parent.queryAssetsInformation(),
			};
		}
		*/

		local background = brother.getBackground();
		local dummyEntry = {
			ID = brother.getID(),
			Name = brother.getName(),
			Level = brother.getLevel(),
			ImagePath = brother.getImagePath(),
			ImageOffsetX = brother.getImageOffsetX(),
			ImageOffsetY = brother.getImageOffsetY(),
			BackgroundImagePath = background.getIconColored(),
			BackgroundText = background.getDescription(),
			Training = [],
			Effects = this.HD_getRelevantEffects(brother),
		};
		return {
			Entity = dummyEntry,
			Assets = this.m.Parent.queryAssetsInformation(),
		};
	}

// New Functions
	// Return all perk groups that _brother is allowed to learn
	// @return array of training-entries
	q.HD_getPerkGroupEntries <- function( _brother )
	{
		local possiblePerkGroupIDs = [];
		foreach (trainablePGC in ::Hardened.Const.TrainablePGC)
		{
			foreach (perkGroupID in ::DynamicPerks.PerkGroupCategories.findById(trainablePGC.Id).getGroups())
			{
				if (perkGroupID in possiblePerkGroupIDs) continue;	// We don't want duplicates
				if (perkGroupID in trainablePGC.Excluded) continue;	// We don't want groups that are marked as excluded
				possiblePerkGroupIDs.push({
					id = perkGroupID,
					price = trainablePGC.Price,
				});
			}
		}

		local ret = [];
		foreach (entry in possiblePerkGroupIDs)
		{
			if (_brother.getPerkTree().hasPerkGroup(entry.id)) continue;		// We don't want groups that the brother already knows

			local perkGroup = ::DynamicPerks.PerkGroups.findById(entry.id);
			ret.push({
				// Vanilla uses integers for the id. We use string values, so we later know, which perk group to unlock
				id = perkGroup.getID(), 	// We push string values will be needed to unlock the perk. vanilla has IDs from 0-2 here.
				icon = perkGroup.getIcon(),
				name = "Unlock " + perkGroup.getName(),
				tooltip = "PerkGroup+" + perkGroup.getID(),
				price = entry.price,
				HD_isBuyablPerkGroup = true,	// New custom entry, so that we can detect these entries and run custom logic for them on the .js side
			});
		}

		return ret;
	}

	// Return an array of relevant effect information, for pushing into the Effects entry of a brother
	q.HD_getRelevantEffects <- function( _bro )
	{
		local ret = [];

		local trainedEffect = _bro.getSkills().getSkillByID("effects.trained");
		if (trainedEffect != null)
		{
			ret.push({
				id = trainedEffect.getID(),
				icon = trainedEffect.getIcon(),
			});
		}

		return ret;
	}

	// Process the perk group related training option _option for the brother _bro
	// This includes subtracting money, counting the amount of learned groups and adding the group to the tree
	q.HD_processPerkGroupOption <- function( _bro, _option )
	{
		::World.Assets.addMoney(-_option.price);
		_bro.getFlags().increment(this.m.HD_PerkGroupsBoughtFlag);
		_bro.getPerkTree().addPerkGroup(_option.id);
	}
});
