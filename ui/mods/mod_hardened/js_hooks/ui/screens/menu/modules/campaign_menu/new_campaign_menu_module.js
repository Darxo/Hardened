
// Vanilla Fix: We reduce the scroll speed of the origin list to 0.5 (down from 5)
Hardened.Hooks.NewCampaignMenuModule_buildOriginSelectionPanel = NewCampaignMenuModule.prototype.buildOriginSelectionPanel;
NewCampaignMenuModule.prototype.buildOriginSelectionPanel = function ( _container )
{
	// We switcheroo the jquery createList function as that is the simplest way to switch out the high vanilla delta with a smaller one
	var oldCreateList = $.fn.createList;
	$.fn.createList = function(_scrollDelta, _classes, _withoutFrame)
	{
		return oldCreateList.call(this, 0.5, _classes, _withoutFrame);
	};

	Hardened.Hooks.NewCampaignMenuModule_buildOriginSelectionPanel.call(this, _container);

	$.fn.createList = oldCreateList;
}

{	// New Functions
	NewCampaignMenuModule.prototype.HD_applyDefaultValues = function( _settings )
	{
		if (_settings.companyName !== undefined)
		{
			this.mCompanyName.setInputText(_settings.companyName);
		}

		if (_settings.combatDifficulty !== undefined)
		{
			switch (_settings.combatDifficulty)
			{
				case 0: this.mDifficultyEasyCheckbox.iCheck('check'); break;
				case 1: this.mDifficultyNormalCheckbox.iCheck('check'); break;
				case 2: this.mDifficultyHardCheckbox.iCheck('check'); break;
			}
		}

		if (_settings.economicDifficulty !== undefined)
		{
			switch (_settings.economicDifficulty)
			{
				case 0: this.mEconomicDifficultyEasyCheckbox.iCheck('check'); break;
				case 1: this.mEconomicDifficultyNormalCheckbox.iCheck('check'); break;
				case 2: this.mEconomicDifficultyHardCheckbox.iCheck('check'); break;
			}
		}

		if (_settings.budgetDifficulty !== undefined)
		{
			switch (_settings.budgetDifficulty)
			{
				case 0: this.mBudgetDifficultyEasyCheckbox.iCheck('check'); break;
				case 1: this.mBudgetDifficultyNormalCheckbox.iCheck('check'); break;
				case 2: this.mBudgetDifficultyHardCheckbox.iCheck('check'); break;
			}
		}

		if (_settings.ironman !== undefined)
		{
			this.mIronmanCheckbox.iCheck(_settings.ironman ? 'check' : 'uncheck');
		}

		if (_settings.explorationDifficulty !== undefined)
		{
			this.mExplorationCheckbox.iCheck(_settings.explorationDifficulty ? 'check' : 'uncheck');
		}

		if (_settings.lateGameCrisis !== undefined)
		{
			switch (_settings.lateGameCrisis)
			{
				case 0: this.mEvilRandomCheckbox.iCheck('check'); break;
				case 1: this.mEvilWarCheckbox.iCheck('check'); break;
				case 2: this.mEvilGreenskinsCheckbox.iCheck('check'); break;
				case 3: this.mEvilUndeadCheckbox.iCheck('check'); break;
				case 4: this.mEvilCrusadeCheckbox.iCheck('check'); break;
			}
		}

		if (_settings.permanentDestruction !== undefined)
		{
			this.mEvilPermanentDestructionCheckbox.iCheck(_settings.permanentDestruction ? 'check' : 'uncheck');
		}

		if (_settings.origin !== undefined)
		{
			for (var i = 0; i < this.mScenarios.length; ++i)
			{
				if (this.mScenarios[i].ID == _settings.origin)
				{
					$('#cb-scenario-' + i).iCheck('check');
					break;
				}
			}
		}
	};
}
