// Vanilla Fix: We limit the maximum UIScale so that it is impossible for a user to brick their UI by accident
Hardened.Hooks.OptionsMenuModuleVideoPanel_selectUIScalingOption = OptionsMenuModuleVideoPanel.prototype.selectUIScalingOption;
OptionsMenuModuleVideoPanel.prototype.selectUIScalingOption = function ( _currentScale )
{
	Hardened.Hooks.OptionsMenuModuleVideoPanel_selectUIScalingOption.call(this, _currentScale);

	// Hard-coded value, that we fetched once.
	// This should be at least the Height of the Options Menu (720), otherwise you can never revert this change
	// You could also set it to 900, which is the Height of the Character Screen as we assume it to be the biggest screen in the game
	// I choose 720, so that someone with 1600x900 resolution can still use this feature and see its effect and learn from that
	const optionWindowHeight = 720;

	// Here we get the current real pixel height of the game window
	var htmlElem = document.documentElement; // top-level <html> element
	var currentGameHeight = htmlElem.offsetHeight;

	var step = parseInt(this.mUIScale.attr('step'), 10) || 10; // get step or default to 10
	var min = parseInt(this.mUIScale.attr('min'), 10) || 100;  // get min or default to 100
	var max = parseInt(this.mUIScale.attr('max'), 10) || 200;  // get min or default to 100

	// Now we calculated the maximum possible scaling that we can allow without scaling our options window past the point of no return
	var maxPossibleScaleMax = currentGameHeight / optionWindowHeight * _currentScale;
	maxPossibleScaleMax = Math.floor(maxPossibleScaleMax / step) * step;	// We want the new maximum to still be a multiple of the step
	maxPossibleScaleMax = Math.max(maxPossibleScaleMax, min);				// We never want a maximum thats lower than the minimum
	maxPossibleScaleMax = Math.min(maxPossibleScaleMax, max);				// We never want the maximum thats higher than the vanilla maximum
	this.mUIScale.attr('max', maxPossibleScaleMax);
}
