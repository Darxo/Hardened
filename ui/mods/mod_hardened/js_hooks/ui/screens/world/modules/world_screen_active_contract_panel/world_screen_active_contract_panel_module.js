{	// Feat: Visual Contract Tier
	Hardened.Hooks.WorldScreenActiveContractPanelModule_createDIV = WorldScreenActiveContractPanelModule.prototype.createDIV;
	WorldScreenActiveContractPanelModule.prototype.createDIV = function (_parentDiv)
	{
		Hardened.Hooks.WorldScreenActiveContractPanelModule_createDIV.call(this, _parentDiv);

		var headerContainer = this.mContainer.find('.header-container');

		var tierContainer = $('<div class="HD-contract-tier-container"/>');
		headerContainer.append(tierContainer);

		this.mHD_ContractTierImage = $('<img class="HD-contract-tier-image"/>');
		tierContainer.append(this.mHD_ContractTierImage);
	}

	Hardened.Hooks.WorldScreenActiveContractPanelModule_destroyDIV = WorldScreenActiveContractPanelModule.prototype.destroyDIV;
	WorldScreenActiveContractPanelModule.prototype.destroyDIV = function ()
	{
		Hardened.Hooks.WorldScreenActiveContractPanelModule_destroyDIV.call(this);
		this.mHD_ContractTierImage.remove();
		this.mHD_ContractTierImage = null;
	}

	Hardened.Hooks.WorldScreenActiveContractPanelModule_loadFromData = WorldScreenActiveContractPanelModule.prototype.loadFromData;
	WorldScreenActiveContractPanelModule.prototype.loadFromData = function (_data)
	{
		Hardened.Hooks.WorldScreenActiveContractPanelModule_loadFromData.call(this, _data);

		if (_data.HD_ContractTierImage != null)
		{
			this.mHD_ContractTierImage.attr('src', Path.GFX + _data.HD_ContractTierImage);
		}
	}
}

Hardened.Hooks.WorldScreenActiveContractPanelModule_hide = WorldScreenActiveContractPanelModule.prototype.hide;
WorldScreenActiveContractPanelModule.prototype.hide = function (_withSlideAnimation)
{
	Hardened.Hooks.WorldScreenActiveContractPanelModule_hide.call(this, _withSlideAnimation);

	if (_withSlideAnimation) this.HD_notifyBackendContractDetailsToggled();
}

Hardened.Hooks.WorldScreenActiveContractPanelModule_show = WorldScreenActiveContractPanelModule.prototype.show;
WorldScreenActiveContractPanelModule.prototype.show = function (_withSlideAnimation)
{
	Hardened.Hooks.WorldScreenActiveContractPanelModule_show.call(this, _withSlideAnimation);

	if (_withSlideAnimation) this.HD_notifyBackendContractDetailsToggled();
}

WorldScreenActiveContractPanelModule.prototype.HD_notifyBackendContractDetailsToggled = function ()
{
	if (this.mSQHandle !== null)
	{
		SQ.call(this.mSQHandle, 'HD_onContractDetailsToggled');
	}
};
