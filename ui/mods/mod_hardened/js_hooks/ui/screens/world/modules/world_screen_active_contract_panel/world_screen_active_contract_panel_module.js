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
