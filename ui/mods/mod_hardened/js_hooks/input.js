/// Our goal compared to vanilla is to also allow usage of copy, paste, cut and mark combinations
/// Overwrite of vanilla function because we can't hook the vanilla boundary checks properly
/// We remove a bunch of redundant vanilla logic that never even worked

/**
 * Construct and input object and attach handler which shake the box when the boundaries are violated and which fire callback functions
 * @param {*} _text not used
 * @param {*} _minLength not used
 * @param {*} _maxLength maximum length allowed in the text box, enforced by the underlying html. Adding a character while the textbox has this length, results in shaking
 * @param {*} _tabIndex Integer used to control which textfield is focussed next on pressing Tab
 * @param {*} _inputUpdatedCallback callback that is fired with the current textlength whenever any key is pressed
 * @param {*} _classes additional classes added to this input object
 * @param {*} _acceptCallback Callback that is fired, when Enter or Return are released
 * @returns constructed input object
 *
 * Todo (Doable): Add wiggle, when user pastes text, which would surpass the textbox
 * Todo (Tricky): Remove wiggle, when the input field is full, user has marked all text, and replaces it (paste) with a smaller or equally sized text
 */
$.fn.createInput = function(_text, _minLength, _maxLength, _tabIndex, _inputUpdatedCallback, _classes, _acceptCallback)
{
	// We can't enforce _minLength here, but it is still used in setInputText
	var maxLength = _maxLength || null;
	var tabIndex = _tabIndex || null;

	var result = $('<input type="text" class="ui-control"/>');
	var data = { minLength: _minLength || 0, maxLength: _maxLength || null, inputUpdatedCallback: null, acceptCallback: null, inputDenied: false };

	if (maxLength !== null) result.attr('maxlength', maxLength);	// With this the text field will handle maximum input restraints
	if (tabIndex !== null)  result.attr('tabindex', tabIndex);
	if (_classes !== undefined && _classes !== null && typeof(_classes) === 'string') result.addClass(_classes);	// Add additional custom classes

	if (_inputUpdatedCallback !== undefined && jQuery.isFunction(_inputUpdatedCallback)) data.inputUpdatedCallback = _inputUpdatedCallback;
	if (_acceptCallback !== undefined && jQuery.isFunction(_acceptCallback)) data.acceptCallback = _acceptCallback;
	result.data('input', data);

	// input handler
	result.on('keydown.input', null, result, function (_event)
	{
		var code = _event.which || _event.keyCode;
		var self = _event.data;
		var eventMaxLength = self.data('input').maxLength;
		var textLength = self.getInputTextLength();

		var allowInput = !data.inputDenied;

		if (_event.ctrlKey || _event.metaKey)
		{
			if (code === KeyConstants.X) data.inputDenied = true;	// Prevent windows error sfx whenever a user cuts text from an input box

			if (code === KeyConstants.V)
			{
				if (!data.inputDenied && code === KeyConstants.V && textLength === eventMaxLength)	// paste is the only important ctrl command that can violate the boundary
				{
					self.shakeLeftRight(3);
				}
				data.inputDenied = true;	// Prevent textbox being spammed with text
			}
		}
		else
		{
			switch (code)
			{
				case KeyConstants.Tabulator:
				case KeyConstants.ArrowLeft:
				case KeyConstants.ArrowRight:
				case KeyConstants.ArrowUp:
				case KeyConstants.ArrowDown:
					data.inputDenied = true;	// Prevent Arrow keys from flying across the word. Instead you need to let go and press again to move one character at a time
					break;	// These actions will never violate boundaries
				case KeyConstants.Delete:
					if (data.inputDenied) break;	// Prevent shakeLeftRight when holding this key on an empty text box
					data.inputDenied = true;	// Prevent way too many Delete-actions from just one button press. Instead you need to let go and press again to delete one character at a time
				case KeyConstants.Backspace:
					if (textLength === 0) self.shakeLeftRight(3);	// Trying to delete in an empty text box
					break;
				// We assume that any other character down here is one that would increase the text length
				default:
					if (textLength === eventMaxLength) self.shakeLeftRight(3);	// Trying to write into a full text
			}
		}

		if (_inputUpdatedCallback !== undefined && jQuery.isFunction(_inputUpdatedCallback))
		{
			_inputUpdatedCallback($(this), textLength);
		}

		return allowInput;
	});

	result.on('keyup.input', null, result, function (_event)
	{
		var self = _event.data;
		var code = _event.which || _event.keyCode;

		self.data('input').inputDenied = false;		// Input is always denied until we let go of any key again

		if(code === KeyConstants.Return || code === KeyConstants.Enter)
		{
				if(_acceptCallback !== undefined && jQuery.isFunction(_acceptCallback))
				{
					$(this).blur();
					_acceptCallback($(this));
				}

			return;
		}

		if(_inputUpdatedCallback !== undefined && jQuery.isFunction(_inputUpdatedCallback))
		{
			_inputUpdatedCallback($(this), self.getInputTextLength());
		}
	});

	this.append(result);

	return result;
};
